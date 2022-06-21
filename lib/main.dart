import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hidrotec/screen/home/home.dart';
import 'package:hidrotec/screen/log/login_page.dart';

import 'package:hidrotec/widget/logo.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'models/providerrtdb.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    
    ChangeNotifierProvider(
      create: (_) => ProviderRTDB(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Hidrotec',
      home: AnimatedSplashScreen(
        backgroundColor: Colors.black,
        duration: 3000,
        splash: LogoHidrotec1(
          fontSize1: 38,
          fontSize2: 12,
        ),
        nextScreen: const MainPage(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }  
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Algo Deu errado'),
            );
          } else if (snapshot.hasData) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}




