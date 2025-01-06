import 'package:flutter/material.dart';
import 'package:absensi/models/siswa.dart';
import 'package:absensi/api_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:absensi/screens/widget/SideMenu_Navigation.dart' as custom;
import 'package:absensi/screens/widget/action_buttons.dart';

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: siswa?.tanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFbdaec6),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != siswa?.tanggalLahir) {
      setState(() {
        siswa?.tanggalLahir = picked;
      });
    }
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

    String qrData = siswa!.kodeSiswa;

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

  Widget _buildDynamicFormFields() {
    // Field yang selalu muncul
    final List<Widget> baseFields = [
      TextField(
        controller: TextEditingController(text: siswa?.kodeSiswa),
        decoration: const InputDecoration(
          labelText: 'Kode Siswa',
          border: OutlineInputBorder(),
        ),
        enabled: false,
      ),
      const SizedBox(height: 16),
      TextField(
        controller: TextEditingController(text: siswa?.namaLengkap),
        decoration: const InputDecoration(
          labelText: 'Nama Lengkap',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => siswa?.namaLengkap = value,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: TextEditingController(
          text: siswa?.tanggalLahir != null
              ? DateFormat('dd/MM/yyyy').format(siswa!.tanggalLahir)
              : '',
        ),
        decoration: InputDecoration(
          labelText: 'Tanggal Lahir',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        value: siswa?.jenisKelamin,
        decoration: const InputDecoration(
          labelText: 'Jenis Kelamin',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
          DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
        ],
        onChanged: (value) {
          if (value != null) {
            siswa?.jenisKelamin = value;
          }
        },
      ),
      const SizedBox(height: 16),
      TextField(
        controller: TextEditingController(text: siswa?.alamat),
        decoration: const InputDecoration(
          labelText: 'Alamat',
          border: OutlineInputBorder(),
        ),
        maxLines: 2,
        onChanged: (value) => siswa?.alamat = value,
      ),
      const SizedBox(height: 16),
      TextField(
        controller: TextEditingController(text: siswa?.noHpEmail),
        decoration: const InputDecoration(
          labelText: 'No HP/Email',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => siswa?.noHpEmail = value,
      ),
      const SizedBox(height: 16),
      TextField(
        controller: TextEditingController(text: siswa?.namaOrangTua),
        decoration: const InputDecoration(
          labelText: 'Nama Orang Tua',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => siswa?.namaOrangTua = value,
      ),
      const SizedBox(height: 16),
      TextField(
        controller: TextEditingController(text: siswa?.noHpOrangTua),
        decoration: const InputDecoration(
          labelText: 'No HP Orang Tua',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => siswa?.noHpOrangTua = value,
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        value: siswa?.pilihanKelas,
        decoration: const InputDecoration(
          labelText: 'Pilihan Kelas',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'Reguler', child: Text('Reguler')),
          DropdownMenuItem(
            value: 'Lolos Sekolah Impian',
            child: Text('Lolos Sekolah Impian'),
          ),
          DropdownMenuItem(
            value: 'Lolos Perguruan Tinggi Impian',
            child: Text('Lolos Perguruan Tinggi Impian'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            siswa?.pilihanKelas = value ?? '';
          });
        },
      ),
      const SizedBox(height: 16),
    ];

    // Fields berdasarkan pilihan kelas
    List<Widget> additionalFields = [];

    if (siswa?.pilihanKelas == 'Reguler') {
      additionalFields = [
        TextField(
          controller: TextEditingController(text: siswa?.asalSekolahReguler),
          decoration: const InputDecoration(
            labelText: 'Asal Sekolah (Reguler)',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => siswa?.asalSekolahReguler = value,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String?>(
          value: siswa?.kelasReguler,
          decoration: const InputDecoration(
            labelText: 'Kelas',
            border: OutlineInputBorder(),
          ),
          hint: const Text('Pilih Kelas'),
          items: const [
            DropdownMenuItem(value: null, child: Text('Pilih Kelas')),
            DropdownMenuItem(value: '10', child: Text('10')),
            DropdownMenuItem(value: '11', child: Text('11')),
            DropdownMenuItem(value: '12', child: Text('12')),
          ],
          onChanged: (value) => siswa?.kelasReguler = value ?? '',
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: siswa?.mataPelajaranPilihan,
          decoration: const InputDecoration(
            labelText: 'Mata Pelajaran Pilihan',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
                value: 'Matematika Wajib', child: Text('Matematika Wajib')),
            DropdownMenuItem(
                value: 'Matematika Lintas', child: Text('Matematika Lintas')),
            DropdownMenuItem(value: 'Fisika', child: Text('Fisika')),
            DropdownMenuItem(value: 'Kimia', child: Text('Kimia')),
            DropdownMenuItem(value: 'Biologi', child: Text('Biologi')),
            DropdownMenuItem(value: 'Geografi', child: Text('Geografi')),
            DropdownMenuItem(value: 'Ekonomi', child: Text('Ekonomi')),
            DropdownMenuItem(value: 'Sosiologi', child: Text('Sosiologi')),
            DropdownMenuItem(value: 'Sejarah', child: Text('Sejarah')),
            DropdownMenuItem(
                value: 'Bahasa Inggris', child: Text('Bahasa Inggris')),
            DropdownMenuItem(
                value: 'Bahasa Indonesia', child: Text('Bahasa Indonesia')),
            DropdownMenuItem(value: 'Informatika', child: Text('Informatika')),
          ],
          onChanged: (value) {
            if (value != null) {
              siswa?.mataPelajaranPilihan = value;
            }
          },
        ),
      ];
    } else if (siswa?.pilihanKelas == 'Lolos Sekolah Impian') {
      additionalFields = [
        TextField(
          controller: TextEditingController(text: siswa?.asalSekolahLolos),
          decoration: const InputDecoration(
            labelText: 'Asal Sekolah (Lolos)',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => siswa?.asalSekolahLolos = value,
        ),
        const SizedBox(height: 16),
        // Replace the TextField for Jenis Kelamin with this DropdownButtonFormField
        DropdownButtonFormField<String>(
          value: siswa?.kelasLoslosSekolah,
          decoration: const InputDecoration(
            labelText: 'Kelas (Lolos Sekolah)',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: '10',
              child: Text('10'),
            ),
            DropdownMenuItem(
              value: '11',
              child: Text('11'),
            ),
            DropdownMenuItem(
              value: '12',
              child: Text('12'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              siswa?.kelasLoslosSekolah = value;
            }
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: siswa?.pilihanSekolah),
          decoration: const InputDecoration(
            labelText: 'Pilihan Sekolah',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => siswa?.pilihanSekolah = value,
        ),
      ];
    } else if (siswa?.pilihanKelas == 'Lolos Perguruan Tinggi Impian') {
      additionalFields = [
        DropdownButtonFormField<String?>(
          value: siswa?.kelasLolosPT,
          decoration: const InputDecoration(
            labelText: 'Kelas (Lolos PT)',
            border: OutlineInputBorder(),
          ),
          hint: const Text('Pilih Kelas'),
          items: const [
            DropdownMenuItem(value: null, child: Text('Pilih Kelas')),
            DropdownMenuItem(value: '10', child: Text('10')),
            DropdownMenuItem(value: '11', child: Text('11')),
            DropdownMenuItem(value: '12', child: Text('12')),
          ],
          onChanged: (value) => siswa?.kelasLolosPT = value ?? '',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: siswa?.jurusanSMA),
          decoration: const InputDecoration(
            labelText: 'Jurusan (SMA/SMK)',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => siswa?.jurusanSMA = value,
        ),
        const SizedBox(height: 16),
        TextField(
          controller:
              TextEditingController(text: siswa?.mataPelajaranPilihanSMA),
          decoration: const InputDecoration(
            labelText: 'Mata Pelajaran Pilihan (SMA)',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => siswa?.mataPelajaranPilihanSMA = value,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: siswa?.pilihanJurusanPT),
          decoration: const InputDecoration(
            labelText: 'Pilihan Jurusan PT',
            border: OutlineInputBorder(),
            hintText:
                'Contoh:\nPilihan 1: Teknik Informatika - ITS\nPilihan 2: Sistem Informasi - UI\nPilihan 3: Ilmu Komputer - ITB',
          ),
          maxLines: 5, // Memungkinkan 5 baris text
          keyboardType: TextInputType.multiline, // Mengaktifkan tombol enter
          textInputAction:
              TextInputAction.newline, // Memastikan enter membuat baris baru
          onChanged: (value) => siswa?.pilihanJurusanPT = value,
        ),
      ];
    }

    // Tambahkan status pembayaran di akhir form
    additionalFields.addAll([
      const SizedBox(height: 16),
      TextField(
        controller: TextEditingController(text: siswa?.statusPembayaran),
        decoration: const InputDecoration(
          labelText: 'Status Pembayaran',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => siswa?.statusPembayaran = value,
      ),
    ]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...baseFields, ...additionalFields],
    );
    return Column(children: baseFields);
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
            : siswa == null
                ? const Center(child: Text('Data siswa tidak ditemukan'))
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
                                        if (siswa != null) ...[
                                          Text(
                                            siswa!.namaLengkap,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text('Kode: ${siswa!.kodeSiswa}'),
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
                                child: SingleChildScrollView(
                                  child: _buildDynamicFormFields(),
                                ),
                              ),
                              deleteItemName: siswa?.namaLengkap ?? '',
                              onPrint: () {
                                // Handle print
                              },
                              onUpdate: () async {
                                try {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                  );

                                  final success = await _apiService.updateData(
                                    type: 'siswa',
                                    id: siswa!.kodeSiswa,
                                    data: {
                                      'Pilihan Kelas': siswa!.pilihanKelas,
                                      'Mata Pelajaran Pilihan':
                                          siswa!.mataPelajaranPilihan,
                                      'Asal Sekolah (Reguler)':
                                          siswa!.asalSekolahReguler,
                                      'Kelas (Reguler)': siswa!.kelasReguler,
                                      'Asal Sekolah (lolos sekolah)':
                                          siswa!.asalSekolahLolos,
                                      'Kelas (lolos sekolah)':
                                          siswa!.kelasLoslosSekolah,
                                      'Pilihan Sekolah (3 Pilihan)':
                                          siswa!.pilihanSekolah,
                                      'Kelas (Lolos PT)': siswa!.kelasLolosPT,
                                      'Jurusan (SMA/SMK)': siswa!.jurusanSMA,
                                      'Mata Pelajaran Pilihan (SMA)':
                                          siswa!.mataPelajaranPilihanSMA,
                                      'Pilihan Jurusan Perguruan Tinggi (3 Pilihan)':
                                          siswa!.pilihanJurusanPT,
                                      'Status Pembayaran':
                                          siswa!.statusPembayaran,
                                      'Nama Lengkap': siswa!.namaLengkap,
                                      'Alamat': siswa!.alamat,
                                      'No Hp / Email': siswa!.noHpEmail,
                                      'Nama Orang Tua': siswa!.namaOrangTua,
                                      'No HP Orang Tua': siswa!.noHpOrangTua,
                                      'Tanggal Lahir': DateFormat('dd/MM/yyyy')
                                          .format(siswa!.tanggalLahir),
                                      'Jenis Kelamin': siswa!.jenisKelamin,
                                    },
                                  );

                                  // Tutup dialog loading
                                  Navigator.of(context).pop();

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Data berhasil diupdate'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    await _loadSiswaData();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Gagal mengupdate data'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
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
                                    type: 'siswa',
                                    id: siswa!.kodeSiswa,
                                  );

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Data berhasil dihapus'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    await Future.delayed(
                                        const Duration(seconds: 4));
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Gagal menghapus data'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  Navigator.pop(context);

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
                                  MapEntry('Kode Siswa', siswa!.kodeSiswa),
                                  MapEntry('Nama Lengkap', siswa!.namaLengkap),
                                  MapEntry(
                                    'Tanggal Lahir',
                                    DateFormat('dd/MM/yyyy')
                                        .format(siswa!.tanggalLahir),
                                  ),
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
