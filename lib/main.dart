import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tango_flutter/setting.dart';
import 'package:tango_flutter/tangocho.dart';
import 'package:http/http.dart' as http;

final String TANGOCHO_LAMBDA_URL = 'https://o8mrnceuve.execute-api.ap-northeast-1.amazonaws.com/default/get_tangocho_s3_filename_list';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'VLGothic'
      ),
      home: MyHomePage(title: '単語帳'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Widget> tangochoList = [];

  Future<void> getList() async {
    var header = {"Content-Type": "application/json; charset=utf8"};
    final response = await http.get(Uri.parse(TANGOCHO_LAMBDA_URL), headers: header);
    if (response.statusCode == 200) {
      List<dynamic> responseList = jsonDecode(response.body);
      setState(() {
        for (String tangocho in responseList) {
          tangochoList.add(new ElevatedButton(
            child: Text(tangocho),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TangochoPage(tangocho),
                  )
              );
            },
          ));
        }
      });
    } else {
      throw Exception('Fail to search repository');
    }
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '単語セットを選んでください',
            ),
            Container(
              height: 200,
              child: Scrollbar(
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: tangochoList
                  )
                )
              )
            ),
            ElevatedButton(
              child: Text('設定画面'),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage(),
                    )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
