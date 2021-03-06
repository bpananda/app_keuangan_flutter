import 'package:app_keuangan/utils/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 100.0),
              Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: "Masukan email"),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: "Masukan password"),
              ),
              const SizedBox(height: 10.0),
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    print("Email and password cannot be empty");
                    return;
                  }
                  bool res = await AuthProvider().signInWithEmail(
                      _emailController.text, _passwordController.text);
                  if (!res) {
                    print("Login failed");
                  }
                },
              ),
              const SizedBox(height: 20.0),
              Text("Atau"),
              const SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  "Login with Google",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  bool res = await AuthProvider().loginWithGoogle();
                  if (!res) print("error logging in with google");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
