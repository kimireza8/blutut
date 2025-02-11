import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class QRImageScreen extends StatefulWidget {
  @override
  _QRImageScreenState createState() => _QRImageScreenState();
}

class _QRImageScreenState extends State<QRImageScreen> {
  Uint8List? qrData;
  ui.Image? qrImage;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Code Viewer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Data QR secara Manual
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: "Masukkan Data QR (Base64/Hex)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Tombol untuk Menampilkan QR dari Input Manual
            ElevatedButton(
              onPressed: _convertTextToQR,
              child: Text("Tampilkan QR dari Input"),
            ),
            SizedBox(height: 20),

            // Menampilkan QR Code
            Expanded(
              child: Center(
                child: qrImage != null
                    ? RawImage(image: qrImage)
                    : Text("Belum ada QR Code"),
              ),
            ),
          ],
        ),
      ),
    );
  }



  // Fungsi untuk Mengubah Input Manual ke Gambar QR
  void _convertTextToQR() {
    try {
      // Konversi hex string menjadi Uint8List
      Uint8List inputBytes = _hexToBytes(textController.text);
      print('cek bytes: $inputBytes');

      _decodeImage(inputBytes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Format data tidak valid!")),
      );
    }
  }

// Fungsi untuk mengonversi hex string menjadi Uint8List
  Uint8List _hexToBytes(String hex) {
    hex = hex.replaceAll(RegExp(r'\s+'), ''); // Hilangkan spasi atau newline jika ada
    if (hex.length % 2 != 0) {
      throw FormatException("Hex string memiliki panjang ganjil");
    }

    List<int> bytes = [];
    for (int i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(bytes);
  }


  // Fungsi untuk Mengubah Uint8List menjadi Gambar
  Future<void> _decodeImage(Uint8List data) async {
    final img.Image? image = img.decodeImage(data);
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data QR tidak valid")),
      );
      return;
    }

    final ui.Codec codec =
    await ui.instantiateImageCodec(Uint8List.fromList(img.encodePng(image)));
    final ui.FrameInfo frame = await codec.getNextFrame();

    setState(() {
      qrImage = frame.image;
    });
  }
}
