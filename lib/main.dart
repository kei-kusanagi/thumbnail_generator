import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thumblr/thumblr.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Thumbnail? thumb;
  @override
  void initState() {
    super.initState();
  }

  Future<void> saveImageToFile(Uint8List imageBytes) async {
    Uint8List imageBytes = await thumb!.image
        .toByteData(format: ImageByteFormat.png)
        .then((byteData) => byteData!.buffer.asUint8List());

    String tempDir = Directory.systemTemp.path;
    File imageFile = File('$tempDir/thumbnail.png');
    await imageFile.writeAsBytes(imageBytes);

    debugPrint('Image saved in: ${imageFile.path}');
  }

  getThumbnail(TextEditingController urlController) async {
    try {
      thumb = await generateThumbnail(
        filePath: urlController.text,
        position: 0.5,
      );

      setState(() {});
    } on PlatformException catch (e) {
      debugPrint('Failed to generate thumbnail: ${e.message}');
    } catch (e) {
      debugPrint('Failed to generate thumbnail: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController urlController = TextEditingController();

    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: Material(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: thumb?.image != null
                          ? RawImage(image: thumb!.image)
                          : const Placeholder(),
                    ),
                    TextField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        hintText: 'Enter video URL',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        getThumbnail(urlController);
                      },
                      child: const Text('Save thumbnail'),
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
}
