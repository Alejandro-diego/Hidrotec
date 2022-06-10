import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hidrotec/authbloc/authbloc.dart';
import 'package:hidrotec/screen/home.dart';
import 'package:hidrotec/screen/logo.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brasil_fields/brasil_fields.dart';

import '../models/providerrtdb.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late StreamSubscription<User?> loginStateSubcription;
  late String tok;
  late String dispositivo = "1003";
  late String cep = '99400-000';
  late String cidade = "Espumoso";

  DatabaseReference database = FirebaseDatabase.instance.ref();
  final _numberController = TextEditingController();
  final _cepController = TextEditingController();
  final _cidadeController = TextEditingController();

  @override
  void initState() {
    var autBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubcription = autBloc.currentUser.listen((event) {
      if (event != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    });
    _obtener();

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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('lib/image/PGoM.gif'))),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LogoHidrotec(
                  fontSize1: 35,
                  fontSize2: 12,
                ),
                const SizedBox(
                  height: 100.0,
                ),
                GestureDetector(
                  onLongPress: () {
                    _dispN(context);
                  },
                  child: Container(
                    // padding: const EdgeInsets.all(10),
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black.withOpacity(.2),
                      border: Border.all(),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              color: Colors.black),
                          child: const Center(
                            child: Text('Informação'),
                          ),
                        ),
                        Container(
                          height: 120.0,
                          padding: const EdgeInsets.all(5),
                          width: double.infinity,
                          child: Consumer<ProviderRTDB>(
                            builder: (context, model, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Dispositivo : $dispositivo'),
                                  Text('Local do Dispositivo : $cidade'),
                                  Text('CEP : $cep'),
                                  Text(
                                      'Nome : ${model.datosProvider == null ? 'sem nome' : model.datosProvider!.name}'),
                                  Text(
                                      'e-mail : ${model.datosProvider == null ? 'sem email' : model.datosProvider!.email}'),
                                ],
                              );
                            },
                          ),
                        ),
                       const  SizedBox(
                          child:  Center(
                            child: Text(
                              'Mantenha apertado para mudar as informação',
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.amber),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 200.0,
                ),
                SignInButton(
                  Buttons.Google,
                  text: "Entrar com Google",
                  onPressed: () => authBloc.loginGoogle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _obtener() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      dispositivo = preference.getString('disp') ?? 'Sem Dispositivo';
      cep = preference.getString('cep') ?? 'sem Data';
      cidade = preference.getString('cidade') ?? 'sem Data';
    });
  }

  Future<void> _colocar() async {
    SharedPreferences preference = await SharedPreferences.getInstance();

    setState(
      () {
        preference.setString('disp', _numberController.text);
        preference.setString('cep', _cepController.text);
        preference.setString('cidade', _cidadeController.text);
        database.child('disp' + _numberController.text).update(
          {
            'disp': _numberController.text,
            'cidade': _cidadeController.text,
            'cep': _cepController.text,
          },
        );
      },
    );
  }

  void _dispN(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(.5),
          actions: <Widget>[
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _colocar();

                  Timer.periodic(const Duration(seconds: 2), (timer) {
                      Restart.restartApp();
                  });
                },
                icon: const Icon(Icons.save),
                label: const Text('OK')),
          ],
          title: const Text('Aleterar Informação'),
          content: SizedBox(
            height: 180,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      border: const OutlineInputBorder(),
                      labelText: 'Dispositivo',
                      hintText: dispositivo),
                  keyboardType: TextInputType.number,
                  controller: _numberController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      border: const OutlineInputBorder(),
                      labelText: 'Local do Dispositivo',
                      hintText: cidade),
                  keyboardType: TextInputType.name,
                  controller: _cidadeController,
                ),
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      border: const OutlineInputBorder(),
                      labelText: 'CEP',
                      hintText: cep),
                  controller: _cepController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
