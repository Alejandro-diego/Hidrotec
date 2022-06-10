import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hidrotec/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:hidrotec/authbloc/authbloc.dart';
import '../authbloc/authbloc.dart';
import '../widget/information.dart';
import '../widget/socal_buttons.dart';

import 'home.dart';
import 'logo.dart';

class LoginPage1 extends StatefulWidget {
  const LoginPage1({Key? key}) : super(key: key);

  @override
  State<LoginPage1> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage1>
    with SingleTickerProviderStateMixin {

      late StreamSubscription<User?> loginStateSubcription;
  late AnimationController _animationController;
  bool _isShowSingUp = false;
  late Animation<int> _animationTextRotate;
  late Animation<int> _fontsized;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
     final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, snapshot) {
            return Stack(
              children: [
                AnimatedPositioned(
                  width: _size.width * 0.88,
                  height: _size.height,
                  left: _isShowSingUp ? -_size.width * 0.76 : _size.width * 0,
                  duration: defaultDuration,
                  child: Container(
                    color: login_bg,
                    child: const Information(),
                  ),
                ),
                AnimatedPositioned(
                  duration: defaultDuration,
                  height: _size.height,
                  width: _size.width * 0.88,
                  left: _isShowSingUp ? _size.width * 0.12 : _size.width * 0.88,
                  child: Container(
                    color: signup_bg,
                   
                  ),
                ),
                AnimatedPositioned(
                  duration: defaultDuration,
                  top: _isShowSingUp ? _size.height * 0.3 : _size.height * 0.1,
                  right:
                      _isShowSingUp ? -_size.width * 0.06 : _size.width * 0.12,
                  left: 0,
                  child: AnimatedSwitcher(
                      duration: defaultDuration,
                      child: LogoHidrotec(
                        fontSize1: _fontsized.value.toDouble(),
                        fontSize2: 12,
                      )),
                ),
                AnimatedPositioned(
                  duration: defaultDuration,
                  width: _size.width,
                  right:
                      _isShowSingUp ? -_size.width * 0.06 : _size.width * 0.06,
                  bottom: _size.height * 0.1,
                  child:  SocalButtns(




                    onPressed: _isShowSingUp ?() => authBloc.loginGoogle():(){},
                  ),
                ),
                AnimatedPositioned(
                  duration: defaultDuration,
                  bottom: _isShowSingUp
                      ? _size.height / 2 - 80
                      : _size.height * 0.3,
                  left: _isShowSingUp ? 0 : _size.width * 0.44 - 80,
                  child: AnimatedDefaultTextStyle(
                    duration: defaultDuration,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: _isShowSingUp ? Colors.white : Colors.white70,
                        fontSize: _isShowSingUp ? 20 : 25.0,
                        fontWeight: FontWeight.bold),
                    child: Transform.rotate(
                      angle: -_animationTextRotate.value * pi / 180,
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: updateView,
                        child: Container(
                          //color: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              vertical: defpaultPadding * 0.75),
                          width: 170,
                          child: Text(
                            "Informação".toUpperCase(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: defaultDuration,
                  bottom: !_isShowSingUp
                      ? _size.height / 2 - 80
                      : _size.height * 0.3,
                  right: _isShowSingUp ? _size.width * 0.44 - 80 : 0,
                  child: AnimatedDefaultTextStyle(
                    duration: defaultDuration,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: !_isShowSingUp ? Colors.white : Colors.white70,
                        fontSize: !_isShowSingUp ? 20 : 32.0,
                        fontWeight: FontWeight.bold),
                    child: Transform.rotate(
                      angle: (90 - _animationTextRotate.value) * pi / 180,
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: updateView,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: defpaultPadding * 0.75),
                          width: 160,
                          child: Text(
                            "Sing Up".toUpperCase(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  void setUpAnimation() {
    _animationController =
        AnimationController(vsync: this, duration: defaultDuration);

    _animationTextRotate =
        IntTween(begin: 0, end: 90).animate(_animationController);

    _fontsized = IntTween(begin: 35, end: 50).animate(_animationController);
  }

  void updateView() {
    setState(() {
      _isShowSingUp = !_isShowSingUp;

      _isShowSingUp
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  

  @override
  void dispose() {
     loginStateSubcription.cancel();
    _animationController.dispose();
    super.dispose();
  }

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
  
     setUpAnimation();

    super.initState();
  }

  


  











}
