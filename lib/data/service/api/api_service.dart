import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/entity/result.dart';
import '../models/store_dto.dart';

abstract class ApiService {
  Future<Result<List<StoreDto>>> searchStores(String query);
}

class ApiServiceImpl extends ApiService {
  final http.Client _client = http.Client();

  static const String _baseUrl = 'https://www.coop.no/api/content/butikker';
  static const String _queryParam = 'f';
  static const String _storesKey = 'stores';

  static const String _genericError = 'Error while making request';
  static const String _formatError = 'Incorrect data format';

  @override
  Future<Result<List<StoreDto>>> searchStores(String query) async {
    try {
      final url = Uri.parse('$_baseUrl?$_queryParam=$query');
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final storesJson = jsonData[_storesKey] as List<dynamic>?;

        if (storesJson == null) {
          return const Failure(_formatError);
        }

        final stores =
            storesJson
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
