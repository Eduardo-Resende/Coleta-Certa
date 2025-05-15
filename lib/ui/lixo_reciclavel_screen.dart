import 'package:coleta_certa/ux/image_navigator.dart';
import 'package:flutter/material.dart';

class LixoReciclavelScreen extends StatelessWidget {
  const LixoReciclavelScreen({super.key});

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
            title: Column(
              children: [
                Text(
                  "APRENDA A RECICLAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'nunito',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Clique sobre os tipos de lixo",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'nunito',
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImageNavigator(
                imagePath: 'lib/assets/img/lixo_vermelho.png',
                htmlFilePath: 'lib/assets/html/lixo_vermelho.html',
                popupColor: Colors.red,
                width: 120,
                height: 160,
              ),
              ImageNavigator(
                imagePath: 'lib/assets/img/lixo_azul.png',
                htmlFilePath: 'lib/assets/html/lixo_azul.html',
                popupColor: Colors.blue,
                width: 120,
                height: 160,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImageNavigator(
                imagePath: 'lib/assets/img/lixo_verde.png',
                htmlFilePath: 'lib/assets/html/lixo_verde.html',
                popupColor: Colors.green,
                width: 120,
                height: 160,
              ),
              ImageNavigator(
                imagePath: 'lib/assets/img/lixo_amarelo.png',
                htmlFilePath: 'lib/assets/html/lixo_amarelo.html',
                popupColor: Colors.yellow,
                width: 120,
                height: 160,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImageNavigator(
                imagePath: 'lib/assets/img/lixo_preto.png',
                htmlFilePath: 'lib/assets/html/lixo_preto.html',
                popupColor: const Color.fromARGB(255, 43, 42, 42),
                width: 120,
                height: 160,
              ),
              ImageNavigator(
                imagePath: 'lib/assets/img/lixo_laranja.png',
                htmlFilePath: 'lib/assets/html/lixo_laranja.html',
                popupColor: Colors.orange,
                width: 120,
                height: 160,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImageNavigator(
                imagePath: 'lib/assets/img/lixo_branco.png',
                htmlFilePath: 'lib/assets/html/lixo_branco.html',
                popupColor: Colors.white,
                width: 120,
                height: 160,
              ),
              ImageNavigator(
                imagePath: 'lib/assets/img/lixo_roxo.png',
                htmlFilePath: 'lib/assets/html/lixo_roxo.html',
                popupColor: Colors.deepPurple,
                width: 120,
                height: 160,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImageNavigator(
                imagePath: 'lib/assets/img/lixo_marrom.png',
                htmlFilePath: 'lib/assets/html/lixo_marrom.html',
                popupColor: Colors.brown,
                width: 120,
                height: 160,
              ),
              ImageNavigator(
                imagePath: 'lib/assets/img/lixo_cinza.png',
                htmlFilePath: 'lib/assets/html/lixo_cinza.html',
                popupColor: Colors.grey,
                width: 120,
                height: 160,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
