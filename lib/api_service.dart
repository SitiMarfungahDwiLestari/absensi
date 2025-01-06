import 'dart:async';
import 'dart:convert';
import 'package:absensi/models/guru.dart';
import 'package:absensi/models/presensi.dart';
import 'package:absensi/models/siswa.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl =
      'https://script.google.com/macros/s/AKfycbyoMUoVtkDVMXZ2rMug-iREQvVP9WDafp_JPoCxyIY4zI9p4afBNf9kvCFibewy-PUm/exec';

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

  Future<bool> deleteData({
    required String type, // 'guru' atau 'siswa'
    required String id, // kodeGuru atau kodeSiswa
  }) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'mode': 'delete',
          'type': type,
          'id': id,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == 'success';
      } else if (response.statusCode == 302) {
        // Data berhasil dihapus meskipun server mengembalikan status 302
        return true;
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting data: $e');
    }
  }

  Future<bool> updateData({
    required String type,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'mode': 'update',
          'type': type,
          'id': id,
          'data': data,
        }),
      );

      print('Response status: ${response.statusCode}');

      // Jika dapat 302, ambil URL redirect dari header 'location'
      if (response.statusCode == 302) {
        final String? redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          final redirectResponse = await http.get(Uri.parse(redirectUrl));
          final Map<String, dynamic> jsonResponse =
              json.decode(redirectResponse.body);
          return jsonResponse['status'] == 'success';
        }
      }
      // Jika 200, langsung proses responsenya
      else if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == 'success';
      }

      return false;
    } catch (e) {
      print('Error updating data: $e');
      throw Exception('Error updating data: $e');
    }
  }
}
