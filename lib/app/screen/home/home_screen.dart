import 'package:coop_case/app/screen/home/home_view_model.dart';
import 'package:coop_case/app/screen/store/store_screen.dart';
import 'package:coop_case/domain/entity/Store.dart';
import 'package:coop_case/domain/usecase/SearchStoresUseCase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create:
        (contex) => HomeViewModel(
          searchStoresUseCase: contex.read<SearchStoresUseCase>(),
        ),
    child: Scaffold(body: _HomeScreenBody()),
  );
}

class _HomeScreenBody extends StatefulWidget {
  const _HomeScreenBody();

  @override
  State<_HomeScreenBody> createState() => __HomeScreenBodyState();
}

class __HomeScreenBodyState extends State<_HomeScreenBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final model = context.read<HomeViewModel>();

    final bool isLoading = context.watch<HomeViewModel>().isLoading;
    final List<Store> stores = context.watch<HomeViewModel>().stores;
    final String? error = context.watch<HomeViewModel>().error;

    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Coop Store Finder")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Enter shop zip\\name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  model.searchStores(_controller.text);
                },
                child: const Text("Search"),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _StoresListView(stores: stores),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoresListView extends StatelessWidget {
  const _StoresListView({required List<Store> stores}) : _stores = stores;

  final List<Store> _stores;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _stores.length,
      itemBuilder: (context, index) {
        final store = _stores[index];
        return _StoreCard(store: store);
      },
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required Store store}) : _store = store;
  final Store _store;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StoreScreen(store: _store)),
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
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(
                      _store.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(
                      _store.city,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
