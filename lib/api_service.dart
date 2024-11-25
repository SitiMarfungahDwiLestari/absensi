import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/models/absensi.dart';

class ApiService {
  final String apiUrl =
      'https://script.google.com/macros/s/AKfycbxP4dyxArZY7U9agYYd57fW4Q4Y5io2E6Yx3iqh6qXs6Gb1-oq0ZsPM_LdG_oqqduUUKg/exec';

  Future<List<Absensi>> getAbsensiData(String user) async {
    final response = await http
        .get(Uri.parse('$apiUrl?route=getAbsensi&sheet=Absensi&User=$user'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        var absensiList =
            List<Absensi>.from(data['data'].map((x) => Absensi.fromJson(x)));
        return absensiList;
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
