import 'package:coleta_certa/ux/pop_up.dart';
import 'package:flutter/material.dart';

class MainInfoBox extends StatelessWidget {
  final String imageAsset;
  final String titulo;
  final String subTituloPopUp;
  final String urlVideo;

  const MainInfoBox({super.key, required this.imageAsset, required this.titulo, required this.subTituloPopUp, required this.urlVideo});

  @override

Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: SizedBox(
      width: 190,
      height: 150,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => PopUp(
              title: titulo,
              videoUrl: urlVideo              ,
              subtitle: subTituloPopUp,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.zero, 
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imageAsset,
                  width: 180,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                titulo,
                style: const TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}