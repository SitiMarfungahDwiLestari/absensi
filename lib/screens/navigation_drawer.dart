import 'package:absensi/main.dart';
import 'package:flutter/material.dart';
import 'package:absensi/screens/absensi_siswa.dart';
import 'package:absensi/screens/absensi_guru.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF9c8aa5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          Container(
            color: Color(0xFF6d5f7c),
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            height: 100.0,
            child: Center(
              child: Text(
                'Progressive Learning Center',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.white),
            title:
                Text('Absensi Hari Ini', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.group, color: Colors.white),
            title: Text('Absensi Siswa', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AbsensiSiswaScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.white),
            title: Text('Absensi Guru', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AbsensiGuruScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.menu_book, color: Colors.white),
            title: Text('Daftar Siswa', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AbsensiGuruScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_ind, color: Colors.white),
            title: Text('Daftar Guru', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AbsensiGuruScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.search, color: Colors.white),
            title: Text('Cari', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AbsensiGuruScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.app_registration, color: Colors.white),
            title: Text('Pendaftaran', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AbsensiGuruScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
