import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:provider/provider.dart';

import '../models/providerrtdb.dart';

class PickColor extends StatefulWidget {
  const PickColor({Key? key}) : super(key: key);

  @override
  State<PickColor> createState() => _PickColorState();
}

class _PickColorState extends State<PickColor> {
  final _database = FirebaseDatabase.instance.ref();

  final _controller = CircleColorPickerController(
    initialColor: Colors.blue,
  );

  String _col = "";

  Color currentColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    final dispositivo = Provider.of<ProviderRTDB>(context);
    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Column(
          children: [
            const Text('Led Control'),
            CircleColorPicker(
              
              controller: _controller,
              onChanged: (color) {
                setState(() {
                  currentColor = color;
                  _col = color.toString();
                  _col = _col.replaceFirst('Color(0xff', '');
                  _col = _col.replaceAll(')', '');

                  _database
                      .child('disp' + dispositivo.datosProvider!.disp)
                      .update({
                    'color': _col,
                  });
                });
              },
              size: const Size(190, 190),
              textStyle: const TextStyle(fontSize: 0.0),
              strokeWidth: 2,
              thumbSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
