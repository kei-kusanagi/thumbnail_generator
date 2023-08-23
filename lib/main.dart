import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thumblr/thumblr.dart';

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
    getThumbnail();
  }

  Future<void> getThumbnail() async {
    try {
      thumb = await generateThumbnail(
        filePath:
            "C:/Users/admin/Desktop/Proyectos/Flutter/app_code_test/assets/Genshin.mp4",
        position: 0.5,
      );
    } on PlatformException catch (e) {
      debugPrint('Failed to generate thumbnail: ${e.message}');
    } catch (e) {
      debugPrint('Failed to generate thumbnail: ${e.toString()}');
    }
    debugPrint(thumb.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: Material(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: thumb?.image != null
                      ? RawImage(image: thumb!.image)
                      : const Placeholder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
