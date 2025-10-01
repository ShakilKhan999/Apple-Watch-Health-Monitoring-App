import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool implyLeading;
  final List<Widget>? actions;

  const AppbarWidget({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.implyLeading = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0, // For Material 3 shadow removal on scroll
      automaticallyImplyLeading: implyLeading,
      foregroundColor: Colors.black, // Back icon / actions color
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
