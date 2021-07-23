import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:http/http.dart' as http;
import 'package:tango_flutter/tango_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:developer';
import 'dart:convert';
import 'dart:math';

import 'package:tango_flutter/text_span_info.dart';


class TangochoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: TangochoPageContent(),
      )
    );
  }
}

class TangochoPageContent extends StatefulWidget {
  @override
  TangochoPageContentState createState() => new TangochoPageContentState();
}

class TangochoPageContentState extends State<TangochoPageContent> {

  bool rotateLock = false;
  static const Map<bool, String> buttonString = {false: "向き固定", true: "固定解除"};

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            label: Text(buttonString[rotateLock] ?? "向き固定・解除"),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
            onPressed: () {
              Orientation orientation = MediaQuery.of(context).orientation;
              if (rotateLock) {
                unfreezeOrientation();
                setState(() {
                  rotateLock = false;
                });
              }
              else {
                freezeOrientation(orientation);
                setState(() {
                  rotateLock = true;
                });
              }
            },
          ),
          Tangocho()
        ]
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
  List<TextSpan> visibleTextSpan = [];
  List<TangoCard> tangoCardList = [];
  Color cardBackGroundColor = Colors.red;

  final defaultTextStyle = TextStyle(color: Colors.white);
  final whiteTextStyle = TextStyle(color: Colors.white);
  final yellowTextStyle = TextStyle(color: Colors.yellow);
  final greenTextStyle = TextStyle(color: Colors.green);
  
  Future<String> getPref(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  TextStyle color2TextStyle(String color) {
    switch(color) {
      case 'white':
        return whiteTextStyle;
      case 'yellow':
        return yellowTextStyle;
      case 'green':
        return greenTextStyle;
      default:
        return defaultTextStyle;
    }
  }

  void reverseCard() {
    if (currentCardIsFront) {
      setState(() {
        visibleTextSpan = [];
        for (TextSpanInfo textSpanInfo in tangoCardList[currentListIndex].back) {
          visibleTextSpan.add(TextSpan(
            text: textSpanInfo.text,
            style: color2TextStyle(textSpanInfo.color)
          ));
        }
        currentCardIsFront = false;
      });
    }
    else {
      setState(() {
        visibleTextSpan = [];
        for (TextSpanInfo textSpanInfo in tangoCardList[currentListIndex].front) {
          visibleTextSpan.add(TextSpan(
              text: textSpanInfo.text,
              style: color2TextStyle(textSpanInfo.color)
          ));
        }
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
      visibleTextSpan = [];
      for (TextSpanInfo textSpanInfo in tangoCardList[currentListIndex].front) {
        visibleTextSpan.add(TextSpan(
            text: textSpanInfo.text,
            style: color2TextStyle(textSpanInfo.color)
        ));
      }
      currentCardIsFront = true;
    });
  }

  Future<void> _getCSV() async {
    var header = {"Content-Type": "application/json; charset=utf8"};
    final response = await http.get(Uri.parse('https://vrpbo3xlwf.execute-api.us-east-1.amazonaws.com/develop'), headers: header);
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
    getPref("color")
        .then((value) =>
        setState((){
          cardBackGroundColor = Color(int.parse("FF"+value, radix: 16));
        }
        ));
    super.initState();
  }

  @override
  void dispose(){
    unfreezeOrientation().then((value) => super.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final Size size = MediaQuery.of(context).size;
        final double squareLength = min(size.width, size.height) - 120;
        return RotatedBox(
            quarterTurns: orientation == Orientation.portrait ? 0 : 1,
            child: buildColoredCard(squareLength),
          );
      },
    );
  }

  Widget buildColoredCard(double squareLength) => Card(
    shadowColor: cardBackGroundColor,
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
            colors: [cardBackGroundColor, cardBackGroundColor],
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
              RichText(text: TextSpan(children: visibleTextSpan))
            ],
          ),
        )
      ),
    )
  );
}

List<DeviceOrientation> orientation2DeviceOrientation(Orientation orientation) {
  switch(orientation) {
    case Orientation.landscape:
      return [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ];
    case Orientation.portrait:
      return [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ];
    default:
      return [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ];
  }
}

Future<void> freezeOrientation(Orientation orientation) {
  List<DeviceOrientation> deviceOrientation = orientation2DeviceOrientation(orientation);
  return SystemChrome.setPreferredOrientations(deviceOrientation);
}

Future<void> unfreezeOrientation() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}