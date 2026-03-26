import 'package:injectable/injectable.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/models/response_model.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/data/network/email_auth_service.dart';
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
      final resultJson = response.result as Map<String, dynamic>?;
      if (resultJson != null && response.success == true) {
        final loginResponse = LoginResponseModel.fromJson(resultJson);
        await DI.find<ICacheManager>().setUserData(loginResponse.contact);
        await DI.find<ICacheManager>().setToken(loginResponse.token);
        await DI.find<ICacheManager>().setRefreshToken(
            loginResponse.refreshToken);
        return Right(loginResponse);
      }

      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> register(RegisterModel model) async {
    try {
      final response = await apiService.post(
        endPoint: Constants.registerEndpoint,
        data: {
          "email": model.email,
          "password": model.password,
          "phone": model.phone,
          "fullName": model.userName,
        },
      );
      if (response.success == true) {
        return const Right(null);
      }
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, GoogleLoginResponseModel>> loginWithGoogle(
      GoogleLoginModel model,) async {
    try {
      print('[DEBUG] Google Login - Sending idToken');

      final response = await apiService.post(
        endPoint: Constants.googleLoginEndpoint,
        data: {'idToken': model.idToken},
      );

      print('[DEBUG] Google Login Response: $response');

      final result = response.result as Map<String, dynamic>?;
      if (result == null || response.success != true) {
        return Left(Failure(response.message.isNotEmpty
            ? response.message
            : "Invalid response format - result is null"));
      }

      final userJson = result['contact'];
      final token = result['token'];

      if (userJson == null || token == null) {
        print(
            '[DEBUG] Google Login - Missing contact or token. Contact: $userJson, Token: $token');
        return Left(Failure("Invalid response format from server"));
      }

      final userModel = UserModel.fromJson(userJson);

      await DI.find<ICacheManager>().setUserData(userModel);

      return Right(
        GoogleLoginResponseModel(
          success: response.success,
          message: response.message,
          traceId: response.traceId,
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
  Future<Either<Failure, bool>> verifyOtp(String email, String otp) async {
    try {
      final response = await apiService.post(
          endPoint: Constants.verifyOtpEndpoint, data: {
        'email': email,
        'otp': otp,
      });
      if (response.success == true) {
        return Right(true);
      }
      return Left(Failure(response.message));
    }
    catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
  @override
  Future<Either<Failure, void>> resendOtp(String email) async {
    try {
      final response = await apiService.post(
          endPoint: Constants.resendOtpEndpoint, data: {
        'email': email,
      });
      if (response.success == true) {
        return Right(response.message);
      }
      return Left(Failure(response.message));
    }
    catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
}
