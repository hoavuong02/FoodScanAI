import 'package:mexa_ads/mexa_ads.dart';
import 'package:mexa_ads/native_ad_widget.dart';
import 'package:mexa_ads/utils.dart';
import 'package:flutter/material.dart';

class NativeAdScreen extends StatefulWidget {
  const NativeAdScreen({super.key});

  @override
  State<NativeAdScreen> createState() => _NativeAdScreenState();
}

class _NativeAdScreenState extends State<NativeAdScreen> {
  NativeAdSize size = NativeAdSize.layout1;

  @override
  Widget build(BuildContext context) {
    // return NativeAdView(adUnitId: AdmobAds.instance.adConstant.nativeId);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
            SizedBox(
              height: 60,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          size = NativeAdSize.layout1;
                        });
                      },
                      child: const Text("Layout1"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          size = NativeAdSize.layout2;
                        });
                      },
                      child: const Text("Layout2"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const NativeAdWidget(
                            adBackgrounColor: Colors.red,
                            adBodyTextColor: Colors.black,
                            adTitleTextColor: Colors.amber,
                            adCTABackgroundColor: [
                              Colors.red,
                              Colors.black,
                              Colors.amber,
                            ],
                            size: NativeAdSize.fullScreen,
                            placement: 'native_2',
                          ),
                        ));
                      },
                      child: const Text("FullScreen"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          size = NativeAdSize.layout3;
                        });
                      },
                      child: const Text("layout3"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          size = NativeAdSize.layout4;
                        });
                      },
                      child: const Text("layout4"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          size = NativeAdSize.noMedia;
                        });
                      },
                      child: const Text("No media"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          size = NativeAdSize.noMedia2;
                        });
                      },
                      child: const Text("No media2"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          size = NativeAdSize.layout1CTATop;
                        });
                      },
                      child: const Text("Layout1 Top CTA"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          size = NativeAdSize.noMediaCTATop;
                        });
                      },
                      child: const Text("Layout No Media Top CTA"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
                'Lorem ipsum, placeholder or dummy text used in typesetting and graphic design for previewing layouts. It features scrambled Latin text, which emphasizes the design over content of the layout. It is the standard placeholder text of the printing and publishing industries.'),
            const SizedBox(
              height: 8,
            ),
            NativeAdWidget(
              key: UniqueKey(),
              onAdClicked: () {
                logger('onAdClicked');
              },
              onRevenuePaid:
                  (ad, valueMicros, precision, currencyCode, adType) {
                logger('revenue: $valueMicros');
              },
              size: size,
              borderRadius: 30,
              placement: 'native_1',
              // adCTABackgroundColor: [Colors.amber, Colors.red],
              adTitleTextColor:
                  size == NativeAdSize.fullScreen ? textStyle.color : null,
              adBodyTextColor:
                  size == NativeAdSize.fullScreen ? textStyle.color : null,
            ),
          ],
        ),
      ),
    );
  }

  final TextStyle textStyle = const TextStyle(color: Colors.white);
}
