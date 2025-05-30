import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'container_shimmer.dart';

class PrimaryShimmer extends StatelessWidget {
  const PrimaryShimmer({
    Key? key,
    this.child,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);
  final Widget? child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color.fromARGB(255, 226, 226, 226),
      highlightColor:
          highlightColor ?? const Color.fromARGB(255, 250, 250, 250),
      period: const Duration(milliseconds: 2000),
      direction: ShimmerDirection.ltr,
      child: child ?? const ContainerShimmer(),
    );
  }
}
