import 'package:absensi/api_service.dart';
import 'package:absensi/models/absensi.dart';
import 'package:absensi/screens/widget/silver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:absensi/screens/widget/navigation_drawer.dart' as custom;
import 'package:intl/intl.dart';

class DaftarSiswa extends StatefulWidget {
  const DaftarSiswa({super.key});

  @override
  State<DaftarSiswa> createState() => _DaftarSiswaState();
}

class _DaftarSiswaState extends State<DaftarSiswa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          custom.NavigationDrawer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Daftar Data Siswa",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(20.0)),
                    // Membuat dua tombol di atas dalam satu baris
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tombol 1: Kelas Reguler
                        MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              // Ganti warna tombol saat hover
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              // Kembalikan warna tombol saat hover hilang
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KelasRegulerPage(),
                                ),
                              );
                            },
                            child: Container(
                              width: 150, // Ukuran tombol
                              height: 150,
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFF6fa3ef), // Warna biru muda
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Kelas Reguler',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Tombol 2: Kelas Lolos Sekolah Impian
                        MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              // Ganti warna tombol saat hover
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              // Kembalikan warna tombol saat hover hilang
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              print('Kelas Lolos Sekolah Impian');
                            },
                            child: Container(
                              width: 150, // Ukuran tombol yang sama
                              height: 150,
                              decoration: BoxDecoration(
                                color: Color(0xFFf38a3a), // Warna oranye
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                  // Membungkus teks dalam Column agar lebih teratur
                                  Text(
                                    'Kelas Lolos\nSekolah Impian', // Menggunakan \n untuk baris baru
                                    textAlign: TextAlign
                                        .center, // Membuat teks terpusat
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Tombol 3: Kelas Lolos Perguruan Tinggi Impian (di bawah)
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          // Ganti warna tombol saat hover
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          // Kembalikan warna tombol saat hover hilang
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          print('Kelas Lolos Perguruan Tinggi Impian');
                        },
                        child: Container(
                          width: 150, // Ukuran tombol yang sama
                          height: 150,
                          margin:
                              EdgeInsets.only(top: 32), // Margin agar ada jarak
                          decoration: BoxDecoration(
                            color: Color(0xFF74b14c), // Warna hijau
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.computer_sharp,
                                size: 50,
                                color: Colors.white,
                              ),
                              SizedBox(height: 10),
                              // Membungkus teks dalam Column agar lebih teratur
                              Text(
                                'Kelas Perguruan\nTinggi Impian', // Menggunakan \n untuk baris baru
                                textAlign:
                                    TextAlign.center, // Membuat teks terpusat
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KelasRegulerPage extends StatefulWidget {
  @override
  _KelasRegulerPageState createState() => _KelasRegulerPageState();
}

class _KelasRegulerPageState extends State<KelasRegulerPage> {
  ScrollController _horizontalController = ScrollController();
  ScrollController _verticalController = ScrollController();

  // Fungsi untuk memformat tanggal
  String formatTanggal(String tanggal) {
    try {
      DateTime parsedDate = DateTime.parse(tanggal);
      return DateFormat('dd/MM/yyyy-HH:mm').format(parsedDate);
    } catch (e) {
      return tanggal; // Jika terjadi error, kembalikan tanggal asli
    }
  }

  // Mendapatkan data siswa dari API
  Stream<List<Absensi>> getSiswaStream() async* {
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
                CustomSliverAppBar(
                  title: 'Daftar Siswa',
                  onAddPressed: () {
                    // Aksi ketika ikon "+" ditekan
                    print('Tambah data!');
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Tabel Data Absensi
                        StreamBuilder<List<Absensi>>(
                          stream:
                              getSiswaStream(), // Menggunakan stream untuk data dinamis
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text('Tidak ada data absensi');
                            } else {
                              var absensiList = snapshot.data!;

                              return Column(
                                children: [
                                  // Scroll vertical
                                  SingleChildScrollView(
                                    scrollDirection:
                                        Axis.vertical, // Scroll vertikal
                                    controller: _verticalController,
                                    child: SingleChildScrollView(
                                      scrollDirection:
                                          Axis.horizontal, // Scroll horizontal
                                      controller: _horizontalController,
                                      child: DataTable(
                                        columns: const [
                                          DataColumn(
                                              label: Text('Waktu Absen')),
                                          DataColumn(label: Text('Nama')),
                                          DataColumn(
                                              label:
                                                  Text('Tempat/Tanggal Lahir')),
                                          DataColumn(
                                              label: Text('Jenis Kelamin')),
                                          DataColumn(label: Text('Alamat')),
                                          DataColumn(
                                              label: Text('NoHP / Email')),
                                          DataColumn(
                                              label: Text('Nama Orangtua')),
                                          DataColumn(
                                              label: Text('NoHP Orangtua')),
                                          DataColumn(
                                              label: Text('Asal Sekolah')),
                                        ],
                                        rows: absensiList.map((absensi) {
                                          return DataRow(cells: [
                                            DataCell(Text(formatTanggal(
                                                absensi.timestamp))),
                                            DataCell(Text(
                                                absensi.namaLengkap ?? '-')),
                                            DataCell(Text(
                                                absensi.tempatTanggalLahir ??
                                                    '-')),
                                            DataCell(Text(
                                                absensi.jenisKelamin ?? '-')),
                                            DataCell(
                                                Text(absensi.alamat ?? '-')),
                                            DataCell(
                                                Text(absensi.noHpEmail ?? '-')),
                                            DataCell(Text(
                                                absensi.namaOrangTua ?? '-')),
                                            DataCell(Text(
                                                absensi.noHpOrangTua ?? '-')),
                                            DataCell(Text(
                                                absensi.asalSekolah ?? '-')),
                                          ]);
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  // Menambahkan scrollbar horizontal di bawah tabel
                                  Container(
                                    color: Colors.grey[200],
                                    height: 10,
                                    child: Scrollbar(
                                      controller: _horizontalController,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        controller: _horizontalController,
                                        child: SizedBox(width: 1),
                                      ),
                                    ),
                                  ),
                                ],
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
