import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:to_do_list/database/collection.dart';
import 'package:to_do_list/database/db_helper.dart';
import 'package:to_do_list/database/task.dart';
import 'package:to_do_list/ui/task_detail/task_detail_page.dart';
import 'package:to_do_list/utils/fonts.dart';
import 'package:to_do_list/utils/global_variables.dart';
import 'package:to_do_list/utils/text_styles.dart';

class HomePageList extends StatefulWidget {
  const HomePageList({Key? key}) : super(key: key);

  @override
  State<HomePageList> createState() => _HomePageListState();
}

class _HomePageListState extends State<HomePageList> {
  int? collectionId = 0;

@override
  void initState() {
  Future.delayed(const Duration(milliseconds: 50), () {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Collection>>(
      future: DatabaseHelper.instance.getCollectionList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),

          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final collection = snapshot.data![index];
              collectionId = collection.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 20),
                child: InkWell(
                  onTap: ()=>onTaskList(collection.id!, collection.name ,collection.color),

                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(collection.color)
                          ),
                      width: 170,
                      padding: const EdgeInsets.only(
                          top: 50, bottom: 8.0, right: 20, left: 20),
                      child: Column(
                        children: [
                          Text(collection.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: comfortaa,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.white,
                            height: 1,
                          ),
                          Expanded(
                            child:FutureBuilder<List<Task>>(
                              future: DatabaseHelper.instance.taskQuery(collection.id),

                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.length < 4
                                        ? snapshot.data!.length
                                        : 4,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final task = snapshot.data![index];
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.transparent),
                                        width: 150,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "• ",
                                                  textScaleFactor: 1.5,
                                                  style: homeTaskListStyle,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    task.name,
                                                    style: task.isCompleted == 1
                                                        ?homeListCompletedTaskStyle
                                                        :homeTaskListStyle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )),
                ),
              );
            },
          ),
        );
      },
    );
  }
void onTaskList(int collectionId,String collectionName,int collectionColor)async{
  await Navigator.push(
    context,
    PageTransition(
        type: PageTransitionType.fade,
        child:  TaskDetailPage(
          collectionColor: collectionColor,
          collectionId: collectionId,
          collectionName: collectionName,),
        duration: const Duration(milliseconds: 500),
        inheritTheme: true,
        ctx: context),
  );
  Future.delayed(const Duration(milliseconds: 50), () {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  });

  setState(() {});
}
}

