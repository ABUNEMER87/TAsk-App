import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mission_app/methods/colors.dart';
import 'package:mission_app/methods/provider.dart';
import 'package:mission_app/screens/create_screen.dart';
import 'package:mission_app/screens/see_all_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    Provider.of<Services>(context, listen: false).getDataProvider();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    List myData = Provider.of<Services>(context).myData;
    return Scaffold(
      key: _key,
      backgroundColor: kBlackColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kOrangeColor,
        onPressed: () {
          _key.currentState!.showBottomSheet((context) => CreateScreen());
        },
        child: const Icon(
          Icons.add,
          color: kWhiteColor,
        ),
      ),
      appBar: AppBar(
        backgroundColor: kBlackColor,
        surfaceTintColor: kBlackColor,
        foregroundColor: kWhiteColor,
        title: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                'Hi there',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                'ABUNEMER87',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        color: kOrangeColor,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text(
                      DateFormat.yMMMMEEEEd().format(DateTime.now()),
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: IconButton(
                      style: IconButton.styleFrom(
                          backgroundColor: kBlack2Color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      color: kWhiteColor,
                      onPressed: () {
                        Provider.of<Services>(context, listen: false)
                            .getDataProvider();
                      },
                      icon: const Icon(Icons.refresh)),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text(
                  'Today Task...!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        color: kBlack2Color,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text("${myData.length}"),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: kBlack2Color,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                          fontSize: 14, decoration: TextDecoration.underline),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SeeAllScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: myData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = myData.reversed.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: kBlack2Color,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data['title'],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: kWhiteColor,
                                    decoration: data['is_completed']
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                data['description'],
                                style: const TextStyle(color: kGrayColor),
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                DateFormat.yMMMEd()
                                    .format(DateTime.parse(data['created_at']))
                                    .toString(),
                                style: const TextStyle(color: kGrayColor),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  _key.currentState!.showBottomSheet(
                                      (context) => CreateScreen(
                                            itemData: data,
                                          ));
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
                                        title: const Text("Delete Task"),
                                        content: const Text(
                                          "Are you sure you want to delete this task?",
                                          textAlign: TextAlign.start,
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            onPressed: () {
                                              Provider.of<Services>(context,
                                                      listen: false)
                                                  .delByIdProvider(data['_id']);
                                              Navigator.of(context).pop();
                                              Provider.of<Services>(context,
                                                      listen: false)
                                                  .getDataProvider();
                                            },
                                            child: const Text("OK"),
                                          ),
                                          CupertinoDialogAction(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: kRedColor,
                                ),
                              ),
                              Checkbox(
                                shape: const CircleBorder(),
                                side: const BorderSide(color: kWhiteColor),
                                activeColor: kOrangeColor,
                                value: data['is_completed'],
                                onChanged: (val) {
                                  Provider.of<Services>(context, listen: false)
                                      .checkBoxProvider(val!, data['_id'],
                                          data['title'], data['description']);
                                  Provider.of<Services>(context, listen: false)
                                      .getDataProvider();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
