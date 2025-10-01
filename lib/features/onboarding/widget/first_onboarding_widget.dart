import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/customize_card_widget.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/models/customize_card_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/core/utils/constants/image_path.dart';

class FirstOnboardingWidget extends StatelessWidget {
  final Widget animationWidget;
  final String title;
  final VoidCallback onButtonPressed;
  final String buttonText;

  const FirstOnboardingWidget({
    super.key,
    required this.animationWidget,
    required this.title,
    required this.onButtonPressed,
    this.buttonText = 'get_started',
  });

  // Define cards inside this widget
  List<CustomCardWidget> _buildCards() {
    final card1 = CustomCardModel(
      title: 'first_onboarding_better_sleep'.tr,
      subtitle: 'first_onboarding_optimize_rest'.tr,
      leftIconPath: IconPath.betterSleep,
      backgroundColor: const Color(0xFFEDF2FF),
      borderColor: const Color(0xFFBFD1FF),
      iconBackgroundColor: Color(0xFFC7D6FF),
    );

    final card2 = CustomCardModel(
      title: 'first_onboarding_less_stress'.tr,
      subtitle: 'first_onboarding_inner_calm'.tr,
      leftIconPath: IconPath.lessStress,
      backgroundColor: const Color(0xFFFFF5F5),
      borderColor: const Color(0xFFFFC2BF),
      iconBackgroundColor: Color(0xFFFFC2BF),
    );

    final card3 = CustomCardModel(
      title: 'first_onboarding_healthy_habits'.tr,
      subtitle: 'first_onboarding_lasting_routines'.tr,
      leftIconPath: IconPath.healthyHabit,
      backgroundColor: const Color(0xFFEFF9F1),
      borderColor: const Color(0xFF95C7A2),
      iconBackgroundColor: Color(0xFFC0EECC),
    );

    return [
      CustomCardWidget(cardModel: card1),
      CustomCardWidget(cardModel: card2),
      CustomCardWidget(cardModel: card3),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final sizer = Sizer(context);
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
                    // horizontal: sizer.wp(10),
                    // vertical: sizer.hp(32),
                    horizontal: 10.w,
                    vertical: 32.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 250.h,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Positioned background PNG
                            Positioned.directional(
                              textDirection: TextDirection.ltr,
                              start: 10,
                              top: 20,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          title,
                          style: getTextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            lineHeight: 40,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Cards
                      ...cards.map(
                        (card) => Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: card,
                        ),
                      ),

                      const Spacer(),

                      CustomFilledButton(
                        text: buttonText.tr,
                        onPressed: onButtonPressed,
                        padding: EdgeInsets.all(3),
                        icon: Icons.arrow_forward,
                      ),

                      24.h.verticalSpace,
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
