import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../components/applocal.dart';
import '../components/crud.dart';
import '../components/valid.dart';
import '../constants/linksApi.dart';
import '../decoration/custom_text_form.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = GlobalKey();

  final Crud _crud = Crud();

  bool isLoading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  String hashPassword(String password) {
    // Use SHA-256 for hashing the password
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  SignUp() async {
    // if (formstate.currentState!.validate()) {
    setState(() {
      isLoading = true;
    });

    String hashedPassword = hashPassword(password.text);

    var response = await _crud.postRequest(linkSignUp, {
      "username": username.text,
      "email": email.text,
      "password": hashedPassword
    });

    isLoading = false;
    setState(() {});

    if (response != null &&
        response.containsKey('status') &&
        response['status'] == "success") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("success", (route) => false);
    } else {
      print("sign up failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  Form(
                    key: formstate,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/blackball.jpeg",
                          width: 200,
                          height: 200,
                        ),
                        CustomTextForm(
                          valid: (val) {
                            return validInput(val!, 5,
                                40); // Return the validation message or null

                            //return  validInput(val!, 3, 20);
                          },
                          savecontroller: username,
                          hint:  "${getLang(context, "username")}",
                        ),
                        CustomTextForm(
                          valid: (val) {
                            return validInput(val!, 5, 40);
                          },
                          savecontroller: email,
                          hint:  "${getLang(context, "email")}",
                        ),
                        CustomTextForm(
                          valid: (val) {
                            return validInput(val!, 3, 50);
                          },
                          savecontroller: password,
                          hint:"${getLang(context, "password")}",
                        ),
                        MaterialButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70, vertical: 10),
                          onPressed: () async {
                            await SignUp();
                          },
                          child:  Text("${getLang(context, "signup")}"),

                        ),
                        Container(height: 10),
                        InkWell(
                          child:  Text("${getLang(context, "login")}"),
                          onTap: () {
                            Navigator.of(context).pushNamed("login");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
