import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/models/subject.dart';

import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Subjects extends StatefulWidget {
  final User user;
  const Subjects({Key? key, required this.user}) : super(key: key);

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  List<Subject> subjectList = <Subject>[];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: subjectList.isEmpty
              ? Container(
                  child: Text("Hello World"),
                )
              : Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(
                          subjectList.length,
                          (index) {
                            return Card(
                                child: Column(children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                    imageUrl:
                                        "https://hubbuddies.com/271513/myTutor/assets/courses/" +
                                            subjectList[index]
                                                .subjectId
                                                .toString() +
                                            '.png'),
                              ),
                              Flexible(
                                flex: 4,
                                child: Column(children: [
                                  Text(subjectList[index].subjectName.toString())
                                ]),
                              ),
                            ]));
                          },
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  void _loadSubjects() {
    http.post(
        Uri.parse(
            "https://hubbuddies.com/271513/myTutor/php/load_subjects.php"),
        body: {}).then((response) {
      print(response.body); 
      // print(response.statusCode);
      

      var data = jsonDecode(response.body);

      print(response.statusCode);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
        }
        else{
          print('no data');
        }
      }
    });
  }
}
