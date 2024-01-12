import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';

class KTextButton extends StatefulWidget {
  KTextButton(
    this.text, {
    super.key,
    this.enabled = true,
    this.onPressed,
    this.accentIndex,
  }){
    if(accentIndex != null){
      firstStr = text.substring(0, accentIndex);
      secondStr = text[accentIndex!];
      thirdStr = text.substring(accentIndex! + 1);
    }
  }

  final String text;
  final bool enabled;
  final dynamic Function()? onPressed;
  final int? accentIndex;

  String firstStr = '';
  String secondStr = '';
  String thirdStr = '';

  @override
  State<KTextButton> createState() => _KTextButtonState();
}

class _KTextButtonState extends State<KTextButton> {
  Widget _accentLetterText(baseColor, accentColor, color1, color2){
    final f = widget.firstStr;
    final s = widget.secondStr;
    final t = widget.thirdStr;

    return GestureDetector(
      onTap: (){
        if(widget.onPressed != null){
          widget.onPressed!();
        }
      },
      onPanDown: (details){
        // print('down');
        setState(() {
          clicking = true;
        });
      },
      onPanEnd: (details){
        // print('end');
        setState(() {
          clicking = false;
        });
      },
      onPanCancel: (){
        // print('cancel');
        setState(() {
          clicking = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [color1, color2]
            )
        ),
        child: Text.rich(
            TextSpan(
                text: f,
                style: TextStyle(
                    fontSize: 20,
                    color: baseColor
                ),
                children: [
                  TextSpan(
                      text: s,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: accentColor
                      )
                  ),
                  TextSpan(
                      text: t
                  )
                ]
            ), textAlign: TextAlign.center,
        ),
      ),
    );
  }

  bool clicking = false;

  @override
  Widget build(BuildContext context) {
    return widget.enabled?
    HoverWidget(
        hoverChild: clicking?
          _accentLetterText(Color(0xffBCD1A0), Color(0xff95CFAE), Color(0xff7A4B5D), Color(0xffD17E78))
            :_accentLetterText(Colors.white, Color(0xffb26371), Color(0xff3B3242), Color(0xff915664)),
        onHover: ( event) {  },
        child: _accentLetterText(Colors.white, Color(0xffb26371), Colors.transparent, Colors.transparent)
    ) : _accentLetterText(Color(0xff796e5d), Color(0xff5a5245), Colors.transparent, Colors.transparent);
  }
}
