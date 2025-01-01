import 'dart:async';
import 'dart:convert';
import 'package:absensi/models/guru.dart';
import 'package:http/http.dart' as http;
import 'package:absensi/models/absensi.dart';

class ApiService {
  final String apiUrl =
      'https://script.google.com/macros/s/AKfycbyz46KGiTGKtY4w0ReEufFIwvuTfIn7C2P20W4nrdoudxFbAtu_3lnfy_NdI-Rwg7lG/exec';

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

  Future<List<Guru>> getGuruData() async {
    try {
      // Ubah URL untuk mengambil data dari sheet guru
      final response = await http.get(
        Uri.parse('$apiUrl?sheet=guru'), // Pastikan parameter sheet=guru
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success' &&
            responseData['data'] is List) {
          return responseData['data']
              .map<Guru>((x) => Guru.fromJson(x))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error getting guru data: $e');
      return [];
    }
  }

  Future<bool> updateGuru(Map<String, String> updatedData) async {
    try {
      final Map<String, String> requestData = {
        'mode': 'editGuru',
        'namaLengkap': updatedData['Nama Lengkap'] ?? '',
        'alamat': updatedData['Alamat'] ?? '',
        'noHp': updatedData['No HP'] ?? '',
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 302 &&
          response.headers.containsKey('location')) {
        final redirectResponse =
            await http.get(Uri.parse(response.headers['location']!));
        if (redirectResponse.statusCode == 200) {
          final responseData = json.decode(redirectResponse.body);
          return responseData['status'] == 'success';
        }
      }
      return false;
    } catch (e) {
      print('Error updating guru: $e');
      return false;
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

  Future<bool> deleteAbsensi(String namaLengkap) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'mode': 'delete',
          'namaLengkap': namaLengkap,
        }),
      );

      print('Delete response status: ${response.statusCode}');
      print('Delete response body: ${response.body}');

      if (response.statusCode == 302 &&
          response.headers.containsKey('location')) {
        final redirectResponse =
            await http.get(Uri.parse(response.headers['location']!));
        print('Delete redirect status: ${redirectResponse.statusCode}');
        print('Delete redirect body: ${redirectResponse.body}');

        if (redirectResponse.statusCode == 200) {
          final responseData = json.decode(redirectResponse.body);
          return responseData['status'] == 'success';
        }
      }

      return false;
    } catch (e) {
      print('Error during delete: $e');
      return false;
    }
  }
}
