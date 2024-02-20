import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:shop_app/screens/cart/factura/util/util.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import '../../../models/carrito_model.dart';

class PdfPage extends StatefulWidget {
  final List<CarritoModel> model;
  const PdfPage({super.key, required this.model});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  PrintingInfo? printingInfo;

  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }
  Future<void> postInvoice(User user, List<CarritoModel> models) async {
    try {
      // Generar el PDF
      final pdfBytes = await generatePdf(PdfPageFormat.a4);

      // Convertir el PDF a un archivo temporal
      final tempDir = await getTemporaryDirectory();
      final pdfFile = File('${tempDir.path}/invoice.pdf');
      await pdfFile.writeAsBytes(pdfBytes);

      // Crear la solicitud POST
      final url = Uri.parse('URL_DE_TU_API'); // Reemplaza esto con la URL de tu API
      final request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('invoice', pdfFile.path))
        ..fields['userId'] = user.uid;

      // Enviar la solicitud
      final response = await request.send();

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        print('Factura enviada con éxito.');
      } else {
        print('Error al enviar la factura: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error al enviar la factura: $e');
    }
  }

  Future<Uint8List> generatePdf(final PdfPageFormat format) async {
    final doc = pw.Document(title: "Factura");
    final logoImage = pw.MemoryImage(
        (await rootBundle.load("assets/sena.png")).buffer.asUint8List());

    final pageTheme = await myPageTheme(format);

    doc.addPage(
      pw.MultiPage(
          pageTheme: pageTheme,
          header: (final context) => pw.Image(
              alignment: pw.Alignment.topLeft,
              logoImage,
              fit: pw.BoxFit.contain,
              width: 100),
          build: (context) => [
                pw.Container(
                    padding: pw.EdgeInsets.only(left: 30, bottom: 20),
                    child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text('Email: '),
                                pw.Text('Telefono: '),
                                pw.Text('Instagram: ')
                              ]),
                          pw.SizedBox(width: 70),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('sena@misena.com'),
                                pw.Text('032131 03123'),
                              ]),
                          pw.SizedBox(width: 70),
                          pw.BarcodeWidget(
                              data: "Factura",
                              width: 40,
                              height: 40,
                              barcode: pw.Barcode.qrCode(),
                              drawText: false),
                          pw.Padding(padding: pw.EdgeInsets.zero)
                        ])),
                pw.Center(
                  child: pw.Padding(
                padding: pw.EdgeInsets.only(bottom: 15),
                      child: pw.Text('Factura',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 30))
    )
                    ),
                for (var item in widget.model)
                  pw.Container(
                    padding:
                        pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: pw.EdgeInsets.only(bottom: 10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(item.carritoNombre!),
                        pw.Text(
                            "\$${item.carritoPrecioUnitario} x ${item.carritoCantidad}"),
                        pw.Text("\$${item.carritoSubtotal}"),
                      ],
                    ),
                  ),
                pw.Container(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: pw.EdgeInsets.only(bottom: 10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(
                          "\$${widget.model.map((carrito) => int.parse(carrito.carritoSubtotal!)).fold(0, (a, b) => a + b)}"),
                    ],
                  ),
                )
              ]),
    );
    return doc.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Factura"),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: [],
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: generatePdf,
      ),
    );
  }
}