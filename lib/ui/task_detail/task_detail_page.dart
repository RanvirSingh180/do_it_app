import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:to_do_list/database/task.dart';
import 'package:to_do_list/utils/colors.dart';
import 'package:to_do_list/utils/fonts.dart';
import 'package:to_do_list/utils/strings.dart';
import 'package:to_do_list/database/db_helper.dart';
import 'package:to_do_list/widgets/color_picker_dialog.dart';
import 'package:to_do_list/ui/task_detail/task_list.dart';
import '../../widgets/app_header.dart';
import 'package:to_do_list/widgets/alert_dialog.dart';




// ignore: must_be_immutable
class TaskDetailPage extends StatefulWidget {
 final String collectionName ;
  final int collectionId ;
  late int collectionColor;

   TaskDetailPage({Key? key, required this.collectionId, required this.collectionName,required this.collectionColor})
      : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  bool isEditVisible = false;
  bool value = false;
  int boxSelected = 0;
  bool addValidate = false;
  TextEditingController addTextController = TextEditingController();
  TextEditingController editCollectionTextController = TextEditingController();
  late double taskPercentCompleted = 0;
  int? tasks;
  int? completedTask;
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    editCollectionTextController.text = widget.collectionName;
    progress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20),
                          child: Header(
                            onCrossPress: pop,
                            isCrossVisible: !isEditVisible,
                            isTickVisible: isEditVisible,
                            onTickPress: () {
                              setState(() {
                                DatabaseHelper.instance.collectionColorUpdate(widget.collectionId, defaultCollectionColor.value);
                                isEditVisible = false;
                                widget.collectionColor =defaultCollectionColor.value;
                              });
                            },
                          )),
                      const SizedBox(
                        height: 70,
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 45,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                                  editCollectionTextController.text,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: comfortaa),
                                )),
                            InkWell(
                                child: Visibility(
                                  visible: isEditVisible,
                                  child:  Icon(
                                    Icons.mode_edit_outlined,
                                    color:Theme.of(context).primaryColorLight,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialogBox(
                                              positiveButtonText: edit,
                                              negativeButtonText: cancel,
                                              isValidateStatus: false,
                                              title: editCollectionTitle,
                                              isTextFieldRequired: true,
                                              isValidateRequired: true,
                                              controller:
                                              editCollectionTextController,
                                              positiveCallback: () {
                                                if (editCollectionTextController
                                                    .text
                                                    .trim()
                                                    .isEmpty) {
                                                  return;
                                                }
                                                DatabaseHelper.instance.collectionUpdate(
                                                    widget.collectionId,
                                                    editCollectionTextController
                                                        .text
                                                        .trim()
                                                        .toString());
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              }));
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialogBox(
                                            positiveButtonText:
                                            yes,
                                            negativeButtonText:
                                            no,
                                            isValidateStatus: false,
                                            title: deleteCollectionTitle,
                                            isTextFieldRequired: false,
                                            isValidateRequired: false,
                                            positiveCallback: () {
                                              setState(() {
                                                DatabaseHelper.instance.taskCollectionDelete(
                                                    widget.collectionId);
                                                DatabaseHelper.instance.collectionDelete(
                                                    widget.collectionId);
                                              });
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            }));
                              },
                              child: Visibility(
                                visible: isEditVisible,
                                child:  Icon(
                                  Icons.delete_outline_outlined,
                                  color:Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            CircularPercentIndicator(
                              radius: 10,
                              backgroundColor: Colors.grey.shade500,
                              progressColor: Colors.redAccent,
                              percent: tasks == 0 ? 0 : taskPercentCompleted,
                              lineWidth: 3,
                              animation: true,
                              animateFromLastPercent: true,
                              animationDuration: 500,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // AnimatedIcon(icon: AnimatedIcons., progress:),
                            Text(
                              "Completed $completedTask out of $tasks",
                              style: TextStyle(
                                  fontFamily: comfortaa,
                                  color: Colors.grey.shade500),
                            ),
                            const Spacer(),
                            Visibility(
                                visible: isEditVisible,
                                child: InkWell(
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
                                    )))
                          ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        const SizedBox(
                          width: 45,
                        ),
                        Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey.shade400,
                            ))
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: FutureBuilder<List<Task>>(
                              future: DatabaseHelper.instance.taskQuery(widget.collectionId),
                              builder: (context, snapshot) {
                                return TaskList(
                                    isEdit: isEditVisible ,
                                    cId: widget.collectionId,
                                    cName: widget.collectionName,
                                    progress: progress);
                              }))
                    ]))),
        floatingActionButton: SpeedDial(
            elevation: 10,
            overlayOpacity: .3,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            activeIcon: Icons.close,
            icon: Icons.menu,
            spacing: 10,
            children: [
              SpeedDialChild(
                onTap: () {
                  onAdd();
                },
                child: const Icon(
                  Icons.add,
                ),
                elevation: 10,
              ),
              SpeedDialChild(
                  onTap: () {
                    setState(() {
                      defaultCollectionColor=Color(widget.collectionColor);
                      isEditVisible = true;
                    });
                  },
                  child: const Icon(Icons.mode_edit_outline),
                  elevation: 10),
            ]));
  }

  void pop() {
    Navigator.pop(context);
  }

  void onAdd () {
    showDialog<String?>(
        context: context,
        builder: (context) => AlertDialogBox(
            controller: addTextController,
            isValidateStatus: addValidate,
            positiveButtonText: add,
            negativeButtonText: cancel,
            title: addDialogTitle,
            isValidateRequired: true,
            isTextFieldRequired: true,
            positiveCallback: () {
              setState(() {
                if (addTextController.text.trim().isEmpty) {
                  return;
                }
                DatabaseHelper.instance.taskInsert(Task(
                    date: timestamp,
                    name: addTextController.text.trim().toString(),
                    collectionId: widget.collectionId,
                    isCompleted: 0));
                addTextController.text = '';
                progress();
                Navigator.of(context).pop();
              });
            }));
  }

  void progress() async {
    tasks = await DatabaseHelper.instance.countTask(widget.collectionId);
    completedTask = await DatabaseHelper.instance.countCompletedTask(widget.collectionId);
    double? completed = (completedTask! / tasks!);
    setState(() {
      taskPercentCompleted = completed;
      completedTask;
      tasks;
    });
  }

  openColorDialog() => showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(colorUpdate: () {
        setState(() {
          defaultCollectionColor;
        });
      }));
}