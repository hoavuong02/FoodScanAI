import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:read_the_label/core/constants/enum.dart';
import 'package:read_the_label/main.dart';
import 'package:read_the_label/theme/app_colors.dart';

class LanguageItem extends StatelessWidget {
  final String icon;
  final String index;
  final String groupIndex;
  final Function(String value) onTap;
  final AppLocale appLocale;
  const LanguageItem({
    super.key,
    required this.icon,
    required this.onTap,
    required this.index,
    required this.groupIndex,
    required this.appLocale,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        height: 60,
        width: 330,
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: InkWell(
          onTap: () async {
            try {
              await context.setLocale(supportedLocales
                  .where((element) => element.languageCode == index)
                  .first);
            } catch (e) {
              log(e.toString());
            }
            onTap.call(index);
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SvgPicture.asset(
                  icon,
                  width: 48,
                  height: 48,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  appLocale.toLocaleString(),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              Radio(
                value: index,
                groupValue: groupIndex,
                activeColor: AppColors.primary,
                onChanged: (value) async {
                  await context.setLocale(supportedLocales
                      .where((element) => element.languageCode == index)
                      .first);
                  onTap.call(value!);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
