import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:my_tutor/views/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  final FocusNode focusNode6 = FocusNode();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  bool _isObscure1 = true;
  bool _isObscure2 = true;

  // ignore: prefer_typing_uninitialized_variables
  var _imageFile;
  String pathAsset = 'assets/images/profilepic.jpg';

  @override
  void initState() {
    super.initState();
    focusNode1.addListener(() {
      setState(() {});
    });
    focusNode2.addListener(() {
      setState(() {});
    });
    focusNode3.addListener(() {
      setState(() {});
    });
    focusNode4.addListener(() {
      setState(() {});
    });
    focusNode5.addListener(() {
      setState(() {});
    });
    focusNode6.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    print("dispose was called");
    _usernameController.dispose();
    _phoneNumController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 60, 30, 10),
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: 130,
                                height: 130,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: _imageFile == null
                                        ? Image.asset(pathAsset)
                                        : Image.file(_imageFile),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20.0,
                                right: 20.0,
                                child: InkWell(
                                  onTap: () {
                                    _showPickOptionsDialog();
                                  },
                                  child: const Icon(Icons.camera_alt,
                                      color: Color(0xFF919191), size: 28.0),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        inputText(focusNode1, "Name", Icons.person, false,
                            _usernameController, TextInputType.text),
                        const SizedBox(height: 20),
                        inputText(
                            focusNode2,
                            "Phone Number",
                            Icons.phone_android,
                            false,
                            _phoneNumController,
                            TextInputType.phone),
                        const SizedBox(height: 20),
                        inputText(focusNode3, "Home Address", Icons.home, false,
                            _addressController, TextInputType.text),
                        const SizedBox(height: 20),
                        inputText(focusNode4, "Email", Icons.email, false,
                            _emailController, TextInputType.emailAddress),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: _isObscure1,
                          controller: _passwordController,
                          cursorColor: Colors.grey,
                          focusNode: focusNode5,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 15, 0, 0),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: focusNode5.hasFocus
                                  ? const Color.fromARGB(255, 9, 56, 95)
                                  : const Color(0xFF919191),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 9, 56, 95)),
                            ),
                            icon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure1
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure1 = !_isObscure1;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: _isObscure2,
                          controller: _cpasswordController,
                          cursorColor: Colors.grey,
                          focusNode: focusNode6,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 15, 0, 0),
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(
                              color: focusNode6.hasFocus
                                  ? const Color.fromARGB(255, 9, 56, 95)
                                  : const Color(0xFF919191),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 9, 56, 95)),
                            ),
                            icon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure2
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure2 = !_isObscure2;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 10,
                            color: const Color.fromARGB(255, 9, 56, 95),
                            onPressed: () {
                              _userSignUp();
                            },
                            child: const Text(
                              "Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
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

  TextField inputText(focusNode, text, icons, state, controller, keyboard) {
    return TextField(
      keyboardType: keyboard,
      obscureText: state,
      controller: controller,
      cursorColor: Colors.grey,
      focusNode: focusNode,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
          labelText: text,
          labelStyle: TextStyle(
            color: focusNode.hasFocus
                ? const Color.fromARGB(255, 9, 56, 95)
                : const Color(0xFF919191),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color.fromARGB(255, 9, 56, 95)),
          ),
          icon: Icon(icons)),
    );
  }

  void _userSignUp() {
    String _username = _usernameController.text;
    String _phoneNum = _phoneNumController.text;
    String _address = _addressController.text;
    String _email = _emailController.text;
    String _password = _passwordController.text;
    String _confirmPassword = _cpasswordController.text;
    String base64Image = base64Encode(_imageFile!.readAsBytesSync());
    bool isValid = EmailValidator.validate(_email);

    if (_username.isNotEmpty &&
        _phoneNum.isNotEmpty &&
        _address.isNotEmpty &&
        _email.isNotEmpty &&
        _password.isNotEmpty &&
        _confirmPassword.isNotEmpty) {
      if (isValid == true) {
        if (_password == _confirmPassword) {
          http.post(
              Uri.parse(
                  "https://hubbuddies.com/271513/myTutor/php/registeruser.php"),
              body: {
                "username": _username,
                "phoneNum": _phoneNum,
                "address": _address,
                "email": _email,
                "password": _password,
                "image": base64Image,
              }).then((response) {
            var data = jsonDecode(response.body);
            if (response.statusCode == 200 && data['status'] == 'success') {
              print("Success");
              _verify(context);
              return;
            } else {
              print("Failed");
              Fluttertoast.showToast(
                  msg: "Email has been used. Please try again",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0);
            }
          });
        } else {
          Fluttertoast.showToast(
              msg: "Password mismatch!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Invalid Email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please fill in your information",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  _showPickOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color.fromARGB(255, 9, 56, 95),
              ),
              title: const Text("Pick from Gallery"),
              onTap: () => {
                Navigator.of(context).pop(),
                _galleryPicker(),
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_camera,
                color: Color.fromARGB(255, 9, 56, 95),
              ),
              title: const Text("Take a Picture"),
              onTap: () => {
                Navigator.of(context).pop(),
                _cameraPicker(),
              },
            )
          ],
        ),
      ),
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      _cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Color.fromARGB(255, 9, 56, 95),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _imageFile = croppedFile;

      setState(() {});
    }
  }

  _verify(BuildContext context) async {
    // set up the buttons
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Fluttertoast.showToast(
            msg: "Sign up success!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Verfication"),
      content: const Text(
          "Please activate your account through your mailbox to sign in!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
