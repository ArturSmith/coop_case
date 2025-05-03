import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/entity/Result.dart';
import '../models/StoreDto.dart';

class ApiService {
  static const String _baseUrl = 'https://www.coop.no/api/content/butikker';
  static const String _queryParam = 'f';
  static const String _storesKey = 'stores';

  static const String _genericError = 'Error while making request';
  static const String _formatError = 'Incorrect data format';

  Future<Result<List<StoreDto>>> searchStores(String query) async {
    final url = Uri.parse('$_baseUrl?$_queryParam=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final storesJson = jsonData[_storesKey] as List<dynamic>?;

        if (storesJson == null) {
          return const Failure(_formatError);
        }

        final stores = storesJson
            .map((storeJson) => StoreDto.fromJson(storeJson))
            .toList();

        return Success(stores);
      } else {
        return Failure('Error: ${response.statusCode}');
      }
    } catch (e) {
      return Failure('$_genericError: $e');
    }
  }
}

