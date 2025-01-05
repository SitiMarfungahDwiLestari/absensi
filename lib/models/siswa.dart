import 'package:intl/intl.dart';

class Siswa {
  final String timestamp;
  final String kodeSiswa;
  String namaLengkap; // Mutable untuk update
  DateTime tanggalLahir; // Mutable untuk update
  String jenisKelamin; // Mutable untuk update
  String alamat; // Mutable untuk update
  String pilihanKelas; // Mutable untuk update
  String noHpEmail; // Mutable untuk update
  String namaOrangTua; // Mutable untuk update
  String noHpOrangTua; // Mutable untuk update
  String asalSekolahReguler; // Mutable untuk update
  String kelasReguler; // Mutable untuk update
  String mataPelajaranPilihan; // Mutable untuk update
  String asalSekolahLolos; // Mutable untuk update
  String kelasLoslosSekolah; // Mutable untuk update
  String pilihanSekolah; // Mutable untuk update
  String kelasLolosPT; // Mutable untuk update
  String jurusanSMA; // Mutable untuk update
  String mataPelajaranPilihanSMA; // Mutable untuk update
  String pilihanJurusanPT; // Mutable untuk update
  String statusPembayaran; // Mutable untuk update
  final Map<String, dynamic>? qrCode;

  Siswa({
    required this.timestamp,
    required this.kodeSiswa,
    required this.namaLengkap,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.alamat,
    required this.pilihanKelas,
    required this.noHpEmail,
    required this.namaOrangTua,
    required this.noHpOrangTua,
    required this.asalSekolahReguler,
    required this.kelasReguler,
    required this.mataPelajaranPilihan,
    required this.asalSekolahLolos,
    required this.kelasLoslosSekolah,
    required this.pilihanSekolah,
    required this.kelasLolosPT,
    required this.jurusanSMA,
    required this.mataPelajaranPilihanSMA,
    required this.pilihanJurusanPT,
    required this.statusPembayaran,
    this.qrCode,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    DateTime parseTanggalLahir(dynamic value) {
      if (value == null) return DateTime.now();

      try {
        // Coba parse jika format ISO
        return DateTime.parse(value.toString());
      } catch (e) {
        try {
          // Coba parse jika format dd/MM/yyyy
          final parts = value.toString().split('/');
          if (parts.length == 3) {
            return DateTime(
              int.parse(parts[2]), // year
              int.parse(parts[1]), // month
              int.parse(parts[0]), // day
            );
          }
        } catch (e) {
          print('Error parsing date: $value');
        }
        return DateTime.now();
      }
    }

    return Siswa(
      timestamp: json['Timestamp']?.toString() ?? '',
      kodeSiswa: json['Kode Siswa']?.toString() ?? '',
      namaLengkap: json['Nama Lengkap']?.toString() ?? '',
      tanggalLahir: parseTanggalLahir(json['Tanggal Lahir']),
      jenisKelamin: json['Jenis Kelamin']?.toString() ?? '',
      alamat: json['Alamat']?.toString() ?? '',
      pilihanKelas: json['Pilihan Kelas']?.toString() ?? '',
      noHpEmail: json['No Hp / Email']?.toString() ?? '',
      namaOrangTua: json['Nama Orang Tua']?.toString() ?? '',
      noHpOrangTua: json['No HP Orang Tua']?.toString() ?? '',
      asalSekolahReguler: json['Asal Sekolah (Reguler)']?.toString() ?? '',
      kelasReguler: json['Kelas (Reguler)']?.toString() ?? '',
      mataPelajaranPilihan: json['Mata Pelajaran Pilihan']?.toString() ?? '',
      asalSekolahLolos: json['Asal Sekolah (lolos sekolah)']?.toString() ?? '',
      kelasLoslosSekolah: json['Kelas (lolos sekolah)']?.toString() ?? '',
      pilihanSekolah: json['Pilihan Sekolah (3 Pilihan)']?.toString() ?? '',
      kelasLolosPT: json['Kelas (Lolos PT)']?.toString() ?? '',
      jurusanSMA: json['Jurusan (SMA/SMK)']?.toString() ?? '',
      mataPelajaranPilihanSMA:
          json['Mata Pelajaran Pilihan (SMA)']?.toString() ?? '',
      pilihanJurusanPT:
          json['Pilihan Jurusan Perguruan Tinggi (3 Pilihan)']?.toString() ??
              '',
      statusPembayaran: json['Status Pembayaran']?.toString() ?? '',
      qrCode: json['QR Code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Timestamp': timestamp,
      'Kode Siswa': kodeSiswa,
      'Nama Lengkap': namaLengkap,
      'Tanggal Lahir': DateFormat('dd/MM/yyyy')
          .format(tanggalLahir), // Format sesuai spreadsheet
      'Jenis Kelamin': jenisKelamin,
      'Alamat': alamat,
      'Pilihan Kelas': pilihanKelas,
      'No Hp / Email': noHpEmail,
      'Nama Orang Tua': namaOrangTua,
      'No HP Orang Tua': noHpOrangTua,
      'Asal Sekolah (Reguler)': asalSekolahReguler,
      'Kelas (Reguler)': kelasReguler,
      'Mata Pelajaran Pilihan': mataPelajaranPilihan,
      'Asal Sekolah (lolos sekolah)': asalSekolahLolos,
      'Kelas (lolos sekolah)': kelasLoslosSekolah,
      'Pilihan Sekolah (3 Pilihan)': pilihanSekolah,
      'Kelas (Lolos PT)': kelasLolosPT,
      'Jurusan (SMA/SMK)': jurusanSMA,
      'Mata Pelajaran Pilihan (SMA)': mataPelajaranPilihanSMA,
      'Pilihan Jurusan Perguruan Tinggi (3 Pilihan)': pilihanJurusanPT,
      'Status Pembayaran': statusPembayaran,
      'QR Code': qrCode,
    };
  }
}
