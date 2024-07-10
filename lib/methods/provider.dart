import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Services with ChangeNotifier {
  List myData = [];
// Get Data
  getDataProvider({bool allList = false}) async {
    var url = Uri.parse('https://api.nstack.in/v1/todos');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      myData = json['items'];
      final fillterToday = myData
          .where((element) =>
              DateFormat.yMMMEd()
                  .format(DateTime.parse(element['created_at'])) ==
              DateFormat.yMMMEd().format(DateTime.now()))
          .toList();
      if (allList == false) {
        myData = fillterToday;
      } else {
        myData = json['items'];
      }
      notifyListeners();
    } else {
      // Handle the error case
      // ignore: avoid_print
      print('Failed to load data');
    }
  }

  // Post Data

  postDataProvider(
      {required title, required desc, required BuildContext context}) async {
    var body = {"title": title, "description": desc, "is_completed": false};
    var url = Uri.parse('https://api.nstack.in/v1/todos');
    var response = await http.post(
      url,
      headers: {'content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Created'),
        ),
      );
      getDataProvider();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something Wrong'),
        ),
      );
    }
  }

  //Put Data (update Data)

  putDataProvider(
      {required String id1,
      required String title,
      required String desc,
      required BuildContext context}) async {
    final id = id1;
    var body = {"title": title, "description": desc, "is_completed": false};
    var url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    var response = await http.put(
      url,
      body: jsonEncode(body),
      headers: {'content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updated'),
        ),
      );
      getDataProvider();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something Wrong'),
        ),
      );
    }
  }

  //Delete Data

  delByIdProvider(String id) async {
    var url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    await http.delete(url);
  }

  //CheckBox

  checkBoxProvider(bool che, String _id, String tit, String dec) async {
    final id = _id;
    final body = {
      'is_completed': che,
      "title": tit,
      "description": dec,
    };
    var url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    // ignore: unused_local_variable
    var response = await http.put(url,
        body: jsonEncode(body), headers: {'content-Type': 'application/json'});
    //getData();
  }
}
