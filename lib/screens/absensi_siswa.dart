import 'package:flutter/material.dart';
import 'package:absensi/api_service.dart';
import 'package:absensi/models/absensi.dart';
import 'package:intl/intl.dart';
import 'package:absensi/screens/absensi_guru.dart';
import 'package:absensi/screens/navigation_drawer.dart' as custom;

class AbsensiSiswaScreen extends StatefulWidget {
  @override
  _AbsensiSiswaScreenState createState() => _AbsensiSiswaScreenState();
}

class _AbsensiSiswaScreenState extends State<AbsensiSiswaScreen> {
  // Fungsi untuk memformat tanggal
  String formatTanggal(String tanggal) {
    try {
      DateTime parsedDate = DateTime.parse(tanggal);
      return DateFormat('dd/MM/yyyy-HH:mm').format(parsedDate);
    } catch (e) {
      return tanggal; // Jika terjadi error, kembalikan tanggal asli
    }
  }

  // Stream untuk mendapatkan data absensi siswa secara berkala
  Stream<List<Absensi>> getAbsensiStream() async* {
    while (true) {
      // Ambil data dari API setiap 5 detik
      List<Absensi> data = await ApiService().getAbsensiData("Siswa");
      yield data;
      await Future.delayed(Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          custom.NavigationDrawer(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Color(0xFFbdaec6),
                  title: Text(
                    'Presensi Siswa',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  pinned: true,
                  expandedHeight: 60,
                  automaticallyImplyLeading: false, // Hilangkan tombol back
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
                // Menggunakan SliverToBoxAdapter untuk menampilkan konten di bawah AppBar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tabel Data Absensi
                        StreamBuilder<List<Absensi>>(
                          stream:
                              getAbsensiStream(), // Menggunakan stream untuk data dinamis
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text('Tidak ada data absensi');
                            } else {
                              var absensiList = snapshot.data!;

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Waktu Absen')),
                                    DataColumn(label: Text('Nama')),
                                    DataColumn(label: Text('NIS')),
                                  ],
                                  rows: absensiList.map((absensi) {
                                    return DataRow(cells: [
                                      DataCell(Text(
                                          formatTanggal(absensi.timestamp))),
                                      DataCell(Text(absensi.nama)),
                                      DataCell(Text(absensi.nisNip)),
                                    ]);
                                  }).toList(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
