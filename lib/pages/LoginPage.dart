import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robot_application/main.dart';
import 'package:robot_application/pages/ForgotPassword.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginWidget({
    Key? key,
    required this.showRegisterPage,
  }) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passswordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      reverse: true,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   height: height / 25,
          // ),
          Text(
            'ROBOT APPLICATION',
            style: GoogleFonts.carterOne(
              color: Color.fromARGB(211, 64, 132, 203),
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 9),
                  height: 160,
                  width: 435,
                  child: Image.asset(
                    'lib/assets/bg.png',
                    fit: BoxFit.cover,
                  ))),
          SizedBox(
            height: 10,
          ),

          TextField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.mail),
              )),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: passswordController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.password_sharp),
            ),
            obscureText: true,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(211, 64, 132, 203),
              elevation: 5,
              minimumSize: const Size.fromHeight(50),
            ),
            icon: const Icon(Icons.lock_open, size: 32),
            label: const Text(
              'Sign In',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: signIn,
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: const Text(
              'Forgot Password ?',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 138, 138, 138)),
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const forgotPasswordPage())),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
              text: TextSpan(
            style: const TextStyle(
                color: Color.fromARGB(211, 64, 132, 203), fontSize: 24),
            text: 'No Account ?  ',
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = widget.showRegisterPage,
                text: 'Sign Up',
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Color.fromARGB(255, 53, 53, 53)),
              ),
            ],
          ))
        ],
      ),
    );
  }

  signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passswordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
