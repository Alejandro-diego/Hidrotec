import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hidrotec/screen/login.dart';
import 'package:hidrotec/widget/buttonset.dart';
import 'package:hidrotec/widget/datainf.dart';
import 'package:hidrotec/widget/gauge.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../authbloc/authbloc.dart';
import '../widget/buttonled.dart';
import '../widget/circulo.dart';
import '../widget/weather.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<User?> loginStateSubcription;

  String disp = '463';
  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubcription = authBloc.currentUser.listen(
      (fbuser) {
        if (fbuser == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPage1(),
            ),
          );
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    loginStateSubcription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize:const  Size(double.infinity,56.0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
            child: AppBar(
              backgroundColor:Colors.transparent,
              elevation: 0,
              
              title: const Text('Hidrotec Controller'),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.headset_mic),
                    onPressed: () {
                      launch('https://wa.me/message/OJG5RNHXJSJNB1');
                    }),
                IconButton(
                    onPressed: () {
                      authBloc.logout();
                    },
                    icon: const Icon(Icons.logout)),
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
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    height: 310,
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only (top: 85,left: 5,right: 5,bottom: 10),
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[800]!.withOpacity(0.6),
                    ),
                    child: Row(
                      children: [
                        const SetTempContainer(),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 2, left: 8),
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                              ),
                              height: 190.0,
                              width: 200.0,
                              child: const Gauge(),
                            ),
                            const ButtonSET(),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 1),
                              width: MediaQuery.of(context).size.width / 2,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: OutlinedText(
                                  text: const Text(
                                    'HIDROTEC',
                                    style: TextStyle(
                                        fontFamily: 'ArialBlack',
                                        color: Colors.white70,
                                        fontSize: 20),
                                  ),
                                  strokes: [
                                    OutlinedTextStroke(
                                        color: const Color(0xff1528ff),
                                        width: 6),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 240,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey[800]!.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                const   PickColor(),


                  Column(
                    children:const  [
                       LedButton(),
                       Weather(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
