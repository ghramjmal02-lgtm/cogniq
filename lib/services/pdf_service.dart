import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  // استخراج كل النص من ملف PDF (يشتغل ع الويب والموبايل والويندوز)
  static Future<String> extractText(Uint8List bytes) async {
    final PdfDocument document = PdfDocument(inputBytes: bytes);
    final String text = PdfTextExtractor(document).extractText();
    document.dispose();
    return text;
  }
}
