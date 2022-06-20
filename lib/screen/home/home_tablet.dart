import 'package:flutter/material.dart';
import 'package:hidrotec/widget/buttonset.dart';
import 'package:hidrotec/widget/datainf.dart';
import 'package:hidrotec/widget/gauge.dart';
import '../../widget/buttonled.dart';
import '../../widget/circulo.dart';
import '../../widget/logo_small.dart';
import '../../widget/weather.dart';

class HomePageTablet extends StatefulWidget {
  const HomePageTablet({Key? key}) : super(key: key);

  @override
  State<HomePageTablet> createState() => _HomePageTabletState();
}

class _HomePageTabletState extends State<HomePageTablet> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  height: 312,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(
                      top: 100, left: 5, right: 5, bottom: 10),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[800]!.withOpacity(0.6),
                  ),
                  child: Row(
                    children: [
                      SetTempContainer(
                        width: size.width * .17,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Gauge(),
                          ButtonSET(),
                          LogoHidrotec(),
                        ],
                      ),
                      PickColor(
                        widht: size.width * 0.28,
                        height: 291,
                      ),
                      Column(
                        children: const [
                          LedButton(),
                          SizedBox(height: 8,),
                          Weather(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
