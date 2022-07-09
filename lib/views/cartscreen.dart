import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/models/cart.dart';
import 'package:my_tutor/models/subject.dart';
import 'package:my_tutor/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/views/payment.dart';

class CartScreen extends StatefulWidget {
  final User user;
  const CartScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Subject> subjectList = <Subject>[];
  List<Cart> cartList = <Cart>[];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  String search = "";
  int cart = 0;
  double totalpayable = 0.0;
  double totalamount = 0.0;
  int qty = 0;
  List<bool> values = <bool>[];
  bool overall = false;
  List<String> pricearray = <String>[];
  List<String> perunit = <String>[];

  @override
  void initState() {
    _loadCart();
    super.initState();
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
          title: const Text('Cart'),
          backgroundColor: const Color.fromARGB(255, 9, 56, 95),
          centerTitle: true,
        ),
        body: cartList.isEmpty
            ? Center(
                child: Text(
                  titlecenter,
                  style: (const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(2, 5, 2, 0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 244, 243, 238)),
                  child: Column(
                    children: [
                      Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (1 / 1.5),
                          children: List.generate(
                            cartList.length,
                            (index) {
                              return Stack(
                                children: [
                                  Card(
                                    child: Column(
                                      children: [
                                        Flexible(
                                          flex: 6,
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://hubbuddies.com/271513/myTutor/assets/courses/" +
                                                      cartList[index]
                                                          .subject_id
                                                          .toString() +
                                                      '.jpg',
                                              fit: BoxFit.cover,
                                              width: resWidth,
                                              height: screenHeight),
                                        ),
                                        const SizedBox(height: 5),
                                        Flexible(
                                          flex: 4,
                                          child: Column(
                                            children: [
                                              Text(
                                                cartList[index]
                                                    .subject_name
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 5),
                                              Text("RM " +
                                                  double.parse(cartList[index]
                                                          .subject_price
                                                          .toString())
                                                      .toStringAsFixed(2) +
                                                  "/unit"),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Flexible(
                                          flex: 3,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Column(children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        _updateCart(index, "-");
                                                      },
                                                      child: const Text("-")),
                                                  Text(cartList[index]
                                                      .cart_qty
                                                      .toString()),
                                                  TextButton(
                                                      onPressed: () {
                                                        _updateCart(index, "+");
                                                      },
                                                      child: const Text("+")),
                                                  IconButton(
                                                      onPressed: () {
                                                        _deleteitemDialog(
                                                            index);
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete))
                                                ],
                                              ),
                                            ]),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: InkWell(
                                        child: _checkboxCondition(index)),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 7,
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: overall,
                                            onChanged: (value) {
                                              setState(() {
                                                overall = value!;
                                                if (overall == true) {
                                                  totalamount = totalpayable;
                                                  print(totalamount);
                                                } else {
                                                  totalamount = 0.0;
                                                }
                                              });
                                            },
                                          ),
                                          Text(
                                            "All ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Total ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            'RM',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 9, 56, 95),
                                            ),
                                          ),
                                          Text(
                                            double.parse(totalamount.toString())
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 9, 56, 95),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Payment(
                                          user: widget.user,
                                          totalamount: totalamount),
                                    ),
                                  );
                                },
                                child: InkWell(
                                  onTap: () {
                                    _onPaynowDialog();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Color.fromARGB(255, 9, 56, 95),
                                    child: const Text(
                                      "Check Out",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _loadCart() {
    http.post(
        Uri.parse("https://hubbuddies.com/271513/myTutor/php/load_cart.php"),
        body: {
          'email': widget.user.email,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];

        if (extractdata['carts'] != null) {
          cartList = <Cart>[];
          extractdata['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));
          });
          qty = 0;
          totalpayable = 0.00;
          for (var element in cartList) {
            qty = qty + int.parse(element.cart_qty.toString());
            totalpayable =
                totalpayable + double.parse(element.pricetotal.toString());
          }
          titlecenter = qty.toString() + " Products in your cart";
          for (var i = 0; i < cartList.length; i++) {
            values.add(false);
          }
          for (var i = 0; i < cartList.length; i++) {
            pricearray.add("0");
          }
          if (overall == true) {
            totalamount = totalpayable;
          }
          setState(() {});
        }
      } else {
        //do something
        titlecenter = "Cart is Empty";
        cartList.clear();
        setState(() {});
      }
    });
  }

  void _updateCart(int index, String s) {
    if (s == "-") {
      if (int.parse(cartList[index].cart_qty.toString()) == 1) {
        _deleteitemDialog(index);
      }
    }
    http.post(
        Uri.parse("https://hubbuddies.com/271513/myTutor/php/update_cart.php"),
        body: {'cartid': cartList[index].cart_id, 'operation': s}).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print("Success");
        _loadCart();
      } else {
        print('Failed');
      }
    });
  }

  void _deleteItem(int index) {
    http.post(
        Uri.parse("https://hubbuddies.com/271513/myTutor/php/delete_cart.php"),
        body: {
          'email': widget.user.email,
          'cartid': cartList[index].cart_id
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print("Success");
        _loadCart();
      } else {
        print("Failed");
      }
    });
  }

  void _deleteitemDialog(index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            insetPadding: EdgeInsets.all(65),
            buttonPadding: EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Do you want to remove this product?',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _deleteItem(index);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 98, 144, 195),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0)),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10.0)),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "No",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color.fromARGB(255, 98, 144, 195),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  _checkboxCondition(int index) {
    if (overall == true) {
      return Checkbox(
        value: overall,
        onChanged: (value) {
          setState(() {
            overall = value!;
            if (overall == false) {
              totalamount = 0.0;
            }
          });
        },
      );
    } else if (overall == false) {
      return Checkbox(
        value: values[index],
        onChanged: (value) {
          setState(() {
            values[index] = value!;
            if (values[index] == true) {
              var price = cartList[index].subject_price;
              pricearray[index] = price!;
              print(pricearray);
            } else {
              pricearray[index] = "0";
              print(pricearray);
            }
          });
        },
      );
    }
  }

  void _onPaynowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Pay Now",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => Payment(
                            user: widget.user, totalamount: totalamount)));
                _loadCart();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
