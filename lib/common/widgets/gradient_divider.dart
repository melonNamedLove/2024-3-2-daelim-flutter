import 'package:flutter/material.dart';

class GradientDivider extends StatelessWidget {
  final bool reverse;
  final Color color;
  final double? width;

  const GradientDivider({
    super.key,
    this.reverse = false,
    this.color = Colors.black26,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // if (reverse) {
    //   return Container(
    //       width: 50,
    //       height: 1.5,
    //       decoration: const BoxDecoration(
    //           gradient: LinearGradient(
    //         colors: [
    //           Colors.black26,
    //           Colors.transparent,
    //           // Colors.grey,
    //         ],
    //         // stops: [0.1, 1.0],
    //       )));
    // } else {
    //   return Container(
    //       width: 50,
    //       height: 1.5,
    //       decoration: const BoxDecoration(
    //           gradient: LinearGradient(
    //         colors: [
    //           Colors.transparent,
    //           // Colors.grey,
    //           Colors.black26
    //         ],
    //         // stops: [0.1, 1.0],
    //       )));
    // }

    return Container(
        width: width,
        height: 1.5,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.transparent,
            // Colors.grey,
            color.withOpacity(0.24),
          ],
          begin: !reverse ? Alignment.centerLeft : Alignment.centerRight,
          end: !reverse ? Alignment.centerRight : Alignment.centerLeft,
          // colors: !reverse
          //     ? [
          //         Colors.transparent,
          //         Colors.black26,
          //         // Colors.grey,
          //       ]
          //     : [
          //         Colors.black26,
          //         Colors.transparent,
          //       ],
          // stops: [0.1, 1.0],
        )));
  }
}
