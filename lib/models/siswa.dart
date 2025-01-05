// siswa_model.dart
class Siswa {
  final String timestamp;
  final String kodeSiswa;
  final String namaLengkap;
  final DateTime tanggalLahir;
  final String jenisKelamin;
  final String alamat;
  final String pilihanKelas;
  final String noHpEmail;
  final String namaOrangTua;
  final String noHpOrangTua;
  final String asalSekolahReguler;
  final String kelasReguler;
  final String mataPelajaranPilihan;
  final String asalSekolahLolos;
  final String kelasLoslosSekolah;
  final String pilihanSekolah;
  final String kelasLolosPT;
  final String jurusanSMA;
  final String mataPelajaranPilihanSMA;
  final String pilihanJurusanPT;
  final String statusPembayaran;
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
    return Siswa(
      timestamp: json['Timestamp'] ?? '',
      kodeSiswa: json['Kode Siswa'] ?? '',
      namaLengkap: json['Nama Lengkap'] ?? '',
      tanggalLahir: json['Tanggal Lahir'] != null
          ? DateTime.parse(json['Tanggal Lahir'])
          : DateTime.now(),
      jenisKelamin: json['Jenis Kelamin'] ?? '',
      alamat: json['Alamat'] ?? '',
      pilihanKelas: json['Pilihan Kelas'] ?? '',
      noHpEmail: json['No Hp / Email']?.toString() ?? '',
      namaOrangTua: json['Nama Orang Tua'] ?? '',
      noHpOrangTua: json['No HP Orang Tua']?.toString() ?? '',
      asalSekolahReguler: json['Asal Sekolah (Reguler)'] ?? '',
      kelasReguler: json['Kelas (Reguler)']?.toString() ?? '',
      mataPelajaranPilihan: json['Mata Pelajaran Pilihan'] ?? '',
      asalSekolahLolos: json['Asal Sekolah (lolos sekolah)'] ?? '',
      kelasLoslosSekolah: json['Kelas (lolos sekolah)'] ?? '',
      pilihanSekolah: json['Pilihan Sekolah (3 Pilihan)'] ?? '',
      kelasLolosPT: json['Kelas (Lolos PT)']?.toString() ?? '',
      jurusanSMA: json['Jurusan (SMA/SMK)'] ?? '',
      mataPelajaranPilihanSMA: json['Mata Pelajaran Pilihan (SMA)'] ?? '',
      pilihanJurusanPT:
          json['Pilihan Jurusan Perguruan Tinggi (3 Pilihan)']?.toString() ??
              '',
      statusPembayaran: json['Status Pembayaran'] ?? '',
      qrCode: json['QR Code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Timestamp': timestamp,
      'Kode Siswa': kodeSiswa,
      'Nama Lengkap': namaLengkap,
      'Tanggal Lahir': tanggalLahir.toIso8601String(),
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
