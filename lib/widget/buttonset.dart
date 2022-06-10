
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/providerrtdb.dart';

class ButtonSET extends StatefulWidget {
  const ButtonSET({Key? key}) : super(key: key);

  @override
  State<ButtonSET> createState() => _ButtonSETState();
}

class _ButtonSETState extends State<ButtonSET> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      width: MediaQuery.of(context).size.width / 2,
      height: 65,
      decoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => Provider.of<ProviderRTDB>(context, listen: false)
                  .downSetTemp(),
              child: const Icon(
                Icons.arrow_downward_rounded,
              ),
              style:  ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                
              ),
            ),
          
            const Text('SET'),

             ElevatedButton(
              onPressed: () => Provider.of<ProviderRTDB>(context, listen: false)
                  .upSetTemp(),
              child: const Icon(
                Icons.arrow_upward_rounded,
              ),
              style:  ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                
              ),
            ),
          
         
          ],
        ),
      ),
    );
  }
}
