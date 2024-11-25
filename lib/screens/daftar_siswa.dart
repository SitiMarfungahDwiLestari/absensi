import 'package:absensi/screens/widget/silver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:absensi/screens/widget/navigation_drawer.dart' as custom;

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
                              print('Kelas Reguler');
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
