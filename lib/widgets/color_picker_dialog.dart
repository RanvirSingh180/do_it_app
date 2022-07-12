import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:to_do_list/utils/colors.dart';
import 'package:to_do_list/utils/fonts.dart';
// ignore: must_be_immutable
class ColorPickerDialog extends StatefulWidget {
  VoidCallback colorUpdate;
  ColorPickerDialog({Key? key,required this.colorUpdate}) : super(key: key);
  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late StateSetter stateSetter;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: const EdgeInsets.all(0.0),
        contentPadding: const EdgeInsets.all(0.0),
        content:
        StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              stateSetter=setState;
              return SingleChildScrollView(
              child: Column(

                children: [

                  ColorPicker(
                    hexInputBar: false,
                      pickerColor: defaultCollectionColor,
                      onColorChanged: (color){
                        setState(() {
                          defaultCollectionColor=color;
                        });
                      },
                      colorPickerWidth: 300.0,
                      pickerAreaHeightPercent: 0.7,
                      enableAlpha: false,
                      displayThumbColor: false,
                      paletteType: PaletteType.hueWheel,
                      pickerAreaBorderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(2.0),
                        topRight: Radius.circular(2.0),
                      )),
              InkWell(
                onTap: (){
                  widget.colorUpdate.call();
                    Navigator.of(context).pop(defaultCollectionColor);

                },
                 child: Container(
                   width: 100,
                     height: 30,
                     decoration:BoxDecoration(
                       border:Border.all(color: Colors.grey),
                       borderRadius: BorderRadius.circular(10)
                     ),
                     child: const Center(child: Text('Select',style: TextStyle(fontFamily:comfortaa),))),
               ),
                  const SizedBox(height: 10,)
                ],
              ));}
        ));
  }
}
