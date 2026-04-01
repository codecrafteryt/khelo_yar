import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchingController extends GetxController {
  final SharedPreferences sharedPreferences;
  SearchingController({required this.sharedPreferences,});
}
