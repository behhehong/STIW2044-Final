// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/models/subject.dart';

import 'package:http/http.dart' as http;

class SubjectPage extends StatefulWidget {
  const SubjectPage({Key? key}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  void initState() {
    super.initState();
    _loadSubjects(1, search);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Subjects'),
          backgroundColor: const Color.fromARGB(255, 9, 56, 95),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                _loadSearchDialog();
              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: subjectList.isEmpty
            ? Center(
                child: Text(
                  titlecenter,
                  style: (const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 244, 243, 238)),
                child: Column(
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
                              onTap: () => {
                                _loadSubjectDetails(index),
                              },
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
                                        width: resWidth,
                                        height: screenHeight)),
                                const SizedBox(height: 5),
                                Flexible(
                                  flex: 3,
                                  child: Column(children: [
                                    Text(
                                        subjectList[index]
                                            .subject_name
                                            .toString(),
                                        style: const TextStyle(fontSize: 15),
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
                                color = const Color.fromARGB(255, 219, 80, 74);
                              } else {
                                color = Colors.black;
                              }
                              return SizedBox(
                                  width: 40,
                                  child: TextButton(
                                    onPressed: () =>
                                        {_loadSubjects(index + 1, search)},
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(color: color),
                                    ),
                                  ));
                            }))
                  ],
                ),
              ),
      ),
    );
  }

  void _loadSubjects(int pageno, String search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(
            "https://hubbuddies.com/271513/myTutor/php/load_subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': search,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
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
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Subject Description: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subjectList[index].subject_description.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 98, 144, 195))),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Price: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                        "RM " +
                            double.parse(
                                    subjectList[index].subject_price.toString())
                                .toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 98, 144, 195)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Subject Sessions: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(subjectList[index].subject_sessions.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(255, 98, 144, 195))),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Subject Rating: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(subjectList[index].subject_rating.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 98, 144, 195))),
                    ],
                  ),
                ])
              ],
            )),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(color: Color.fromARGB(255, 98, 144, 195)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            title: const Text(
              "Search",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter the name of subject',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: searchController.clear,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadSubjects(1, search);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 9, 56, 95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text("Search",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
