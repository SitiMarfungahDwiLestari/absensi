import 'package:flutter/material.dart';
import 'package:absensi/models/absensi.dart';
import 'package:absensi/api_service.dart';

class DetailSiswa extends StatefulWidget {
  final Absensi absensi;

  const DetailSiswa({super.key, required this.absensi});

  @override
  State<DetailSiswa> createState() => _DetailSiswaState();
}

class _DetailSiswaState extends State<DetailSiswa> {
  final ApiService _apiService = ApiService();
  bool isLoading = false;

  bool isValidValue(String? value, String fieldName) {
    if (fieldName == "Status Pembayaran") return true;
    if (value == null) return false;
    if (value.toLowerCase() == "null") return false;
    if (value.trim().isEmpty) return false;
    return true;
  }

  Map<String, String> initialValues = {};
  Map<String, String> editedValues = {};
  bool hasChanges = false;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    initialValues = {
      "Nama Lengkap": widget.absensi.namaLengkap,
      "Tempat/Tanggal Lahir": widget.absensi.tempatTanggalLahir,
      "Jenis Kelamin": widget.absensi.jenisKelamin,
      "Alamat": widget.absensi.alamat,
      "Pilihan Kelas": widget.absensi.pilihanKelas,
      "Nama Orang Tua": widget.absensi.namaOrangTua,
      "No HP Orang Tua": widget.absensi.noHpOrangTua,
      "Asal Sekolah": widget.absensi.asalSekolah,
      "Status Pembayaran": widget.absensi.statusPembayaran,
    };

    editedValues = Map.from(initialValues);

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

  Future<void> _saveChanges() async {
    if (!hasChanges) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Kumpulkan hanya field yang berubah
      final Map<String, String> dataToUpdate = {};

      editedValues.forEach((key, value) {
        if (value != initialValues[key]) {
          dataToUpdate[key] = value;
        }
      });

      // Selalu sertakan Nama Lengkap sebagai identifier
      dataToUpdate['Nama Lengkap'] = widget.absensi.namaLengkap;

      print('Sending updates for fields: ${dataToUpdate.keys.join(", ")}');

      final success = await _apiService.updateAbsensi(dataToUpdate);

      if (success) {
        setState(() {
          initialValues = Map.from(editedValues);
          hasChanges = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil disimpan'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Gagal menyimpan data. Pastikan data yang diubah sudah benar.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            TextButton(
              onPressed: hasChanges ? _saveChanges : null,
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

  Widget _buildEditableDetailRow(String fieldName, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              fieldName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _controllers[fieldName],
              focusNode: _focusNodes[fieldName],
              onChanged: (newValue) {
                setState(() {
                  editedValues[fieldName] = newValue;
                  checkForChanges();
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: fieldName,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
