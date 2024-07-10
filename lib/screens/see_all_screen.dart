import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mission_app/methods/colors.dart';

import 'package:mission_app/methods/provider.dart';
import 'package:mission_app/screens/create_screen.dart';
import 'package:provider/provider.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({super.key});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  @override
  void initState() {
    Provider.of<Services>(context, listen: false)
        .getDataProvider(allList: true);
    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    List myData = Provider.of<Services>(context).myData;
    return Scaffold(
        key: _key,
        backgroundColor: kBlackColor,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: kBlackColor,
          foregroundColor: Colors.white,
          title: const Text(
            "All Task's",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
                color: Colors.white,
                onPressed: () {
                  Provider.of<Services>(context, listen: false)
                      .getDataProvider();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const SizedBox(height: 20),
            Text('You Have ${myData.length} Task '),
            Expanded(
              child: ListView.builder(
                  itemCount: myData.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = myData.reversed.toList()[index];
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: kBlack2Color,
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        data['title'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            decoration: data['is_completed']
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(data['description'])),
                                    ],
                                  ),
                                  Row(children: [
                                    Text(
                                      DateFormat.yMMMEd()
                                          .format(DateTime.parse(
                                              data['created_at']))
                                          .toString(),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        _key.currentState!.showBottomSheet(
                                          (context) => CreateScreen(
                                            itemData: data,
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: kGreenColor,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CupertinoAlertDialog(
                                                    title: const Text(
                                                        "Delete Task"),
                                                    content: const Text(
                                                      "Are you sure you want to delete this task?",
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        onPressed: () {
                                                          Provider.of<Services>(
                                                                  context,
                                                                  listen: false)
                                                              .delByIdProvider(
                                                                  data['_id']);
                                                          Navigator.of(context)
                                                              .pop();
                                                          Provider.of<Services>(
                                                                  context,
                                                                  listen: false)
                                                              .getDataProvider();
                                                        },
                                                        child: const Text("OK"),
                                                      ),
                                                      CupertinoDialogAction(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            "Cancel"),
                                                      ),
                                                    ]);
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: kRedColor,
                                        )),
                                    Checkbox(
                                      shape: const CircleBorder(),
                                      side:
                                          const BorderSide(color: kWhiteColor),
                                      activeColor: kOrangeColor,
                                      value: data['is_completed'],
                                      onChanged: (val) {
                                        Provider.of<Services>(context,
                                                listen: false)
                                            .checkBoxProvider(
                                                val!,
                                                data['_id'],
                                                data['title'],
                                                data['description']);
                                        Provider.of<Services>(context,
                                                listen: false)
                                            .getDataProvider();
                                      },
                                    )
                                  ])
                                ])));
                  }),
            )
          ]),
        ));
  }
}
