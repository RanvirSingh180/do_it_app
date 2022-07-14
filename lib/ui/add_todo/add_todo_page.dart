import 'dart:core';
import 'package:flutter/material.dart';
import 'package:to_do_list/database/collection.dart';
import 'package:to_do_list/database/db_helper.dart';
import 'package:to_do_list/database/task.dart';
import 'package:to_do_list/utils/colors.dart';
import 'package:to_do_list/utils/strings.dart';
import 'package:to_do_list/widgets/alert_dialog.dart';
import 'package:to_do_list/widgets/app_header.dart';
import 'package:to_do_list/utils/fonts.dart';
import 'package:to_do_list/utils/text_styles.dart';
import 'package:to_do_list/widgets/color_picker_dialog.dart';


class AddToDoPage extends StatefulWidget {
  const AddToDoPage({Key? key}) : super(key: key);

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  late TextEditingController taskController;
  TextEditingController? collectionTitleController = TextEditingController();
  String task = "";
  //variable remove direct pass
  bool isAddTaskValidate = false;
  bool isEditValidate = false;
  late StateSetter addListSet;
  late StateSetter editListSet;
  List<String> tasks = [];
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  @override
  void initState() {
    super.initState();
    taskController = TextEditingController();
  }

  @override
  void dispose() {
    taskController.dispose();
    collectionTitleController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 20),
                          child: Header(
                              onCrossPress: pop,
                              isCrossVisible: true,
                              isTickVisible: false)),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                          cursorColor: Theme.of(context).primaryColor,
                          controller: collectionTitleController,
                          maxLength: 20,
                          decoration: InputDecoration(
                              hintText: collectionTitle,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              contentPadding: const EdgeInsets.only(left: 10)),
                          style: addListTitleStyle),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(colorPickerText,
                                    style: TextStyle(
                                        fontFamily: comfortaa,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                InkWell(
                                    onTap: () {
                                      openColorDialog();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: defaultCollectionColor,
                                      ),
                                      width: 60,
                                      height: 30,
                                    ))
                              ])),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              tasks[index],
                                              style: TextStyle(
                                                  fontFamily: comfortaa,
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              onTap: () => onEdit(index),
                                              child: Icon(
                                                Icons.mode_edit_outlined,
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  tasks.removeAt(index);
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete_outline_outlined,
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                              ),
                                            )
                                          ])));
                            }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        InkWell(
                            onTap:()=>onSubmit(),
                            child: Container(
                                height: 50,
                                width: 250,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor)),
                                child: Center(
                                    child: Text(submit,
                                        style:
                                            submitTextStyle)))),
                        const Spacer(),
                        InkWell(
                            onTap: () async {
                              taskController.clear();
                              final task = await openDialog();
                              if (task == null || task.isEmpty) return;
                              setState(() {
                                this.task = task;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 70,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor)),
                              child: Icon(
                                Icons.add,
                                color: Theme.of(context).primaryColor,
                              ),
                            ))
                      ]),
                      const SizedBox(
                        height: 10,
                      )
                    ]))));
  }

  Future<String?> openDialog() => showDialog<String?>(
      context: context,
      builder: (context) => AlertDialogBox(
          controller: taskController,
          isValidateStatus: isAddTaskValidate,
          positiveButtonText: add,
          negativeButtonText: cancel,
          isValidateRequired: true,
          title: addDialogTitle,
          isTextFieldRequired: true,
          positiveCallback: () {
            if (taskController.text.isEmpty) {
              return;
            } else {
              Navigator.of(context).pop(taskController.text);
              tasks.add(taskController.text);
              taskController.clear();
            }
          }));

  void onEdit(int index) {
    taskController.text = tasks[index].toString();
    showDialog<String?>(
        context: context,
        builder: (context) => AlertDialogBox(
            controller: taskController,
            isValidateStatus: isEditValidate,
            positiveButtonText: edit,
            negativeButtonText: cancel,
            isValidateRequired: true,
            title: editDialogTitle,
            isTextFieldRequired: true,
            positiveCallback: () {
              setState(() {
                if (taskController.text.isEmpty) {
                  return;
                }
                tasks[index] = taskController.text;
                Navigator.of(context).pop(taskController.text);
              });
            }));
  }

  openColorDialog() => showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(colorUpdate: () {
            setState(() {
              defaultCollectionColor;
            });
          }));
void onSubmit()async {
  if (collectionTitleController!.text
      .toString()
      .trim()
      .isNotEmpty) {
  int collectingId = await DatabaseHelper.instance
      .collectionInsert(Collection(
  name: collectionTitleController!.text
      .toString()
      .trim(),
  date: timestamp,
  color: defaultCollectionColor.value));
  for (int index = 0;
  index < tasks.length;
  index++) {
  await DatabaseHelper.instance.taskInsert(Task(
  date: timestamp,
  name: tasks[index].toString().trim(),
  collectionId: collectingId,
  isCompleted: 0));
  }

  Navigator.pop(context, true);
  } else {

  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(
  content: Text(taskTitleError),
  duration: Duration(seconds: 2),
  ));
  }
  }

  void pop() {
    Navigator.pop(context, false);
  }
}
