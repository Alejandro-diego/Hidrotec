import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../responsive.dart';
import '../../widget/logo_small.dart';
import 'home_movil.dart';
import 'home_tablet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 56.0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text('Hidrotec Controller'),
              actions: <Widget>[
                PopupMenuButton<int>(
                  
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      
                      value: 0,
                      child: Icon(
                        Icons.support_agent,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: Icon(
                        Icons.info_outline,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Icon(
                        Icons.logout,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/image/azul.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Responsive(
          mobile: HomePageMovil(),
          tablet: HomePageTablet(),
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        // ignore: deprecated_member_use
        launch('https://wa.me/message/OJG5RNHXJSJNB1');
        break;
      case 1:
        about();
        break;
      case 2:
        FirebaseAuth.instance.signOut();
        break;
    }
  }

  void about() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(.5),
          title: const Text("Acerca de"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: Column(
              children: [
                const LogoHidrotec(),
                TextButton(
                  onPressed: () {
                    // ignore: deprecated_member_use
                    launch("mailto:hidrotecpiscinaseaquecedores@gmail.com");
                  },
                  child: const Text("hidrotecpiscinaseaquecedores@gmail.com"),
                ),
                const Text('Rua Fioravante Barleze N°110'),
                 const Text('Carazinho'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

//   launch('https://wa.me/qr/SOV436WKK5SXF1');
//   FirebaseAuth.instance.signOut();