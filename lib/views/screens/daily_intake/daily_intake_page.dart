import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mexa_ads/mexa_ads.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/core/constants/constans.dart';
import 'package:read_the_label/models/id_ads_model.dart';
import 'package:read_the_label/models/user_info.dart';
import 'package:read_the_label/repositories/storage_repository.dart';
import 'package:read_the_label/utils/ad_service_helper.dart';
import 'package:read_the_label/viewmodels/daily_intake_view_model.dart';
import 'package:read_the_label/views/screens/ai_chat/ai_chat_page.dart';
import 'package:read_the_label/views/widgets/ask_ai_widget.dart';
import 'package:read_the_label/views/widgets/date_selector.dart';
import 'package:read_the_label/views/widgets/detailed_nutrients_card.dart';
import 'package:read_the_label/views/widgets/food_history_card.dart';
import 'package:read_the_label/views/widgets/macronutrien_summary_card.dart';
import 'package:read_the_label/views/widgets/title_section_widget.dart';

class DailyIntakePage extends StatefulWidget {
  const DailyIntakePage({super.key});

  @override
  State<DailyIntakePage> createState() => _DailyIntakePageState();
}

class _DailyIntakePageState extends State<DailyIntakePage> {
  DateTime _selectedDate = DateTime.now();
  UserInfo _userInfo = UserInfo(
      name: "",
      gender: "",
      age: 0,
      height: 0,
      weight: 0,
      energy: 2200,
      protein: 50,
      carbohydrate: 280,
      fat: 80,
      fiber: 30);

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = context.read<StorageRepository>().getUserInfo();
    if (userInfo != null) {
      _userInfo = userInfo;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initializeData() async {
    print("Initializing DailyIntakePage data...");
    final dailyIntakeProvider =
        Provider.of<DailyIntakeViewModel>(context, listen: false);

    // Debug check storage
    if (kDebugMode) {
      await dailyIntakeProvider.debugCheckStorage();
      // Load food history first
      print("Loading food history...");
      await dailyIntakeProvider.loadFoodHistory();
    }

    // Then load daily intake for selected date
    print("Loading daily intake for selected date...");
    await dailyIntakeProvider.loadDailyIntake(DateTime.now());

    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 80,
          top: MediaQuery.of(context).padding.top + 10,
        ),
        child: Consumer<DailyIntakeViewModel>(
            builder: (context, dailyIntakeProvider, _) {
          return Column(
            children: [
              DateSelector(
                selectedDate: _selectedDate,
                onDateSelected: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                    dailyIntakeProvider.loadDailyIntake(newDate);
                  });
                },
              ),
              if (AdsConfig.getStatusAds(AdPlacement.nativeHomeDaily))
                const MexaNativeAd(
                  placement: AdPlacement.nativeHomeDaily,
                  layout: NativeAdSize.noMedia2,
                ),
              TitleSectionWidget(
                title: "daily_nutrition".tr(),
              ),
              MacronutrientSummaryCard(
                dailyIntake: dailyIntakeProvider.dailyIntake,
                userInfo: _userInfo,
              ),
              TitleSectionWidget(
                title: "today_intake".tr(),
                onTapInfoButton: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      title: Text('food_items_history'.tr()),
                      content: Text(
                        'this_section_show_all_food_item_you_have_comsume'.tr(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('got_it'.tr()),
                        ),
                      ],
                    ),
                  );
                },
              ),
              FoodHistoryCard(
                  context: context,
                  currentIndex: 2,
                  selectedDate: _selectedDate),
              TitleSectionWidget(
                title: "detailed_nutrients".tr(),
                // onTapInfoButton: () {
                //   showDialog(
                //     context: context,
                //     builder: (context) => AlertDialog(
                //       backgroundColor: Theme.of(context).colorScheme.surface,
                //       title: const Text('About Nutrients'),
                //       content: const Text(
                //         'This section shows detailed breakdown of your nutrient intake. Values are shown as percentage of daily recommended intake.',
                //       ),
                //       actions: [
                //         TextButton(
                //           onPressed: () => Navigator.pop(context),
                //           child: const Text('Got it'),
                //         ),
                //       ],
                //     ),
                //   );
                // },
              ),
              DetailedNutrientsCard(
                dailyIntake: dailyIntakeProvider.dailyIntake,
                userInfo: _userInfo,
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const AiChatPage(),
                    ),
                  );
                },
                child: const AskAiWidget(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
