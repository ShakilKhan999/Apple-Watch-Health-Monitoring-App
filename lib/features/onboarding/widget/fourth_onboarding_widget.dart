import 'package:flutter/gestures.dart';
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

class FourthOnboardingWidget extends StatelessWidget {
  final Widget animationWidget;
  final String title;
  final String subtitle;
  final VoidCallback onButtonPressed;
  final String buttonText;

  const FourthOnboardingWidget({
    super.key,
    required this.animationWidget,
    required this.title,
    required this.onButtonPressed,
    required this.subtitle,
    this.buttonText = 'get_started',
  });

  List<CustomCardWidget> _buildCards() {
    final card1 = CustomCardModel(
      title: 'fourth_onboarding_personalized_plans'.tr,
      subtitle: 'fourth_onboarding_tailored_recommendations'.tr,
      leftIconPath: IconPath.plan,
      rightIconPath: IconPath.right,
      backgroundColor: const Color(0xFFEBF9EE),
      borderColor: const Color(0xFF5EDD60),
      iconBackgroundColor: const Color(0xFFEBF9EE),
    );

    final card2 = CustomCardModel(
      title: 'fourth_onboarding_track_progress'.tr,
      subtitle: 'fourth_onboarding_monitor_journey'.tr,
      leftIconPath: IconPath.trackProgess,
      rightIconPath: IconPath.right,
      backgroundColor: const Color(0xFFEDF2FF),
      borderColor: const Color(0xFF4A7BFF),
      iconBackgroundColor: const Color(0xFFEDF2FF),
    );

    final card3 = CustomCardModel(
      title: 'fourth_onboarding_community_support'.tr,
      subtitle: 'fourth_onboarding_connect_people'.tr,
      leftIconPath: IconPath.support,
      rightIconPath: IconPath.right,
      backgroundColor: const Color(0xFFFFF9F2),
      borderColor: const Color(0xFFD46434),
      iconBackgroundColor: const Color(0xFFFFF9F2),
    );

    final card4 = CustomCardModel(
      title: 'fourth_onboarding_data_safe'.tr,
      subtitle: 'fourth_onboarding_encryption_hipaa'.tr,
      leftIconPath: IconPath.safe,
      backgroundColor: const Color.fromARGB(255, 247, 244, 240),
      borderColor: const Color(0xFF8E8E93),
      iconBackgroundColor: const Color.fromARGB(255, 247, 244, 240),
    );

    return [
      CustomCardWidget(cardModel: card1),
      CustomCardWidget(cardModel: card2),
      CustomCardWidget(cardModel: card3),
      CustomCardWidget(cardModel: card4),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cards = _buildCards();

    return CommonBackgroundScaffold(
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
                      // SizedBox(height: 250.h, child: animationWidget),
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

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          subtitle,
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey,
                            lineHeight: 24.sp,
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

                      CustomFilledButton(
                        text: buttonText.tr,
                        onPressed: onButtonPressed,
                        padding: EdgeInsets.all(3),
                        iconPath: IconPath.getStarted,
                      ),

                      Text(
                        'fourth_onboarding_skip_now'.tr,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                          lineHeight: 24.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      15.h.verticalSpace,

                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey,
                            lineHeight: 20.sp,
                          ),
                          children: [
                            TextSpan(text: 'fourth_onboarding_agree_terms'.tr),
                            TextSpan(
                              text: 'fourth_onboarding_terms_service'.tr,
                              style: getTextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.green,
                                lineHeight: 20.sp,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle Terms of Service tap
                                },
                            ),
                            TextSpan(text: 'fourth_onboarding_and'.tr),
                            TextSpan(
                              text: 'fourth_onboarding_privacy_policy'.tr,
                              style: getTextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors
                                    .green, // Use your green color here
                                lineHeight: 20.sp,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle Privacy Policy tap
                                },
                            ),
                          ],
                        ),
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
