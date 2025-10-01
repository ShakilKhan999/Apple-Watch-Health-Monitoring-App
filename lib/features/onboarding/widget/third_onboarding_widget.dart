import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/customize_card_widget.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/common/widgets/customize_unfilled_button.dart';
import 'package:surajashray/core/models/customize_card_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/core/utils/constants/image_path.dart';

class ThirdOnboardingWidget extends StatelessWidget {
  final Widget animationWidget;
  final String title;
  final VoidCallback onButtonPressed;
  final VoidCallback? onSecondButtonPressed;
  final String buttonText;
  final String buttonText2;

  const ThirdOnboardingWidget({
    super.key,
    required this.animationWidget,
    required this.title,
    required this.onButtonPressed,
    this.onSecondButtonPressed,
    this.buttonText = 'Get Started',
    this.buttonText2 = 'Get Started',
  });

  List<CustomCardWidget> _buildCards() {
    final card1 = CustomCardModel(
      title: 'onboarding_perfect_timing'.tr,
      leftIconPath: IconPath.timerIcon,
      backgroundColor: const Color(0xFFEDF2FF),
      borderColor: const Color(0xFF4A7BFF),
      iconBackgroundColor: const Color(0xFFC7D6FF),
    );

    final card2 = CustomCardModel(
      title: 'onboarding_gentle_reminders'.tr,
      leftIconPath: IconPath.reminderIcon,
      backgroundColor: const Color(0xFFF5F5F7),
      borderColor: const Color(0xFF34C759),
      iconBackgroundColor: const Color(0xFFEBF9EE),
    );

    final card3 = CustomCardModel(
      title: 'onboarding_healthy_habits'.tr,
      leftIconPath: IconPath.settingsIcon,
      backgroundColor: const Color(0xFFF5F5F7),
      borderColor: const Color(0xFF6F3FC3),
      iconBackgroundColor: const Color.fromARGB(255, 206, 191, 235),
    );

    return [
      CustomCardWidget(cardModel: card1),
      CustomCardWidget(cardModel: card2),
      CustomCardWidget(cardModel: card3),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cards = _buildCards();

    return CommonBackgroundScaffold(
      useSafeArea: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 32.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Animation
                      SizedBox(
                        height: 250.h,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Positioned background PNG
                            Positioned.directional(
                              textDirection: TextDirection.ltr,
                              start: 10,
                              top: 45,
                              child: Image.asset(
                                ImagePath.vector,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // Center the animation widget on top
                            Center(child: animationWidget),
                          ],
                        ),
                      ),

                      // Title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          title,
                          style: getTextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            lineHeight: 40.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      24.h.verticalSpace,

                      // Cards
                      ...cards.map(
                        (card) => Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: card,
                        ),
                      ),

                      const Spacer(),

                      // Primary Button
                      CustomFilledButton(
                        text: buttonText,
                        onPressed: onButtonPressed,
                        padding: EdgeInsets.all(3),
                        iconPath: IconPath.notificationIcon,
                      ),

                      // Secondary Button
                      8.h.verticalSpace,

                      CustomUnfilledButton(
                        text: buttonText2,
                        onPressed: onButtonPressed,
                        padding: EdgeInsets.all(3),
                        borderColor: AppColors.grey,
                        textColor: AppColors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
