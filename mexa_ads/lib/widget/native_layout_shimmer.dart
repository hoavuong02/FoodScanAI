import 'package:flutter/material.dart';
import 'package:mexa_ads/mexa_ads.dart';
import 'package:mexa_ads/widget/container_shimmer.dart';
import 'package:mexa_ads/widget/primary_shimmer.dart';

class NativeLayout1Shimmer extends StatelessWidget {
  final double? adHeight;
  const NativeLayout1Shimmer({
    super.key,
    this.adHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      color: Colors.white,
      height: adHeight ?? MexaAds.instance.adConstant.nativeAdHeightLayout1,
      child: const PrimaryShimmer(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContainerShimmer(
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContainerShimmer(
                        width: 160,
                        height: 20,
                      ),
                      SizedBox(height: 10),
                      ContainerShimmer(
                        width: double.infinity,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(child: ContainerShimmer()),
            SizedBox(
              height: 10,
            ),
            ContainerShimmer(
              width: double.infinity,
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

class NativeLayout2Shimmer extends StatelessWidget {
  final double? adHeight;
  const NativeLayout2Shimmer({
    super.key,
    this.adHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      width: double.infinity,
      color: Colors.white,
      height: adHeight ?? MexaAds.instance.adConstant.nativeAdHeightLayout2,
      child: const PrimaryShimmer(
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ContainerShimmer(
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ContainerShimmer(
                                height: 25,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        ContainerShimmer(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(flex: 1, child: ContainerShimmer())
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ContainerShimmer(
              height: 50,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

class NativeLayout3Shimmer extends StatelessWidget {
  final double? adHeight;
  const NativeLayout3Shimmer({
    super.key,
    this.adHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      width: double.infinity,
      color: Colors.white,
      height: adHeight ?? MexaAds.instance.adConstant.nativeAdHeightLayout3,
      child: const PrimaryShimmer(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContainerShimmer(
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContainerShimmer(
                        width: 160,
                        height: 20,
                      ),
                      SizedBox(height: 10),
                      ContainerShimmer(
                        width: double.infinity,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ContainerShimmer(
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: ContainerShimmer(height: 50, width: 100)),
            ),
          ],
        ),
      ),
    );
  }
}

class NativeLayout4Shimmer extends StatelessWidget {
  final double? adHeight;
  const NativeLayout4Shimmer({
    super.key,
    this.adHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      width: double.infinity,
      color: Colors.white,
      height: adHeight ?? MexaAds.instance.adConstant.nativeAdHeightLayout4,
      child: const PrimaryShimmer(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ContainerShimmer(
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ContainerShimmer(
                          height: 30,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ContainerShimmer(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ContainerShimmer(
                    width: double.infinity,
                    height: 40,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ContainerShimmer(
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenNativeAdShimmer extends StatelessWidget {
  const FullScreenNativeAdShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: 16,
          top: MediaQuery.of(context).padding.top,
          left: 8,
          right: 8),
      width: double.infinity,
      color: Colors.black,
      height: 300,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryShimmer(
            baseColor: Color.fromARGB(255, 180, 180, 180),
            highlightColor: Color.fromARGB(255, 80, 80, 80),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                PrimaryShimmer(
                  child: ContainerShimmer(
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContainerShimmer(
                        width: 160,
                        height: 24,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          PrimaryShimmer(
                            child: Row(
                              children: [
                                Text('Ad', style: TextStyle(fontSize: 12)),
                                SizedBox(width: 10),
                                Icon(Icons.star, size: 12),
                                Icon(Icons.star, size: 12),
                                Icon(Icons.star, size: 12),
                                Icon(Icons.star, size: 12),
                                Icon(Icons.star, size: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          PrimaryShimmer(
            baseColor: Color.fromARGB(255, 180, 180, 180),
            highlightColor: Color.fromARGB(255, 80, 80, 80),
            child: ContainerShimmer(
              height: 30,
              width: 300,
            ),
          ),
          Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          PrimaryShimmer(
            baseColor: Color.fromARGB(255, 180, 180, 180),
            highlightColor: Color.fromARGB(255, 80, 80, 80),
            child: ContainerShimmer(
              height: 50,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}

class NoMediaNativeAdShimmer extends StatelessWidget {
  final double? adHeight;
  const NoMediaNativeAdShimmer({
    super.key,
    this.adHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      height:
          adHeight ?? MexaAds.instance.adConstant.nativeAdHeightLayoutNoMedia,
      color: Colors.white,
      child: const PrimaryShimmer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ContainerShimmer(
                      width: 160,
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ContainerShimmer(
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ContainerShimmer(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoMedia2NativeAdShimmer extends StatelessWidget {
  final double? adHeight;
  const NoMedia2NativeAdShimmer({
    super.key,
    this.adHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      height:
          adHeight ?? MexaAds.instance.adConstant.nativeAdHeightLayoutNoMedia2,
      color: Colors.white,
      child: const PrimaryShimmer(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContainerShimmer(
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContainerShimmer(
                        width: 160,
                        height: 20,
                      ),
                      SizedBox(height: 10),
                      ContainerShimmer(
                        width: double.infinity,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ContainerShimmer(
              width: double.infinity,
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
