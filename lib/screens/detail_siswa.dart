import 'package:flutter/material.dart';
import 'package:absensi/models/absensi.dart';

class DetailSiswa extends StatefulWidget {
  final Absensi absensi;

  const DetailSiswa({super.key, required this.absensi});

  @override
  State<DetailSiswa> createState() => _DetailSiswaState();
}

class _DetailSiswaState extends State<DetailSiswa> {
  bool isValidValue(String? value, String fieldName) {
    // Pengecualian untuk Status Pembayaran
    if (fieldName == "Status Pembayaran") {
      return true; // Selalu tampilkan Status Pembayaran
    }

    // Validasi normal untuk field lainnya
    if (value == null) return false;
    if (value.toLowerCase() == "null") return false;
    if (value.trim().isEmpty) return false;
    return true;
  }

  // Map untuk menyimpan nilai awal
  Map<String, String> initialValues = {};
  // Map untuk menyimpan nilai yang diedit
  Map<String, String> editedValues = {};
  // Flag untuk menandai apakah ada perubahan
  bool hasChanges = false;
  // Map untuk menyimpan controller
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai awal
    initialValues = {
      "Nama Lengkap": widget.absensi.namaLengkap ?? "",
      "Tempat/Tanggal Lahir": widget.absensi.tempatTanggalLahir ?? "",
      "Jenis Kelamin": widget.absensi.jenisKelamin ?? "",
      "Alamat": widget.absensi.alamat ?? "",
      "Pilihan Kelas": widget.absensi.pilihanKelas ?? "",
      "No Hp / Email": widget.absensi.noHpEmail ?? "",
      "Nama Orang Tua": widget.absensi.namaOrangTua ?? "",
      "No HP Orang Tua": widget.absensi.noHpOrangTua ?? "",
      "Asal Sekolah": widget.absensi.asalSekolah ?? "",
      "Kelas": widget.absensi.kelas ?? "",
      "Mata Pelajaran Pilihan": widget.absensi.mataPelajaranPilihan ?? "",
      "Jurusan (SMA/SMK)": widget.absensi.jurusanSMA_SMK ?? "",
      "Mata Pelajaran Pilihan (SMA)":
          widget.absensi.mataPelajaranPilihanSMA ?? "",
      "Pilihan Jurusan Perguruan Tinggi":
          widget.absensi.pilihanJurusanPerguruanTinggi ?? "",
      "Status Pembayaran": widget.absensi.statusPembayaran ?? "",
    };
    editedValues = Map.from(initialValues);

    // Inisialisasi controller dan focus node untuk setiap field
    initialValues.forEach((key, value) {
      _controllers[key] = TextEditingController(text: value);
      _focusNodes[key] = FocusNode();
    });
  }

  void checkForChanges() {
    bool changed = false;
    initialValues.forEach((key, value) {
      if (editedValues[key] != value) {
        changed = true;
      }
    });
    setState(() {
      hasChanges = changed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, String>> validDetails = initialValues.entries
        .where((entry) => isValidValue(entry.value, entry.key))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Siswa"),
        actions: [
          const Spacer(),
          TextButton(
            onPressed: hasChanges
                ? () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Konfirmasi"),
                          content: const Text(
                              "Anda telah mengedit detail siswa, yakin simpan?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () {
                                print("Detail siswa telah disimpan.");
                                setState(() {
                                  initialValues = Map.from(editedValues);
                                  hasChanges = false;
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Simpan",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                : null,
            child: Text(
              "Simpan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: hasChanges ? null : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Konfirmasi Hapus"),
                    content: const Text(
                        "Apakah Anda yakin ingin menghapus data siswa ini?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          print("Siswa telah dihapus.");
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Hapus",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              "Hapus Siswa",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 160,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.qr_code, size: 40, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: validDetails
                      .map((entry) => _buildEditableDetailRow(
                          entry.key, editedValues[entry.key] ?? ""))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableDetailRow(String label, String value) {
    final controller = _controllers[label]!;
    final focusNode = _focusNodes[label]!;

    return StatefulBuilder(
      builder: (context, setState) {
        focusNode.addListener(() {
          setState(() {});
        });

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$label:",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.text,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (newValue) {
                    editedValues[label] = newValue;
                    checkForChanges();
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: focusNode.hasFocus ? Colors.black : Colors.black54,
                    height: 1.5,
                  ),
                  cursorColor: Colors.blue,
                  cursorWidth: 2.0,
                  cursorRadius: const Radius.circular(1.0),
                ),
              ),
              const Divider(height: 1, thickness: 1),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Bersihkan controllers dan focus nodes
    _controllers.forEach((key, controller) => controller.dispose());
    _focusNodes.forEach((key, focusNode) => focusNode.dispose());
    super.dispose();
  }
}
