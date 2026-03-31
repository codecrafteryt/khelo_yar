/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: di here
*/

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:khelo_yar/controller/auth_controller.dart';
import 'package:khelo_yar/controller/home_host_controller.dart';
import 'package:khelo_yar/controller/map_controller.dart';
import 'package:khelo_yar/data/auth_repo/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_provider.dart';

class DependencyInjection {
  static void init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut(() => sharedPreferences, fenix: true);
    Get.lazyPut(() => ApiProvider());
    Get.lazyPut(() => AuthRepo(apiProvider: Get.find()));
    Get.lazyPut(() => AuthController(authRepo: Get.find(), sharedPreferences: Get.find(),), fenix: true,);
    Get.lazyPut(() => MapController(sharedPreferences: Get.find(),), fenix: true,);
    Get.lazyPut(() => HomeHostController(sharedPreferences: Get.find(),), fenix: true,);
  }
}
