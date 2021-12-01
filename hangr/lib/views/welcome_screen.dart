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
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/homepage');
                  },
                child: const Text("Continue",
                  style: TextStyle(
                      // color: kWhiteColor,
                      fontSize: 14,
                      // fontFamily: 'SF',
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),
            ],
          ),
        ),

    );
  }
}