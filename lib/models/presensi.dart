class Presensi {
  final String timestamp;
  final String kodePresensi;
  final String kodeGuruSiswa;
  final String nama;
  final String kehadiran;
  final String statusPembayaran;
  final bool isEditable;

  Presensi({
    required this.timestamp,
    required this.kodePresensi,
    required this.kodeGuruSiswa,
    required this.nama,
    required this.kehadiran,
    required this.statusPembayaran,
    this.isEditable = true
  });

  factory Presensi.fromJson(Map<String, dynamic> json) {
    return Presensi(
      timestamp: json['Timestamp']?.toString() ?? '',
      kodePresensi: json['Kode Presensi']?.toString() ?? '',
      kodeGuruSiswa: json['Kode Guru/Siswa']?.toString() ?? '',
      nama: json['Nama']?.toString() ?? '',
      kehadiran: json['Kehadiran']?.toString() ?? '',
      statusPembayaran: json['Status Pembayaran']?.toString() ?? '',
      isEditable: json['isEditable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Timestamp': timestamp,
      'Kode Presensi': kodePresensi,
      'Kode Guru/Siswa': kodeGuruSiswa,
      'Nama': nama,
      'Kehadiran': kehadiran,
      'Status Pembayaran': statusPembayaran,
    };
  }
}
