import 'package:coop_case/domain/entity/Store.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreViewModel extends ChangeNotifier {
  final Store _store;
  Store get store => _store;

  StoreViewModel({required Store store}) : _store = store;

  String? _snackbarMessage;
  String? get snackbarMessage => _snackbarMessage;

  void launchStore() async {
    final localUrl = Uri.tryParse(_store.url);

    if (localUrl == null) {
      _snackbarMessage = "Error while launching, try again.";
      notifyListeners();
      return;
    }

    final canLaunch = await canLaunchUrl(localUrl);

    if (!canLaunch) {
      _snackbarMessage = "Unable to launch";
      notifyListeners();
      return;
    }

    if (canLaunch) {
      await launchUrl(localUrl);
    } else {}
  }
}
