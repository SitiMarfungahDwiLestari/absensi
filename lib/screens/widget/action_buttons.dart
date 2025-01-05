import 'package:absensi/screens/widget/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? iconColor;

  const ActionButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: iconColor ?? foregroundColor),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? const Color(0xFF9c8aa5),
        foregroundColor: foregroundColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        minimumSize: const Size(150, 0),
        fixedSize: const Size(150, 45),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final Widget printContent;
  final VoidCallback? onPrint;
  final Widget updateContent;
  final VoidCallback? onUpdate;
  final String deleteItemName;
  final VoidCallback? onDelete;

  const ActionButtons({
    Key? key,
    required this.printContent,
    this.onPrint,
    required this.updateContent,
    this.onUpdate,
    required this.deleteItemName,
    this.onDelete,
  }) : super(key: key);

  void _showPrintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print Kartu'),
        content: printContent,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              if (onPrint != null) onPrint!();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Fitur print akan segera tersedia')),
              );
            },
            icon: const Icon(Icons.print),
            label: const Text('Print'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Update Data',
        headerIcon: Icons.edit,
        content: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: updateContent,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onUpdate != null) onUpdate!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9c8aa5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Konfirmasi Hapus',
        headerIcon: Icons.warning,
        headerColor: Colors.red,
        maxWidth: 600,
        maxHeight: 200,
        content: Padding(
          padding: const EdgeInsets.only(left: 3), // Jarak 3 dari kiri
          child: Align(
              alignment: Alignment.centerLeft, // Memastikan teks rata kiri
              child: Text(
                'Apakah Anda yakin ingin menghapus data $deleteItemName?',
                style: const TextStyle(fontSize: 16),
              )),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onDelete != null) onDelete!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActionButton(
          label: 'Print Kartu',
          icon: Icons.print,
          iconColor: Colors.white,
          onPressed: () => _showPrintDialog(context),
        ),
        const SizedBox(height: 16),
        ActionButton(
          label: 'Edit',
          icon: Icons.edit,
          iconColor: Colors.white,
          onPressed: () => _showUpdateDialog(context),
        ),
        const SizedBox(height: 16),
        ActionButton(
          label: 'Hapus',
          icon: Icons.delete,
          backgroundColor: Colors.red[400],
          foregroundColor: Colors.white,
          iconColor: Colors.white,
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
  }
}
