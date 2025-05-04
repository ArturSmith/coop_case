import 'package:url_launcher/url_launcher.dart';

abstract class CustomUrlLauncher {
  Uri? tryParseUri(String uri, [int start = 0, int? end]);

  Future<bool> canLaunch(Uri url);

  Future<bool> launch(Uri url);
}

class CustomUrlLauncherImpl extends CustomUrlLauncher {
  @override
  Uri? tryParseUri(String uri, [int start = 0, int? end]) {
    return Uri.tryParse(uri, start, end);
  }

  @override
  Future<bool> canLaunch(Uri url) async {
    return await canLaunchUrl(url);
  }

  @override
  Future<bool> launch(Uri url) async {
    return await launchUrl(url);
  }
}
