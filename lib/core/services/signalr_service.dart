import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:logging/logging.dart';
import '../../data/caching/i_cache_manager.dart';
import '../../data/network/auth_token_refresher.dart';
import '../../data/network/constants.dart';
import '../../features/chat/data/data_source/chat_local_data_source.dart';
import '../../features/chat/data/model/message_model.dart';

@lazySingleton
class SignalRService {
  final ICacheManager _cacheManager;
  final Talker _talker;
  final ChatLocalDataSource _chatLocalCache;
  final AuthTokenRefresher _tokenRefresher;
  HubConnection? _hubConnection;

  final _messageController = StreamController<MessageModel>.broadcast();
  final _conversationController = StreamController<void>.broadcast();
  final _deleteController = StreamController<int>.broadcast();

  Stream<MessageModel> get messageStream => _messageController.stream;
  Stream<void> get conversationStream => _conversationController.stream;
  Stream<int> get deleteStream => _deleteController.stream;

  SignalRService(
    this._cacheManager,
    this._talker,
    this._chatLocalCache,
    this._tokenRefresher,
  );

  Future<void> start() async {
    if (_hubConnection?.state == HubConnectionState.Connected ||
        _hubConnection?.state == HubConnectionState.Connecting) {
      return;
    }

    final token = await _cacheManager.getToken();
    if (token == null || token.isEmpty) {
      _talker.error('SignalR: Cannot start connection without token');
      return;
    }

    // Enable verbose SignalR logging
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      _talker.verbose(
        'SignalR-Internal: ${rec.level.name}: ${rec.time}: ${rec.message}',
      );
    });

    _buildConnection(token);
    _registerConnectionHandlers();
    _registerListeners();

    await _startWithRetry();
  }

  void _buildConnection(String token) {
    final normalizedToken = _normalizeToken(token);
    // Backend constraint: token MUST be in the query string.
    final hubUrl =
        '${Constants.baseUrl}/hubs/chat?access_token=${Uri.encodeComponent(normalizedToken)}';

    _hubConnection =
        HubConnectionBuilder()
            .withUrl(
              hubUrl,
              options: HttpConnectionOptions(
                headers:
                    MessageHeaders()
                      ..setHeaderValue('ngrok-skip-browser-warning', 'true')
                      ..setHeaderValue(
                        'Authorization',
                        'Bearer $normalizedToken',
                      ),
              ),
            )
            .configureLogging(Logger("SignalR"))
            .withAutomaticReconnect()
            .build();
  }

  String _normalizeToken(String token) {
    return _tokenRefresher.normalizeToken(token);
  }

  void _registerConnectionHandlers() {
    _hubConnection!.onclose(({error}) {
      _talker.warning('SignalR: Connection closed. Error: $error');
    });

    _hubConnection!.onreconnecting(({error}) {
      _talker.warning('SignalR: Reconnecting. Error: $error');
    });

    _hubConnection!.onreconnected(({connectionId}) {
      _talker.info('SignalR: Reconnected. ConnectionId: $connectionId');
    });
  }

  void _registerListeners() {
    // Register Listeners
    void onMessageReceived(List<Object?>? arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          Map<String, dynamic>? messageJson;
          for (var arg in arguments) {
            if (arg is Map<String, dynamic>) {
              messageJson = arg;
              break;
            } else if (arg is String) {
              try {
                final decoded = jsonDecode(arg);
                if (decoded is Map<String, dynamic>) {
                  messageJson = decoded;
                  break;
                }
              } catch (_) {}
            }
          }

          if (messageJson == null) {
            _talker.warning(
              'SignalR: No valid Map found in messageReceived arguments: $arguments',
            );
            return;
          }

          final message = MessageModel.fromJson(messageJson);
          _messageController.add(message);

          // Persistence: Save to local cache
          _chatLocalCache.appendMessage(message.conversationId, message);

          _talker.info('SignalR: Message received and cached: ${message.id}');
        } catch (e) {
          _talker.error('SignalR: Error parsing messageReceived: $e');
        }
      }
    }

    final eventNames = [
      'messageReceived',
      'MessageReceived',
      'ReceiveMessage',
      'receiveMessage',
      'newMessage',
      'NewMessage',
      'chatMessage',
      'ChatMessage',
      'onMessage',
      'OnMessage',
      'broadcastMessage',
      'BroadcastMessage',
      'Receive',
      'receive',
    ];

    for (var event in eventNames) {
      _hubConnection!.on(event, onMessageReceived);
    }

    void onConversationUpdated(List<Object?>? arguments) {
      _conversationController.add(null);
      _talker.info('SignalR: Conversation updated');
    }

    _hubConnection!.on('conversationUpdated', onConversationUpdated);
    _hubConnection!.on('ConversationUpdated', onConversationUpdated);

    void onMessageDeleted(List<Object?>? arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          int? messageId;
          for (var arg in arguments) {
            if (arg is int) {
              messageId = arg;
              break;
            } else if (arg is String) {
              messageId = int.tryParse(arg);
              if (messageId != null) break;
            }
          }

          if (messageId != null) {
            _deleteController.add(messageId);
            _talker.info('SignalR: Message deleted: $messageId');
          }
        } catch (e) {
          _talker.error('SignalR: Error parsing messageDeleted: $e');
        }
      }
    }

    _hubConnection!.on('messageDeleted', onMessageDeleted);
    _hubConnection!.on('MessageDeleted', onMessageDeleted);
  }

  Future<void> _startWithRetry() async {
    int retryCount = 0;
    const maxRetries = 6;
    bool connected = false;
    bool triedRefresh = false;

    while (retryCount < maxRetries && !connected) {
      try {
        _talker.info(
          'SignalR: Starting connection attempt ${retryCount + 1}...',
        );
        await _hubConnection!.start();
        connected = true;
        _talker.info('SignalR: Connection started successfully');
      } catch (e) {
        if (_isUnauthorizedError(e)) {
          _talker.warning('SignalR: Unauthorized. Trying token refresh...');
          if (!triedRefresh && await _refreshTokenForSignalR()) {
            triedRefresh = true;
            final newToken = await _cacheManager.getToken();
            if (newToken != null && newToken.isNotEmpty) {
              _buildConnection(newToken);
              _registerConnectionHandlers();
              _registerListeners();
              retryCount = 0;
              continue;
            }
          }
          _talker.error('SignalR: Unauthorized after refresh. Stopping.');
          return;
        }

        retryCount++;
        _talker.error('SignalR: Connection attempt $retryCount failed: $e');
        if (retryCount < maxRetries) {
          final delay = Duration(seconds: 2 * retryCount);
          _talker.info('SignalR: Retrying in ${delay.inSeconds}s...');
          await Future.delayed(delay);
        } else {
          _talker.error('SignalR: All connection attempts failed.');
        }
      }
    }
  }

  bool _isUnauthorizedError(Object error) {
    final value = error.toString().toLowerCase();
    return value.contains('401') || value.contains('unauthorized');
  }

  Future<bool> _refreshTokenForSignalR() async {
    final token = await _tokenRefresher.refresh();
    return token != null && token.isNotEmpty;
  }

  Future<void> stop() async {
    if (_hubConnection == null) return;
    try {
      await _hubConnection!.stop();
      _hubConnection = null;
      _talker.info('SignalR: Connection stopped');
    } catch (e) {
      _talker.error('SignalR: Error stopping connection: $e');
    }
  }

  Future<void> joinConversation(int conversationId) async {
    if (_hubConnection?.state != HubConnectionState.Connected) return;

    // Many SignalR backends require clients to explicitly join a conversation group
    // We try the most common method names defensively.
    final methods = [
      'JoinConversation',
      'JoinChat',
      'JoinGroup',
      'JoinRoom',
      'SubscribeToConversation',
    ];
    for (var method in methods) {
      try {
        await _hubConnection!.invoke(method, args: [conversationId]);
        _talker.info(
          'SignalR: Successfully joined conversation via $method($conversationId)',
        );
        return; // Success! Stop trying.
      } catch (e) {
        _talker.verbose(
          'SignalR: Join attempt with $method failed (might not exist): $e',
        );
      }
    }
  }

  @disposeMethod
  void dispose() {
    _messageController.close();
    _conversationController.close();
    _deleteController.close();
  }
}
