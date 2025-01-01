class Guru {
  final String id;
  final String namaLengkap;
  final String alamat;
  final String noHp;

  Guru({
    required this.id,
    required this.namaLengkap,
    required this.alamat,
    required this.noHp,
  });

  factory Guru.fromJson(Map<String, dynamic> json) {
    return Guru(
      id: json['id']?.toString() ?? '',
      namaLengkap: json['namaLengkap']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      noHp: json['noHp']?.toString() ?? '',
    );
  }
}
