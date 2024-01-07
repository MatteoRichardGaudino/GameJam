import 'package:flutter/material.dart';

class PowerSlot extends StatelessWidget {
  const PowerSlot(this.active, {super.key, this.width = 100});

  final bool active;
  final double width;

  Widget _buildActivePs(){
    return Image.asset(
      "assets/candela-animazione.gif",
      width: width,
    );
  }

  Widget _buildInactivePs(){
    return Image.asset(
        "assets/candela-spenta.png",
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    if(active) return _buildActivePs();
    else return _buildInactivePs();
  }
}
