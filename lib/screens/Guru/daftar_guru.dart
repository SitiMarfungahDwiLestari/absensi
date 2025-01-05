import 'package:flutter/material.dart';
import 'package:absensi/api_service.dart';
import 'package:absensi/models/guru.dart';
import 'package:absensi/screens/Guru/detail_guru.dart';
import 'package:absensi/screens/widget/SideMenu_Navigation.dart' as custom;

class DaftarGuru extends StatefulWidget {
  const DaftarGuru({super.key});

  @override
  State<DaftarGuru> createState() => _DaftarGuruState();
}

class _DaftarGuruState extends State<DaftarGuru> {
  Stream<List<Guru>> getGuruStream() async* {
    while (true) {
      try {
        List<Guru> data = await ApiService().getGuruData();
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
          custom.SideMenuNavigation(currentPage: 'daftar_guru'),
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
                          'Daftar Guru',
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
                        StreamBuilder<List<Guru>>(
                          stream: getGuruStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text('Tidak ada data guru');
                            } else {
                              var guruList = snapshot.data!;

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(label: Text('No')),
                                    DataColumn(label: Text('Kode Guru')),
                                    DataColumn(label: Text('Nama')),
                                    DataColumn(label: Text('No HP')),
                                    DataColumn(label: Text('Status Aktivasi')),
                                  ],
                                  rows: guruList.asMap().entries.map((entry) {
                                    final index = entry.key + 1;
                                    final guru = entry.value;

                                    return DataRow(
                                      onSelectChanged: (_) {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => DetailGuru(guru: guru),
                                        //   ),
                                        // );
                                      },
                                      cells: [
                                        DataCell(Text(index.toString())),
                                        DataCell(Text(guru.kodeGuru)),
                                        DataCell(Text(guru.namaLengkap)),
                                        DataCell(Text(guru.noHp)),
                                        DataCell(Text(guru.statusAktivasi)),
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
