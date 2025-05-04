import 'package:coop_case/domain/entity/store.dart';
import 'package:coop_case/utils/custom_url_launcher.dart';
import 'package:flutter/material.dart';

class StoreViewModel {
  final CustomUrlLauncher _launcher;

  final Store store;

  StoreViewModel({required this.store, required CustomUrlLauncher launcher})
    : _launcher = launcher;

  final ValueNotifier<String?> snackbarMessage = ValueNotifier(null);

  Future<void> launchStore() async {
    final Uri? localUrl = _launcher.tryParseUri(store.url);

    if (localUrl == null) {
      _showMessage("Invalid URL. Please try again.");
      return;
    }

    final canLaunch = await _launcher.canLaunch(localUrl);
    if (!canLaunch) {
      _showMessage("Unable to launch the store web page.");
      return;
    }

    await _launcher.launch(localUrl);
  }

  void _showMessage(String message) {
    snackbarMessage.value = message;
  }

  void clearMessage() {
    snackbarMessage.value = null;
  }
}
