import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/customize_card_widget.dart';
import 'package:surajashray/core/models/customize_card_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';

class HealthGoalCardWidget extends StatelessWidget {
  // final Widget animationWidget;
  // final String title;
  // final VoidCallback onButtonPressed;
  // final String buttonText;

  const HealthGoalCardWidget({
    super.key,
    // required this.animationWidget,
    // required this.title,
    // required this.onButtonPressed,
    // this.buttonText = 'Get Started',
  });

  List<CustomCardWidget> _buildCards() {
    final card1 = CustomCardModel(
      title: 'Better Sleep',
      subtitle: 'Optimize your rest patterns',
      leftIconPath: IconPath.betterSleep,
      backgroundColor: const Color(0xFFEDF2FF),
      borderColor: const Color(0xFFBFD1FF),
      iconBackgroundColor: const Color(0xFFC7D6FF),
    );

    final card2 = CustomCardModel(
      title: 'Less Stress',
      subtitle: 'Find your inner calm',
      leftIconPath: IconPath.lessStress,
      backgroundColor: const Color(0xFFFFF5F5),
      borderColor: const Color(0xFFFFC2BF),
      iconBackgroundColor: const Color(0xFFFFC2BF),
    );

    final card3 = CustomCardModel(
      title: 'Healthy Habits',
      subtitle: 'Build lasting routines',
      leftIconPath: IconPath.healthyHabit,
      backgroundColor: const Color(0xFFEFF9F1),
      borderColor: const Color(0xFF95C7A2),
      iconBackgroundColor: const Color(0xFFC0EECC),
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
      body: SafeArea(
        child: LayoutBuilder(
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
                        // Title

                        // Cards
                        ...cards.map(
                          (card) => Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: card,
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
      ),
    );
  }
}
