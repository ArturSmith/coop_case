import 'package:coop_case/app/screen/home/home_screen_state.dart';
import 'package:coop_case/app/screen/home/home_view_model.dart';
import 'package:coop_case/app/screen/store/store_screen.dart';
import 'package:coop_case/domain/entity/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      lazy: true,
      create: (context) => HomeViewModel(searchStoresUseCase: context.read()),
      child: const _HomeScreenBody(),
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: viewModel.controller,
              decoration: const InputDecoration(
                hintText: "Enter shop zip or name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 10),
                onPressed:
                    () => viewModel.searchStores(viewModel.controller.text),
                child: const Text(
                  "Search",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(child: _Content()),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HomeState>(
      valueListenable: context.watch<HomeViewModel>().state,
      builder: (context, state, _) {
        switch (state) {
          case HomeInitial():
            return const SizedBox();
          case HomeLoading():
            return const Center(child: CircularProgressIndicator());
          case HomeError():
            return Center(child: Text(state.message));
          case HomeLoaded():
            return _StoresListView(stores: state.stores);
        }
      },
    );
  }
}

class _StoresListView extends StatelessWidget {
  final List<Store> stores;

  const _StoresListView({required this.stores});

  @override
  Widget build(BuildContext context) {
    return stores.isNotEmpty
        ? ListView.builder(
          itemCount: stores.length,
          itemBuilder: (context, index) {
            return _StoreCard(store: stores[index]);
          },
        )
        : const Center(
          child: Text(
            "Empty list",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        );
  }
}

class _StoreCard extends StatelessWidget {
  final Store store;

  const _StoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StoreScreen(store: store)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                'assets/images/coop.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Placeholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      store.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      store.city,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
