import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/image_path.dart';

class SecondOnboardingWidget extends StatelessWidget {
  final Widget animationWidget;
  final String title;
  final String subtitle;
  final VoidCallback onButtonPressed;
  final String buttonText;

  const SecondOnboardingWidget({
    super.key,
    required this.animationWidget,
    required this.title,
    required this.subtitle,
    required this.onButtonPressed,
    this.buttonText = 'Get Started',
  });

  @override
  Widget build(BuildContext context) {
    return CommonBackgroundScaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 32.h,
                    ),
                    child: Column(
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
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
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

                        20.h.verticalSpace,

                        // Subtitle
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

                        80.h.verticalSpace,

                        // Button
                        CustomFilledButton(
                          text: buttonText,
                          onPressed: onButtonPressed,
                          padding: EdgeInsets.all(3),
                          icon: Icons.arrow_forward,
                        ),
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



//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Animation
//             SizedBox(height: sizer.hp(250), child: animationWidget),
//             // Flexible(child: animationWidget),
              
//             SizedBox(height: sizer.hp(24)),
              
//             // Title
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: Text(
//                 title,
//                 style: getTextStyle(
//                   fontSize: 36,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
              
//             SizedBox(height: sizer.hp(16)),
              
//             // Subtitle
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: Text(
//                 subtitle,
//                 style: getTextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
              
//             SizedBox(height: sizer.hp(40)),
              
//             // CTA Button
//             CustomFilledButton(
//               text: buttonText,
//               onPressed: onButtonPressed,
//               icon: Icons.arrow_forward,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
