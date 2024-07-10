import 'package:flutter/material.dart';
import 'package:mission_app/methods/colors.dart';

import 'package:mission_app/methods/provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CreateScreen extends StatefulWidget {
  Map? itemData;
  CreateScreen({super.key, this.itemData});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  TextEditingController titleConroller = TextEditingController();
  TextEditingController descriptionConroller = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    final data = widget.itemData;
    if (widget.itemData != null) {
      isEdit = true;
      titleConroller.text = data!['title'];
      descriptionConroller.text = data['description'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: kOrangeColor)),
        color: kBlackColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Task title', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              TextField(
                controller: titleConroller,
                decoration: const InputDecoration(
                  hintText: "Write Title here... ",
                  hintStyle: TextStyle(color: kGrayColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kOrangeColor),
                  ),
                  border: OutlineInputBorder(),
                  fillColor: kBlack2Color,
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),
              const Text('Task Description', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              TextField(
                maxLines: 6,
                controller: descriptionConroller,
                decoration: const InputDecoration(
                  hintText: "Write Description here... ",
                  hintStyle: TextStyle(color: kGrayColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kOrangeColor),
                  ),
                  border: OutlineInputBorder(),
                  fillColor: kBlack2Color,
                  filled: true,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: kOrangeColor,
                      ),
                      onPressed: () {
                        isEdit
                            ? Provider.of<Services>(context, listen: false)
                                .putDataProvider(
                                    id1: widget.itemData!["_id"],
                                    title: titleConroller.text,
                                    desc: descriptionConroller.text,
                                    context: context)
                            : Provider.of<Services>(context, listen: false)
                                .postDataProvider(
                                    title: titleConroller.text,
                                    desc: descriptionConroller.text,
                                    context: context);
                      },
                      child: Text(
                        isEdit ? 'Update Task' : 'Create Task',
                        style: const TextStyle(
                            color: kWhiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
