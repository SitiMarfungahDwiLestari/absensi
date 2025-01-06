import 'dart:typed_data';
import 'package:absensi/models/guru.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintService {
  static Future<Uint8List> generatePdf(Guru guru) async {
    final doc = pw.Document();
    final double cmToPt = 30;
    final cardFormat = PdfPageFormat(
      13.0 * cmToPt, // lebar 8 cm
      10.0 * cmToPt, // tinggi 6 cm
      marginAll: 0.5 * cmToPt, // margin 2mm
    );

    doc.addPage(
      pw.Page(
        pageFormat: cardFormat,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(0.5 * cmToPt),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 0.5),
              borderRadius: pw.BorderRadius.circular(0.3 * cmToPt),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'KARTU IDENTITAS',
                  style: pw.TextStyle(
                    fontSize: 0.6 * cmToPt,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 0.5 * cmToPt),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: guru.kodeGuru,
                  width: 4.3 * cmToPt, // QR code 3cm x 3cm
                  height: 4.3 * cmToPt,
                ),
                pw.SizedBox(height: 0.1 * cmToPt),
                pw.Text(
                  '${guru.kodeGuru}',
                  style: pw.TextStyle(fontSize: 0.2 * cmToPt),
                ),
                pw.SizedBox(height: 0.05 * cmToPt),
                pw.Text(
                  guru.namaLengkap,
                  style: pw.TextStyle(fontSize: 0.2 * cmToPt),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );

    return doc.save();
  }

  static Future<void> printGuruCard(BuildContext context, Guru guru) async {
    try {
      final pdfData = await generatePdf(guru);

      await Printing.layoutPdf(
        onLayout: (_) async => pdfData,
        name: 'Kartu_${guru.kodeGuru}',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mencetak kartu. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
