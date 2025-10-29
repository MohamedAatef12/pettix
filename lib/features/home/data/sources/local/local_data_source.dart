
import 'package:pettix/features/auth/data/models/register/register_model.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';

abstract class GetUserLocalDataSource {
  UserModel getUserData();
}
