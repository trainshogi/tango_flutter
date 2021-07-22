import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Center(
          child: Setting()
        )
    );
  }
}

class Setting extends StatefulWidget {
  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  List<DropdownMenuItem<String>> _items = [];
  String _selectItem = "ffffff";

  @override
  void initState() {
    super.initState();
    getCsvData("assets/settings/colors.csv").then(
      (value) =>
          getPref("color").then((color) => setState((){
            _items = value;
            if (color.isNotEmpty) {
              _selectItem = color;
            } else {
              _selectItem = _items[0].value!;
            }
          }))
    );
  }

  Future<List<DropdownMenuItem<String>>> getCsvData(String path) async {
    List<DropdownMenuItem<String>> list = [];
    String csv = await rootBundle.loadString(path);
    for (String line in csv.split("\n")) {
      List rows = line.split(',');
      list.add(DropdownMenuItem(
        value: rows[0],
        child: Text(rows[1]),
      ));
    }
    return list;
  }

  Future<String> getPref(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  Future<void> setPref(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("単語帳のカード背景色"),
          DropdownButton(
            items: _items,
            value: _selectItem,
            onChanged: (value) => {
              setState(() {
                _selectItem = value as String;
                setPref("color", value);
              }),
            },
          ),
        ]
    );
  }
}
