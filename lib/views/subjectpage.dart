import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tutor/models/subject.dart';

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
                        return Card(
                            child: Column(children: [
                          Flexible(
                            flex: 6,
                            child: CachedNetworkImage(
                                imageUrl:
                                    "https://hubbuddies.com/271513/myTutor/assets/courses/" +
                                        subjectList[index]
                                            .subject_id
                                            .toString() +
                                        '.png'),
                          ),
                          Flexible(
                            flex: 4,
                            child: Column(children: [
                              Text(subjectList[index].subject_name.toString())
                            ]),
                          ),
                        ]));
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
                            color:
                            Colors.red;
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
      print(response.statusCode);
      var jsondata = jsonDecode(response.body);

      print(jsondata);
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

  // void _loadSubjects() {
  //   http.post(
  //       Uri.parse(
  //           "https://hubbuddies.com/271513/myTutor/php/load_subjects.php"),
  //       body: {}).then((response) {
  //     print(response.body);
  //     print(response.statusCode);

  //     var data = jsonDecode(response.body);
  //     if (response.statusCode == 200 && data['status'] == 'success') {
  //       var extractdata = data['data'];
  //       if (extractdata['subjects'] != null) {
  //         // subjectList = <Subject>[];
  //         // extractdata['subjects'].forEach((v) {
  //         //   subjectList.add(Subject.fromJson(v));
  //         // });
  //       } else {
  //         print('no data');
  //       }
  //     }
  //   });
  // }
}
