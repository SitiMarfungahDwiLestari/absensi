class Absensi {
  final String timestamp;
  final String nama;
  final String nisNip;
  final String status;

  Absensi(
      {required this.timestamp,
      required this.nama,
      required this.nisNip,
      required this.status});

  factory Absensi.fromJson(Map<String, dynamic> json) {
    return Absensi(
      timestamp: json['Timestamp'].toString(),
      nama: json['Nama'].toString(),
      nisNip: json['NIS/NIP'].toString(),
      status: json['Status'].toString(),
    );
  }
}
