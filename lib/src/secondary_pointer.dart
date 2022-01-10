import 'package:flutter/material.dart';
import 'package:rootally_ai/src/utils/size_extension.dart';

class SecondaryPointer extends StatelessWidget {
  const SecondaryPointer({
    Key? key,
    this.width = 3,
    this.height = 35,
    this.color = Colors.grey,
    this.borderRadius = 30,
    this.num=0,
  }) : super(key: key);

  /// If non-null, requires the child to have exactly this Width.
  final int width;

  /// If non-null, requires the child to have exactly this height.
  final int height;

  /// The color of the gradation.
  final Color color;

  final int borderRadius;

  final int num;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 3,
          width: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius.r),
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 13,),
        RotationTransition(
            turns: const AlwaysStoppedAnimation(90/360),
            child: Text("$num",style: const TextStyle(color: Colors.grey),)),
      ],
    );
  }
}
