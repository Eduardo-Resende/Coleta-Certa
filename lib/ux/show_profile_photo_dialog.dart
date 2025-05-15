import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

void showProfilePhotoDialog(BuildContext context, String photoPath) {
  showDialog(
    context: context,
    barrierDismissible: true, // <- permite fechar ao clicar fora
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // fecha ao tocar na área da imagem
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Fundo escuro borrado
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              ),

              // Imagem da foto
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(photoPath),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

