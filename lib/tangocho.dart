import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tango_flutter/tango_card.dart';
import 'dart:convert';
import 'dart:math';


class TangochoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("単語帳"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Tangocho()
            ]
        ),
      )
    );
  }
}

class Tangocho extends StatefulWidget {
  @override
  TangochoState createState() => new TangochoState();
}

class TangochoState extends State<Tangocho> {
  int currentListIndex = 0;
  bool currentCardIsFront = false;
  DateTime updatedTime = DateTime.now();
  String visibleText = "";
  List<TangoCard> tangoCardList = [];

  void reverseCard() {
    if (currentCardIsFront) {
      setState(() {
        visibleText = tangoCardList[currentListIndex].back;
        currentCardIsFront = false;
      });
    }
    else {
      setState(() {
        visibleText = tangoCardList[currentListIndex].front;
        currentCardIsFront = true;
      });
    }
  }


  void nextCard() {
    currentListIndex = currentListIndex + 1;
    if (currentListIndex >= tangoCardList.length) {
      currentListIndex = 0;
    }
    setState(() {
      visibleText = tangoCardList[currentListIndex].front;
      currentCardIsFront = true;
    });
  }

  Future<void> _getCSV() async {
    var header = {"Content-Type": "application/json; charset=utf8"};
    final response = await http.get(Uri.parse('https://vrpbo3xlwf.execute-api.us-east-1.amazonaws.com/initial'), headers: header);
    if (response.statusCode == 200) {
      List<dynamic> responseJson = jsonDecode(response.body)["result"];
      responseJson.forEach((card) => tangoCardList.add(new TangoCard.fromJson(card)));
      // as debug
      // TangoCard tangoCard = TangoCard("apple\n\nマック", "りんご\n\n\nりんご", "hoge");
      // TangoCard tangoCard2 = TangoCard("banana\n\nばなな", "ばなな\n\n\nフィリピン", "hoge");
      // TangoCard tangoCard3 = TangoCard("car\n\nくるま", "くるま\n\n\nたいや", "hoge");
      // TangoCardsDTO tangoCardsDTO = TangoCardsDTO([tangoCard, tangoCard2, tangoCard3]);
      // tangoCardList = tangoCardsDTO.tangoCardList;
      reverseCard();
    } else {
      throw Exception('Fail to search repository');
    }
  }

  @override
  void initState() {
    _getCSV();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double squareLength = min(size.width, size.height) - 10;
    return buildColoredCard(squareLength);
  }

  Widget buildColoredCard(double squareLength) => Card(
    shadowColor: Colors.red,
    elevation: 8,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    child: InkWell(
      onTap: () {
        reverseCard();
      },
      onDoubleTap: () {
        nextCard();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.red],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: squareLength,
        height: squareLength,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                visibleText,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ),
    )
  );
}