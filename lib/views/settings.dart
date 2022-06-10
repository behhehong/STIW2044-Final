import 'package:flutter/material.dart';
import 'package:my_tutor/models/user.dart';
import 'package:my_tutor/views/changePass.dart';
import 'package:my_tutor/views/loginscreen.dart';

class Settings extends StatefulWidget {
  final User user;
  const Settings({Key? key, required this.user}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 9, 56, 95),
          elevation: 0,
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 9, 56, 95)),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(children: [
                          Icon(Icons.lock),
                          const SizedBox(width: 10),
                          Text(
                            "Change Password",
                            style: TextStyle(fontSize: 15),
                          )
                        ]),
                      )),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePass(user: widget.user),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(children: [
                          Icon(Icons.logout),
                          SizedBox(width: 10),
                          Text(
                            "Log Out",
                            style: TextStyle(fontSize: 15),
                          )
                        ]),
                      )),
                  onTap: () {
                    logOut(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  logOut(BuildContext context) async {
    // set up the buttons
    Widget continueButton = TextButton(
      child: const Text("Confirm"),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        continueButton,
        cancelButton,
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
