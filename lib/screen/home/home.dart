import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hidrotec/screen/login.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../authbloc/authbloc.dart';
import '../../responsive.dart';
import 'home_movil.dart';
import 'home_tablet.dart';

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
        preferredSize: const Size(double.infinity, 56.0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              backgroundColor: Colors.transparent,
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
        child: const Responsive(
          mobile: HomePageMovil(),
          tablet: HomePageTablet(),
        ),
      ),
    );
  }
}
