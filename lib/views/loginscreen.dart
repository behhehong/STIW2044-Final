import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_tutor/models/user.dart';
import 'package:my_tutor/views/changePass.dart';
import 'package:my_tutor/views/mainpage.dart';
import 'package:my_tutor/views/registrationscreen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool remember = false;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 400,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.jpg'),
                            fit: BoxFit.cover),
                      ),
                      height: constraints.maxHeight / 2.2,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 40, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/logo1.png', scale: 2.5),
                    const SizedBox(height: 30),
                    Text(
                      "Welcome",
                      style: GoogleFonts.merriweather(
                        textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Sign in to continue",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    aboveText('Email address'),
                    const SizedBox(height: 5),
                    textFormField(emailController),
                    const SizedBox(height: 30),
                    aboveText('Password'),
                    const SizedBox(height: 5),
                    TextFormField(
                      obscureText: _isObscure,
                      controller: passwordController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 9, 56, 95),
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        elevation: 10,
                        color: const Color.fromARGB(255, 9, 56, 95),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        onPressed: () {
                          _userLogin();
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registration(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color.fromARGB(255, 9, 56, 95),
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _forgotPassword,
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: Color.fromARGB(255, 9, 56, 95),
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Align aboveText(text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Color.fromARGB(255, 9, 56, 95),
        ),
      ),
    );
  }

  TextFormField textFormField(controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 9, 56, 95),
          ),
        ),
      ),
    );
  }

  void _userLogin() {
    String _email = emailController.text;
    String _password = passwordController.text;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      http.post(
          Uri.parse("https://hubbuddies.com/271513/myTutor/php/loginuser.php"),
          body: {"email": _email, "password": _password}).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'Success') {
          User user = User.fromJson(data['data']);
          
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainPage(user: user)));
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      });
    }
  }

  void _saveRemovePref(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String email = emailController.text;
      String password = passwordController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value) {
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('remember', true);
      } else {
        await prefs.setString('email', '');
        await prefs.setString('pass', '');
        await prefs.setBool('remember', false);
        emailController.text = "";
        passwordController.text = "";
      }
    } else {
      remember = false;
    }
  }

  void _onRememberMeChanged(bool value) {
    remember = value;
    setState(() {
      if (remember) {
        _saveRemovePref(true);
      } else {
        _saveRemovePref(false);
      }
    });
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;

    if (remember) {
      setState(() {
        emailController.text = email;
        passwordController.text = password;
        remember = true;
      });
    }
  }

  void _forgotPassword() {
    TextEditingController _useremailController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Forgot Your Password?"),
              content: SizedBox(
                  height: 90,
                  child: Column(children: [
                    TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _useremailController,
                        decoration: const InputDecoration(
                            labelText: 'Email', icon: Icon(Icons.email))),
                  ])),
              actions: [
                TextButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    _resetPassword(_useremailController.text);
                  },
                ),
                TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  void _resetPassword(String userEmail) {
    http.post(
        Uri.parse("https://hubbuddies.com/271513/myTutor/php/resetuser.php"),
        body: {
          // "firstName": ,
          //"lastName": lastName,
          "email": userEmail,
          //"phoneNumber": phoneNumber,
          //"password": password
        }).then((respone) {
      print(respone.body);
      if (respone.body == "success") {
        Fluttertoast.showToast(
          msg: "Reset Done! Please check your email !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => LoginScreen()));
      } else if (respone.body == "reset failed") {
        Fluttertoast.showToast(
          msg: "Reset Failed !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => LoginScreen()));
      } else if (respone.body == "no user") {
        Fluttertoast.showToast(
          msg: "This user not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => LoginScreen()));
      } else {
        Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      }
    });
  }
}
