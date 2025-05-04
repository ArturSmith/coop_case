import 'package:coop_case/app/screen/store/store_view_mode.dart';
import 'package:coop_case/domain/entity/store.dart';
import 'package:coop_case/utils/custom_url_launcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUrlLauncher extends Mock implements CustomUrlLauncher {}

void main() {
  final storeMock = Store(
    url: 'http://valid-url.com',
    name: "coop",
    address: "Oslo",
    zip: "0977",
    city: "Oslo",
    chain: "coop",
    openingHours: [],
    latitude: null,
    longitude: null,
  );

  group('StoreViewModel Tests', () {
    late CustomUrlLauncher launcher;
    late StoreViewModel storeViewModel;

    setUp(() {
      launcher = MockUrlLauncher();
      storeViewModel = StoreViewModel(store: storeMock, launcher: launcher);

      when(
        () => launcher.tryParseUri(storeMock.url),
      ).thenAnswer((_) => Uri.base);
    });

    test('should show snackbar message when URL is invalid', () async {
      when(() => launcher.tryParseUri(storeMock.url)).thenAnswer((_) => null);

      await storeViewModel.launchStore();

      expect(
        storeViewModel.snackbarMessage.value,
        "Invalid URL. Please try again.",
      );
    });

    test('should show snackbar message when URL cannot be launched', () async {
      when(() => launcher.canLaunch(Uri.base)).thenAnswer((_) async => false);

      await storeViewModel.launchStore();

      expect(
        storeViewModel.snackbarMessage.value,
        "Unable to launch the store web page.",
      );
      verify(() => launcher.canLaunch(Uri.base)).called(1);
    });

    test('should successfully launch URL', () async {
      when(() => launcher.canLaunch(Uri.base)).thenAnswer((_) async => true);
      when(() => launcher.launch(Uri.base)).thenAnswer((_) async => true);

      await storeViewModel.launchStore();

      expect(storeViewModel.snackbarMessage.value, isNull);

      verify(() => launcher.launch(Uri.base)).called(1);
    });
  });
}
