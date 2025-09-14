import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

// Message Model
class ChatMessage {
  final String id;
  final String text;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final DateTime timestamp;
  final MessageStatus status;
  final bool isTyping;

  ChatMessage({
    required this.id,
    required this.text,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.isTyping = false,
  });
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
}

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserName;
  final String otherUserAvatar;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserName,
    required this.otherUserAvatar,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _typingAnimationController;
  final bool _isOtherUserTyping = false;

  static const String _currentUserId = 'current_user';
  static const String _otherUserId = 'other_user';

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _loadMockMessages();
  }

  void _loadMockMessages() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    _messages.addAll([
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Hi,can i grab? your product.i need this item to buy',
        authorId: _otherUserId,
        authorName: widget.otherUserName,
        authorAvatar: widget.otherUserAvatar,
        timestamp: yesterday.add(const Duration(hours: 12)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Hi,can i grab? your product.i need this item to buy',
        authorId: _currentUserId,
        authorName: 'You',
        timestamp: yesterday.add(const Duration(hours: 12, minutes: 5)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Hi,can i grab?',
        authorId: _currentUserId,
        authorName: 'You',
        timestamp: now.subtract(const Duration(minutes: 5)),
        status: MessageStatus.delivered,
      ),
    ]);

    setState(() {});
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final message = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      authorId: _currentUserId,
      authorName: 'You',
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    setState(() {
      _messages.add(message);
    });

    _textController.clear();

    // Animate scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate status updates
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        final index = _messages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          _messages[index] = ChatMessage(
            id: message.id,
            text: message.text,
            authorId: message.authorId,
            authorName: message.authorName,
            timestamp: message.timestamp,
            status: MessageStatus.delivered,
          );
        }
      });
    });
  }

  void _handleAttachmentPressed() {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => SafeArea(
        child: Container(
          margin: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(top: 2.w, bottom: 3.w),
                decoration: BoxDecoration(
                  color: AppColors.grayD9,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.photo_library,
                    size: 15, color: AppColors.blueGray374957),
                title: Text('Photo Library', style: AppTypography.bodySmall),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt,
                    size: 15, color: AppColors.blueGray374957),
                title: Text('Camera', style: AppTypography.bodySmall),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file,
                    size: 15, color: AppColors.blueGray374957),
                title: Text('Document', style: AppTypography.bodySmall),
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(height: 2.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 2.w,
        left: 4.w,
        right: 4.w,
        bottom: 3.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.grayF9,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Color(0xFF646161),
                size: 18,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              widget.otherUserName,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.blueGray374957,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (messageDate == DateTime(now.year, now.month, now.day)) {
      dateText = 'Today';
    } else if (messageDate == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMMM d, yyyy').format(date);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.w, horizontal: 40.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.2.w),
        child: Center(
          child: Text(
            dateText,
            style: AppTypography.bodySmall.copyWith(
              color: Color(0XFF646461),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(
      ChatMessage message, bool showAvatar, bool isLastInGroup) {
    final isMe = message.authorId == _currentUserId;

    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 15.w : 4.w,
        right: isMe ? 4.w : 15.w,
        bottom: isLastInGroup ? 3.w : 1.w,
        top: showAvatar ? 2.w : 0,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe && showAvatar)
            Padding(
              padding: EdgeInsets.only(left: 5.w, bottom: 1.w),
              child: Text(
                message.authorName,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.blueGray374957,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: isMe ? 0 : (showAvatar ? 15 : 0),
                  right: isMe ? (showAvatar ? 15 : 0) : 0,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.5.w,
                ),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFFE8F5E8) : AppColors.white,
                  border: Border.all(
                    color: AppColors.blueGray374957.withValues(alpha: 0.15),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isMe ? 20 : 4),
                    topRight: Radius.circular(isMe ? 4 : 20),
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.text,
                      style: AppTypography.body.copyWith(
                        color: AppColors.blueGray374957,
                        fontSize: 14.5.sp,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 1.w),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(message.timestamp),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.gray8B959E.withValues(alpha: 0.7),
                            fontSize: 11.sp,
                          ),
                        ),
                        if (isMe) ...[
                          SizedBox(width: 1.w),
                          _buildStatusIcon(message.status),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (showAvatar)
                Positioned(
                  top: -8,
                  left: isMe ? null : -8,
                  right: isMe ? -8 : null,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: AppColors.blueGray374957,
                    backgroundImage: message.authorAvatar != null
                        ? NetworkImage(message.authorAvatar!)
                        : null,
                    child: message.authorAvatar == null
                        ? Text(
                            isMe ? 'Y' : message.authorName[0].toUpperCase(),
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          )
                        : null,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icon(
          Icons.access_time,
          size: 12,
          color: AppColors.gray8B959E.withValues(alpha: 0.5),
        );
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 12,
          color: AppColors.gray8B959E.withValues(alpha: 0.7),
        );
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,
          size: 12,
          color: AppColors.gray8B959E.withValues(alpha: 0.7),
        );
      case MessageStatus.read:
        return Icon(
          Icons.done_all,
          size: 12,
          color: AppColors.blueGray374957,
        );
    }
  }

  Widget _buildTypingIndicator() {
    if (!_isOtherUserTyping) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 2.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.blueGray374957.withValues(alpha: 0.1),
            backgroundImage: widget.otherUserAvatar.isNotEmpty
                ? NetworkImage(widget.otherUserAvatar)
                : null,
            child: widget.otherUserAvatar.isEmpty
                ? Text(
                    widget.otherUserName[0].toUpperCase(),
                    style: TextStyle(
                      color: AppColors.blueGray374957,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: AnimatedBuilder(
              animation: _typingAnimationController,
              builder: (context, child) {
                return Row(
                  children: List.generate(3, (index) {
                    final animationValue =
                        (_typingAnimationController.value * 3 - index)
                            .clamp(0.0, 1.0);
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.gray8B959E
                            .withValues(alpha: 0.3 + animationValue * 0.7),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 4.w,
        right: 4.w,
        top: 3.w,
        bottom: MediaQuery.of(context).padding.bottom + 3.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _focusNode,
              builder: (context, child) {
                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _focusNode.hasFocus
                          ? AppColors.blueGray374957.withValues(alpha: 0.5)
                          : AppColors.blueGray374957.withValues(alpha: 0.32),
                      width: _focusNode.hasFocus ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Image picker icon
                      GestureDetector(
                        onTap: _handleAttachmentPressed,
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w, right: 2.w),
                          child: SvgPicture.asset(
                            'assets/icons/image_picker.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      // Text input
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: AppTypography.body.copyWith(
                              color:
                                  AppColors.gray8B959E.withValues(alpha: 0.6),
                              fontSize: 14.5.sp,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 2.w),
                            filled: true,
                            fillColor: AppColors.white,
                          ),
                          style: AppTypography.body.copyWith(
                            fontSize: 14.5.sp,
                            color: AppColors.blueGray374957,
                          ),
                        ),
                      ),
                      // Send button
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          margin: EdgeInsets.only(right: 1.w),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/send.svg',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 3.w),
          // Microphone button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // Handle voice recording
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.blueGray374957.withValues(alpha: 0.32),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/audio.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Group messages by date and author for proper avatar display
    final groupedMessages = <DateTime, List<ChatMessage>>{};
    for (final message in _messages) {
      final date = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      groupedMessages[date] ??= [];
      groupedMessages[date]!.add(message);
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.blueGray374957 : AppColors.grayF9,
      body: Column(
        children: [
          _buildCustomAppBar(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(top: 2.w),
              itemCount: () {
                int count = 0;
                groupedMessages.forEach((date, messages) {
                  count++; // Date separator
                  count += messages.length; // Messages
                });
                if (_isOtherUserTyping) count++; // Typing indicator
                return count;
              }(),
              itemBuilder: (context, index) {
                int currentIndex = 0;

                for (final entry in groupedMessages.entries) {
                  if (currentIndex == index) {
                    return _buildDateSeparator(entry.key);
                  }
                  currentIndex++;

                  for (int i = 0; i < entry.value.length; i++) {
                    if (currentIndex == index) {
                      final message = entry.value[i];
                      final nextMessage = i < entry.value.length - 1
                          ? entry.value[i + 1]
                          : null;

                      final showAvatar = nextMessage == null ||
                          nextMessage.authorId != message.authorId ||
                          nextMessage.timestamp
                                  .difference(message.timestamp)
                                  .inMinutes >
                              5;

                      final isLastInGroup = nextMessage == null ||
                          nextMessage.authorId != message.authorId;

                      return _buildMessage(message, showAvatar, isLastInGroup);
                    }
                    currentIndex++;
                  }
                }

                if (_isOtherUserTyping && currentIndex == index) {
                  return _buildTypingIndicator();
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }
}
