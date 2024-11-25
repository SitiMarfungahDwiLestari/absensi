import 'package:absensi/screens/widget/silver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:absensi/screens/widget/navigation_drawer.dart' as custom;

class DaftarGuru extends StatefulWidget {
  const DaftarGuru({super.key});

  @override
  State<DaftarGuru> createState() => _DaftarGuruState();
}

class _DaftarGuruState extends State<DaftarGuru> {
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
                  title: 'Data Guru', // Mengatur panjang search bar menjadi 200
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
