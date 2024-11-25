import 'package:absensi/screens/widget/silver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:absensi/screens/widget/navigation_drawer.dart' as custom;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Menonaktifkan banner DEBUG
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          custom
              .NavigationDrawer(), // Menggunakan NavigationDrawer buatan sendiri
          Expanded(
            child: CustomScrollView(
              slivers: [
                CustomSliverAppBar(
                  title:
                      'Presensi Hari Ini', // Mengatur panjang search bar menjadi 200
                  onAddPressed: () {
                    // Aksi ketika ikon "+" ditekan
                    print('Tambah data!');
                  },
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Isi konten di sini...',
                        style: TextStyle(color: Color(0xFFbdaec6)),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
