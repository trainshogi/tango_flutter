import 'package:flutter/material.dart';
import 'package:tango_flutter/tangocho.dart';

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
  int _counter = 0;

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
              'クラスを選んでください',
            ),
            ElevatedButton(
              child: Text('3年A組'),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TangochoPage(),
                    )
                );
              },
            ),
            ElevatedButton(
              child: Text('3年B組'),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TangochoPage(),
                    )
                );
              },
            ),
            ElevatedButton(
              child: Text('3年C組'),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TangochoPage(),
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
