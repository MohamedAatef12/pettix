import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/email_auth_service.dart';
import 'package:pettix/data/network/twilio_service.dart';
import 'package:pettix/features/auth/data/models/login/google_login_model.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';
import 'package:pettix/features/auth/domain/entities/google_login_entity.dart';
import 'package:pettix/features/auth/domain/entities/register_domain_entity.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/auth/domain/usecases/forgot_password.dart';
import 'package:pettix/features/auth/domain/usecases/google_login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/register_usecase.dart';
import 'package:pettix/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:pettix/features/auth/domain/usecases/reset_password.dart';
import 'package:pettix/features/auth/domain/usecases/verify_otp.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final GoogleLoginUseCase googleLoginUseCase;
  final EmailAuthService emailAuthService;
  final VerifyOtp verifyOtp;
  final ResendOtpUseCase resendOtpUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
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
  String? _pendingEmail;
  // Controllers for Forgot Password
  final emailForgotController = TextEditingController();
  final otpForgotController = TextEditingController();
  final newPasswordForgotController = TextEditingController();
  final confirmNewPasswordForgotController = TextEditingController();
  final forgotFormKey = GlobalKey<FormState>();
  AuthBloc( {
    required this.registerUseCase,
    required this.loginUseCase,
    required this.googleLoginUseCase,
    required this.emailAuthService,
    required this.verifyOtp,
    required this.resendOtpUseCase,
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
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
    on<ResendOtpEvent>(_resendOtp);
    on<LoginTogglePasswordVisibility>((event, emit) {
      obscurePasswordLogin = !obscurePasswordLogin;
      emit(LoginPasswordVisibilityChanged());
    });
    on<ToggleRememberMe>((event, emit) {
      rememberMe = event.value;
      emit(LoginRememberMeChanged(rememberMe));
    });
    on<GoogleLoginSubmitted>(_googleLoginSubmitted);
    on<ForgotPasswordEvent>(_forgotPassword);
    on<ResetPasswordEvent>(_resetPassword);
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

    // Continue to step two locally
    emit(RegisterStepOneSuccess());
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
    
    emit(RegisterLoading());
    
    // Call the register endpoint to send the OTP to the user's email
    final result = await registerUseCase(_tempRegisterData!);

    result.fold(
          (failure) => emit(RegisterFailure(failure.message)),
          (_) => emit(RegisterStepTwoSuccess()),
    );
  }

// Step 3: OTP
  Future<void> _registerOtp(
      RegisterOtpSubmitted event, Emitter<AuthState> emit) async {
    // Support both the registration flow (_tempRegisterData) and the
    // login "activate email" flow (_pendingEmail set by ResendOtpEvent).
    final email = _tempRegisterData?.email ?? _pendingEmail;
    if (email == null) {
      emit(RegisterFailure("Email not found. Please start the process again."));
      return;
    }

    emit(RegisterLoading());

    final verified = await verifyOtp(email, event.otp);

    verified.fold(
          (failure) => emit(RegisterFailure(failure.message)),
          (_) {
            if (_tempRegisterData != null) {
              _tempRegisterData = _tempRegisterData!.copyWith(otp: event.otp);
            }
            _pendingEmail = null; // clear after successful verification
            emit(RegisterOtpSuccess());
          },
    );
  }

Future<void> _loginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(LoginLoading());

    final result = await loginUseCase(event.model);
    await result.fold(
          (failure) async {
            print('failure message: ${failure.message}');
            emit(LoginFailure(failure.message));} ,
          (loginResponse) async {
        await DI.find<ICacheManager>()
            .setUserData(UserModel.fromEntity(loginResponse.contact));
        await DI.find<ICacheManager>().setToken(loginResponse.token);
        await DI.find<ICacheManager>().setRefreshToken(loginResponse.refreshToken.toString());// ✅ stores user + logged_in = true

        if (event.rememberMe) {
          await DI.find<ICacheManager>().saveLogin(true);
        } else {
          await DI.find<ICacheManager>().clearLogin();
        }

        emit(LoginSuccess(loginResponse.contact));
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
        emit(GoogleLoginFailure("Google login cancelled"));
        return;
      }

      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        emit(GoogleLoginFailure("Failed to get Google ID token"));
        return;
      }

      final result = await googleLoginUseCase(
        GoogleLoginEntity(idToken: googleAuth.idToken!),
      );

      await result.fold(
            (failure) {
          emit(GoogleLoginFailure(failure.message));
        },
            (loginResponse) async {
          // هنا loginResponse.result عبارة عن String
          await DI.find<ICacheManager>().setToken(loginResponse.token);

          if (event.rememberMe) {
            await DI.find<ICacheManager>().saveLogin(true);
          } else {
            await DI.find<ICacheManager>().clearLogin();
          }

          emit(GoogleLoginSuccess(loginResponse.user)); // مفيش User entity جديد
        },
      );
    } catch (e, st) {
      emit(GoogleLoginFailure(e.toString()));
    }
  }
  Future<void> _resendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    _pendingEmail = event.email; // store for OTP verification step

    final result = await resendOtpUseCase(event.email);

    result.fold(
          (failure) {
            _pendingEmail = null; // clear on failure
            emit(RegisterFailure(failure.message));
          },
          (_) => emit(OtpSent()),
    );
  }
  Future<void> _forgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    _pendingEmail = event.email; // ensure OTP verification can use this email

    final result = await forgotPasswordUseCase(event.email);

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(OtpSent()),
    );
  }
  Future<void> _resetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await resetPasswordUseCase(
      event.email,
      event.otp,
      event.newPassword,
      event.confirmPassword,
    );

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(AuthSuccess(UserEntity(
        id: 0,
        email: event.email,
        userName: '',
        phone: '',
        country: '',
        city: '',
        image: '',
        gender: '',
        age: 0,
        address: '',
        idImage: '',
      ))),
    );
    }
}
