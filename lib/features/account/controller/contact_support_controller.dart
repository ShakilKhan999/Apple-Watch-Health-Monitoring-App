import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/models/faq_item_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportController extends GetxController {
  final String supportEmail = 'ibnatnstu@gmail.com';

  Future<void> contactSupport() async {
    final Uri emailUri = Uri.parse(
      'mailto:$supportEmail?subject=${Uri.encodeComponent('Support Request')}&body=${Uri.encodeComponent('Please describe your issue here...')}',
    );

    if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
      await Clipboard.setData(ClipboardData(text: supportEmail));

      Get.snackbar(
        'No Email App Found',
        'Support email copied to clipboard. Please paste it into your email app.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black,
        duration: const Duration(seconds: 4),
      );
    }
  }

  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How do I log my water intake?',
      answer:
          'To log your water intake, simply tap the water drop icon on your home screen. You can add water by selecting preset amounts (250ml, 500ml, etc.) or use the custom amount option. Your daily progress will be automatically tracked and displayed on your dashboard.',
    ),
    FAQItem(
      question: 'Can I customize my daily nudges?',
      answer:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque congue lorem, vel tincidunt tortor placerat a. Proin ac diam quam. Aenean in sagittis magna, ut feugiat diam.',
    ),
    FAQItem(
      question: 'How do reminders work?',
      answer:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque congue lorem, vel tincidunt tortor placerat a. Proin ac diam quam. Aenean in sagittis magna, ut feugiat diam.',
    ),
    FAQItem(
      question: 'How do I reset my password?',
      answer:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque congue lorem, vel tincidunt tortor placerat a. Proin ac diam quam. Aenean in sagittis magna, ut feugiat diam.',
    ),
    FAQItem(
      question: 'Lorem ipsum dolor sit amet?',
      answer:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque congue lorem, vel tincidunt tortor placerat a. Proin ac diam quam. Aenean in sagittis magna, ut feugiat diam.',
    ),
  ];

  List<FAQItem> get faqs => _faqs;

  void toggleFAQ(int index) {
    _faqs[index].isExpanded = !_faqs[index].isExpanded;
  }
}
