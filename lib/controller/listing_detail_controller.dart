  /*
    ---------------------------------------
    Project: khelo yaar Mobile Application
    Date: April 2, 2024
    Author: Ameer Salman
    ---------------------------------------
    Description: Listing detail controller
  */

  import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

  class ListingDetailController extends GetxController {
    final SharedPreferences sharedPreferences;
    ListingDetailController({required this.sharedPreferences,});
  }