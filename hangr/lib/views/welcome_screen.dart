import 'package:flutter/material.dart';


class WelcomeScreen extends StatefulWidget {

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/png/welcomeScreen.png"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.4),
              Container(
              width: 200,
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/png/logo.png'),
                ),
              ),
            ),
              SizedBox(height: size.height * 0.2),
              Center(
                child: SizedBox(
                  width: size.width * 0.3,
                  height: size.height * 0.0657,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        splashFactory: NoSplash.splashFactory,
                        primary: Colors.amber, // background
                        onPrimary: Colors.white, // foreground
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8)))),
                    onPressed: () {
                      Navigator.pushNamed(context, '/homepage');
                    },
                    child: const Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ),
              ),
            ],
          ),
        ),

    );
  }
}