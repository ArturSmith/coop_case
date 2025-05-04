import 'package:coop_case/app/screen/store/store_view_mode.dart';
import 'package:coop_case/domain/entity/opening_hour.dart';
import 'package:coop_case/domain/entity/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatelessWidget {
  final Store store;

  const StoreScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Provider(
      lazy: true,
      create: (_) => StoreViewModel(store: store, launcher: context.read()),
      child: const _StoreScreenBody(),
    );
  }
}

class _StoreScreenBody extends StatefulWidget {
  const _StoreScreenBody();

  @override
  State<_StoreScreenBody> createState() => _StoreScreenBodyState();
}

class _StoreScreenBodyState extends State<_StoreScreenBody> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StoreViewModel>();

    return ValueListenableBuilder<String?>(
      valueListenable: viewModel.snackbarMessage,
      builder: (context, message, child) {
        if (message != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
            viewModel.clearMessage();
          });
        }

        return child!;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: const SafeArea(child: _StoreContent()),
      ),
    );
  }
}

class _StoreContent extends StatelessWidget {
  const _StoreContent();

  @override
  Widget build(BuildContext context) {
    final store = context.select((StoreViewModel vm) => vm.store);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _StoreImage(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        store.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text('${store.address}, ${store.zip} ${store.city}'),
                      const SizedBox(height: 8),
                      Text('Chain: ${store.chain}'),
                      const SizedBox(height: 16),
                      Text(
                        'Open:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...store.openingHours.asMap().entries.map(
                        (entry) => OpeningHourItem(
                          hours: entry.value,
                          isGrey: entry.key.isEven,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const _StoreButton(),
      ],
    );
  }
}

class _StoreButton extends StatelessWidget {
  const _StoreButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => context.read<StoreViewModel>().launchStore(),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
          child: const Text('Open store web page'),
        ),
      ),
    );
  }
}

class OpeningHourItem extends StatelessWidget {
  final OpeningHours hours;
  final bool isGrey;

  const OpeningHourItem({required this.hours, required this.isGrey, super.key});

  @override
  Widget build(BuildContext context) {
    final containerColor =
        isGrey ? const Color.fromARGB(255, 211, 209, 209) : Colors.transparent;

    return Container(
      color: containerColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hours.day, style: const TextStyle(color: Colors.black)),
          Text(hours.timeText, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}

class _StoreImage extends StatelessWidget {
  const _StoreImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/coop.png',
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Placeholder(),
    );
  }
}
