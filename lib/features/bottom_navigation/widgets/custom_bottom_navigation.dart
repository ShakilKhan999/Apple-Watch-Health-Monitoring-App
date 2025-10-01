import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/utils/constants/colors.dart';

class CustomStackBottomNavBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const CustomStackBottomNavBar({
    super.key,
    required this.onTabSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125.h, // Increased to accommodate floating button
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Main Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 95.h, // Back to original height
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.backgroundDark.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Tab
                  _buildNavItem(
                    index: 0,
                    activeIcon: 'assets/icons/home_active.png',
                    inactiveIcon: 'assets/icons/home_inactive.png',
                    label: 'Home',
                  ),

                  // Map Tab
                  _buildNavItem(
                    index: 1,
                    activeIcon: 'assets/icons/trac_active.png',
                    inactiveIcon: 'assets/icons/trac_inactive.png',
                    label: 'Track',
                  ),

                  SizedBox(width: 60.w),

                  // Reward Tab
                  _buildNavItem(
                    index: 3,
                    activeIcon: 'assets/icons/chat_active.png',
                    inactiveIcon: 'assets/icons/chat_inactive.png',
                    label: 'Chat',
                  ),

                  // Profile Tab
                  _buildNavItem(
                    index: 4,
                    activeIcon: 'assets/icons/profile_active.png',
                    inactiveIcon: 'assets/icons/profile_inactive.png',
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),

          // Center Floating Button
          Positioned(
            top: -17.h,
            child: Column(
              children: [
                Container(
                  width: 80.w, // Larger touch area
                  height: 80.w, // Larger touch area
                  alignment: Alignment.center,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onTabSelected(2);
                      },
                      borderRadius: BorderRadius.circular(40.r),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: ShapeDecoration(
                          gradient: currentIndex == 2
                              ? AppColors.buttonGradient
                              : AppColors.buttonGreenGradient,
                          shape: const OvalBorder(),
                          shadows: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          currentIndex == 2
                              ? 'assets/icons/scan_active.png'
                              : 'assets/icons/scan_inactive.png',
                          height: 32.h,
                          width: 32.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                24.verticalSpace,
                Text(
                  'Scan',
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: currentIndex == 2
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String activeIcon,
    required String inactiveIcon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTabSelected(index);
        },
        borderRadius: BorderRadius.circular(20.r),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with original size
              Container(
                width: 40.w,
                height: 40.w,
                decoration: isSelected
                    ? BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Image.asset(
                      isSelected ? activeIcon : inactiveIcon,
                      width: 24.w,
                      height: 24.w,
                      key: Key(
                        '${index}_${isSelected ? 'active' : 'inactive'}',
                      ),
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),

              Text(
                label,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
