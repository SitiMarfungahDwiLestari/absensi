// guru_model.dart
class Guru {
  final String timestamp;
  final String kodeGuru;
  final String namaLengkap;
  final String jenisKelamin;
  final DateTime tanggalLahir;
  final String alamat;
  final String noHp;
  final String statusAktivasi;
  final Map<String, dynamic>? qrCode;

  Guru({
    required this.timestamp,
    required this.kodeGuru,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.alamat,
    required this.noHp,
    required this.statusAktivasi,
    this.qrCode,
  });

  factory Guru.fromJson(Map<String, dynamic> json) {
    return Guru(
      timestamp: json['Timestamp'] ?? '',
      kodeGuru: json['Kode Guru'] ?? '',
      namaLengkap: json['Nama Lengkap'] ?? '',
      jenisKelamin: json['Jenis Kelamin'] ?? '',
      tanggalLahir: json['Tanggal Lahir'] != null
          ? DateTime.parse(json['Tanggal Lahir'])
          : DateTime.now(),
      alamat: json['Alamat'] ?? '',
      noHp: json['No HP']?.toString() ?? '',
      statusAktivasi: json['Status Aktivasi'] ?? '',
      qrCode: json['QR Code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Timestamp': timestamp,
      'Kode Guru': kodeGuru,
      'Nama Lengkap': namaLengkap,
      'Jenis Kelamin': jenisKelamin,
      'Tanggal Lahir': tanggalLahir.toIso8601String(),
      'Alamat': alamat,
      'No HP': noHp,
      'Status Aktivasi': statusAktivasi,
      'QR Code': qrCode,
    };
  }
}
