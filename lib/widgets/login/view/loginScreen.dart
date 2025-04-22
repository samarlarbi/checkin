import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../utils/tokenprovider.dart';
import '../controller/controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController codeController = TextEditingController();

  LoginController loginController = LoginController();
  String? code;

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> Login(BuildContext context) async {
    try {
      if (codeController.text.isEmpty) {
        _showErrorDialog(context, "Please enter the code");
      } else {
        code = codeController.text;
        var response = await loginController.getToken(codeController.text);
        print(loginController.token);
        print(response);
        await Provider.of<AccessTokenProvider>(context, listen: false)
            .saveTokens(accessToken: response);
        if (response == "error") {
          _showErrorDialog(context, "Invalid code. Please try again.");
        } else {
          print("Token: $response");
          Navigator.pushNamed(context, '/home');
        }
      }
    } catch (e) {
      _showErrorDialog(context, "An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THE MAZE',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome Mic Member! Please login to your account.',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 118, 117, 117)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Code",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter the secret code',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      minimumSize: Size(MediaQuery.of(context).size.width, 50),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Login(context);
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/mic.png',
                    width: 65,
                    height: 65,
                  ),
                  Image.asset(
                    'assets/themaze.jpg',
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
