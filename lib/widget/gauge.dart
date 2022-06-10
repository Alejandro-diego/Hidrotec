import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../models/providerrtdb.dart';

class Gauge extends StatefulWidget {
  const Gauge({Key? key}) : super(key: key);

  @override
  State<Gauge> createState() => _GaugeState();
}

class _GaugeState extends State<Gauge> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderRTDB>(builder: (context, model, child) {
      if (model.datosProvider != null) {
        return SfRadialGauge(
            title: const GaugeTitle(text: 'Control Temperatura',textStyle: TextStyle(fontSize: 10)),
            axes: <RadialAxis>[
              RadialAxis(
                  minimum: 0,
                  maximum: 60,
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 20,
                      endValue: 36,
                      color: Colors.greenAccent,
                      startWidth: 5,
                      endWidth: 10,
                    ),
                    //  GaugeRange(
                    //      startValue: 50, endValue: 100, color: Colors.orange),
                    //  GaugeRange(startValue: 100, endValue: 150, color: Colors.red)
                    //],
                  ],
                  axisLineStyle: const AxisLineStyle(
                      thickness: 0.05, thicknessUnit: GaugeSizeUnit.factor),
                  showTicks: true,
                  showLabels: true,
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: (model.datosProvider!.temp / 100).toDouble(),
                      color: Colors.redAccent,
                      width: 4,
                    ),

                    MarkerPointer(
                      markerOffset: -11,
                      color: Colors.orangeAccent,
                      markerHeight: 15,
                      markerWidth: 15,
                      enableDragging: true,
                      value: model.datosProvider!.tempSetting.toDouble(),
                    ),
                   
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Row(
                          children: <Widget>[
                            Text(
                              (model.datosProvider!.temp /100).toString() + "º",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        angle: 1,
                        positionFactor: .95)
                  ])
            ]);
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
