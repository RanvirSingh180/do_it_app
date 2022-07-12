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



//ignore: must_be_immutable
class TaskDetailPage extends StatefulWidget {
  String cName = "";
  int cId = 0;

  TaskDetailPage({Key? key, required this.cId, required this.cName})
      : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  bool isEditVisible = false;
  bool value = false;
  int boxSelected = 0;
  final DatabaseHelper _instance = DatabaseHelper();
  bool addValidate = false;
  TextEditingController addTextController = TextEditingController();
  TextEditingController editCollectionTextController = TextEditingController();
  late double taskPercentCompleted = 0;
  int? tasks;
  int? completedTask;
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    editCollectionTextController.text = widget.cName;
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
                                isEditVisible = false;
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
                              widget.cName,
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
                                              positiveResponse: editText,
                                              negativeResponse: cancelText,
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
                                                _instance.collectionUpdate(
                                                    widget.cId,
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
                                            positiveResponse:
                                                yes,
                                            negativeResponse:
                                                no,
                                            isValidateStatus: false,
                                            title: deleteCollectionTitle,
                                            isTextFieldRequired: false,
                                            isValidateRequired: false,
                                            positiveCallback: () {
                                              setState(() {
                                                _instance.taskCollectionDelete(
                                                    widget.cId);
                                                _instance.collectionDelete(
                                                    widget.cId);
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
                              progressColor: Colors.red,
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
                              future: _instance.taskQuery(widget.cId),
                              builder: (context, snapshot) {
                                return TaskList(
                                  isEdit: isEditVisible ,
                                    cId: widget.cId,
                                    cName: widget.cName,
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
                  add();
                },
                child: const Icon(
                  Icons.add,
                ),
                elevation: 10,
              ),
              SpeedDialChild(
                  onTap: () {
                    setState(() {
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

  void add() {
    showDialog<String?>(
        context: context,
        builder: (context) => AlertDialogBox(
            controller: addTextController,
            isValidateStatus: addValidate,
            positiveResponse: addText,
            negativeResponse: cancelText,
            title: addDialogTitle,
            isValidateRequired: true,
            isTextFieldRequired: true,
            positiveCallback: () {
              setState(() {
                if (addTextController.text.trim().isEmpty) {
                  return;
                }
                _instance.taskInsert(Task(
                    date: timestamp,
                    name: addTextController.text.trim().toString(),
                    collectionId: widget.cId,
                    isCompleted: 0));
                addTextController.text = '';
                progress();
                Navigator.of(context).pop();
              });
            }));
  }

  void progress() async {
    tasks = await _instance.countTask(widget.cId);
    completedTask = await _instance.countCompletedTask(widget.cId);
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
            _instance.collectionColorUpdate(widget.cId, defaultCollectionColor.value);
          }));
}
