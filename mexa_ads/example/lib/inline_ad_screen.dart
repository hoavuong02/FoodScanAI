import 'package:mexa_ads/inline_ads_widget.dart';
import 'package:flutter/material.dart';

class InlineAdScreen extends StatelessWidget {
  const InlineAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
                'Lorem ipsum, placeholder or dummy text used in typesetting and graphic design for previewing layouts. It features scrambled Latin text, which emphasizes the design over content of the layout. It is the standard placeholder text of the printing and publishing industries.'),
            SizedBox(
              height: 8,
            ),
            InlineAdaptiveAdWidget(),
            SizedBox(
              height: 8,
            ),
            Text(
                'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available. It is also used to temporarily replace text in a process called greeking, which allows designers to consider the form of a webpage or publication, without the meaning of the text influencing the design.'),
          ],
        ),
      ),
    );
  }
}
