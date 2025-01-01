import 'package:absensi/api_service.dart';
import 'package:absensi/models/guru.dart';
import 'package:absensi/screens/widget/silver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:absensi/screens/widget/navigation_drawer.dart' as custom;

class DaftarGuru extends StatefulWidget {
  const DaftarGuru({super.key});

  @override
  State<DaftarGuru> createState() => _DaftarGuruState();
}

class _DaftarGuruState extends State<DaftarGuru> {
  final ApiService _apiService = ApiService();

  Stream<List<Guru>> getGuruStream() async* {
    while (true) {
      List<Guru> data = await _apiService.getGuruData();
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
                CustomSliverAppBar(
                  title: 'Data Guru',
                  onAddPressed: () {
                    print('Tambah guru!');
                  },
                ),
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
                                    DataColumn(label: Text('Nama')),
                                    DataColumn(label: Text('Alamat')),
                                    DataColumn(label: Text('No HP')),
                                  ],
                                  rows: guruList.asMap().entries.map((entry) {
                                    final index = entry.key + 1;
                                    final guru = entry.value;

                                    return DataRow(
                                      onSelectChanged: (_) {
                                        // Navigate to detail page
                                      },
                                      cells: [
                                        DataCell(Text(index.toString())),
                                        DataCell(Text(guru.namaLengkap)),
                                        DataCell(Text(guru.alamat)),
                                        DataCell(Text(guru.noHp)),
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
