/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: check device connectivity
*/

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnectionService {
  bool hasConnection = false;

  // This is how we'll allow subscribing to connection changes
  final StreamController<bool> connectionChangeController = StreamController<bool>.broadcast();

  // flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  // Hook into flutter_connectivity's Stream to listen for changes
  // And check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream<bool> get connectionChange => connectionChangeController.stream;

  // A clean-up method to close our StreamController
  // Because this is meant to exist through the entire application life cycle this isn't
  // really an issue
  void dispose() {
    connectionChangeController.close();
  }

  // flutter_connectivity's listener
  void _connectionChange(List<ConnectivityResult> results) {
    checkConnection();
  }

  // The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    // The connection status changed; send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}
