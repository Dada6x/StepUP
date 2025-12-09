// lib/core/services/network_serice.dart
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyc_test/core/constants/themes/colors.dart';

//@ Globally accessible offline flag (true = no usable internet).
final RxBool isOffline = false.obs;

enum NetStatus { online, offline, limited }

class NetworkService extends GetxService {
  final Connectivity _conn;
  NetworkService(this._conn);

  /// Optional detailed status if you ever want it.
  final Rx<NetStatus> status = NetStatus.offline.obs;

  StreamSubscription<List<ConnectivityResult>>? _sub;
  Worker? _offlineWorker;

  Future<NetworkService> init() async {
    // initial state (v6 returns List<ConnectivityResult>)
    final initial = await _conn.checkConnectivity();
    await _updateFrom(initial);

    // listen for changes (v6 stream: List<ConnectivityResult>)
    _sub = _conn.onConnectivityChanged.listen(_updateFrom);

    // global reaction: show/hide snackbar automatically
    _offlineWorker = ever<bool>(isOffline, (offline) {
      if (offline) {
        Get.rawSnackbar(
          isDismissible: true,
          message: "You Are Offline",

          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.danger,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
          // icon: const Iconify(Carbon.wifi_off, color: white),
          snackStyle: SnackStyle.FLOATING,
        );
      } else {
        Get.rawSnackbar(
          isDismissible: true,
          message: "You'r Back Online",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
          snackStyle: SnackStyle.FLOATING,
        );
      }
    });

    return this;
  }

  Future<void> _updateFrom(List<ConnectivityResult> results) async {
    // nothing or only "none" -> offline
    if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
      status.value = NetStatus.offline;
      isOffline.value = true;
      return;
    }

    // active probe – checks real internet, not just Wi-Fi link
    final ok = await _activeProbe();
    status.value = ok ? NetStatus.online : NetStatus.limited;
    isOffline.value = !ok;
  }

  Future<bool> _activeProbe() async {
    try {
      final res = await InternetAddress.lookup('1.1.1.1')
          .timeout(const Duration(seconds: 2));
      return res.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  bool get isOnline => !isOffline.value;

  @override
  void onClose() {
    _sub?.cancel();
    _offlineWorker?.dispose();
    super.onClose();
  }
}
