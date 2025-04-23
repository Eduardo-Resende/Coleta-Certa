// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

class ImageNavigator extends StatelessWidget {
  final String imagePath;
  final String htmlFilePath;
  final double width;
  final double height;
  final Color popupColor;

  const ImageNavigator({
    super.key,
    required this.imagePath,
    required this.htmlFilePath,
    this.popupColor = const Color.fromARGB(225, 76, 175, 80),
    this.width = 150,
    this.height = 150,
  });

  Future<String> _loadHtmlFromAssets() async {
    return await rootBundle.loadString(htmlFilePath);
  }

  Future<void> _showPopUp(BuildContext context) async {
    String htmlContent = await _loadHtmlFromAssets();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: popupColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  Html(data: htmlContent),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: popupColor,
                    ),
                    child: const Text('Fechar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPopUp(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}