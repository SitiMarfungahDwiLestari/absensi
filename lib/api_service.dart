import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/models/absensi.dart';

class ApiService {
  final String apiUrl =
      'https://script.google.com/macros/s/AKfycbyxOhTzIVLGkeO2OmWfS89OTOBffOvx63AhJ0mFUJ4ln7yDFADogpTOg5wfziRw0wE/exec';

  Future<List<Absensi>> getAbsensiData(String user) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?route=getAbsensi&sheet=Reguler&User=$user'),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'FlutterApp',
        },
      );

      print('Status Respons: ${response.statusCode}');
      print('Body Respons: ${response.body}');

      if (response.statusCode == 200) {
        // Parse JSON dengan memperhatikan struktur baru
        dynamic bodyDekode = json.decode(response.body);

        if (bodyDekode['status'] == 'success' && bodyDekode['data'] is List) {
          return bodyDekode['data']
              .map<Absensi>((x) => Absensi.fromJson(x))
              .toList();
        } else {
          throw Exception(
              'Format data tidak sesuai atau status tidak berhasil');
        }
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Kesalahan mengambil data: $e');
      throw Exception('Kesalahan mengambil data: $e');
    }
  }
}









// class ApiService {
//   final String apiUrl =
//       'https://script.google.com/macros/s/AKfycbxK6hU-DZ66hfXk9EvEBm3uJ9H9xakyIQE_yBuC-vnxbXGuWwU4UoIN94T2AVgWu19W/exec';

//   Future<List<Absensi>> getAbsensiData(String user) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$apiUrl?route=getAbsensi&sheet=Reguler&User=$user'),
//         headers: {
//           'Content-Type': 'application/json',
//           'User-Agent': 'FlutterApp',
//         },
//       );

//       // Tambahkan log untuk melihat respons yang diterima
//       print('Status Respons: ${response.statusCode}');
//       print('Body Respons: ${response.body}');

//       // Cek apakah status code 200 (berhasil)
//       if (response.statusCode == 200) {
//         // Cek apakah respons adalah JSON atau HTML
//         if (response.body.startsWith('<!doctype html>')) {
//           // Jika respons adalah HTML, berarti ada masalah
//           throw Exception(
//               'API mengembalikan halaman HTML, kemungkinan ada error di server.');
//         }

//         // Parsing JSON jika formatnya benar
//         dynamic bodyDekode = json.decode(response.body);

//         if (bodyDekode is List) {
//           return bodyDekode.map((x) => Absensi.fromJson(x)).toList();
//         } else {
//           throw Exception('Format data tidak sesuai');
//         }
//       } else {
//         throw Exception('Gagal memuat data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Kesalahan mengambil data: $e');
//       throw Exception('Kesalahan mengambil data: $e');
//     }
//   }
// }
