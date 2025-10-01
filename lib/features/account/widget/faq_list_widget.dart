import 'package:flutter/material.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/account/controller/contact_support_controller.dart';

class FAQListWidget extends StatefulWidget {
  const FAQListWidget({super.key, required this.controller});
  final ContactSupportController controller;

  @override
  State<FAQListWidget> createState() => _FAQListWidgetState();
}

class _FAQListWidgetState extends State<FAQListWidget> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.controller.faqs.length,
      separatorBuilder: (_, __) =>
          const Divider(color: AppColors.grey, thickness: 1, height: 1),
      itemBuilder: (context, index) {
        final faq = widget.controller.faqs[index];
        final bool isCurrentlyExpanded = _expandedIndex == index;

        return ExpansionTile(
          // Using a Key is crucial. It tells Flutter to treat tiles as distinct
          // widgets, ensuring their state is properly managed during rebuilds.
          key: PageStorageKey(faq.question),
          tilePadding: EdgeInsets.zero,

          // Use initiallyExpanded here. It's evaluated on each rebuild.
          initiallyExpanded: isCurrentlyExpanded,

          onExpansionChanged: (bool isExpanding) {
            setState(() {
              // This logic correctly updates which index should be expanded
              _expandedIndex = isExpanding ? index : -1;
            });
          },
          dense: true,
          title: Text(
            faq.question,
            style: getTextStyle(
              color: isCurrentlyExpanded
                  ? Colors.black
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(faq.answer, style: getTextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}
