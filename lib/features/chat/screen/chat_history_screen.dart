import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/models/chat_history_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/core/utils/formatters/app_formatters.dart';
import 'package:surajashray/features/chat/controller/chat_history_controller.dart';
import 'package:surajashray/features/chat/screen/new_chat_screen.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatHistoryController controller = Get.put(ChatHistoryController());

    return CommonBackgroundScaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              16.verticalSpace,
              _buildHeader(),
              16.verticalSpace,
              _buildSearchSection(controller),
              16.verticalSpace,
              // Wrap both sections in Expanded with SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildChatListContent(controller),
                      _buildLoadMoreSection(controller),
                      16.verticalSpace,
                    ],
                  ),
                ),
              ),
              _buildNewChatButton(),
              150.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Text(
        'your_chats'.tr,
        style: getTextStyle(
          color: Colors.black,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSearchSection(ChatHistoryController controller) {
    return TextField(
      onChanged: (value) => controller.searchQuery.value = value,
      style: getTextStyle(
        color: Colors.black, // Set the text color to black or any desired color
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: "search_conversations".tr,
        suffixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        hintStyle: getTextStyle(
          color: AppColors.textSecondary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      ),
    );
  }

  Widget _buildChatListContent(ChatHistoryController controller) {
    return Obx(() {
      final sections = controller.filteredChats.entries.toList();

      if (sections.isEmpty) {
        return SizedBox(
          height: 200.h,
          child: Center(child: Text("no_chats_available".tr)),
        );
      }

      return Column(
        children: sections.map((entry) {
          final dateLabel = entry.key;
          final chats = entry.value;
          return _buildSection(dateLabel, chats);
        }).toList(),
      );
    });
  }

  Widget _buildSection(String dateLabel, List<ChatHistoryModel> chats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateLabel,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chats.length,
          itemBuilder: (context, index) => _chatTile(chats[index]),
          separatorBuilder: (context, index) => Divider(height: 1.h),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _chatTile(ChatHistoryModel chat) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.primary,
        child: Text(
          chat.senderInitials,
          style: getTextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        chat.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      trailing: Text(
        AppForMatters.formatTime(chat.timestamp),
        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
      ),
      onTap: () {
        // Navigate to chat detail
      },
    );
  }

  Widget _buildLoadMoreSection(ChatHistoryController controller) {
    return Obx(
      () => controller.isLoadingMore.value
          ? const Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: controller.loadMoreChats,
              child: Text(
                "load_more_conversations".tr,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
    );
  }

  Widget _buildNewChatButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: CustomFilledButton(
        iconPath: IconPath.add,
        iconColor: Colors.white,
        text: "new_chat".tr,
        onPressed: () {
          Get.to(NewChatScreen());
        },
        padding: EdgeInsetsGeometry.zero,
      ),
    );
  }
}
