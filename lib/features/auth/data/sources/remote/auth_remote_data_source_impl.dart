import 'package:injectable/injectable.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/data/network/email_auth_service.dart';
import 'package:pettix/data/network/twilio_service.dart';
import 'package:pettix/features/auth/data/models/login/google_login_model.dart';
import 'package:pettix/features/auth/data/models/login/google_login_response_model.dart';
import 'package:pettix/features/auth/data/models/login/login_response_model.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';
import 'package:pettix/features/auth/data/sources/remote/auth_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:pettix/features/auth/data/models/login/login_model.dart';
import 'package:pettix/features/auth/data/models/register/register_model.dart';
import 'package:pettix/data/network/failure.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;
  final EmailAuthService emailAuthService;
  AuthRemoteDataSourceImpl(this.apiService, this.emailAuthService);

  @override
  Future<Either<Failure, LoginResponseModel>> login(LoginModel model) async {
    try {
      final response = await apiService.post(
        endPoint: Constants.loginEndpoint,
        data: model.toJson(),
      );

      final message = response['message'] ?? '';

      if (message == 'Login successful') {
        final userJson = response['contact'];
        final userModel = UserModel.fromJson(userJson);
        final token = response['token'] as String;
        await DI.find<ICacheManager>().setUserData(userModel);

        return Right(
          LoginResponseModel(
            user: userModel,
            token: token,
            message: response['message'] ?? 'Login successful',
            role: response['role'] ?? '',
            refreshToken: response['refreshToken'] ?? '',
            success: response['success'] ?? true,
          ),
        );
      }
      return Left(Failure('Login failed'));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> register(RegisterModel model) async {
    try {
      await apiService.post(
        endPoint: Constants.usersEndpoint,
        data: model.toJson(),
      );
      return Right(null);
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
  @override
  Future<Either<Failure, GoogleLoginResponseModel>> loginWithGoogle(
      GoogleLoginModel model,
      ) async {
    try {
      print('[DEBUG] Google Login - Sending idToken');

      final response = await apiService.post(
        endPoint: Constants.googleLoginEndpoint,
        data: {'idToken': model.idToken},
      );

      print('[DEBUG] Google Login Response: $response');

      final result = response['result'];
      if (result == null) {
        return Left(Failure("Invalid response format - result is null"));
      }

      final userJson = result['contact'];
      final token = result['token'];

      if (userJson == null || token == null) {
        print('[DEBUG] Google Login - Missing contact or token. Contact: $userJson, Token: $token');
        return Left(Failure("Invalid response format from server"));
      }

      final userModel = UserModel.fromJson(userJson);

      await DI.find<ICacheManager>().setUserData(userModel);

      return Right(
        GoogleLoginResponseModel(
          success: response['success'] ?? true,
          message: response['message'] ?? '',
          traceId: response['traceId'] ?? '',
          resultSuccess: result['success'] ?? true,
          resultMessage: result['message'] ?? '',
          token: token,
          refreshToken: result['refreshToken'] ?? '',
          role: result['role'] ?? '',
          user: userModel,
        ),
      );
    } catch (e) {
      print('[ERROR] Google Login failed: $e');
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> sendOtp(String email) async {
    try {
      final result = await emailAuthService.sendOtp(email);
      if (result) {
        return Right(true);
      } else {
        return Left(Failure('Email OTP send failed'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String email, String code) async {
    try {
      final result = await emailAuthService.verifyOtp(email, code);
      if (result) {
        return Right(true);
      } else {
        return Left(Failure('Email OTP verification failed'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
