class DatosAD {
  int temp;
  int tempSetting;
  bool led;
  bool ledpisca;
  bool bomba;
  bool bomba1;
  bool auto;
  String disp;
  String email;
  String name;

  DatosAD(
      {required this.temp,
      required this.name,
      required this.email,
      required this.auto,
      required this.tempSetting,
      required this.bomba,
      required this.led,
      required this.bomba1,
      required this.disp,
      required this.ledpisca});

  factory DatosAD.fromRTDB(Map<String, dynamic> data) {
    return DatosAD(
        auto: data['auto'] ?? false,
        temp: data['temp'] ?? 2151,
        tempSetting: data['setTemp'] ?? 23,
        bomba: data['bomba'] ?? false,
        bomba1: data['bomba1'] ?? false,
        led: data['led'] ?? false,
        ledpisca: data['ledpisca'] ?? false,
        name: data['name'] ?? 'name', 
        email: data['email'] ?? 'email',
        disp: data['disp'] ?? '1001');
  }
}
