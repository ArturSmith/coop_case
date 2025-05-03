import 'package:coop_case/app/screen/store/store_view_mode.dart';
import 'package:coop_case/domain/entity/Store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatelessWidget {
  final Store _store;
  const StoreScreen({super.key, required Store store}) : _store = store;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoreViewModel(store: _store),
      child: Scaffold(body: _StoreScreenBody()),
    );
  }
}

class _StoreScreenBody extends StatelessWidget {
  const _StoreScreenBody();

  @override
  Widget build(BuildContext context) {
    final model = context.read<StoreViewModel>();
    final snackbarMessage = context.watch<StoreViewModel>().snackbarMessage;
    final store = context.watch<StoreViewModel>().store;

    if (snackbarMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(snackbarMessage)));
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(store.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/coop.png',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(store.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('${store.address}, ${store.zip} ${store.city}'),
            const SizedBox(height: 8),
            Text('Сеть: ${store.chain}'),
            const SizedBox(height: 16),
            Text(
              'Часы работы:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...store.openingHours.entries.map(
              (e) => Text('${e.key}: ${e.value}'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => model.launchStore(),
              child: const Text('Перейти в магазин'),
            ),
          ],
        ),
      ),
    );
  }
}
