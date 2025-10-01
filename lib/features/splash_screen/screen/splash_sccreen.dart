import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/core/utils/constants/image_path.dart';
import 'package:surajashray/features/splash_screen/controller/spash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late Animation<double> _bgScaleAnimation;

  late AnimationController _logoController;
  late Animation<double> _scaleAnimation;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final SplashScreenController controller = Get.put(SplashScreenController());

  @override
  void initState() {
    super.initState();

    // Background zoom animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _bgScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));
    _bgController.forward();

    // Logo bounce/scale animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    // Fade-in animation for text
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      _fadeController.forward();
    });

    // Optional: Navigate after splash
    // Future.delayed(const Duration(seconds: 4), () {
    //   Get.offAllNamed('/home');
    // });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgScaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _bgScaleAnimation.value,
                child: Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagePath.splashBackImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    IconPath.appIcon,
                    width: 160,
                    height: 160,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'app_title'.tr,
                    style: getTextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'splash_subtitle'.tr,
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'splash_description'.tr,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
