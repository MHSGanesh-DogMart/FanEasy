import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({required this.chatData, super.key});
  final Map<String, dynamic> chatData;

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Custom message seed matching mockups exactly!
  late final List<Map<String, dynamic>> _messages = [
    {
      'text': "Good, I'll see you tonight. Don't forget, now, 1:15 a.m., Twin Pines Mall.",
      'isMe': false,
      'time': '08:22',
      'reactions': <String>[],
    },
    {
      'text': "Right",
      'isMe': true,
      'time': '08:22',
      'reactions': <String>[],
    },
    {
      'text': "There's a slight possibility for overload ⛔",
      'isMe': false,
      'time': '08:23',
      'reactions': <String>[],
    },
    {
      'text': "Yeah, I'll keep that in mind....",
      'isMe': true,
      'time': '11:06',
      'reactions': <String>[],
    },
  ];

  bool _isEditing = false;
  int? _editingIndex;
  bool _showEmojiKeyboard = false;
  String _searchEmojiQuery = '';
  String _selectedLanguage = 'Spanish';

  // Emoji pool for the keyboard bottom sheet
  final List<String> _allEmojis = [
    '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣',
    '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰',
    '😘', '😗', '😙', '😚', '😋', '😛', '😝', '😜',
    '🤪', '🤨', '🧐', '🤓', '😎', '🥸', '🤩', '🥳',
    '🤡', '💩', '👻', '💀', '👽', '🤖', '🎃', '😺'
  ];

  // Icebreaker options from mockup for empty chats (if cleared)
  final List<Map<String, String>> _icebreakers = [
    {'emoji': '⚽', 'text': "What's up? Let's plan a match."},
    {'emoji': '🎫', 'text': "Which events are you into?"},
    {'emoji': '🎈', 'text': "Are you up for a watch party?"},
    {'emoji': '☕', 'text': "Let's grab coffee?"},
    {'emoji': '📍', 'text': "Any recent plans you going for?"},
  ];

  void _sendMessage(String text, {bool isMe = true}) {
    if (text.trim().isEmpty) return;

    final now = DateTime.now();
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    setState(() {
      _messages.add({
        'text': text,
        'isMe': isMe,
        'time': timeStr,
        'reactions': <String>[],
      });
    });

    _messageController.clear();
    _showEmojiKeyboard = false;

    // Scroll to the bottom of the list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Mock response after sending the first dynamic message
    if (isMe && _messages.length == 5) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _messages.add({
              'text': "Hey! That sounds like an awesome plan 🔥 Let's do it!",
              'isMe': false,
              'time': 'Just now',
              'reactions': <String>[],
            });
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      });
    }
  }

  void _startEditing(int index) {
    setState(() {
      _isEditing = true;
      _editingIndex = index;
      _messageController.text = _messages[index]['text'];
      _showEmojiKeyboard = false;
    });
  }

  void _handleSendOrConfirm() {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;

    if (_isEditing && _editingIndex != null) {
      setState(() {
        _messages[_editingIndex!]['text'] = text;
        _isEditing = false;
        _editingIndex = null;
      });
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message updated successfully'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      _sendMessage(text);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showIcebreakers = _messages.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xffFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w, top: 6.h, bottom: 6.h),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 20.r,
            ),
          ),
        ),
        title: Row(
          children: [
            // Premium circular avatar with border and drop shadow
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(3.r),
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: Image.network(
                    widget.chatData['avatar'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) =>
                        Container(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          widget.chatData['name'],
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.chatData['online'] == true) ...[
                        SizedBox(width: 6.w),
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w, top: 6.h, bottom: 6.h),
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEEEEEE), width: 1.w),
              ),
              child: Icon(
                Icons.more_vert_rounded,
                size: 20.r,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xffFAF9F6),
          image: DecorationImage(
            image: AssetImage(AppAssets.whatsappBg),
            fit: BoxFit.cover,
            opacity: 0.08, // Subtle opacity wallpaper
          ),
        ),
        child: Column(
          children: [
            // ── Scrollable Chat Thread ─────────────────────────────────────
            Expanded(
              child: showIcebreakers
                  ? _buildIcebreakerView()
                  : _buildMessageListView(),
            ),

            // ── Message Input Bar & Emoji Keyboard ──────────────────────────
            _buildMessageInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcebreakerView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 20.h),
      children: [
        Center(
          child: Text(
            'Break the ice',
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: -0.6,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Start the vibe, pick a topic and use a fun opener to get the conversation going.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: const Color(0xFF8E8E93),
              height: 1.45,
            ),
          ),
        ),
        SizedBox(height: 30.h),
        ..._icebreakers.map(
          (icebreaker) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: GestureDetector(
              onTap: () => _sendMessage(icebreaker['text']!),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      icebreaker['emoji']!,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        icebreaker['text']!,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageListView() {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final isMe = msg['isMe'] == true;
        final bubbleKey = GlobalKey();

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            key: bubbleKey,
            margin: EdgeInsets.only(bottom: 16.h),
            constraints: BoxConstraints(maxWidth: 0.78.sw),
            child: GestureDetector(
              onLongPress: () => _showOptionsOverlay(context, msg, index, bubbleKey),
              child: _buildBubbleWidget(msg, isMe),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBubbleWidget(Map<String, dynamic> msg, bool isMe, {bool showBadge = true}) {
    final hasReactions = msg['reactions'] != null && (msg['reactions'] as List).isNotEmpty;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: isMe ? OutgoingBubbleClipper() : IncomingBubbleClipper(),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              isMe ? 12.w : 20.w, // Pad tail space properly
              8.h,
              isMe ? 20.w : 12.w,
              12.h,
            ),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFE13353) : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h, right: 30.w), // Space for inline time
                  child: Text(
                    msg['text'],
                    style: GoogleFonts.inter(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),
                ),
                Text(
                  msg['time'],
                  style: GoogleFonts.inter(
                    color: isMe ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF8E8E93),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Pin reactions to bubble dynamically
        if (showBadge && hasReactions)
          Positioned(
            bottom: -8.h,
            right: isMe ? 20.w : null,
            left: isMe ? null : 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: (msg['reactions'] as List).map<Widget>((emoji) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: Text(
                      emoji,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  void _showOptionsOverlay(BuildContext context, Map<String, dynamic> msg, int index, GlobalKey bubbleKey) {
    final renderBox = bubbleKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setOverlayState) {
            final isMe = msg['isMe'] == true;
            return Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  // Dismiss trigger on back tap
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  
                  // Premium blur back filter
                  Positioned.fill(
                    child: IgnorePointer(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ),

                  // Duplicate high-fidelity bubble cloned in position
                  Positioned(
                    left: offset.dx,
                    top: offset.dy,
                    width: size.width,
                    child: IgnorePointer(
                      child: _buildBubbleWidget(msg, isMe, showBadge: false),
                    ),
                  ),

                  // Emoji floating pill row
                  Positioned(
                    left: isMe 
                        ? (offset.dx + size.width - 300.w).clamp(16.w, 1.sw - 316.w)
                        : offset.dx.clamp(16.w, 1.sw - 316.w),
                    top: offset.dy - 56.h,
                    child: Container(
                      width: 300.w,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 15.r,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...['❤️', '🔥', '👏', '✅', '😍', '🥳'].map((emoji) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  final reactions = List<String>.from(msg['reactions'] ?? []);
                                  if (reactions.contains(emoji)) {
                                    reactions.remove(emoji);
                                  } else {
                                    reactions.add(emoji);
                                  }
                                  msg['reactions'] = reactions;
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                emoji,
                                style: TextStyle(fontSize: 22.sp),
                              ),
                            );
                          }),
                          // Add reactions toggle
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                final reactions = List<String>.from(msg['reactions'] ?? []);
                                reactions.add('👍');
                                msg['reactions'] = reactions;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 28.r,
                              height: 28.r,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2F2F7),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.add_rounded, size: 18.r, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Context list menu options
                  Positioned(
                    left: isMe
                        ? (offset.dx + size.width - 220.w).clamp(16.w, 1.sw - 236.w)
                        : offset.dx.clamp(16.w, 1.sw - 236.w),
                    top: offset.dy + size.height + 8.h,
                    child: Container(
                      width: 220.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 20.r,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMenuOption(
                            icon: Icons.reply_rounded,
                            text: 'Reply',
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Replying to: "${msg['text']}"'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1, color: Color(0xFFE5E5EA)),
                          if (isMe) ...[
                            _buildMenuOption(
                              icon: Icons.edit_rounded,
                              text: 'Edit',
                              onTap: () {
                                Navigator.pop(context);
                                _startEditing(index);
                              },
                            ),
                            const Divider(height: 1, color: Color(0xFFE5E5EA)),
                          ],
                          _buildMenuOption(
                            icon: Icons.copy_rounded,
                            text: 'Copy',
                            onTap: () {
                              Navigator.pop(context);
                              Clipboard.setData(ClipboardData(text: msg['text']));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to clipboard'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                            },
                          ),
                          const Divider(height: 1, color: Color(0xFFE5E5EA)),
                          _buildMenuOption(
                            icon: Icons.g_translate_rounded,
                            text: 'Translate to',
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isMe ? _selectedLanguage : 'Spanish',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFE13353),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Icon(
                                  Icons.unfold_more_rounded,
                                  size: 14.r,
                                  color: const Color(0xFFE13353),
                                ),
                              ],
                            ),
                            onTap: () {
                              // Dynamic live translation toggler
                              setOverlayState(() {
                                if (isMe) {
                                  _selectedLanguage = (_selectedLanguage == 'Spanish') ? 'German' : 'Spanish';
                                }
                              });
                              setState(() {
                                final currentText = msg['text'] as String;
                                if (currentText.startsWith('Spanish:') || currentText.startsWith('German:')) {
                                  msg['text'] = msg['originalText'] ?? currentText;
                                } else {
                                  msg['originalText'] = currentText;
                                  final targetLang = isMe ? _selectedLanguage : 'Spanish';
                                  if (targetLang == 'Spanish') {
                                    if (currentText.contains('possibility') || currentText.contains('overload')) {
                                      msg['text'] = 'Spanish: Existe una ligera posibilidad de sobrecarga ⛔';
                                    } else if (currentText.contains('mind')) {
                                      msg['text'] = 'Spanish: Sí, lo tendré en cuenta...';
                                    } else {
                                      msg['text'] = 'Spanish: Traducido...';
                                    }
                                  } else {
                                    if (currentText.contains('possibility') || currentText.contains('overload')) {
                                      msg['text'] = 'German: Es besteht eine leichte Möglichkeit der Überlastung ⛔';
                                    } else if (currentText.contains('mind')) {
                                      msg['text'] = 'German: Ja, ich werde das im Hinterkopf behalten...';
                                    } else {
                                      msg['text'] = 'German: Übersetzt...';
                                    }
                                  }
                                }
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 18.r, color: Colors.black.withValues(alpha: 0.8)),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputBar() {
    final hasText = _messageController.text.isNotEmpty;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
          child: Row(
            children: [
              // Plus icon toggler button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showEmojiKeyboard = !_showEmojiKeyboard;
                    if (_showEmojiKeyboard) {
                      FocusScope.of(context).unfocus();
                    }
                  });
                },
                child: Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    _showEmojiKeyboard ? Icons.keyboard_rounded : Icons.add_rounded,
                    size: 24.r,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Message rounded text input field bar
              Expanded(
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          onTap: () {
                            setState(() {
                              _showEmojiKeyboard = false;
                            });
                          },
                          onChanged: (val) {
                            setState(() {});
                          },
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: _isEditing ? 'Edit message...' : 'Send a message',
                            hintStyle: GoogleFonts.inter(
                              color: const Color(0xFFC7C7CC),
                              fontSize: 14.sp,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          onSubmitted: (val) => _handleSendOrConfirm(),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Voice input is activated...'),
                              duration: Duration(milliseconds: 800),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.mic_none_rounded,
                          size: 20.r,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Custom red tick checkmark submit button
              if (hasText || _isEditing) ...[
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: _handleSendOrConfirm,
                  child: Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE13353),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 24.r,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Dynamic Custom Emoji Keyboard Panel
        if (_showEmojiKeyboard) _buildEmojiKeyboard(),
      ],
    );
  }

  Widget _buildEmojiKeyboard() {
    final filteredEmojis = _allEmojis
        .where((emoji) => _searchEmojiQuery.isEmpty || emoji.contains(_searchEmojiQuery))
        .toList();

    return Container(
      height: 310.h,
      color: const Color(0xFFF2F2F7),
      child: Column(
        children: [
          // Keyboard suggestion predictive text row
          _buildPredictionRow(),
          
          // Emojis Search Input Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Container(
              height: 36.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchEmojiQuery = val;
                        });
                      },
                      style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search an emoji',
                        hintStyle: GoogleFonts.inter(
                          color: const Color(0xFFC7C7CC),
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.search_rounded,
                    size: 18.r,
                    color: const Color(0xFF8E8E93),
                  ),
                ],
              ),
            ),
          ),

          // Emojis list grid
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              physics: const BouncingScrollPhysics(),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SMILEYS & PEOPLE',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8E8E93),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                  itemCount: filteredEmojis.length,
                  itemBuilder: (context, idx) {
                    final emoji = filteredEmojis[idx];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _messageController.text += emoji;
                          _messageController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _messageController.text.length),
                          );
                        });
                      },
                      child: Center(
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 26.sp),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),

          // Custom Keyboard Footer Category navigation
          Container(
            height: 48.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE5E5EA), width: 0.5)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryIcon(Icons.schedule_rounded, true),
                _buildCategoryIcon(Icons.emoji_emotions_outlined, false),
                _buildCategoryIcon(Icons.pets_rounded, false),
                _buildCategoryIcon(Icons.fastfood_rounded, false),
                _buildCategoryIcon(Icons.sports_soccer_rounded, false),
                _buildCategoryIcon(Icons.directions_car_rounded, false),
                _buildCategoryIcon(Icons.lightbulb_outline_rounded, false),
                _buildCategoryIcon(Icons.category_rounded, false),
                _buildCategoryIcon(Icons.flag_rounded, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, bool isActive) {
    return Icon(
      icon,
      size: 20.r,
      color: isActive ? Colors.black : const Color(0xFF8E8E93),
    );
  }

  Widget _buildPredictionRow() {
    return Container(
      height: 42.h,
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F7),
        border: Border(
          top: BorderSide(color: Color(0xFFE5E5EA), width: 0.5),
          bottom: BorderSide(color: Color(0xFFE5E5EA), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          _buildPredictionButton('"The"'),
          Container(width: 0.5, color: const Color(0xFFD1D1D6)),
          _buildPredictionButton('the'),
          Container(width: 0.5, color: const Color(0xFFD1D1D6)),
          _buildPredictionButton('to'),
        ],
      ),
    );
  }

  Widget _buildPredictionButton(String word) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            final cleanWord = word.replaceAll('"', '');
            if (_messageController.text.endsWith(' ') || _messageController.text.isEmpty) {
              _messageController.text += '$cleanWord ';
            } else {
              _messageController.text += ' $cleanWord ';
            }
            _messageController.selection = TextSelection.fromPosition(
              TextPosition(offset: _messageController.text.length),
            );
          });
        },
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Text(
            word,
            style: GoogleFonts.inter(
              color: Colors.black.withValues(alpha: 0.8),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// ── CUSTOM SHAPE SPEECH BUBBLE CLIPPERS ──────────────────────────────────────

class IncomingBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const r = 16.0;
    const tailW = 8.0;
    
    // Start top-left after the tail space
    path.moveTo(tailW + r, 0);
    path.lineTo(size.width - r, 0);
    path.quadraticBezierTo(size.width, 0, size.width, r);
    path.lineTo(size.width, size.height - r);
    path.quadraticBezierTo(size.width, size.height, size.width - r, size.height);
    
    // Bottom line stopping near the tail area
    path.lineTo(tailW + 10, size.height);
    // Smooth bezier curve tail pointing bottom-left
    path.cubicTo(tailW + 8, size.height, 3, size.height - 1, 0, size.height);
    path.cubicTo(0, size.height, tailW, size.height - 4, tailW, size.height - 10);
    
    // Left side border going up
    path.lineTo(tailW, r);
    path.quadraticBezierTo(tailW, 0, tailW + r, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class OutgoingBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const r = 16.0;
    const tailW = 8.0;
    
    path.moveTo(r, 0);
    path.lineTo(size.width - tailW - r, 0);
    path.quadraticBezierTo(size.width - tailW, 0, size.width - tailW, r);
    
    // Right side line down to tail start area
    path.lineTo(size.width - tailW, size.height - 10);
    // Smooth bezier curve tail pointing bottom-right
    path.cubicTo(size.width - tailW, size.height - 4, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width - 3, size.height - 1, size.width - tailW - 8, size.height, size.width - tailW - 10, size.height);
    
    // Bottom side border
    path.lineTo(r, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - r);
    
    // Left side border going up
    path.lineTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
