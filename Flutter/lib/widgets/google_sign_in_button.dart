import 'package:camera_gallery/screens/imagecapture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera_gallery/screens/signinscreen.dart';
import 'package:camera_gallery/providers/social_auth.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User? user =
                    await Authentication.signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  print('hi');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ImageCapture(
                        user: user,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                // Flexible(
                // child: Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      // flex: 1,
                      child: Image.asset(
                        'assets/images/google_logo.png',
                        // height: 160,
                        // width: 200,
                      ),
                    ),
                    // Flexible(
                    //   child: Card(
                    //     child: Image(
                    //       image: AssetImage("assets\images\google_logo.png"),
                    //       // height: 35.0,
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 10),
                    //   // child: Text(
                    //   //   'Sign in with Google',
                    //   //   style: TextStyle(
                    //   //     fontSize: 10,
                    //   //     color: Colors.black54,
                    //   //     fontWeight: FontWeight.w600,
                    //   //   ),
                    //   // ),
                    // )
                  ],
                ),
                // ),
                //),
              ),
            ),
    );
  }
}
