import 'package:flutter/material.dart';
import 'package:absensi/models/guru.dart';
import 'package:absensi/api_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:absensi/screens/widget/SideMenu_Navigation.dart' as custom;
import 'package:absensi/screens/widget/action_buttons.dart';

class DetailGuru extends StatefulWidget {
  final String kodeGuru;

  const DetailGuru({super.key, required this.kodeGuru});

  @override
  State<DetailGuru> createState() => _DetailGuruState();
}

class _DetailGuruState extends State<DetailGuru> {
  final ApiService _apiService = ApiService();
  bool isLoading = true;
  Guru? guru;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadGuruData();
  }

  // Di class _DetailGuruState
  Future<void> _handleUpdate() async {
    try {
      // Tampilkan loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Lakukan update
      final success = await _apiService.updateData(
        type: 'guru',
        id: guru!.kodeGuru,
        data: {
          'Nama Lengkap': guru!.namaLengkap,
          'Jenis Kelamin': guru!.jenisKelamin,
          'Tanggal Lahir': DateFormat('dd/MM/yyyy').format(guru!.tanggalLahir),
          'Alamat': guru!.alamat,
          'No HP': guru!.noHp,
          'Status Aktivasi': guru!.statusAktivasi,
        },
      );

      // Tutup loading
      Navigator.of(context).pop();

      if (success) {
        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil diupdate'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh data
        await _loadGuruData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengupdate data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Tutup loading jika ada
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadGuruData() async {
    try {
      final loadedGuru = await _apiService.getGuruByKode(widget.kodeGuru);
      setState(() {
        guru = loadedGuru;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data guru: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Widget _buildQRCode() {
    if (guru == null) return const SizedBox();

    // QR hanya berisi kode
    String qrData = guru!.kodeGuru; // atau guru!.kodeGuru untuk guru

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
    final validDetails = details.where((entry) {
      if (entry.value == null) return false;
      if (entry.value.trim().isEmpty) return false;
      if (entry.value.toLowerCase() == 'null') return false;
      return true;
    }).toList();

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
            : guru == null
                ? const Center(child: Text('Data guru tidak ditemukan'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            _buildQRCode(),
                            const SizedBox(height: 16),
                            ActionButtons(
                              printContent: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        if (guru != null) ...[
                                          Text(
                                            guru!.namaLengkap,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text('Kode: ${guru!.kodeGuru}'),
                                          const SizedBox(height: 8),
                                          _buildQRCode(),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              updateContent: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: TextEditingController(
                                          text: guru?.namaLengkap),
                                      decoration: const InputDecoration(
                                        labelText: 'Nama Lengkap',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) =>
                                          guru?.namaLengkap = value,
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: TextEditingController(
                                          text: guru?.jenisKelamin),
                                      decoration: const InputDecoration(
                                        labelText: 'Jenis Kelamin',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) =>
                                          guru?.jenisKelamin = value,
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: TextEditingController(
                                        text: guru?.tanggalLahir != null
                                            ? DateFormat('dd/MM/yyyy')
                                                .format(guru!.tanggalLahir)
                                            : '',
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Tanggal Lahir (DD/MM/YYYY)',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        try {
                                          final date = DateFormat('dd/MM/yyyy')
                                              .parse(value);
                                          guru?.tanggalLahir = date;
                                        } catch (e) {
                                          // Handle invalid date format
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: TextEditingController(
                                          text: guru?.alamat),
                                      decoration: const InputDecoration(
                                        labelText: 'Alamat',
                                        border: OutlineInputBorder(),
                                      ),
                                      maxLines: 2,
                                      onChanged: (value) =>
                                          guru?.alamat = value,
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: TextEditingController(
                                          text: guru?.noHp),
                                      decoration: const InputDecoration(
                                        labelText: 'No HP',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) => guru?.noHp = value,
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: TextEditingController(
                                          text: guru?.statusAktivasi),
                                      decoration: const InputDecoration(
                                        labelText: 'Status Aktivasi',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) =>
                                          guru?.statusAktivasi = value,
                                    ),
                                  ],
                                ),
                              ),
                              deleteItemName: guru?.namaLengkap ?? '',
                              onPrint: () {
                                // Handle print
                              },
                              onUpdate: () async {
                                try {
                                  // Tampilkan loading
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                  );

                                  // Lakukan update
                                  final success = await _apiService.updateData(
                                    type: 'guru',
                                    id: guru!.kodeGuru,
                                    data: {
                                      'Nama Lengkap': guru!.namaLengkap,
                                      'Jenis Kelamin': guru!.jenisKelamin,
                                      'Tanggal Lahir': DateFormat('dd/MM/yyyy')
                                          .format(guru!.tanggalLahir),
                                      'Alamat': guru!.alamat,
                                      'No HP': guru!.noHp,
                                      'Status Aktivasi': guru!.statusAktivasi,
                                    },
                                  );

                                  // Tutup loading
                                  Navigator.of(context).pop();

                                  if (success) {
                                    // Tampilkan pesan sukses
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Data berhasil diupdate'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    // Refresh data
                                    await _loadGuruData();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Gagal mengupdate data'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  // Tutup loading jika ada
                                  Navigator.of(context).pop();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              onDelete: () async {
                                try {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                  );

                                  final success = await _apiService.deleteData(
                                    type:
                                        'guru', // atau 'siswa', 'presensi' sesuai konteks
                                    id: guru!
                                        .kodeGuru, // atau siswa!.kodeSiswa, presensi!.kodePresensi
                                  );

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Data berhasil dihapus'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    // Tunggu selama 5 detik sebelum kembali ke halaman sebelumnya
                                    await Future.delayed(
                                        const Duration(seconds: 4));
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(
                                        context); // Tutup dialog loading
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(
                                        context); // Kembali ke halaman sebelumnya
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(
                                        context); // Tutup dialog loading

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Gagal menghapus data'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(
                                      context); // Tutup dialog loading

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
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
                                  MapEntry('Kode Guru', guru!.kodeGuru),
                                  MapEntry('Nama Lengkap', guru!.namaLengkap),
                                  MapEntry('Jenis Kelamin', guru!.jenisKelamin),
                                  MapEntry(
                                    'Tanggal Lahir',
                                    DateFormat('dd/MM/yyyy')
                                        .format(guru!.tanggalLahir),
                                  ),
                                  MapEntry('Alamat', guru!.alamat),
                                  MapEntry('No HP', guru!.noHp),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoSection(
                                'Status',
                                [
                                  MapEntry(
                                      'Status Aktivasi', guru!.statusAktivasi),
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
          custom.SideMenuNavigation(currentPage: 'daftar_guru'),
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
                          'Detail Guru',
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
