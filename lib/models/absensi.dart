class Absensi {
  final String timestamp;
  final String namaLengkap;
  final String tempatTanggalLahir;
  final String jenisKelamin;
  final String alamat;
  final String pilihanKelas;
  final String noHpEmail;
  final String namaOrangTua;
  final String noHpOrangTua;
  final String asalSekolah;
  final String kelas;
  final String mataPelajaranPilihan;
  final String pilihanSekolah;
  final String jurusanSMA_SMK;
  final String mataPelajaranPilihanSMA;
  final String pilihanJurusanPerguruanTinggi;
  final String statusPembayaran;

  Absensi({
    required this.timestamp,
    required this.namaLengkap,
    required this.tempatTanggalLahir,
    required this.jenisKelamin,
    required this.alamat,
    required this.pilihanKelas,
    required this.noHpEmail,
    required this.namaOrangTua,
    required this.noHpOrangTua,
    required this.asalSekolah,
    required this.kelas,
    required this.mataPelajaranPilihan,
    required this.pilihanSekolah,
    required this.jurusanSMA_SMK,
    required this.mataPelajaranPilihanSMA,
    required this.pilihanJurusanPerguruanTinggi,
    required this.statusPembayaran,
  });

  factory Absensi.fromJson(Map<String, dynamic> json) {
    return Absensi(
      timestamp: json['Timestamp'].toString(),
      namaLengkap: json['Nama Lengkap'].toString(),
      tempatTanggalLahir: json['Tempat/Tanggal Lahir'].toString(),
      jenisKelamin: json['Jenis Kelamin'].toString(),
      alamat: json['Alamat'].toString(),
      pilihanKelas: json['Pilihan Kelas'].toString(),
      noHpEmail: json['No Hp / Email'].toString(),
      namaOrangTua: json['Nama Orang Tua'].toString(),
      noHpOrangTua: json['No HP Orang Tua'].toString(),
      asalSekolah: json['Asal Sekolah'].toString(),
      kelas: json['Kelas'].toString(),
      mataPelajaranPilihan: json['Mata Pelajaran Pilihan'].toString(),
      pilihanSekolah: json['Pilihan Sekolah (3 Pilihan)'].toString(),
      jurusanSMA_SMK: json['Jurusan (SMA/SMK)'].toString(),
      mataPelajaranPilihanSMA: json['Mata Pelajaran Pilihan (SMA)'].toString(),
      pilihanJurusanPerguruanTinggi:
          json['Pilihan Jurusan Perguruan Tinggi (3 Pilihan)'].toString(),
      statusPembayaran: json['Status Pembayaran'].toString(),
    );
  }
}
