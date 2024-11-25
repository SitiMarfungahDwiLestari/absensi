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
            child: CustomScrollView(
              slivers: [
                CustomSliverAppBar(
                  title:
                      'Data Siswa', // Mengatur panjang search bar menjadi 200
                  onAddPressed: () {
                    // Aksi ketika ikon "+" ditekan
                    print('Tambah data!');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
