import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:absensi/main.dart';
import 'package:absensi/screens/daftar_guru.dart';
import 'package:absensi/screens/daftar_siswa.dart';
import 'package:absensi/screens/absensi_siswa.dart';
import 'package:absensi/screens/absensi_guru.dart';

class NavigationDrawer extends StatelessWidget {
  // Fungsi untuk membuka link URL Google Form
  Future<void> _launchURL() async {
    final Uri url = Uri.parse(
        'https://docs.google.com/forms/d/e/1FAIpQLSdzJwgUzlmRVg_uFKaoTAeNYaKVBSfGkLKHM7QtcyIKa0X3Cw/viewform'); //ganti link GFORM 
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

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
            height: 200.0,
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
                MaterialPageRoute(builder: (context) => DaftarSiswa()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_ind, color: Colors.white),
            title: Text('Daftar Guru', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DaftarGuru()),
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
              _launchURL(); // Membuka Google Form saat diklik
            },
          ),
        ],
      ),
    );
  }
}
