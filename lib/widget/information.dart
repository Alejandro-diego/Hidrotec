import 'dart:async';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hidrotec/models/providerrtdb.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Information extends StatefulWidget {
  const Information({Key? key}) : super(key: key);

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final _formKey = GlobalKey<FormState>();
  late String dispositivo = "1003";
  late String cep = '99400-000';
  late String cidade = "Espumoso";

  DatabaseReference database = FirebaseDatabase.instance.ref();
  final _numberController = TextEditingController();
  final _cepController = TextEditingController();
  final _cidadeController = TextEditingController();

  @override
  void initState() {
    _obtener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.13),
      child: Column(
        children: [
          const Spacer(),
          Container(
            // color: Colors.orange,
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
                SizedBox(
                  child: Center(
                    child: InkWell(
                      onLongPress: () => _dispN(context),
                      child: const Text(
                        'Mantenha apertado para mudar as informação',
                        style: TextStyle(fontSize: 13.0, color: Colors.amber),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 2,
          )
        ],
      ),
    );
  }

  Future<void> _obtener() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      dispositivo = preference.getString('disp') ?? 'Sem Dispositivo';
      cep = preference.getString('cep') ?? 'sem Data';
      cidade = preference.getString('cidade') ?? 'sem Data';

      _cepController.text = cep;
      _cidadeController.text = cidade;
      _numberController.text = dispositivo;
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
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.black,
                      content: Text(
                        'Salvando datos',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                  _colocar();

                  Timer.periodic(const Duration(seconds: 2), (timer) {
                     Restart.restartApp();
                  });
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          ],
          title: const Text('Aleterar Informação'),
          content: SizedBox(
            height: 220,
            width: 300,
            child: Form(
              key: _formKey,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese Dispositivo';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese Local do Dispositivo';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'por favor ingresar Preço';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
