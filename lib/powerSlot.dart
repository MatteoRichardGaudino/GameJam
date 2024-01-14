import 'package:flutter/material.dart';

class PowerSlot extends StatelessWidget {
  const PowerSlot(this.active, {super.key, this.width, this.offset = 0});

  final bool active;
  final double? width;
  final double offset;

  Widget _buildActivePs(){
    return Transform.translate(
      offset: Offset(offset, 0),
      child: Image.asset(
        "assets/candela-animazione.gif",
        width: width,
      ),
    );
  }

  Widget _buildInactivePs(){
    return Transform.translate(
      offset: Offset(offset, 0),
      child: Image.asset(
          "assets/candela-spenta.png",
        width: width,
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    if(active) return _buildActivePs();
    else return _buildInactivePs();
  }
}
