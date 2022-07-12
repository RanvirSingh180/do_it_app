import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/utils/images.dart';

// ignore: must_be_immutable
class Header extends StatefulWidget {
  Header({Key? key,
  required this.isCrossVisible,required this.onCrossPress,required this.isTickVisible,this.onTickPress}) : super(key: key);
   bool isCrossVisible;
  final VoidCallback onCrossPress;
   bool isTickVisible;
  VoidCallback? onTickPress;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          logo,
          color: Theme.of(context).primaryColor,
          height: 30,
          width: 30,
        ),
        const Spacer(),
        Visibility(
          visible: widget.isTickVisible,
          child: IconButton(
            onPressed: () {
              widget.onTickPress!();
            },
            icon: Icon(Icons.done, color: Theme.of(context).primaryColor),
            iconSize: 30,
          ),
        ),
        Visibility(
          visible: widget.isCrossVisible,
          child: IconButton(
            onPressed: () {
              widget.onCrossPress();
            },
            icon: const Icon(Icons.close),
            iconSize: 30,
          ),
        )
      ],
    );
  }
}
