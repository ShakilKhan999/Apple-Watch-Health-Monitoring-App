import 'package:flutter/material.dart';

/// Common background widget with gradient that can be used across multiple screens
class CommonBackground extends StatelessWidget {
  final Widget child;
  final Gradient? customGradient;
  final bool useSafeArea;
  final EdgeInsetsGeometry? padding;

  const CommonBackground({
    super.key,
    required this.child,
    this.customGradient,
    this.useSafeArea = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Background container that extends to full screen
    Widget content = SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Base white/light gray background
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF6F6F6), // Light gray base from Figma
            ),
          ),

          // Blue gradient - left side top with full width coverage for smooth right edge
          Positioned(
            top: 0,
            left: 0,
            width: MediaQuery.of(
              context,
            ).size.width, // Full width to avoid harsh edges
            height:
                MediaQuery.of(context).size.height *
                0.7, // 70% height for better blending
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.4, -0.4), // Left-top positioned
                  radius:
                      2.0, // Larger radius for smoother blending to right edge
                  colors: [
                    Color(0x1F4A7BFF), // Blue with 12% opacity
                    Color.fromARGB(
                      16,
                      75,
                      123,
                      255,
                    ), // Blue with 6% opacity for smoother transition
                    Color(
                      0x054A7BFF,
                    ), // Blue with 2% opacity for smoother transition
                    Color(
                      0x024A7BFF,
                    ), // Blue with 1% opacity for even smoother transition
                    Colors.transparent,
                  ],
                  stops: [
                    0.0,
                    0.3,
                    0.5,
                    0.7,
                    1.0,
                  ], // More stops for ultra-smooth blending to right edge
                ),
              ),
            ),
          ),

          // Green gradient - from bottom center to left corner bottom with better blending
          Positioned(
            bottom: 0,
            left: 0,
            width: MediaQuery.of(
              context,
            ).size.width, // Full width to cover bottom center
            height:
                MediaQuery.of(context).size.height *
                0.5, // 50% height from bottom
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, 1.0), // Bottom center starting point
                  radius: 1.2, // Larger radius for better coverage
                  colors: [
                    Color(0x1F34C759), // Green with 12% opacity
                    Color(
                      0x1034C759,
                    ), // Green with 6% opacity for smoother transition
                    Color(
                      0x0534C759,
                    ), // Green with 2% opacity for smoother transition
                    Colors.transparent,
                  ],
                  stops: [
                    0.0,
                    0.3,
                    0.6,
                    1.0,
                  ], // Multiple stops for smooth blending
                ),
              ),
            ),
          ),

          // Additional green gradient specifically for left corner bottom
          Positioned(
            bottom: 0,
            left: 0,
            width:
                MediaQuery.of(context).size.width *
                0.4, // 40% width for left corner
            height:
                MediaQuery.of(context).size.height *
                0.3, // 30% height for left corner
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-1.0, 1.0), // Left corner bottom
                  radius: 0.8,
                  colors: [
                    Color(0x1534C759), // Slightly stronger green for corner
                    Color(0x0A34C759), // Fade to transparent
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Content with SafeArea applied only to content, not background
          useSafeArea
              ? SafeArea(
                  child: padding != null
                      ? Padding(padding: padding!, child: child)
                      : child,
                )
              : (padding != null
                    ? Padding(padding: padding!, child: child)
                    : child),
        ],
      ),
    );

    // Return content without SafeArea wrapper so background extends full screen
    return content;
  }
}

/// A wrapper that provides the common background with default padding
class CommonBackgroundScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  // final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;
  final bool useSafeArea;
  final Gradient? customGradient;

  const CommonBackgroundScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.padding,
    this.useSafeArea = true,
    this.customGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: CommonBackground(
        customGradient: customGradient,
        useSafeArea: useSafeArea,
        padding: padding,
        child: body,
      ),
    );
  }
}
