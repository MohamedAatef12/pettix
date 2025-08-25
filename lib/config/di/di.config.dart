// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

import '../../data/caching/i_cache_manager.dart' as _i694;
import '../../data/network/api_services.dart' as _i655;
import '../../data/network/dio_factory.dart' as _i719;
import '../../data/network/twilio_service.dart' as _i718;
import '../../features/auth/data/repos/auth_repo_impl.dart' as _i152;
import '../../features/auth/data/sources/remote/auth_remote_data_source.dart'
    as _i865;
import '../../features/auth/data/sources/remote/auth_remote_data_source_impl.dart'
    as _i523;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/google_login_use_case.dart'
    as _i550;
import '../../features/auth/domain/usecases/login_use_case.dart' as _i37;
import '../../features/auth/domain/usecases/register_usecase.dart' as _i941;
import '../../features/auth/domain/usecases/send_otp_use_case.dart' as _i643;
import '../../features/auth/domain/usecases/verify_otp.dart' as _i975;
import 'di.dart' as _i913;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i207.Talker>(() => registerModule.talker);
    gh.lazySingleton<_i719.DioFactory>(() => registerModule.dioFactory);
    gh.lazySingleton<_i694.ICacheManager>(() => registerModule.cacheManager);

    gh.lazySingleton<_i718.TwilioService>(() => _i718.TwilioService());
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i719.DioFactory>(), gh<_i207.Talker>()),
    );
    gh.lazySingleton<_i655.ApiService>(() => _i655.ApiService(gh<_i361.Dio>()));
    gh.factory<_i865.AuthRemoteDataSource>(
      () => _i523.AuthRemoteDataSourceImpl(
        gh<_i655.ApiService>(),
        gh<_i718.TwilioService>(),
      ),
    );
    gh.factory<_i787.AuthRepository>(
      () => _i152.AuthRepositoryImpl(gh<_i865.AuthRemoteDataSource>()),
    );
    gh.factory<_i550.GoogleLoginUseCase>(
      () => _i550.GoogleLoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i37.LoginUseCase>(
      () => _i37.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i941.RegisterUseCase>(
      () => _i941.RegisterUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i643.SendOtpUseCase>(
      () => _i643.SendOtpUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i975.VerifyOtp>(
      () => _i975.VerifyOtp(gh<_i787.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i913.RegisterModule {}
