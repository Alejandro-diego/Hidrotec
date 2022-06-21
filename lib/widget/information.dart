import 'dart:async';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hidrotec/models/providerrtdb.dart';
import 'package:provider/provider.dart';
//import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Information extends StatefulWidget {
  const Information({Key? key}) : super(key: key);

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final _formKey = GlobalKey<FormState>();

  DatabaseReference database = FirebaseDatabase.instance.ref();
  final _dispController = TextEditingController();
  final _cepController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    _obtener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.10),
      child: Column(
        children: [
          const Spacer(),
          Container(
            //color: Colors.orange,
            // padding: const EdgeInsets.all(10),
            height: 170,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(.6),
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
                  height: 100.0,
                  padding: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: Consumer<ProviderRTDB>(
                    builder: (context, model, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dispositivo : ${_dispController.text}'),
                          Text(
                              'Local do Dispositivo : ${_cidadeController.text}'),
                          Text('CEP : ${_cepController.text}'),
                          Text('Nome : ${_nameController.text}'),
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
                        'Apertar para mudar as informação',
                        style: TextStyle(fontSize: 15.0, color: Colors.amber),
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
      _cepController.text = preference.getString('cep') ?? '';
      _cidadeController.text = preference.getString('cidade') ?? '';
      _dispController.text = preference.getString('disp') ?? '';
      _nameController.text = preference.getString('name') ?? '';
      if (_dispController.text != "") {
        context.read<ProviderRTDB>().changueDisp(_dispController.text);
      }
    });
  }

  Future<void> _colocar() async {
    SharedPreferences preference = await SharedPreferences.getInstance();

    setState(
      () {
        preference.setString('disp', _dispController.text);
        preference.setString('cep', _cepController.text);
        preference.setString('cidade', _cidadeController.text);
        preference.setString('name', _nameController.text);
        database.child('disp${_dispController.text}').update(
          {
            'disp': _dispController.text,
            'cidade': _cidadeController.text,
            'cep': _cepController.text,
            'name': _nameController.text,
          },
        );
      },
    );
  }

  void _dispN(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
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
                    context
                        .read<ProviderRTDB>()
                        .changueDisp(_dispController.text);

                    Timer.periodic(const Duration(seconds: 2), (timer) {
                      // Restart.restartApp();
                    });
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
            ],
            title: const Text('Aleterar Informação'),
            content: SizedBox(
              height: 250,
              width: 200,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(),
                        labelText: 'Nome',
                      ),
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese Nome';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(),
                        labelText: 'Local do Dispositivo',
                      ),
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
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(),
                        labelText: 'CEP',
                      ),
                      controller: _cepController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'por favor ingresar Preço';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(),
                        labelText: 'Dispositivo',
                      ),
                      keyboardType: TextInputType.number,
                      controller: _dispController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese Dispositivo';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}