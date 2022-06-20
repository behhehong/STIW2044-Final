import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:my_tutor/views/settings.dart';

import '../models/user.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            backgroundColor: const Color.fromARGB(255, 9, 56, 95),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(user: widget.user),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
              )
            ],
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4.0,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://hubbuddies.com/271513/myTutor/assets/profilepic/" +
                                            widget.user.userId.toString() +
                                            '.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.user.username.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.email),
                              SizedBox(width: 10),
                              Text(
                                "Email",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 34.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.user.email.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Divider(
                            color: Colors.grey,
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.phone_android),
                              const SizedBox(width: 10),
                              Text(
                                "Mobile",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 34.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.user.phoneNum.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Divider(
                            color: Colors.grey,
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.home),
                              const SizedBox(width: 5),
                              Text(
                                "Address",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 29.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.user.address.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Divider(
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ))),
    );
  }
}
