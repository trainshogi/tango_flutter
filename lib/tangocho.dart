import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:http/http.dart' as http;
import 'package:tango_flutter/tango_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:tango_flutter/text_span_info.dart';

final String TANGOCHO_LAMBDA_URL = 'https://o8mrnceuve.execute-api.ap-northeast-1.amazonaws.com/default/get_tangocho_s3_filename?filename=';

class TangochoPage extends StatelessWidget {
  TangochoPage(this.filename);
  String filename;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: SafeArea(child: Tangocho(filename)),
      )
    );
  }
}

class Tangocho extends StatefulWidget {
  Tangocho(this.filename);
  String filename;

  @override
  TangochoState createState() => new TangochoState(filename);
}

class TangochoState extends State<Tangocho> {
  TangochoState(this.filename);
  String filename;

  // for screen lock
  bool rotateLock = false;
  static const Map<bool, IconData> buttonIconData = {
    false: Icons.screen_lock_rotation, true: Icons.screen_rotation};

  // for tangocho
  int currentListIndex = 0;
  bool currentCardIsFront = false;
  DateTime updatedTime = DateTime.now();
  List<TextSpan> visibleTextSpan = [];
  List<TangoCard> tangoCardList = [];
  Color cardBackGroundColor = Colors.red;
  int fontSize = 12;

  // for text coloring
  final defaultTextStyle = TextStyle(color: Colors.white, fontFamily: "VLGothic");
  final whiteTextStyle = TextStyle(color: Colors.white, fontFamily: "VLGothic");
  final yellowTextStyle = TextStyle(color: Colors.yellowAccent, fontFamily: "VLGothic");
  final greenTextStyle = TextStyle(color: Color.fromRGBO(0, 255, 60, 1), fontFamily: "VLGothic");
  final redTextStyle = TextStyle(color: Color.fromRGBO(255, 153, 255, 1), fontFamily: "VLGothic");
  final blackTextStyle = TextStyle(color: Colors.black, fontFamily: "VLGothic");
  
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
      case 'red':
        return redTextStyle;
      case 'black':
        return blackTextStyle;
      default:
        return defaultTextStyle;
    }
  }

  void reSetVisibleTextSpan() {
    if (tangoCardList.isNotEmpty) {
      List<TextSpanInfo> targetList = [];
      if (currentCardIsFront) {
        targetList = tangoCardList[currentListIndex].front;
      }
      else {
        targetList = tangoCardList[currentListIndex].back;
      }
      setState(() {
        visibleTextSpan = [];
        for (TextSpanInfo textSpanInfo in targetList) {
          visibleTextSpan.add(TextSpan(
              text: textSpanInfo.text,
              style: color2TextStyle(textSpanInfo.color)
          ));
        }
      });
    }
  }

  void reverseCard() {
    if (currentCardIsFront) {
      currentCardIsFront = false;
    }
    else {
      currentCardIsFront = true;
    }
    reSetVisibleTextSpan();
  }

  void nextCard() {
    currentListIndex = currentListIndex + 1;
    if (currentListIndex >= tangoCardList.length) {
      currentListIndex = 0;
    }
    currentCardIsFront = true;
    reSetVisibleTextSpan();
  }

  Future<void> getJSON() async {
    var header = {"Content-Type": "application/json; charset=utf8"};
    final response = await http.get(Uri.parse(TANGOCHO_LAMBDA_URL+filename), headers: header);
    if (response.statusCode == 200) {
      List<dynamic> responseJson = jsonDecode(response.body)["result"];
      responseJson.forEach((card) => tangoCardList.add(new TangoCard.fromJson(card)));
      reverseCard();
    } else {
      throw Exception('Fail to search repository');
    }
  }

  @override
  void initState() {
    getJSON();
    getPref("color").then((value) => setState((){
      cardBackGroundColor = Color(int.parse("FF"+value, radix: 16));
    }));
    getPref('size').then((value) => setState((){
      fontSize = int.parse(value);
    }));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    unfreezeOrientation();
  }

  @override
  Widget build(BuildContext context) {
    if (visibleTextSpan.isEmpty) {
      visibleTextSpan.add(TextSpan(
          text: "????????????",
          style: color2TextStyle('default')
      ));
    }
    return OrientationBuilder(
      builder: (context, orientation) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: buildColoredCard()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  whiteIconButtonWithInk(backButton(), Colors.black),
                  whiteIconButtonWithInk(lockRotateButton(), Colors.green),
                  whiteIconButtonWithInk(cardShuffleButton(), Colors.blue),
                  whiteIconButtonWithInk(cardSortButton(), Colors.red),
                  whiteIconButtonWithInk(cardReverseButton(), Colors.orange),
                  Text((currentListIndex+1).toString() + "/" + (tangoCardList.length).toString())
                ],
              ),
            ]
        );
      },
    );
  }

  Widget whiteIconButtonWithInk(Widget widget, Color bgColor) => Ink(
      decoration: ShapeDecoration(
        color: bgColor,
        shape: CircleBorder(),
      ),
      child: widget
  );

  Widget backButton() => IconButton(
    icon: Icon(
      Icons.arrow_back,
      color: Colors.white,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget lockRotateButton() => IconButton(
    icon: Icon(
      buttonIconData[rotateLock],
      color: Colors.white,
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
  );

  Widget cardShuffleButton() => IconButton(
    icon: Icon(
      Icons.shuffle,
      color: Colors.white,
    ),
    onPressed: () {
      setState(() {
        tangoCardList.shuffle();
        reSetVisibleTextSpan();
      });
    },
  );

  Widget cardSortButton() => IconButton(
    icon: Icon(
      Icons.sort,
      color: Colors.white,
    ),
    onPressed: () {
      setState(() {
        tangoCardList.sort((a,b) => a.cardID.compareTo(b.cardID));
        reSetVisibleTextSpan();
      });
    },
  );

  Widget cardReverseButton() => IconButton(
    icon: Icon(
      Icons.settings_backup_restore_rounded,
      color: Colors.white,
    ),
    onPressed: () {
      setState(() {
        tangoCardList = new List.from(tangoCardList.reversed);
        reSetVisibleTextSpan();
      });
    },
  );

  Widget buildColoredCard() => Card(
    shadowColor: cardBackGroundColor,
    elevation: 8,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    child: GestureDetector(
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
        padding: EdgeInsets.all(16),
        child: Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: RichText(text:
            TextSpan(children: visibleTextSpan, style: TextStyle(fontSize: fontSize.toDouble()))),
          )
        )
      )
    ),
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