import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

class AboutTheAppScreen extends StatefulWidget {
  const AboutTheAppScreen({super.key});

  @override
  State<AboutTheAppScreen> createState() => _AboutTheAppScreenState();
}

class _AboutTheAppScreenState extends State<AboutTheAppScreen> {
  String readmeContent = '';

  @override
  void initState() {
    super.initState();
    loadReadme();
  }

  Future<void> loadReadme() async {
    final String content = await rootBundle.loadString('README.md');
    setState(() {
      readmeContent = content;
    });
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
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Sobre o App',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'nunito',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

      body:
          readmeContent.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Markdown(
                data: readmeContent,
                padding: EdgeInsets.all(16),
                styleSheet: MarkdownStyleSheet.fromTheme(
                  Theme.of(context),
                ).copyWith(
                  p: TextStyle(fontSize: 16),
                  h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
    );
  }
}
