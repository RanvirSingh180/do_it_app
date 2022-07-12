import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/database/db_helper.dart';
import 'package:to_do_list/database/task.dart';

import 'package:to_do_list/utils/strings.dart';
import 'package:to_do_list/utils/text_styles.dart';

import '../../widgets/alert_dialog.dart';
//TODO:COLOR CHANGE ONLY ON TICK, ALL RED CHANGE TO ACCENT RED

// ignore: must_be_immutable
class TaskList extends StatefulWidget {
  String cName = "";
  int cId = 0;
  VoidCallback progress;
  bool isEdit;

  TaskList(
      {Key? key,
        required this.isEdit,
      required this.cId,
      required this.cName,
      required this.progress})
      : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final DatabaseHelper _instance = DatabaseHelper();
  TextEditingController editTextController = TextEditingController();
  bool editValidate = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
        future: _instance.taskQuery(widget.cId),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final task = snapshot.data![index];
                return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: InkWell(
                        onTap: () {
                          if (task.isCompleted == 0) {
                            _instance.taskUpdate(task, 1);
                          } else {
                            _instance.taskUpdate(task, 0);
                          }
                          widget.progress();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    checkColor: Colors.red,
                                    fillColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    side: MaterialStateBorderSide.resolveWith(
                                      (states) => BorderSide(
                                          width: 1.0,
                                          color: Colors.grey.shade400),
                                    ),
                                    value: (task.isCompleted == 1),
                                    onChanged: (value) {
                                      if (task.isCompleted == 0) {
                                        _instance.taskUpdate(task, 1);
                                      } else {
                                        _instance.taskUpdate(task, 0);
                                      }
                                      widget.progress();
                                    }),
                                Expanded(
                                    child: Text(
                                  task.name,
                                  style: task.isCompleted == 1
                                      ? updateListCompletedTaskStyle
                                      : updateListTaskStyle,
                                )),
                                Visibility(
                                    visible: widget.isEdit,
                                    child: InkWell(
                                        onTap: () => edit(task),
                                        child: Icon(
                                          Icons.mode_edit_outlined,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ))),
                                const SizedBox(
                                  width: 10,
                                ),
                                Visibility(
                                  visible: widget.isEdit,
                                  child: InkWell(
                                    onTap: () async {
                                      await _instance.taskDelete(task.id!);
                                      int? length =
                                          await _instance.countTask(widget.cId);
                                      setState(() {
                                        if (length == 0) {
                                          widget.isEdit = false;
                                        }
                                      });
                                      widget.progress();
                                    },
                                    child: Icon(
                                      Icons.delete_outline_outlined,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 50),
                                Text(
                                    DateFormat('EE, d MMM').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            task.date)),
                                    style: updateListDateStyle),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        )));
              });
        });
  }

  void edit(Task task) {
    editTextController.text = task.name;
    showDialog<String?>(
        context: context,
        builder: (context) => AlertDialogBox(
              controller: editTextController,
              isValidateStatus: editValidate,
              positiveResponse: editText,
              negativeResponse: cancelText,
              isTextFieldRequired: true,
              isValidateRequired: true,
              title: editDialogTitle,
              positiveCallback: () {
                if (editTextController.text.trim().isEmpty) {
                  return;
                }
                _instance.taskEdit(
                    task, editTextController.text.trim().toString());
                Navigator.of(context).pop();
                setState(() {});
              },
            ));
  }
}
