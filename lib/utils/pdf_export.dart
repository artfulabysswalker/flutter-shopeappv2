import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> exportReceipt(Map<String, dynamic> txn, List<Map<String, dynamic>> items) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Receipt #${txn['id']}', style: pw.TextStyle(fontSize: 18)),
          pw.Text('Date: ${txn['created_at']}'),
          pw.SizedBox(height: 10),
          ...items.map((item) => pw.Text('Item ID: ${item['item_id']} x${item['qty']} = ${item['price']}')),
          pw.SizedBox(height: 10),
          pw.Text('Total: ${txn['total']}', style: pw.TextStyle(fontSize: 16)),
        ],
      ),
    ),
  );

  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );
}
