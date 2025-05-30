// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageCropScreen extends StatefulWidget {
  final File imageFile;

  const ImageCropScreen({super.key, required this.imageFile});

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final GlobalKey<ExtendedImageEditorState> _editorKey =
      GlobalKey<ExtendedImageEditorState>();

  void _cropAndReturn() async {
    final rawImageData = await cropImageDataWithNativeLibrary(
      state: _editorKey.currentState!,
    );

    if (rawImageData != null) {
      final croppedFile = File('${widget.imageFile.path}_cropped.jpg');
      await croppedFile.writeAsBytes(rawImageData);
      Navigator.pop(context, croppedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 36, 139, 55),
            shadowColor: Colors.black,
            elevation: 10,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Ajustar Foto',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'nunito',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.white, size: 40),
                onPressed: _cropAndReturn,
              ),
            ],
          ),
        ),
      ),
      body: ExtendedImage.file(
        widget.imageFile,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        extendedImageEditorKey: _editorKey,
        cacheRawData: true,
        initEditorConfigHandler:
            (state) => EditorConfig(
              maxScale: 8.0,
              cropRectPadding: const EdgeInsets.all(20.0),
              hitTestSize: 20.0,
              cropAspectRatio: 1, // Círculo/Quadrado
            ),
      ),
    );
  }
}

Future<Uint8List?> cropImageDataWithNativeLibrary({
  required ExtendedImageEditorState state,
}) async {
  final Rect cropRect = state.getCropRect()!;
  final Uint8List data = state.rawImageData;

  final img.Image? image = img.decodeImage(data);
  if (image == null) return null;

  final img.Image cropped = img.copyCrop(
    image,
    x: cropRect.left.toInt(),
    y: cropRect.top.toInt(),
    width: cropRect.width.toInt(),
    height: cropRect.height.toInt(),
  );

  return Uint8List.fromList(img.encodeJpg(cropped));
}
