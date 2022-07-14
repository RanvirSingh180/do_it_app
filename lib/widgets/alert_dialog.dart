import 'package:flutter/material.dart';
import 'package:to_do_list/utils/fonts.dart';
import 'package:to_do_list/utils/strings.dart';


// ignore: must_be_immutable
class AlertDialogBox extends StatefulWidget {
  TextEditingController? controller;
  bool? isValidateStatus;
  String positiveButtonText;
  String negativeButtonText;
  String title;
  bool isValidateRequired;
  bool isTextFieldRequired;
  VoidCallback positiveCallback;

  AlertDialogBox(
      {Key? key,
      this.controller,
      this.isValidateStatus,
      required this.positiveButtonText,
      required this.negativeButtonText,
      this.title = logoName,
      required this.isTextFieldRequired,
      required this.isValidateRequired,
      required this.positiveCallback})
      : super(key: key);

  @override
  State<AlertDialogBox> createState() => _AlertDialogBoxState();
}

class _AlertDialogBoxState extends State<AlertDialogBox> {
  late StateSetter stateSetter;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(fontFamily: comfortaa),
      ),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        stateSetter = setState;
        return Visibility(
          visible: widget.isTextFieldRequired,
          child: TextFormField(
            style: const TextStyle(fontFamily: comfortaa),
            cursorColor: Theme.of(context).primaryColorLight,
            autofocus: true,
            validator: (text) => text?.isEmpty ?? false ? 'Error' : null,
            maxLength: 20,
            decoration: InputDecoration(
                focusColor: Theme.of(context).primaryColorDark,
                hintText: widget.title,
                hintStyle: const TextStyle(fontFamily: comfortaa),
                errorText:
                    widget.isValidateStatus! ? 'Value can\'t be empty' : null,
                errorStyle:
                    TextStyle(color: Theme.of(context).primaryColorDark),
                focusedErrorBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColorDark)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColorLight))),
            controller: widget.controller,
          ),
        );
      }),
      actions: [
        TextButton(
            onPressed: () {
              if (widget.isValidateRequired == true) {
                stateSetter(() {
                  widget.controller!.text.trim().isEmpty
                      ? widget.isValidateStatus = true
                      : widget.isValidateStatus = false;
                });
              }
              widget.positiveCallback.call();
            },
            child: Text(widget.positiveButtonText,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: comfortaa))),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(widget.negativeButtonText,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w300,
                    fontFamily: comfortaa)))
      ],
    );
  }
}
