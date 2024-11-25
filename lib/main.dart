import 'package:flutter/material.dart';
import 'package:absensi/screens/navigation_drawer.dart' as custom;

void main() {
  runApp(MaterialApp(
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
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Color(0xFFbdaec6),
                  title: Text(
                    'Presensi Hari Ini',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  pinned: true,
                  expandedHeight: 60,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Color(0xFF666666),
                    ),
                  ),
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
