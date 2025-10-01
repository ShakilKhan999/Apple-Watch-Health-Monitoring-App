import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/models/new_chat_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/formatters/app_formatters.dart';
import 'package:surajashray/features/chat/controller/new_chat_controller.dart';
import 'package:surajashray/features/chat/widget/bot_typing_indicator_widget.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<NewChatModel> _messages = List.from(
    NewChatController.fakeMessages,
  );
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CommonBackgroundScaffold(
      body: SafeArea(
        child: Column(
          children: [
            10.h.verticalSpace,
            _buildHeaderSection(),
            // Text('Mira'),
            _buildTitleSection(),
            10.h.verticalSpace,
            Expanded(child: _buildChatMessagesSection()),
            _builDoingSection(),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  void _handleSendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        NewChatModel(text: text, isUser: true, timestamp: DateTime.now()),
      );
    });

    _textController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Add placeholder for typing indicator
    setState(() {
      _messages.add(
        NewChatModel(
          text: "__typing__", // special marker for typing
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.removeWhere((m) => m.text == "__typing__");
        _messages.add(
          NewChatModel(
            text: "chat_auto_response".tr,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildHeaderSection() => Align(
    alignment: Alignment.centerLeft,
    child: GestureDetector(
      onTap: () => Get.back(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 24.w,
          color: AppColors.textSecondary,
        ),
      ),
    ),
  );

  Widget _buildTitleSection() => Column(
    children: [
      Text(
        // "chat_support".tr,
        'Mira',
        style: getTextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      4.verticalSpace,
      Text(
        "chat_support_subtitle".tr,
        style: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),
    ],
  );

  Widget _buildChatMessagesSection() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];

        // --- Bot message + Options (after first message) ---
        if (index == 0 && !msg.isUser) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMessageBubble(msg),
              8.h.verticalSpace,
              ...NewChatController.faqOptions.map(
                (option) => _buildOptionButton(option),
              ),
            ],
          );
        }

        return _buildMessageBubble(msg);
      },
    );
  }

  Widget _buildMessageBubble(NewChatModel msg) {
    return Column(
      crossAxisAlignment: msg.isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: msg.isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!msg.isUser) ...[
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.primary,
                child: Text(
                  "WB",
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              8.horizontalSpace,
            ],
            Flexible(
              child: Container(
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.only(bottom: 4.h),
                decoration: BoxDecoration(
                  color: msg.isUser ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: msg.text == "__typing__"
                    ? const TypingIndicator()
                    : Text(
                        msg.text,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: msg.isUser
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: msg.isUser ? Colors.white : Colors.black,
                        ),
                      ),
              ),
            ),
            if (msg.isUser) ...[
              8.horizontalSpace,
              CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.orange[200],
                child: Text(
                  "U",
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: msg.isUser ? 0 : 40.w,
            right: msg.isUser ? 40.w : 0,
            bottom: 8.h,
          ),
          child: Text(
            AppForMatters.formatTime(msg.timestamp),
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          backgroundColor: Color(0xFFC7D6FF),
        ),
        onPressed: () {
          setState(() {
            _textController.text = text; // Fill textfield
          });
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() => Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: Colors.transparent)),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            style: getTextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: "type_your_message".tr,
              hintStyle: getTextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.r),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 16.w,
              ),
            ),
          ),
        ),
        8.horizontalSpace,
        GestureDetector(
          onTap: _handleSendMessage,
          child: CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ),
      ],
    ),
  );

  Widget _builDoingSection() {
    return Column(
      children: [
        Text(
          'how_are_you_today'.tr,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: Text('😊', style: getTextStyle(fontSize: 24.sp)),
            ),
            TextButton(
              onPressed: () {},
              child: Text('🤩', style: getTextStyle(fontSize: 24.sp)),
            ),
            TextButton(
              onPressed: () {},
              child: Text('🥰', style: getTextStyle(fontSize: 24.sp)),
            ),
            TextButton(
              onPressed: () {},
              child: Text('😢', style: getTextStyle(fontSize: 24.sp)),
            ),
          ],
        ),
      ],
    );
  }
}
