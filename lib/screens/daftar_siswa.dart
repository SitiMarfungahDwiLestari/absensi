import 'package:absensi/api_service.dart';
import 'package:absensi/models/absensi.dart';
import 'package:absensi/screens/detail_siswa.dart'; // Import halaman detail
import 'package:absensi/screens/widget/silver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:absensi/screens/widget/navigation_drawer.dart' as custom;

class DaftarSiswa extends StatefulWidget {
  const DaftarSiswa({super.key});

  @override
  State<DaftarSiswa> createState() => _DaftarSiswaState();
}

class _DaftarSiswaState extends State<DaftarSiswa> {
  // Stream untuk mendapatkan data absensi siswa secara berkala
  Stream<List<Absensi>> getAbsensiStream() async* {
    while (true) {
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
                CustomSliverAppBar(
                  title: 'Daftar Siswa',
                  onAddPressed: () {
                    print('Tambah data!');
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        StreamBuilder<List<Absensi>>(
                          stream: getAbsensiStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text('Tidak ada data absensi');
                            } else {
                              var absensiList = snapshot.data!;

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(label: Text('No')),
                                    DataColumn(label: Text('Nama')),
                                    DataColumn(label: Text('Kelas')),
                                    DataColumn(label: Text('Status Pembayaran')),
                                  ],
                                  rows: absensiList.asMap().entries.map((entry) {
                                    final index = entry.key + 1; // Nomor urut
                                    final absensi = entry.value;

                                    return DataRow(
                                      onSelectChanged: (_) {
                                        // Navigasi ke halaman DetailSiswa
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailSiswa(absensi: absensi),
                                          ),
                                        );
                                      },
                                      cells: [
                                        DataCell(Text(index.toString())),
                                        DataCell(Text(absensi.namaLengkap ?? '-')),
                                        DataCell(Text(absensi.pilihanKelas ?? '-')),
                                        DataCell(Text(absensi.statusPembayaran ?? '-')),
                                      ],
                                      color: MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.hovered)) {
                                            return Colors.grey[200]; // Warna saat hover
                                          }
                                          return null; // Warna default
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
