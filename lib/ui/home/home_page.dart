import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:to_do_list/ui/add_todo/add_todo_page.dart';
import 'package:to_do_list/utils/fonts.dart';
import 'package:to_do_list/utils/global_variables.dart';
import 'package:to_do_list/utils/strings.dart';
import 'package:to_do_list/ui/home/home_page_list.dart';

import '../../widgets/app_header.dart';
class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedId = 1;
@override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 30),
                child: Header(onCrossPress: pop, isCrossVisible: false,isTickVisible: false)),

            const SizedBox(
              height: 90,
            ),
            Row(children: const <Widget>[
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  height: 15,
                  thickness: 1.2,
                ),
              ),
              SizedBox(width: 40),
              Text(
                tasks,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ),
              Text(
                list,
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),

              SizedBox(width: 40),
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  height: 15,
                  thickness: 1.2,
                ),
              ),
            ]),
            const SizedBox(height: 40),
            Center(
                child: InkWell(onTap:()=>onListAdd(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Icon(Icons.add,color: Theme.of(context).primaryColor,),
                    ),
                  ),
                ),
            const SizedBox(
              height: 20,
            ),
            const Center(
                child: Text(addList,
                    style:
                    TextStyle(color: Colors.grey, fontFamily: comfortaa))),
            const SizedBox(
              height: 80,
            ),
            // ignore: prefer_const_constructors
            Expanded(
              // ignore: prefer_const_constructors
              child: Padding(
                padding:const  EdgeInsets.only(bottom: 10),
                // ignore: prefer_const_constructors
                child: SizedBox(
                  height: 300,
                    // ignore: prefer_const_constructors
                  child: HomePageList()
                ),
              ),
            ), ],
      ),
        ),
    );
  }
  void onListAdd()async {

    var isRefresh=await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: const AddToDoPage(),
            duration: const Duration(milliseconds: 500),
            inheritTheme: true,
            ctx: context
        ));
    Future.delayed(const Duration(milliseconds: 50), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });

    if (isRefresh!=null && isRefresh ) {
      setState(() {});

    }
  }
  void pop() {
    Navigator.pop(context, true);
  }
}

