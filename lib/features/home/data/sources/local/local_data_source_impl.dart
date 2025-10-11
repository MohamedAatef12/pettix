import 'package:injectable/injectable.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/features/auth/data/models/register/register_model.dart';

import 'local_data_source.dart';

@Injectable(as: GetUserLocalDataSource)
class GetUserDataSourceImpl extends GetUserLocalDataSource {
  final ICacheManager _cacheManager;

  GetUserDataSourceImpl(this._cacheManager);

  @override
  RegisterModel getUserData() {
    return _cacheManager.getUserData()!;
  }
}
