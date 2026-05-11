import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../data/caching/i_cache_manager.dart';
import '../../data/network/constants.dart';
import '../../features/chat/data/data_source/chat_local_data_source.dart';
import '../../features/chat/data/model/message_model.dart';

@lazySingleton
class SignalRService {
  final ICacheManager _cacheManager;
  final Talker _talker;
  final ChatLocalDataSource _chatLocalCache;
  HubConnection? _hubConnection;
  
  final _messageController = StreamController<MessageModel>.broadcast();
  final _conversationController = StreamController<void>.broadcast();
  final _deleteController = StreamController<int>.broadcast();

  Stream<MessageModel> get messageStream => _messageController.stream;
  Stream<void> get conversationStream => _conversationController.stream;
  Stream<int> get deleteStream => _deleteController.stream;

  SignalRService(this._cacheManager, this._talker, this._chatLocalCache);

  Future<void> start() async {
    if (_hubConnection?.state == HubConnectionState.Connected) return;

    final token = await _cacheManager.getToken();
    if (token == null || token.isEmpty) {
      _talker.error('SignalR: Cannot start connection without token');
      return;
    }

    // Backend constraint: token MUST be in the query string
    final hubUrl = '${Constants.baseUrl}/hubs/chat?access_token=$token';
    
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          options: HttpConnectionOptions(
            headers: MessageHeaders()..setHeaderValue('ngrok-skip-browser-warning', 'true'),
          ),
        )
        .withAutomaticReconnect()
        .build();

    _hubConnection!.onclose(({error}) {
      _talker.warning('SignalR: Connection closed. Error: $error');
    });

    _hubConnection!.onreconnecting(({error}) {
      _talker.warning('SignalR: Reconnecting. Error: $error');
    });

    _hubConnection!.onreconnected(({connectionId}) {
      _talker.info('SignalR: Reconnected. ConnectionId: $connectionId');
    });

    // Register Listeners
    _hubConnection!.on('messageReceived', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final messageJson = arguments[0] as Map<String, dynamic>;
          final message = MessageModel.fromJson(messageJson);
          _messageController.add(message);
          
          // Persistence: Save to local cache
          _chatLocalCache.appendMessage(message.conversationId, message);
          
          _talker.info('SignalR: Message received and cached: ${message.id}');
        } catch (e) {
          _talker.error('SignalR: Error parsing messageReceived: $e');
        }
      }
    });

    _hubConnection!.on('conversationUpdated', (arguments) {
      _conversationController.add(null);
      _talker.info('SignalR: Conversation updated');
    });

    _hubConnection!.on('messageDeleted', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final messageId = arguments[0] as int;
          _deleteController.add(messageId);
          _talker.info('SignalR: Message deleted: $messageId');
        } catch (e) {
          _talker.error('SignalR: Error parsing messageDeleted: $e');
        }
      }
    });
    
    int retryCount = 0;
    const maxRetries = 6;
    bool connected = false;

    while (retryCount < maxRetries && !connected) {
      try {
        _talker.info('SignalR: Starting connection attempt ${retryCount + 1}...');
        await _hubConnection!.start();
        connected = true;
        _talker.info('SignalR: Connection started successfully');
      } catch (e) {
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

  @disposeMethod
  void dispose() {
    _messageController.close();
    _conversationController.close();
    _deleteController.close();
  }
}
