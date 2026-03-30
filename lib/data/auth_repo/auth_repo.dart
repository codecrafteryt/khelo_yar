/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: Auth repo (middle_ware)
*/

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import '../api_provider.dart';

class AuthRepo extends GetxService {
  ApiProvider apiProvider;

  AuthRepo({required this.apiProvider,});
}
