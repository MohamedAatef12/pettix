// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

import '../../data/caching/i_cache_manager.dart' as _i694;
import '../../data/network/api_services.dart' as _i655;
import '../../data/network/dio_factory.dart' as _i719;
import '../../data/network/email_auth_service.dart' as _i1;
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
import '../../features/home/data/repo/home_repo_impl.dart' as _i1024;
import '../../features/home/data/sources/local/local_data_source.dart' as _i526;
import '../../features/home/data/sources/local/local_data_source_impl.dart'
    as _i298;
import '../../features/home/data/sources/remote/home_remote_data_source.dart'
    as _i1055;
import '../../features/home/data/sources/remote/home_remote_data_source_impl.dart'
    as _i621;
import '../../features/home/domain/repositories/home_domain_repo.dart' as _i986;
import '../../features/home/domain/usecases/add_comment.dart' as _i829;
import '../../features/home/domain/usecases/add_post.dart' as _i1056;
import '../../features/home/domain/usecases/delete_post.dart' as _i354;
import '../../features/home/domain/usecases/dislike_post.dart' as _i1036;
import '../../features/home/domain/usecases/get_comments_id.dart' as _i604;
import '../../features/home/domain/usecases/get_post_comments_count.dart'
    as _i38;
import '../../features/home/domain/usecases/get_posts.dart' as _i1026;
import '../../features/home/domain/usecases/get_posts_likes.dart' as _i947;
import '../../features/home/domain/usecases/get_user_cached%20_data.dart'
    as _i118;
import '../../features/home/domain/usecases/like_post.dart' as _i58;
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
    gh.lazySingleton<_i1.EmailAuthService>(() => _i1.EmailAuthService());
    gh.lazySingleton<_i718.TwilioService>(() => _i718.TwilioService());
    gh.factory<_i526.GetUserLocalDataSource>(
      () => _i298.GetUserDataSourceImpl(gh<_i694.ICacheManager>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i719.DioFactory>(), gh<_i207.Talker>()),
    );
    gh.lazySingleton<_i655.ApiService>(
      () => _i655.ApiService(gh<_i361.Dio>(), gh<_i694.ICacheManager>()),
    );
    gh.factory<_i865.AuthRemoteDataSource>(
      () => _i523.AuthRemoteDataSourceImpl(
        gh<_i655.ApiService>(),
        gh<_i1.EmailAuthService>(),
      ),
    );
    gh.factory<_i787.AuthRepository>(
      () => _i152.AuthRepositoryImpl(gh<_i865.AuthRemoteDataSource>()),
    );
    gh.factory<_i1055.RemoteDataSource>(
      () => _i621.RemoteDataSourceImpl(gh<_i655.ApiService>()),
    );
    gh.factory<_i986.HomeDomainRepository>(
      () => _i1024.HomeRepositoryImpl(
        gh<_i1055.RemoteDataSource>(),
        gh<_i526.GetUserLocalDataSource>(),
      ),
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
    gh.factory<_i829.AddCommentUseCase>(
      () => _i829.AddCommentUseCase(gh<_i986.HomeDomainRepository>()),
    );
    gh.factory<_i1056.AddPostUseCase>(
      () => _i1056.AddPostUseCase(gh<_i986.HomeDomainRepository>()),
    );
    gh.factory<_i354.DeletePostUseCase>(
      () => _i354.DeletePostUseCase(gh<_i986.HomeDomainRepository>()),
    );
    gh.factory<_i1036.UnLikePostUseCase>(
      () => _i1036.UnLikePostUseCase(gh<_i986.HomeDomainRepository>()),
    );
    gh.factory<_i604.GetPostCommentsUseCase>(
      () => _i604.GetPostCommentsUseCase(gh<_i986.HomeDomainRepository>()),
    );
    gh.factory<_i1026.GetPostsUseCase>(
      () => _i1026.GetPostsUseCase(gh<_i986.HomeDomainRepository>()),
    );
    gh.factory<_i947.GetPostLikesUseCase>(
      () => _i947.GetPostLikesUseCase(gh<_i986.HomeDomainRepository>()),
    );
    gh.factory<_i38.GetPostCommentsCountsUseCase>(
      () => _i38.GetPostCommentsCountsUseCase(gh<_i986.HomeDomainRepository>()),
    );
    gh.factory<_i58.LikePostUseCase>(
      () => _i58.LikePostUseCase(gh<_i986.HomeDomainRepository>()),
    );
    gh.factory<_i118.GetUserDataUseCase>(
      () => _i118.GetUserDataUseCase(gh<_i986.HomeDomainRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i913.RegisterModule {}
