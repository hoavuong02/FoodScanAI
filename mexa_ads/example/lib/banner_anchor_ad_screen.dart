import 'package:mexa_ads/banner_anchor_ad_widget.dart';
import 'package:flutter/material.dart';

class BannerAnchorAdScreen extends StatelessWidget {
  const BannerAnchorAdScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                      'Lorem ipsum, placeholder or dummy text used in typesetting and graphic design for previewing layouts. It features scrambled Latin text, which emphasizes the design over content of the layout. It is the standard placeholder text of the printing and publishing industries.'),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text('placement: banner_1'),
                ],
              ),
            ),
          ),
        ),
        BannerAnchorAdWidget(
          placement: 'banner_1',
          key: UniqueKey(),
        ),
      ],
    );
  }
}
