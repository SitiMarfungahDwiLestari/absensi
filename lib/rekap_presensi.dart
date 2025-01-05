import 'package:flutter/material.dart';
import 'package:absensi/api_service.dart';
import 'package:absensi/models/presensi.dart';
import 'package:absensi/screens/widget/SideMenu_Navigation.dart' as custom;

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
                                    DataColumn(label: Text('No')),
                                    DataColumn(label: Text('Timestamp')),
                                    DataColumn(label: Text('Kode Presensi')),
                                    DataColumn(label: Text('Kode Guru/Siswa')),
                                    DataColumn(label: Text('Nama')),
                                    DataColumn(label: Text('Kehadiran')),
                                    DataColumn(
                                        label: Text('Status Pembayaran')),
                                  ],
                                  rows:
                                      presensiList.asMap().entries.map((entry) {
                                    final index = entry.key + 1;
                                    final presensi = entry.value;

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(index.toString())),
                                        DataCell(Text(presensi.timestamp)),
                                        DataCell(Text(presensi.kodePresensi)),
                                        DataCell(Text(presensi.kodeGuruSiswa)),
                                        DataCell(Text(presensi.nama)),
                                        DataCell(Text(presensi.kehadiran)),
                                        DataCell(
                                            Text(presensi.statusPembayaran)),
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
