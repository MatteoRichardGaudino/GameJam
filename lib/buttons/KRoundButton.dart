import 'package:flutter/material.dart';

class KRoundButton extends StatelessWidget {
  KRoundButton(this.text, {super.key, this.onPressed, this.circular = false});

  final String text;
  final dynamic Function()? onPressed;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            shape: circular ? MaterialStateProperty.all<CircleBorder>(CircleBorder()) : MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),

            backgroundColor: MaterialStateProperty.resolveWith((states){
              if(states.contains(MaterialState.pressed)){
                return Color(0xff498C69);
              }
              if(states.contains(MaterialState.hovered)){
                return Color(0xffD8827A);
              }
              return Color(0xffB26371);
            }),
            // text color
             foregroundColor: MaterialStateProperty.resolveWith((states){
              if(states.contains(MaterialState.pressed)){
                return Color(0xff95CFAE);
              }
              if(states.contains(MaterialState.hovered)){
                return Color(0xffE7B884);
              }
              return Color(0xffE7B884);
            }),
            // green splash color
            overlayColor: MaterialStateProperty.resolveWith((states){
              if(states.contains(MaterialState.pressed)){
                return Color(0xff498C69);
              }
              if(states.contains(MaterialState.hovered)){
                return Color(0xffD8827A);
              }
              return Color(0xffB26371);
            }),
        ),
        onPressed: (){
          if(onPressed != null){
            onPressed!();
          }
        },
        child: Container(
            padding: EdgeInsets.all(5),
            child: Text(text, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)))
    );
  }
}
