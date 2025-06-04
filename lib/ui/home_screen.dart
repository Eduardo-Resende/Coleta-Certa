 import 'package:coleta_certa/ui/faq_screen.dart';
import 'package:coleta_certa/ui/horario_coleta_screen.dart';
import 'package:coleta_certa/ui/lixo_reciclavel_screen.dart';
import 'package:coleta_certa/ui/locais_favoritos_screen.dart';
import 'package:coleta_certa/ui/map_screen.dart';
import 'package:coleta_certa/ui/ponto_de_descarte_screen.dart';
import 'package:coleta_certa/ux/floating_navigation_bar.dart';
import 'package:coleta_certa/ux/main_button.dart';
import 'package:coleta_certa/ux/main_info_box.dart';
import 'package:coleta_certa/ux/navigate_screen.dart';
import 'package:coleta_certa/ux/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).usuario;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 36, 139, 55),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ColetaCerta',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed:
                      () =>
                          NavigateScreen.changeScreen(context, FaqScreen()),
                  icon: Icon(
                    Icons.live_help_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(300, 40),
                            bottomRight: Radius.elliptical(300, 40),
                          ),
                          color: const Color.fromARGB(255, 36, 139, 55),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 0,
                          ),
                          child: Text(
                            'Oie, ${user?.name ?? 'Usuário'}!',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Open Sans',
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MainButton(
                                  text: 'Horário\nColeta',
                                  icon: Icons.access_time,
                                  screen: HorarioColetaScreen(),
                                  heroTag: 'Coleta',
                                ),
                                MainButton(
                                  text: 'Descarte\nCorreto',
                                  icon: Icons.recycling_outlined,
                                  screen: LixoReciclavelScreen(),
                                  heroTag: 'lixo',
                                ),
                                MainButton(
                                  text: 'Locais\nFavoritos',
                                  icon: Icons.add_location_alt_outlined,
                                  screen: LocaisFavoritosScreen(),
                                  heroTag: 'favoritos',
                                ),
                                MainButton(
                                  text: 'Ponto de\nDescarte',
                                  icon: Icons.location_on_outlined,
                                  screen: PontoDeDescarteScreen(),
                                  heroTag: 'descarte',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Localização dos pontos de Descarte",
                          style: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 36, 139, 55),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed:
                                () => NavigateScreen.changeScreen(
                                  context,
                                  MapScreen(),
                                ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'lib/assets/img/mapa.jpg',
                                width: 300,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Row(
                      children: [
                        Image.asset(
                          'lib/assets/img/planeta_e_lixo.png',
                          width: 50,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "Fica a Dica!",
                          style: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 25,
                            color: const Color.fromARGB(255, 36, 139, 55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 190,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          MainInfoBox(
                            titulo: 'Aprenda a fazer um robô de garrafas Pet',
                            imageAsset:
                                'lib/assets/img/reciclagem_de_garrafas.png',
                            subTituloPopUp: 'Criando um robô com material reciclado',
                            urlVideo: 'https://www.youtube.com/watch?v=0sbD-5aC-lo',
                          ),
                          MainInfoBox(
                            titulo: 'Brinquedo com rolos de papel',
                            imageAsset: 'lib/assets/img/rolos.jpg',
                            subTituloPopUp: 'Não sabe o que fazer com o rolo de papel? Faça um avião incrivel!!',
                            urlVideo: 'https://www.youtube.com/watch?v=dQ5PL92-oRo',
                          ),
                          MainInfoBox(
                            titulo: 'Fazendo um caminhão de caixa de leite',
                            imageAsset:
                                'lib/assets/img/caixa_de_leite.jpg',
                            subTituloPopUp: 'Sempre quis fazer um caminhão com caixas de leite e não sabia como?\nAprenda agora!!',
                            urlVideo: 'https://www.youtube.com/watch?v=7ddEUmtWtas&list=PLooqzTcqqZvmqNkoxBojvXcqHB9jeJhxV',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        FloatingNavigationBar(),
      ],
    );
  }
}
