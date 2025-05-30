import 'package:flutter/material.dart';

class ContainerShimmer extends StatelessWidget {
  const ContainerShimmer({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.grey,
      ),
    );
  }
}
