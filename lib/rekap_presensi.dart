import 'package:flutter/material.dart';
import 'package:absensi/api_service.dart';
import 'package:absensi/models/presensi.dart';
import 'package:absensi/screens/widget/SideMenu_Navigation.dart' as custom;
import 'package:intl/intl.dart';

class RekapPresensi extends StatefulWidget {
  const RekapPresensi({super.key});

  @override
  State<RekapPresensi> createState() => _RekapPresensiState();
}

class _RekapPresensiState extends State<RekapPresensi> {
  Stream<List<Presensi>> getPresensiStream() async* {
    while (true) {
      try {
        List<Presensi> data = await ApiService().getPresensiData();
        yield data;
        await Future.delayed(Duration(seconds: 5));
      } catch (e) {
        print('Error in stream: $e');
        yield [];
      }
    }
  }

  String formatDate(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  String formatTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final formatter = DateFormat('HH:mm:ss');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Row(
        children: [
          custom.SideMenuNavigation(currentPage: 'rekap_presensi'),
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: isMobile ? 20 : 30,
                      horizontal: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFbdaec6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Rekap Presensi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Data Table
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        StreamBuilder<List<Presensi>>(
                          stream: getPresensiStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text('Tidak ada data presensi');
                            } else {
                              var presensiList = snapshot.data!;

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(label: Text('Tanggal')),
                                    DataColumn(label: Text('Waktu')),
                                    DataColumn(label: Text('Kode Presensi')),
                                    DataColumn(label: Text('Kode')),
                                    DataColumn(label: Text('Nama')),
                                    DataColumn(label: Text('Kehadiran')),
                                    DataColumn(
                                        label: Text('Status Pembayaran')),
                                    DataColumn(label: Text('Aksi')),
                                  ],
                                  rows:
                                      presensiList.asMap().entries.map((entry) {
                                    final index = entry.key + 1;
                                    final presensi = entry.value;

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(
                                            formatDate(presensi.timestamp))),
                                        DataCell(Text(
                                            formatTime(presensi.timestamp))),
                                        DataCell(Text(presensi.kodePresensi)),
                                        DataCell(Text(presensi.kodeGuruSiswa)),
                                        DataCell(Text(presensi.nama)),
                                        DataCell(Text(presensi.kehadiran)),
                                        DataCell(
                                            Text(presensi.statusPembayaran)),
                                        DataCell(
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .blue, // Atur warna latar belakang tombol edit
                                                ),
                                                child: Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .white, // Atur warna teks tombol edit
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              TextButton(
                                                onPressed: () {
                                                  // Aksi saat tombol delete ditekan
                                                  // Misalnya, tampilkan dialog konfirmasi sebelum menghapus
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Konfirmasi'),
                                                      content: const Text(
                                                          'Apakah Anda yakin ingin menghapus presensi ini?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: const Text(
                                                              'Batal'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                              'Hapus'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .red, // Atur warna latar belakang tombol hapus
                                                ),
                                                child: Text(
                                                  'Hapus',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .white, // Atur warna teks tombol hapus
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      color: MaterialStateProperty.resolveWith<
                                          Color?>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.hovered)) {
                                            return Colors.grey[200];
                                          }
                                          return null;
                                        },
                                      ),
                                    );
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
