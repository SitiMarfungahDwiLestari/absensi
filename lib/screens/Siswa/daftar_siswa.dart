import 'package:flutter/material.dart';
import 'package:absensi/api_service.dart';
import 'package:absensi/models/siswa.dart';
import 'package:absensi/screens/Siswa/detail_siswa.dart';
import 'package:absensi/screens/widget/SideMenu_Navigation.dart' as custom;

class DaftarSiswa extends StatefulWidget {
  const DaftarSiswa({super.key});

  @override
  State<DaftarSiswa> createState() => _DaftarSiswaState();
}

class _DaftarSiswaState extends State<DaftarSiswa> {
  Stream<List<Siswa>> getSiswaStream() async* {
    while (true) {
      try {
        List<Siswa> data = await ApiService().getSiswaData();
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
          custom.SideMenuNavigation(currentPage: 'daftar_siswa'),
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
                          'Daftar Siswa',
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
                        StreamBuilder<List<Siswa>>(
                          stream: getSiswaStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text('Tidak ada data siswa');
                            } else {
                              var siswaList = snapshot.data!;

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(label: Text('No')),
                                    DataColumn(label: Text('Kode Siswa')),
                                    DataColumn(label: Text('Nama')),
                                    DataColumn(label: Text('Kelas')),
                                    DataColumn(
                                        label: Text('Status Pembayaran')),
                                  ],
                                  rows: siswaList.asMap().entries.map((entry) {
                                    final index = entry.key + 1;
                                    final siswa = entry.value;

                                    return DataRow(
                                      onSelectChanged: (_) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailSiswa(
                                                kodeSiswa: siswa.kodeSiswa),
                                          ),
                                        );
                                      },
                                      cells: [
                                        DataCell(Text(index.toString())),
                                        DataCell(Text(siswa.kodeSiswa)),
                                        DataCell(Text(siswa.namaLengkap)),
                                        DataCell(Text(siswa.pilihanKelas)),
                                        DataCell(Text(siswa.statusPembayaran)),
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
