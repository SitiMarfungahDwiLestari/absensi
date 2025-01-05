class Guru {
  final String timestamp;
  final String kodeGuru;
  String namaLengkap;
  String jenisKelamin;
  DateTime tanggalLahir;
  String alamat;
  String noHp;
  String statusAktivasi;
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
    DateTime parseTanggalLahir(dynamic value) {
      if (value == null) return DateTime.now();

      try {
        // Coba parse jika format ISO
        return DateTime.parse(value);
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

    return Guru(
      timestamp: json['Timestamp'] ?? '',
      kodeGuru: json['Kode Guru'] ?? '',
      namaLengkap: json['Nama Lengkap'] ?? '',
      jenisKelamin: json['Jenis Kelamin'] ?? '',
      tanggalLahir: parseTanggalLahir(json['Tanggal Lahir']),
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
