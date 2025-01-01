import 'package:flutter/material.dart';
import 'package:absensi/api_service.dart';
import 'package:absensi/models/guru.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailGuru extends StatefulWidget {
  final Guru guru;

  const DetailGuru({super.key, required this.guru});

  @override
  State<DetailGuru> createState() => _DetailGuruState();
}

class _DetailGuruState extends State<DetailGuru> {
  final ApiService _apiService = ApiService();
  bool isLoading = false;

  Map<String, String> initialValues = {};
  Map<String, String> editedValues = {};
  bool hasChanges = false;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    initialValues = {
      "Nama Lengkap": widget.guru.namaLengkap,
      "Alamat": widget.guru.alamat,
      "No HP": widget.guru.noHp,
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

  Widget _buildQRCode() {
    String qrData =
        "${widget.guru.id}|${widget.guru.namaLengkap}|${widget.guru.alamat}|${widget.guru.noHp}";

    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'QR Code Presensi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail ${widget.guru.namaLengkap}"),
        actions: [
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            TextButton.icon(
              onPressed: hasChanges
                  ? () async {
                      setState(() => isLoading = true);
                      try {
                        final success = await _apiService.updateGuru({
                          'Nama Lengkap': widget.guru.namaLengkap,
                          'Alamat': _controllers['Alamat']?.text ?? '',
                          'No HP': _controllers['No HP']?.text ?? '',
                        });

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success
                                  ? 'Data berhasil diupdate'
                                  : 'Gagal mengupdate data'),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );
                          if (success) Navigator.pop(context, true);
                        }
                      } finally {
                        if (mounted) setState(() => isLoading = false);
                      }
                    }
                  : null,
              icon: const Icon(Icons.save),
              label: const Text("Simpan"),
              style: TextButton.styleFrom(
                foregroundColor: hasChanges ? null : Colors.grey,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildQRCode(),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _controllers["Nama Lengkap"],
                      focusNode: _focusNodes["Nama Lengkap"],
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Nama Lengkap",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controllers["Alamat"],
                      focusNode: _focusNodes["Alamat"],
                      decoration: const InputDecoration(
                        labelText: "Alamat",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        editedValues["Alamat"] = value;
                        checkForChanges();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controllers["No HP"],
                      focusNode: _focusNodes["No HP"],
                      decoration: const InputDecoration(
                        labelText: "No HP",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        editedValues["No HP"] = value;
                        checkForChanges();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
