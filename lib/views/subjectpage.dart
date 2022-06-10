import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tutor/models/subject.dart';
import 'package:my_tutor/models/tutor.dart';

import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({Key? key}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "Loading data...";
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  var _tapPosition;
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadSubjects(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      body: subjectList.isEmpty
          ? Center(
              child: Text(
                titlecenter,
                style: (TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
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
                        return InkWell(
                          splashColor: Colors.amber,
                          onTap: () => {_loadSubjectDetails(index)},
                          child: Card(
                              child: Column(children: [
                            Flexible(
                                flex: 7,
                                child: CachedNetworkImage(
                                    imageUrl:
                                        "https://hubbuddies.com/271513/myTutor/assets/courses/" +
                                            subjectList[index]
                                                .subject_id
                                                .toString() +
                                            '.jpg',
                                    fit: BoxFit.cover,
                                    width: resWidth)),
                            const SizedBox(height: 5),
                            Flexible(
                              flex: 3,
                              child: Column(children: [
                                Text(subjectList[index].subject_name.toString(),
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center)
                              ]),
                            ),
                          ])),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                    height: 30,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if ((curpage - 1) == index) {
                            color = Colors.red;
                          } else {
                            color = Colors.black;
                          }
                          return SizedBox(
                              width: 40,
                              child: TextButton(
                                onPressed: () => {_loadSubjects(index + 1)},
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(color: color),
                                ),
                              ));
                        }))
              ],
            ),
    );
  }

  void _loadSubjects(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(
            "https://hubbuddies.com/271513/myTutor/php/load_subjects.php"),
        body: {'pageno': pageno.toString()}).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
          titlecenter = subjectList.length.toString() + " Subjects Available";
        } else {
          titlecenter = "No Subject Available";
          subjectList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Subject Available";
        subjectList.clear();
        setState(() {});
      }
    });
  }

  _loadSubjectDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Subject Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "https://hubbuddies.com/271513/myTutor/assets/courses/" +
                          subjectList[index].subject_id.toString() +
                          '.jpg',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  subjectList[index].subject_name.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Subject Description: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subjectList[index].subject_description.toString(),
                      style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text("Price: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                        "RM " +
                            double.parse(
                                    subjectList[index].subject_price.toString())
                                .toStringAsFixed(2),
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Text("Tutor: " +
                  //     productList[index].productQty.toString() +
                  //     " units"),
                  Row(
                    children: [
                      Text("Subject Sessions: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(subjectList[index].subject_sessions.toString(),
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text("Subject Rating: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(subjectList[index].subject_rating.toString(),
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ])
              ],
            )),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
