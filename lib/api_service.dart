import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/models/absensi.dart';

class ApiService {
  final String apiUrl =
      'https://script.google.com/macros/s/AKfycbxTxIMQWYJrxC_q_Xg8MiwQyug5O3Jw0qcFAwntamPSSasTVtwVSSBs3DV5XMHnYVhz/exec';

  // Fungsi untuk mendapatkan data absensi
  Future<List<Absensi>> getAbsensiData(String user) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?route=getAbsensi&sheet=Reguler&User=$user'),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'FlutterApp',
        },
      );

      if (response.statusCode == 200) {
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

  // Fungsi untuk update data absensi
  Future<bool> updateAbsensi(Map<String, String> updatedData) async {
    try {
      // Persiapkan data yang akan dikirim sesuai format yang berhasil di Postman
      final Map<String, String> requestData = {
        'mode': 'edit',
        'namaLengkap': updatedData['Nama Lengkap'] ?? '',
      };

      // Mapping nama field sesuai dengan Google Sheet
      final Map<String, String> fieldMapping = {
        'Tempat/Tanggal Lahir': 'Tempat/Tanggal Lahir',
        'Jenis Kelamin': 'Jenis Kelamin',
        'Alamat': 'Alamat',
        'No HP': 'No HP',
        'Status Pembayaran': 'Status Pembayaran'
      };

      // Tambahkan field yang ada nilainya
      fieldMapping.forEach((flutterField, sheetField) {
        if (updatedData.containsKey(flutterField) &&
            updatedData[flutterField] != null &&
            updatedData[flutterField]!.isNotEmpty) {
          requestData[sheetField] = updatedData[flutterField]!;
        }
      });

      print('Sending data: ${json.encode(requestData)}');

      // Kirim request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Handle redirect
      if (response.statusCode == 302) {
        final String? redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          final redirectResponse = await http.get(Uri.parse(redirectUrl));

          print('Redirect response status: ${redirectResponse.statusCode}');
          print('Redirect response body: ${redirectResponse.body}');

          if (redirectResponse.statusCode == 200) {
            final responseData = json.decode(redirectResponse.body);
            if (responseData['status'] == 'warning') {
              print('Warning: ${responseData['message']}');
              return false;
            }
            return responseData['status'] == 'success';
          }
        }
      }

      return false;
    } catch (e) {
      print('Error during update: $e');
      throw Exception('Gagal mengupdate data: $e');
    }
  }
}
