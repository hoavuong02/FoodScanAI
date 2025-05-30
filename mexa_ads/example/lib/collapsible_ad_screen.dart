import 'package:mexa_ads/collapsible_ad_widget.dart';
import 'package:flutter/material.dart';

class CollapsibleAdScreen extends StatelessWidget {
  const CollapsibleAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CollapsibleAdScreen(),
                            ),
                          );
                        },
                        child: const Text('New page')),
                    const Text(
                        'Lorem ipsum, placeholder or dummy text used in typesetting and graphic design for previewing layouts. It features scrambled Latin text, which emphasizes the design over content of the layout. It is the standard placeholder text of the printing and publishing industries.'),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                        'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available. It is also used to temporarily replace text in a process called greeking, which allows designers to consider the form of a webpage or publication, without the meaning of the text influencing the design.'),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.red,
            child: CollapsibleAdWidget(
              isCollapsOnce: true,
              placement: 'placement-${DateTime.now()}',
              reloadTimeInSeconds: -1,
            ),
          ),
        ],
      ),
    );
  }
}
