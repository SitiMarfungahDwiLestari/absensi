import 'package:flutter/material.dart';
import 'package:absensi/api_service.dart';
import 'package:absensi/models/presensi.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:absensi/screens/widget/SideMenu_Navigation.dart' as custom;

void main() {
  initializeDateFormatting('id_ID');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Progressive Learning Center',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  Stream<List<Presensi>> getPresensiHariIniStream() async* {
    while (true) {
      try {
        List<Presensi> data = await _apiService.getPresensiHariIni();
        yield data;
        await Future.delayed(Duration(seconds: 5));
      } catch (e) {
        print('Error in stream: $e');
        yield [];
      }
    }
  }

  String formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp).toLocal();
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  Color getKehadiranColor(String kehadiran) {
    switch (kehadiran) {
      case 'H':
        return Colors.green;
      case 'I':
        return Colors.blue;
      case 'S':
        return Colors.orange;
      case 'A':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Future<void> updateKehadiran(String kodePresensi, String newKehadiran) async {
    try {
      final success = await _apiService.updateData(
        type: 'presensi',
        id: kodePresensi,
        data: {'Kehadiran': newKehadiran},
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status kehadiran berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memperbarui status kehadiran'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deletePresensi(String kodePresensi) async {
    try {
      final success = await _apiService.deleteData(
        type: 'presensi',
        id: kodePresensi,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data presensi berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus data presensi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Row(
        children: [
          custom.SideMenuNavigation(currentPage: 'home'),
          Expanded(
            child: CustomScrollView(
              slivers: [
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
                          'Presensi Hari Ini',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                              .format(DateTime.now()),
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StreamBuilder<List<Presensi>>(
                      stream: getPresensiHariIniStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.event_busy,
                                    size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'Belum ada data presensi hari ini',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        var presensiList = snapshot.data!;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            showCheckboxColumn: false,
                            columns: const [
                              DataColumn(label: Text('Waktu')),
                              DataColumn(label: Text('Kode')),
                              DataColumn(label: Text('Nama')),
                              DataColumn(label: Text('Kehadiran')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Aksi')),
                            ],
                            rows: presensiList.map((presensi) {
                              bool isPresensiEditable(String statusPembayaran) {
                                // Records can be edited if status is "Lunas" or empty
                                return statusPembayaran == 'Lunas' ||
                                    statusPembayaran.isEmpty;
                              }

                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                      formatTimestamp(presensi.timestamp))),
                                  DataCell(Text(presensi.kodeGuruSiswa)),
                                  DataCell(Text(presensi.nama)),
                                  DataCell(
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: getKehadiranColor(
                                                presensi.kehadiran)
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: presensi.isEditable
                                          ? DropdownButton<String>(
                                              value: presensi.kehadiran,
                                              items: ['H', 'I', 'S', 'A']
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value == 'H'
                                                        ? 'Hadir'
                                                        : value == 'I'
                                                            ? 'Izin'
                                                            : value == 'S'
                                                                ? 'Sakit'
                                                                : value == 'A'
                                                                    ? 'Alpha'
                                                                    : value,
                                                    style: TextStyle(
                                                      color: getKehadiranColor(
                                                          value),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                if (newValue != null) {
                                                  updateKehadiran(
                                                      presensi.kodePresensi,
                                                      newValue);
                                                }
                                              },
                                              style: TextStyle(
                                                  color: Colors.black),
                                              underline: Container(height: 0),
                                              icon: Icon(Icons.arrow_drop_down,
                                                  color: getKehadiranColor(
                                                      presensi.kehadiran)),
                                            )
                                          : Text(
                                              presensi.kehadiran == 'H'
                                                  ? 'Hadir'
                                                  : presensi.kehadiran == 'I'
                                                      ? 'Izin'
                                                      : presensi.kehadiran ==
                                                              'S'
                                                          ? 'Sakit'
                                                          : presensi.kehadiran ==
                                                                  'A'
                                                              ? 'Alpha'
                                                              : presensi
                                                                  .kehadiran,
                                              style: TextStyle(
                                                color: getKehadiranColor(
                                                    presensi.kehadiran),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                    ),
                                  ),
                                  DataCell(Text(presensi.statusPembayaran)),
                                  DataCell(
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blueGrey[50]),
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Konfirmasi'),
                                                content: const Text(
                                                    'Apakah Anda yakin ingin menghapus presensi ini?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('Batal'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      deletePresensi(presensi
                                                          .kodePresensi);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Hapus'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.red[400],
                                          ),
                                          child: Text(
                                            'Hapus',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      },
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
