import 'package:pettix/config/env/app_config.dart';

import 'main_common.dart';

Future<void> main() async {
  await mainCommon(AppConfig.prod);
}
