import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/twilio_service.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';
import 'package:pettix/features/auth/domain/entities/google_login_entity.dart';
import 'package:pettix/features/auth/domain/entities/register_domain_entity.dart';
import 'package:pettix/features/auth/domain/usecases/google_login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/register_usecase.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final GoogleLoginUseCase googleLoginUseCase;
  final TwilioService twilioService;

  // Controllers for Register
final fullNameController = TextEditingController();
  final emailRegisterController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordRegisterController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool obscurePasswordRegister = true;
  bool obscureConfirmPassword = true;
  final registerFormKey = GlobalKey<FormState>();

  // Controllers for Login
  final emailLoginController = TextEditingController();
  final passwordLoginController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool obscurePasswordLogin = true;
  RegisterEntity? _tempRegisterData;
  AuthBloc( {
    required this.registerUseCase,
    required this.loginUseCase,
    required this.googleLoginUseCase,
    required this.twilioService,
  }) : super(AuthInitial()) {
    // Register events
    on<RegisterStepOneSubmitted>(_registerStepOne);
    on<RegisterStepTwoSubmitted>(_registerStepTwo);
    on<RegisterOtpSubmitted>(_registerOtp);
    on<RegisterTogglePasswordVisibility>((event, emit) {
      obscurePasswordRegister = !obscurePasswordRegister;
      emit(RegisterPasswordVisibilityChanged());
    });
    on<RegisterToggleConfirmPasswordVisibility>((event, emit) {
      obscureConfirmPassword = !obscureConfirmPassword;
      emit(RegisterConfirmPasswordVisibilityChanged());
    });

    // Login events
    on<LoginSubmitted>(_loginSubmitted);
    on<LoginTogglePasswordVisibility>((event, emit) {
      obscurePasswordLogin = !obscurePasswordLogin;
      emit(LoginPasswordVisibilityChanged());
    });
    on<ToggleRememberMe>((event, emit) {
      rememberMe = event.value;
      emit(LoginRememberMeChanged(rememberMe));
    });
    on<GoogleLoginSubmitted>(_googleLoginSubmitted);
  }

  /// Handle Register
  Future<void> _registerStepOne(
      RegisterStepOneSubmitted event, Emitter<AuthState> emit) async {
    emit(RegisterLoading());

    _tempRegisterData = RegisterEntity(
      id: 0,
      email: event.email,
      password: '',
      userName: event.name,
      phone: event.phone,
      country: '',
      city: '',
      image: '',
      gender: '',
      age: 0,
      address: '',
      idImage: '',
    );

    // نرسل OTP عبر Twilio
    final otpSent = await twilioService.sendOtp(event.phone);

    if (otpSent) {
      emit(RegisterStepOneSuccess());
    } else {
      emit(RegisterFailure("فشل إرسال رمز التحقق"));
    }
  }


// Step 2: Confirm Password
  Future<void> _registerStepTwo(
      RegisterStepTwoSubmitted event, Emitter<AuthState> emit) async {
    if (_tempRegisterData == null) {
      emit(RegisterFailure("Step one not completed"));
      return;
    }

    if (event.password != event.confirmPassword) {
      emit(RegisterFailure("Passwords do not match"));
      return;
    }

    _tempRegisterData = _tempRegisterData!.copyWith(
      password: event.password,
    );

    emit(RegisterStepTwoSuccess());
  }

// Step 3: OTP
  Future<void> _registerOtp(
      RegisterOtpSubmitted event, Emitter<AuthState> emit) async {
    if (_tempRegisterData == null) {
      emit(RegisterFailure("Previous steps not completed"));
      return;
    }

    emit(RegisterLoading());

    final verified = await twilioService.verifyOtp(
      _tempRegisterData!.phone,
      event.otp,
    );

    if (!verified) {
      emit(RegisterFailure("رمز التحقق غير صحيح"));
      return;
    }

    // بعد التأكد من OTP → نسجل المستخدم في الباك إند
    _tempRegisterData = _tempRegisterData!.copyWith(otp: event.otp);

    final result = await registerUseCase(_tempRegisterData!);

    result.fold(
          (failure) => emit(RegisterFailure(failure.message)),
          (_) => emit(RegisterOtpSuccess()),
    );
  }


  /// Handle Login
  Future<void> _loginSubmitted(
      LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(LoginLoading());
    final result = await loginUseCase(event.model);
    result.fold(
          (failure) => emit(LoginFailure(failure.message)),
          (loginResponse) {
        if (event.rememberMe) {
          DI.find<ICacheManager>().saveLogin(true);
        } else {
          DI.find<ICacheManager>().clearLogin();
        }
        emit(LoginSuccess(loginResponse.user));
      },
    );
  }
  Future<void> _googleLoginSubmitted(
      GoogleLoginSubmitted event, Emitter<AuthState> emit) async {
    emit(GoogleLoginLoading());

    try {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint("❌ Google sign in cancelled by user");
        emit(GoogleLoginFailure("Google login cancelled"));
        return;
      }

      final googleAuth = await googleUser.authentication;
      debugPrint("✅ Google accessToken: ${googleAuth.accessToken}");
      debugPrint("✅ Google idToken: ${googleAuth.idToken}");

      if (googleAuth.idToken == null) {
        emit(GoogleLoginFailure("Failed to get Google ID token"));
        return;
      }

      final result = await googleLoginUseCase(
        GoogleLoginEntity(idToken: googleAuth.idToken!),
      );

     await result.fold(
            (failure) {
          debugPrint("❌ Backend rejected login: ${failure.message}");
          emit(GoogleLoginFailure(failure.message));
        },
            (loginResponse) async {
              await DI.find<ICacheManager>().setUserData(UserModel.fromEntity(loginResponse.user));
          debugPrint("✅ Backend login success, user: ${loginResponse.user.email}");
          emit(GoogleLoginSuccess(loginResponse.user));
        },
      );
    } catch (e, st) {
      debugPrint("❌ Exception during Google login: $e\n$st");
      emit(GoogleLoginFailure(e.toString()));
    }
  }


  @override
  Future<void> close() {
    // Dispose controllers to prevent memory leaks
  fullNameController.dispose();
    emailRegisterController.dispose();
    phoneController.dispose();
    passwordRegisterController.dispose();
    confirmPasswordController.dispose();

    emailLoginController.dispose();
    passwordLoginController.dispose();

    return super.close();
  }
}
