import 'package:easy_localization/easy_localization.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mexa_ads/mexa_ads.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/core/constants/constans.dart';
import 'package:read_the_label/gen/assets.gen.dart';
import 'package:read_the_label/main.dart';
import 'package:read_the_label/models/id_ads_model.dart';
import 'package:read_the_label/theme/app_theme.dart';
import 'package:read_the_label/viewmodels/ui_view_model.dart';
import 'package:read_the_label/views/common/logo_appbar.dart';
import 'package:read_the_label/views/common/primary_svg_picture.dart';
import 'package:read_the_label/views/screens/ai_chat/ai_chat_page.dart';
import 'package:read_the_label/views/screens/scan_lable/product_scan_page.dart';
import 'package:read_the_label/views/screens/food_scan/food_scan_page.dart';
import 'package:read_the_label/views/screens/daily_intake/daily_intake_page.dart';
import 'package:mexa_ads/collapsible_ad_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    MexaAds.instance.preloadNative(
        placement: AdPlacement.nativeResult, size: NativeAdSize.layout1);
  }

  @override
  Widget build(BuildContext context) {
    isInOnboard = false;
    return FloatingDraggableWidget(
      floatingWidget: InkWell(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const AiChatPage(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12)),
          child: PrimarySvgPicture(
            Assets.icons.icChatbot.path,
            color: Colors.white,
          ),
        ),
      ),
      onDragEvent: (dx, dy) {},
      autoAlign: true,
      disableBounceAnimation: true,
      floatingWidgetHeight: 58,
      floatingWidgetWidth: 58,
      dx: MediaQuery.sizeOf(context).width - 85,
      dy: MediaQuery.sizeOf(context).height - 230,
      mainScreenWidget: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: const LogoAppbar(),
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Consumer<UiViewModel>(
                builder: (context, uiProvider, _) {
                  return IndexedStack(
                    key: ValueKey<int>(uiProvider.currentIndex),
                    index: uiProvider.currentIndex,
                    children: [
                      AnimatedOpacity(
                        opacity: uiProvider.currentIndex == 0 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: const ProductScanPage(),
                      ),
                      AnimatedOpacity(
                        opacity: uiProvider.currentIndex == 1 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: const FoodScanPage(),
                      ),
                      AnimatedOpacity(
                        opacity: uiProvider.currentIndex == 2 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: const DailyIntakePage(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<UiViewModel>(
          builder: (context, uiProvider, _) {
            return Container(
              color: Theme.of(context).colorScheme.cardBackground,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: BottomNavigationBar(
                elevation: 0,
                selectedLabelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  height: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  height: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                backgroundColor: Colors.transparent,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: const Color(0xff6B6B6B),
                currentIndex: uiProvider.currentIndex,
                onTap: (index) {
                  uiProvider.updateCurrentIndex(index);
                },
                items: [
                  _buildNavItem(
                    'scan_lable'.tr(),
                    Assets.icons.icScanLable.path,
                    0,
                    uiProvider.currentIndex,
                    context,
                  ),
                  _buildNavItem(
                    'scan_food'.tr(),
                    Assets.icons.icScanFood.path,
                    1,
                    uiProvider.currentIndex,
                    context,
                  ),
                  _buildNavItem(
                    'daily_intake'.tr(),
                    Assets.icons.icDailyIntake.path,
                    2,
                    uiProvider.currentIndex,
                    context,
                  ),
                ],
              ),
            );
          },
        ),
        if (AdsConfig.getStatusAds(AdPlacement.bannerHome))
          const CollapsibleAdWidget(
            placement: AdPlacement.bannerHome,
            reloadTimeInSeconds: -1,
          )
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
    String label,
    String iconPath,
    int index,
    int currentIndex,
    BuildContext context,
  ) {
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 2,
            width: 10,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: index == currentIndex
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: PrimarySvgPicture(
              iconPath,
              width: 32,
              height: 32,
              color: index == currentIndex
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}
