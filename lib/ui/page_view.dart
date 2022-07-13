import 'package:flutter/material.dart';
import 'package:to_do_list/ui/home/home_page.dart';
import 'package:to_do_list/ui/settings/setting_page.dart';
import 'package:to_do_list/utils/colors.dart';
import 'package:to_do_list/utils/global_variables.dart';



class Pages extends StatefulWidget {
  const Pages({Key? key}) : super(key: key);

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> with WidgetsBindingObserver {
  int selectedId = 1;
  PageController controller=PageController(initialPage: 0);
  int currentPosition=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView(
            physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                onPageChanged: (index){
                  setState(() {
                    currentPosition=index;
                    selectedId=index+1;
                  });
                },
                children: const [
                  HomePage(),
                  SettingPage()
                ],
              ),
            ),
            Column(
              children: [
              const  DividerLine(),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.animateToPage(0, duration:const Duration(milliseconds: 500), curve: Curves.decelerate);
                            setState(() {
                              Future.delayed(const Duration(milliseconds: 50), () {
                                scrollController.jumpTo(scrollController.position.maxScrollExtent);
                              });

                              selectedId = 1;
                            });
                          },
                          child: ColoredBox(
                              color: selectedId == 1
                                  ? bodySelected
                                  : bodyUnSelected,
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 15),
                                child: Icon(Icons.home_filled,
                                    color: selectedId == 1
                                        ? selected
                                        : unSelected),
                              )),
                        ),
                      ),
                      const DividerLine(),
                      Expanded(
                        child: ColoredBox(
                          color:
                          selectedId == 2 ? bodySelected : bodyUnSelected,
                          child: InkWell(
                            onTap: () {
                              controller.animateToPage(1, duration:const Duration(milliseconds: 500), curve: Curves.decelerate);
                              setState(() {
                                selectedId = 2;
                              });
                            },
                            child: Icon(Icons.settings,
                                color: selectedId == 2 ? selected : unSelected),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DividerLine extends StatelessWidget {
  const DividerLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: dividerColor,
      thickness: 1,
      height: 0,
    );
  }
}

