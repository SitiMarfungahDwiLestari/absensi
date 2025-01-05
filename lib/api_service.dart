import 'dart:async';
import 'dart:convert';
import 'package:absensi/models/guru.dart';
import 'package:absensi/models/presensi.dart';
import 'package:absensi/models/siswa.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl =
      'https://script.google.com/macros/s/AKfycbwC1Du6U5tgSFcXHgHp0uGDJiGrWUfKj4vdUtRwp9rgubhUTw3z_Ey9307B_i3Hl6Cw/exec';

  Future<List<Siswa>> getSiswaData() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?endpoint=siswa'),
      );

      if (response.statusCode == 200) {
        // Decode JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> siswaJsonList = jsonResponse['data'];

        // Convert each JSON object to Siswa object
        return siswaJsonList.map((json) => Siswa.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load siswa data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting siswa data: $e');
    }
  }

  Future<List<Guru>> getGuruData() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?endpoint=guru'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> guruJsonList = jsonResponse['data'];
        return guruJsonList.map((json) => Guru.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load guru data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting guru data: $e');
    }
  }

  Future<List<Presensi>> getPresensiData() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?endpoint=presensi'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> presensiJsonList = jsonResponse['data'];
        return presensiJsonList.map((json) => Presensi.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load presensi data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting presensi data: $e');
    }
  }

  // Method untuk mengambil data presensi hari ini
  Future<List<Presensi>> getPresensiHariIni() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?endpoint=presensi'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> presensiJsonList = jsonResponse['data'];

        // Mendapatkan tanggal hari ini (tanpa waktu)
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        // Filter data presensi untuk hari ini saja
        return presensiJsonList
            .map((json) => Presensi.fromJson(json))
            .where((presensi) {
          try {
            final presensiDate = DateTime.parse(presensi.timestamp).toLocal();
            final presensiDay = DateTime(
                presensiDate.year, presensiDate.month, presensiDate.day);
            return presensiDay.isAtSameMomentAs(today);
          } catch (e) {
            print('Error parsing date: ${presensi.timestamp}');
            return false;
          }
        }).toList();
      } else {
        throw Exception('Failed to load presensi data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting presensi data: $e');
    }
  }

  // Method untuk mencari siswa berdasarkan kode
  Future<Siswa?> getSiswaByKode(String kodeSiswa) async {
    try {
      final siswaList = await getSiswaData();
      return siswaList.firstWhere(
        (siswa) => siswa.kodeSiswa == kodeSiswa,
        orElse: () => throw Exception('Siswa tidak ditemukan'),
      );
    } catch (e) {
      throw Exception('Error finding siswa: $e');
    }
  }

  // Method untuk mencari guru berdasarkan kode
  Future<Guru?> getGuruByKode(String kodeGuru) async {
    try {
      final guruList = await getGuruData();
      return guruList.firstWhere(
        (guru) => guru.kodeGuru == kodeGuru,
        orElse: () => throw Exception('Guru tidak ditemukan'),
      );
    } catch (e) {
      throw Exception('Error finding guru: $e');
    }
  }
}
