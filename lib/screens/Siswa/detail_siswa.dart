import 'package:flutter/material.dart';
import 'package:absensi/models/siswa.dart';
import 'package:absensi/api_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:absensi/screens/widget/SideMenu_Navigation.dart' as custom;

class DetailSiswa extends StatefulWidget {
  final String kodeSiswa;

  const DetailSiswa({super.key, required this.kodeSiswa});

  @override
  State<DetailSiswa> createState() => _DetailSiswaState();
}

class _DetailSiswaState extends State<DetailSiswa> {
  final ApiService _apiService = ApiService();
  bool isLoading = true;
  Siswa? siswa;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSiswaData();
  }

  Future<void> _loadSiswaData() async {
    try {
      final loadedSiswa = await _apiService.getSiswaByKode(widget.kodeSiswa);
      setState(() {
        siswa = loadedSiswa;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data siswa: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Widget _buildQRCode() {
    if (siswa == null) return const SizedBox();

    String qrData =
        "${siswa!.kodeSiswa}|${siswa!.namaLengkap}|${siswa!.pilihanKelas}";

    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scan untuk presensi',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      String title, List<MapEntry<String, String>> details) {
    // Filter out null or empty values
    final validDetails = details.where((entry) {
      if (entry.value == null) return false;
      if (entry.value.trim().isEmpty) return false;
      if (entry.value.toLowerCase() == 'null') return false;
      return true;
    }).toList();

    // If no valid details, don't show the section
    if (validDetails.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: validDetails.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Text(entry.value),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    Widget mainContent = isLoading
        ? const Center(child: CircularProgressIndicator())
        : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : siswa == null
                ? const Center(child: Text('Data siswa tidak ditemukan'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 160,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.person,
                                    size: 40, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildQRCode(),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoSection(
                                'Informasi Pribadi',
                                [
                                  MapEntry('Kode Siswa', siswa!.kodeSiswa),
                                  MapEntry('Nama Lengkap', siswa!.namaLengkap),
                                  MapEntry(
                                      'Tanggal Lahir',
                                      DateFormat('dd/MM/yyyy')
                                          .format(siswa!.tanggalLahir)),
                                  MapEntry(
                                      'Jenis Kelamin', siswa!.jenisKelamin),
                                  MapEntry('Alamat', siswa!.alamat),
                                  MapEntry('No HP/Email', siswa!.noHpEmail),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoSection(
                                'Informasi Orang Tua',
                                [
                                  MapEntry(
                                      'Nama Orang Tua', siswa!.namaOrangTua),
                                  MapEntry(
                                      'No HP Orang Tua', siswa!.noHpOrangTua),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoSection(
                                'Informasi Akademik',
                                [
                                  MapEntry(
                                      'Pilihan Kelas', siswa!.pilihanKelas),
                                  MapEntry('Asal Sekolah (Reguler)',
                                      siswa!.asalSekolahReguler),
                                  MapEntry(
                                      'Kelas (Reguler)', siswa!.kelasReguler),
                                  MapEntry('Mata Pelajaran Pilihan',
                                      siswa!.mataPelajaranPilihan),
                                  MapEntry('Asal Sekolah (Lolos)',
                                      siswa!.asalSekolahLolos),
                                  MapEntry('Kelas (Lolos Sekolah)',
                                      siswa!.kelasLoslosSekolah),
                                  MapEntry(
                                      'Pilihan Sekolah', siswa!.pilihanSekolah),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoSection(
                                'Informasi Lanjutan',
                                [
                                  MapEntry(
                                      'Kelas (Lolos PT)', siswa!.kelasLolosPT),
                                  MapEntry(
                                      'Jurusan (SMA/SMK)', siswa!.jurusanSMA),
                                  MapEntry('Mata Pelajaran Pilihan (SMA)',
                                      siswa!.mataPelajaranPilihanSMA),
                                  MapEntry('Pilihan Jurusan PT',
                                      siswa!.pilihanJurusanPT),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoSection(
                                'Status',
                                [
                                  MapEntry('Status Pembayaran',
                                      siswa!.statusPembayaran),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

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
                          'Detail Siswa',
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
                // Content
                SliverToBoxAdapter(
                  child: mainContent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
