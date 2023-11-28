import 'package:fitplus/src/controller/splash_screens_controller.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:fitplus/screens/login&register/login.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;
  @override
  void initState() {
    Get.put(AppController());
    startAnimation();
    // if (FirebaseAuth.instance.currentUser != null) {
    //   if (AppController.to.loginMap['typeAccount'] == 1) {
    //     Future.delayed(Duration(seconds: 4), () {
    //       //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLogin()));
    //       Get.off(() => HomeScreenUser());
    //     });
    //   } else {
    //     Future.delayed(Duration(seconds: 4), () {
    //       //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLogin()));
    //       Get.off(() => HomePageGym());
    //     });
    //   }
    // } else {
    Future.delayed(const Duration(seconds: 4), () {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLogin()));
      Get.off(() => const MyLogin());
    });
    // }
    super.initState();
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      animate = true;
    });
    await Future.delayed(const Duration(milliseconds: 5000));
    Get.to(const MyLogin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // AnimatedPositioned(
          //  duration: const Duration(milliseconds: 1600),
          //  top: animate ? 0 : -30,
          //  left: animate ? 0 : -30,
          //  child: AnimatedOpacity(
          //  duration: const Duration(milliseconds: 1600),
          // opacity: animate ? 1 : 0,
          //  child: const Image(image: AssetImage('assets/logo.png')),
          //  ),
          //  ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 2000),
            top: 10,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: animate ? 1 : 0,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 2400),
            bottom: animate ? 0 : -10,
            left: animate ? 0 : -20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: animate ? 1 : 0,
              child: Container(
                width: 300,
                margin: const EdgeInsets.fromLTRB(35, 0, 50, 330),
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 2400),
            bottom: animate ? 10 : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: animate ? 1 : 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
