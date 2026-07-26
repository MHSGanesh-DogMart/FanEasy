import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../likes/presentation/screens/new_likes_screen.dart';
import 'chat_details_screen.dart';

// ── Mock data ──────────────────────────────────────────────────────────────

final List<Map<String, dynamic>> _matches = [
  {
    'name': 'Emily',
    'avatar':
        'https://images.unsplash.com/photo-1448375240586-882707db888b?w=200',
    'online': true,
  },
  {
    'name': 'Amelia',
    'avatar':
        'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=200',
    'online': false,
  },
  {
    'name': 'Lucas Da.',
    'avatar':
        'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=200',
    'online': false,
  },
  {
    'name': 'Sophie',
    'avatar':
        'https://images.unsplash.com/photo-1448375240586-882707db888b?w=200',
    'online': true,
  },
];

final List<Map<String, dynamic>> _messages = [
  {
    'name': 'John Smith',
    'avatar':
        'https://images.unsplash.com/photo-1448375240586-882707db888b?w=200',
    'preview': 'Say hi and break the ice ✨',
    'time': '12:12 PM',
    'online': true,
    'unread': 0,
    'isGroup': false,
  },
  {
    'name': 'Ibrahim',
    'avatar':
        'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=200',
    'preview': 'Just booked my tickets! So excited 🔥',
    'time': '12:12 PM',
    'online': true,
    'unread': 2,
    'isGroup': false,
  },
  {
    'name': 'NYC Matchday Crew',
    'avatar':
        'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=200',
    'preview': 'John: Pre-game meetup near Times Squar...',
    'time': '10:30 AM',
    'online': false,
    'unread': 0,
    'isGroup': true,
  },
  {
    'name': 'John',
    'avatar':
        'https://images.unsplash.com/photo-1448375240586-882707db888b?w=200',
    'preview': 'Hey, can we catch up sometime to go over t...',
    'time': '12:12 PM',
    'online': false,
    'unread': 0,
    'isGroup': false,
  },
  {
    'name': 'John',
    'avatar':
        'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=200',
    'preview': 'Hey, can we catch up sometime to go over t...',
    'time': '12:12 PM',
    'online': false,
    'unread': 0,
    'isGroup': false,
  },
];

// ── Screen ─────────────────────────────────────────────────────────────────

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  // Set to false to see empty state
  static const bool _hasData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chats',
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFEEEEEE),
                        width: 1.5.w,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, _) =>
                            Container(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ───────────────────────────────────────────────────
            Expanded(child: _hasData ? _DataView() : const _EmptyView()),
          ],
        ),
      ),
    );
  }
}

// ── Data View ──────────────────────────────────────────────────────────────

class _DataView extends StatefulWidget {
  @override
  State<_DataView> createState() => _DataViewState();
}

class _DataViewState extends State<_DataView> {
  late List<Map<String, dynamic>> _localMessages;
  final ValueNotifier<String?> _swipedChatNotifier = ValueNotifier<String?>(
    null,
  );

  @override
  void initState() {
    super.initState();
    _localMessages = List.from(_messages);
  }

  List<Map<String, dynamic>> get _sortedMessages {
    final pinned = _localMessages.where((m) => m['pinned'] == true).toList();
    final unpinned = _localMessages.where((m) => m['pinned'] != true).toList();
    return [...pinned, ...unpinned];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Tapping anywhere outside an open tile closes all swipe states
        _swipedChatNotifier.value = null;
      },
      behavior: HitTestBehavior.translucent,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Matches section ─────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 10.h),
            child: Row(
              children: [
                Image.asset(
                  AppAssets.matchesHeartIcon,
                  width: 20.r,
                  height: 20.r,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Matches',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Horizontal scroll of matches
          SizedBox(
            height: 126.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                // New Likes pill
                _NewLikesBubble(),
                SizedBox(width: 12.w),
                ..._matches.map(
                  (m) => Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: _MatchBubble(match: m),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 6.h),

          // ── Messages section ─────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 6.h),
            child: Text(
              'Messages',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          if (_localMessages.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: Center(
                child: Text(
                  'No conversations remaining',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            ..._sortedMessages.map(
              (msg) => _MessageTile(
                key: ValueKey(msg['name']),
                msg: msg,
                swipedNotifier: _swipedChatNotifier,
                onPinToggle: () {
                  final bool isPinned = msg['pinned'] == true;
                  if (!isPinned) {
                    final pinnedCount = _localMessages
                        .where((m) => m['pinned'] == true)
                        .length;
                    if (pinnedCount >= 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Maximum of 3 pinned chats allowed',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: const Color(0xFFE13353),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                  }
                  setState(() {
                    msg['pinned'] = !isPinned;
                  });
                },
                onDelete: () {
                  setState(() {
                    _localMessages.remove(msg);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Chat with ${msg['name']} deleted',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: const Color(0xFFE13353),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onBlock: () {
                  setState(() {
                    _localMessages.remove(msg);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${msg['name']} blocked successfully',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: const Color(0xFFE13353),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onUnmatch: () {
                  setState(() {
                    _localMessages.remove(msg);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Unmatched with ${msg['name']}',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: const Color(0xFFE13353),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onTranslate: (lang) {
                  setState(() {
                    msg['selectedLanguage'] = lang;
                    // Apply interactive premium translation mock
                    if (msg['name'] == 'John Smith') {
                      if (lang == 'English') {
                        msg['preview'] = 'Say hi and break the ice ✨';
                      }
                      if (lang == 'Spanish') {
                        msg['preview'] = 'Di hola y rompe el hielo ✨';
                      }
                      if (lang == 'French') {
                        msg['preview'] = 'Dis salut et brise la glace ✨';
                      }
                      if (lang == 'German') {
                        msg['preview'] = 'Sag Hallo und brich das Eis ✨';
                      }
                      if (lang == 'Telugu') {
                        msg['preview'] = 'హాయ్ చెప్పి సంభాషణ ప్రారంభించండి ✨';
                      }
                      if (lang == 'Hindi') {
                        msg['preview'] = 'हाय कहें and बातचीत शुरू करें ✨';
                      }
                    } else if (msg['name'] == 'Ibrahim') {
                      if (lang == 'English') {
                        msg['preview'] =
                            'Just booked my tickets! So excited 🔥';
                      }
                      if (lang == 'Spanish') {
                        msg['preview'] =
                            '¡Acabo de reservar mis boletos! Muy emocionado 🔥';
                      }
                      if (lang == 'French') {
                        msg['preview'] =
                            'Je viens de réserver mes billets! Trop hâte 🔥';
                      }
                      if (lang == 'German') {
                        msg['preview'] =
                            'Habe gerade meine Tickets gebucht! So aufgeregt 🔥';
                      }
                      if (lang == 'Telugu') {
                        msg['preview'] =
                            'నేను ఇప్పుడే నా టిక్కెట్లు బుక్ చేసుకున్నాను! చాలా ఉత్సాహంగా ఉంది 🔥';
                      }
                      if (lang == 'Hindi') {
                        msg['preview'] =
                            'मैंने अभी अपने टिकट बुक किए हैं! बहुत उत्साहित हूँ 🔥';
                      }
                    } else if (msg['name'] == 'NYC Matchday Crew') {
                      if (lang == 'English') {
                        msg['preview'] =
                            'John: Pre-game meetup near Times Squar...';
                      }
                      if (lang == 'Spanish') {
                        msg['preview'] =
                            'John: Reunión previa al juego cerca de Times Squar...';
                      }
                      if (lang == 'French') {
                        msg['preview'] =
                            'John: Rencontre d\'avant-match près de Times Squar...';
                      }
                      if (lang == 'German') {
                        msg['preview'] =
                            'John: Treffen vor dem Spiel in der Nähe des Times Squar...';
                      }
                      if (lang == 'Telugu') {
                        msg['preview'] =
                            'జాన్: టైమ్స్ స్క్వేర్ సమీపంలో ప్రీ-గేమ్ మీటప్...';
                      }
                      if (lang == 'Hindi') {
                        msg['preview'] =
                            'जॉन: टाइम्स स्क्वायर के पास प्री-गेम मीटअप...';
                      }
                    } else {
                      if (lang == 'English') {
                        msg['preview'] =
                            'Hey, can we catch up sometime to go over t...';
                      }
                      if (lang == 'Spanish') {
                        msg['preview'] =
                            'Oye, ¿podemos vernos en algún momento para revisar esto?';
                      }
                      if (lang == 'French') {
                        msg['preview'] =
                            'Hé, on peut se voir un de ces quatre pour passer en revue...';
                      }
                      if (lang == 'German') {
                        msg['preview'] =
                            'Hey, können wir uns mal treffen, um das durchzugehen...';
                      }
                      if (lang == 'Telugu') {
                        msg['preview'] =
                            'హే, ఒకసారి కలిసి దీని గురించి మాట్లాడుకుందామా...';
                      }
                      if (lang == 'Hindi') {
                        msg['preview'] =
                            'अरे, क्या हम कभी मिलकर इस पर चर्चा कर सकते हैं...';
                      }
                    }
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ── New Likes Bubble ───────────────────────────────────────────────────────

class _NewLikesBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewLikesScreen()),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Outer ring (light pink) + inner ring (strong red) + blurred avatar
              Container(
                width: 92.r,
                height: 92.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(
                      0xFFFFEBF0,
                    ), // Premium light pink outer border
                    width: 3.w,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(
                        0xFFE13353,
                      ), // Strong brand red inner border
                      width: 2.5.w,
                    ),
                  ),
                  child: ClipOval(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Highly blurred network avatar background
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1448375240586-882707db888b?w=200',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Dark red & black tint overlays for premium contrast and readability
                        Container(
                          color: const Color(0xFFE13353).withValues(alpha: 0.12),
                        ),
                        Container(color: Colors.black.withValues(alpha: 0.15)),
                        // Centered premium bold count "24"
                        Center(
                          child: Text(
                            '24',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Centered double heart badge overlapping the bottom border
              Positioned(
                bottom: -8.h,
                child: Image.asset(
                  AppAssets.doubleHeartIcon,
                  width: 38.r,
                  height: 38.r,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'New Likes',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Match Bubble ───────────────────────────────────────────────────────────

class _MatchBubble extends StatelessWidget {
  const _MatchBubble({required this.match});
  final Map<String, dynamic> match;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: 92.r,
              height: 92.r,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.08,
                    ), // Soft outer shadow
                    blurRadius: 8.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(4.r), // Thick white border!
              child: Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: Image.network(
                    match['avatar'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) =>
                        Container(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
            if (match['online'] == true)
              Positioned(
                bottom: 2.h,
                right: 2.w,
                child: Container(
                  width: 12.r,
                  height: 12.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.w),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          match['name'],
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ── Message Tile ───────────────────────────────────────────────────────────

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    required this.msg,
    required this.swipedNotifier,
    required this.onPinToggle,
    required this.onDelete,
    required this.onBlock,
    required this.onUnmatch,
    required this.onTranslate,
    super.key,
  });

  final Map<String, dynamic> msg;
  final ValueNotifier<String?> swipedNotifier;
  final VoidCallback onPinToggle;
  final VoidCallback onDelete;
  final VoidCallback onBlock;
  final VoidCallback onUnmatch;
  final ValueChanged<String> onTranslate;

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = (msg['unread'] as int) > 0;

    return _SwipeableTile(
      chatId: msg['name'],
      swipedNotifier: swipedNotifier,
      leftThreshold: 80.w,
      rightThreshold: 80.w,
      leftActionBuilder: (close) => Container(
        color: const Color(0xFF2C2C2E), // Dark premium slate grey
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 80.w,
          child: GestureDetector(
            onTap: () {
              close();
              onPinToggle();
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: -0.4,
                  child: Icon(
                    msg['pinned'] == true
                        ? Icons.push_pin_outlined
                        : Icons.push_pin_rounded,
                    color: Colors.white,
                    size: 20.r,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  msg['pinned'] == true ? 'Unpin' : 'Pin',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      rightActionBuilder: (close) => Container(
        color: const Color(0xFF2C2C2E), // Dark premium slate grey
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 80.w,
          child: GestureDetector(
            onTap: () {
              close();
              _showMoreBottomSheet(
                context,
                msg,
                onDelete,
                onBlock,
                onUnmatch,
                onTranslate,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.more_horiz_rounded, color: Colors.white, size: 20.r),
                SizedBox(height: 4.h),
                Text(
                  'More',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Container(
        color: Colors.white, // Opaque container ensures smooth overlap slides
        height: 84.h,
        child: InkWell(
          onTap: () {
            if (swipedNotifier.value != null) {
              // If any tile is currently swiped open, a tap anywhere closes it
              swipedNotifier.value = null;
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailsScreen(chatData: msg),
                ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                // Premium Circular Avatar with thick white border and outer drop shadow!
                Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.08,
                        ), // Soft outer shadow
                        blurRadius: 8.r,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(3.r), // Thick white border!
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.network(
                        msg['avatar'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, _) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Name + preview
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          // Name
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    msg['name'],
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (msg['online'] == true) ...[
                                  SizedBox(width: 5.w),
                                  Container(
                                    width: 7.r,
                                    height: 7.r,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF22C55E),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Time + Pin indicator
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (msg['pinned'] == true) ...[
                                Transform.rotate(
                                  angle: 0.4,
                                  child: Icon(
                                    Icons.push_pin_rounded,
                                    size: 11.r,
                                    color: const Color(0xFF9E9E9E),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                              ],
                              Text(
                                msg['time'],
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: hasUnread
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: hasUnread
                                      ? const Color(0xFF22C55E)
                                      : const Color(0xFF9E9E9E),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      Row(
                        children: [
                          // Preview text
                          Expanded(
                            child: Text(
                              msg['preview'],
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9E9E9E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasUnread) ...[
                            SizedBox(width: 8.w),
                            Container(
                              width: 20.r,
                              height: 20.r,
                              decoration: const BoxDecoration(
                                color: Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${msg['unread']}',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
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
          ),
        ),
      ),
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  final double borderRadius;
  final Color shadowColor;
  final Offset offset;
  final double blurRadius;
  final double spreadRadius;

  _InnerShadowPainter({
    required this.borderRadius,
    required this.shadowColor,
    required this.offset,
    required this.blurRadius,
    required this.spreadRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );

    // Clip to the button's rounded rectangle
    canvas.clipRRect(rrect);

    final Paint shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    // deflating/inflating RRect
    RRect shadowRRect = rrect;
    if (spreadRadius != 0) {
      shadowRRect = rrect.deflate(spreadRadius);
    }

    final Path shadowPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(
        Rect.fromLTWH(-100.w, -100.h, size.width + 200.w, size.height + 200.h),
      )
      ..addRRect(shadowRRect);

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(shadowPath, shadowPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.offset != offset ||
        oldDelegate.blurRadius != blurRadius ||
        oldDelegate.spreadRadius != spreadRadius;
  }
}

void _showMoreBottomSheet(
  BuildContext context,
  Map<String, dynamic> msg,
  VoidCallback onDelete,
  VoidCallback onBlock,
  VoidCallback onUnmatch,
  ValueChanged<String> onTranslate,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _MoreActionsBottomSheet(
      parentContext: context,
      msg: msg,
      onDelete: onDelete,
      onBlock: onBlock,
      onUnmatch: onUnmatch,
      onTranslate: onTranslate,
    ),
  );
}

void _showReportDetailsSheet(
  BuildContext context,
  String? avatarUrl,
  String? userName,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.maybeOf(context)?.viewInsets.bottom ?? 0,
      ),
      child: _ReportDetailsBottomSheet(
        avatarUrl: avatarUrl ?? '',
        userName: userName ?? 'User',
      ),
    ),
  );
}

void _showReportSuccessSheet(BuildContext context, String avatarUrl) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => _ReportSuccessBottomSheet(avatarUrl: avatarUrl),
  );
}

class _SwipeableTile extends StatefulWidget {
  const _SwipeableTile({
    required this.child,
    required this.chatId,
    required this.swipedNotifier,
    required this.leftActionBuilder,
    required this.rightActionBuilder,
    required this.leftThreshold,
    required this.rightThreshold,
  });

  final Widget child;
  final String chatId;
  final ValueNotifier<String?> swipedNotifier;
  final Widget Function(VoidCallback close) leftActionBuilder;
  final Widget Function(VoidCallback close) rightActionBuilder;
  final double leftThreshold;
  final double rightThreshold;

  @override
  State<_SwipeableTile> createState() => _SwipeableTileState();
}

class _SwipeableTileState extends State<_SwipeableTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _dragOffset = 0.0;
  double _animationStartOffset = 0.0;
  double _animationTargetOffset = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _controller.addListener(() {
      if (!_isDragging) {
        setState(() {
          _dragOffset =
              _animationStartOffset +
              (_animationTargetOffset - _animationStartOffset) *
                  _controller.value;
        });
      }
    });

    // Listen to parent active swipe notifier for single-swipe behavior
    widget.swipedNotifier.addListener(_onSwipedNotifierChange);
  }

  @override
  void dispose() {
    widget.swipedNotifier.removeListener(_onSwipedNotifierChange);
    _controller.dispose();
    super.dispose();
  }

  void _onSwipedNotifierChange() {
    // If another tile is swiped open, automatically close this one
    if (widget.swipedNotifier.value != widget.chatId && _dragOffset != 0.0) {
      _close();
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _isDragging = true;
    _controller.stop();
    // Claim active swipe focus
    widget.swipedNotifier.value = widget.chatId;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.primaryDelta ?? 0.0;
      // Clamp values
      if (_dragOffset > widget.leftThreshold) {
        _dragOffset = widget.leftThreshold;
      } else if (_dragOffset < -widget.rightThreshold) {
        _dragOffset = -widget.rightThreshold;
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _isDragging = false;
    final double velocity = details.primaryVelocity ?? 0.0;
    double target = 0.0;

    if (velocity < -200) {
      // Swiped left quickly (fling)
      target = -widget.rightThreshold;
    } else if (velocity > 200) {
      // Swiped right quickly (fling)
      target = widget.leftThreshold;
    } else {
      // Slow swipe, check distance thresholds (0.4x width for easier opening)
      if (_dragOffset > widget.leftThreshold * 0.4) {
        target = widget.leftThreshold;
      } else if (_dragOffset < -widget.rightThreshold * 0.4) {
        target = -widget.rightThreshold;
      } else {
        target = 0.0;
      }
    }
    _animateTo(target);

    // Reset focus if snapped closed
    if (target == 0.0 && widget.swipedNotifier.value == widget.chatId) {
      widget.swipedNotifier.value = null;
    }
  }

  void _onHorizontalDragCancel() {
    _isDragging = false;
    double target = 0.0;
    if (_dragOffset > widget.leftThreshold * 0.4) {
      target = widget.leftThreshold;
    } else if (_dragOffset < -widget.rightThreshold * 0.4) {
      target = -widget.rightThreshold;
    }
    _animateTo(target);

    if (target == 0.0 && widget.swipedNotifier.value == widget.chatId) {
      widget.swipedNotifier.value = null;
    }
  }

  void _animateTo(double target) {
    _animationStartOffset = _dragOffset;
    _animationTargetOffset = target;
    _controller.forward(from: 0.0);
  }

  void _close() {
    _isDragging = false;
    _animateTo(0.0);
    if (widget.swipedNotifier.value == widget.chatId) {
      widget.swipedNotifier.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double absoluteOffset = _dragOffset.abs();

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        if (_dragOffset > 0)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: absoluteOffset,
            child: ClipRect(child: widget.leftActionBuilder(_close)),
          ),
        if (_dragOffset < 0)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: absoluteOffset,
            child: ClipRect(child: widget.rightActionBuilder(_close)),
          ),
        Transform.translate(
          offset: Offset(_dragOffset, 0),
          child: Stack(
            children: [
              GestureDetector(
                onHorizontalDragStart: _onHorizontalDragStart,
                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                onHorizontalDragCancel: _onHorizontalDragCancel,
                behavior: HitTestBehavior.opaque,
                child: widget.child,
              ),
              // Tapping the main content of the swiped tile closes it smoothly
              if (_dragOffset != 0.0 && !_isDragging)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _close,
                    behavior: HitTestBehavior.opaque,
                    child: const SizedBox.expand(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoreActionsBottomSheet extends StatefulWidget {
  const _MoreActionsBottomSheet({
    required this.parentContext,
    required this.msg,
    required this.onDelete,
    required this.onBlock,
    required this.onUnmatch,
    required this.onTranslate,
  });

  final BuildContext parentContext;
  final Map<String, dynamic> msg;
  final VoidCallback onDelete;
  final VoidCallback onBlock;
  final VoidCallback onUnmatch;
  final ValueChanged<String> onTranslate;

  @override
  State<_MoreActionsBottomSheet> createState() =>
      _MoreActionsBottomSheetState();
}

class _MoreActionsBottomSheetState extends State<_MoreActionsBottomSheet> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.msg['selectedLanguage'] ?? 'English';
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Select Language',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12.h),
            ...[
              'English',
              'Spanish',
              'French',
              'German',
              'Telugu',
              'Hindi',
            ].map(
              (lang) => ListTile(
                title: Text(
                  lang,
                  style: GoogleFonts.inter(
                    fontWeight: _selectedLanguage == lang
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: _selectedLanguage == lang
                        ? const Color(0xFFE13353)
                        : Colors.black,
                  ),
                ),
                trailing: _selectedLanguage == lang
                    ? const Icon(Icons.check_rounded, color: Color(0xFFE13353))
                    : null,
                onTap: () {
                  setState(() {
                    _selectedLanguage = lang;
                  });
                  widget.onTranslate(lang);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String avatarUrl,
    required String title,
    required String description,
    required String cancelText,
    required String confirmText,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          width:
              360.w, // Constrain Dialog width to exactly 360.w matching Figma!
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              22.w,
              24.h,
              22.w,
              20.h,
            ), // 22px Left/Right padding from Figma!
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned
              children: [
                // Premium Circular Avatar with thick white border and outer drop shadow!
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.08,
                        ), // Soft outer shadow
                        blurRadius: 8.r,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(4.r), // Thick white border!
                  child: Container(
                    width: 52.r,
                    height: 52.r,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, _) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.25,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff626060),
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: SizedBox(
                        height: 56.h, // Exactly 56.h height from Figma!
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Stack(
                            children: [
                              // 1. Drop shadow and background container
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    16.r,
                                  ), // radius-2xl = 16px!
                                  border: Border.all(
                                    color: const Color(0xFFEBEAEA),
                                    width: 1.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF284A66).withValues(
                                        alpha: 0.04,
                                      ), // #284A66 4% opacity
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                              ),
                              // 2. Inner border shadow: X 0, Y 0, Blur 0, Spread 1, Color #566D81 6%
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF566D81,
                                      ).withValues(alpha: 0.06),
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                              ),
                              // 3. Text label
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                    cancelText,
                                    style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w), // Exactly 10px Gap from Figma!
                    // Confirm Button
                    Expanded(
                      child: SizedBox(
                        height: 56.h, // Exactly 56.h height from Figma!
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            onConfirm();
                          },
                          child: Stack(
                            children: [
                              // 1. Drop shadow and background container
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFE13353,
                                  ), // brand crimson red
                                  borderRadius: BorderRadius.circular(
                                    16.r,
                                  ), // radius-2xl = 16px!
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF284A66).withValues(
                                        alpha: 0.04,
                                      ), // #284A66 4% opacity
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                              ),
                              // 2. Inner Shadow 1: X: 0, Y: -2, Blur: 4, Spread: 0, Color: #000000 20%
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _InnerShadowPainter(
                                    borderRadius: 16.r,
                                    shadowColor: Colors.black.withValues(
                                      alpha: 0.20,
                                    ),
                                    offset: const Offset(
                                      0,
                                      -2,
                                    ), // Y: -2 (bottom edge upwards)
                                    blurRadius: 4.r,
                                    spreadRadius: 0,
                                  ),
                                ),
                              ),
                              // 3. Inner Shadow 2: X: 0, Y: 0, Blur: 0, Spread: 1, Color: #000000 4%
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                              ),
                              // 4. Text label
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                    confirmText,
                                    style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDatingMatch =
        widget.msg['isGroup'] != true; // Mock Dating match condition

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top drag handle
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          SizedBox(height: 16.h),

          // Header Row: Avatar + Name on left, Circular Close button on right
          Row(
            children: [
              // Premium Circular Avatar with thick white border and outer drop shadow!
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.08,
                      ), // Soft outer shadow
                      blurRadius: 6.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(3.r), // Thick white border!
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.network(
                      widget.msg['avatar'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) =>
                          Container(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                widget.msg['name'],
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              // Close button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFEEEEEE),
                      width: 1.w,
                    ),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18.r,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Standalone Rounded "Translate to" block
          GestureDetector(
            onTap: () => _showLanguagePicker(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xffF4F3F3), // Soft grey background
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Text(
                    'Translate to',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedLanguage,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFE13353),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.unfold_more_rounded,
                        size: 16.r,
                        color: const Color(0xFFE13353),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Action Options Grouped in a single Rounded Container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffF4F3F3), // Soft grey background
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildGroupRow(
                  label: 'Delete Chat',
                  assetPath: AppAssets.deleteChatIcon,
                  onTap: () {
                    Navigator.pop(context);
                    _showConfirmationDialog(
                      context: widget.parentContext,
                      avatarUrl: widget.msg['avatar'],
                      title: 'Delete Messages',
                      description:
                          'This will permanently delete all messages in this chat. This action cannot be undone.',
                      cancelText: 'Cancel',
                      confirmText: 'Delete',
                      onConfirm: widget.onDelete,
                    );
                  },
                ),
                const Divider(
                  height: 1,
                  color: Color(0xffEBEAEA),
                  thickness: 1,
                ),
                if (isDatingMatch) ...[
                  _buildGroupRow(
                    label: 'Unmatch ${widget.msg['name']}',
                    assetPath: AppAssets.unmatchUserIcon,
                    onTap: () {
                      Navigator.pop(context);
                      _showConfirmationDialog(
                        context: widget.parentContext,
                        avatarUrl: widget.msg['avatar'],
                        title: 'Unmatch ${widget.msg['name']}?',
                        description:
                            'This will permanently remove your connection and delete your chat. This can\'t be undone.',
                        cancelText: 'No, Cancel',
                        confirmText: 'Yes, Unmatch',
                        onConfirm: widget.onUnmatch,
                      );
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0xffEBEAEA),
                    thickness: 1,
                  ),
                ],
                _buildGroupRow(
                  label: 'Block ${widget.msg['name']}',
                  assetPath: AppAssets.blockUserIcon,
                  onTap: () {
                    Navigator.pop(context);
                    _showConfirmationDialog(
                      context: widget.parentContext,
                      avatarUrl: widget.msg['avatar'],
                      title: 'Block ${widget.msg['name']}?',
                      description:
                          'This fan won\'t be able to interact, view your activity, or message you. Future accounts will also be blocked. You can undo this anytime.',
                      cancelText: 'No, Cancel',
                      confirmText: 'Yes, Block',
                      onConfirm: widget.onBlock,
                    );
                  },
                ),
                const Divider(
                  height: 1,
                  color: Color(0xffEBEAEA),
                  thickness: 1,
                ),
                _buildGroupRow(
                  label: 'Report ${widget.msg['name']}',
                  assetPath: AppAssets.reportUserIcon,
                  onTap: () {
                    Navigator.pop(context);
                    _showConfirmationDialog(
                      context: widget.parentContext,
                      avatarUrl: widget.msg['avatar'],
                      title:
                          'Are you sure you want to report\n${widget.msg['name']}?',
                      description:
                          'We\'ll review this report and take appropriate action if needed. Your report is confidential, and ${widget.msg['name']} won\'t be notified.',
                      cancelText: 'No, Cancel',
                      confirmText: 'Yes, Report',
                      onConfirm: () {
                        _showReportDetailsSheet(
                          widget.parentContext,
                          widget.msg['avatar'],
                          widget.msg['name'],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupRow({
    required String label,
    required String assetPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFE13353),
              ),
            ),
            const Spacer(),
            Image.asset(
              assetPath,
              width: 22.r,
              height: 22.r,
              color: const Color(0xFFE13353),
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty State View ───────────────────────────────────────────────────────

class _EmptyView extends StatefulWidget {
  const _EmptyView();

  @override
  State<_EmptyView> createState() => _EmptyViewState();
}

class _EmptyViewState extends State<_EmptyView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _float = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _float,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _float.value),
                child: child,
              ),
              child: Image.asset(
                AppAssets.chatEmptyState,
                width: 280.w,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 28.h),
            Text(
              'Get Matching',
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Match with Fans to\nconnect and communicate.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: const Color(0xFF9E9E9E),
                height: 1.55,
              ),
            ),
            SizedBox(height: 32.h),
            _PulsingButton(label: 'Start Matching', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

// ── Pulsing CTA button ─────────────────────────────────────────────────────

class _PulsingButton extends StatefulWidget {
  const _PulsingButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<_PulsingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulse,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 50.h,
          width: 200.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE13353), Color(0xFFFF6B8A)],
            ),
            borderRadius: BorderRadius.circular(100.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE13353).withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_rounded, color: Colors.white, size: 18.r),
                SizedBox(width: 8.w),
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Report Details and Success Sheets ──────────────────────────────────────

class _ReportDetailsBottomSheet extends StatefulWidget {
  const _ReportDetailsBottomSheet({
    required this.avatarUrl,
    required this.userName,
  });

  final String avatarUrl;
  final String userName;

  @override
  State<_ReportDetailsBottomSheet> createState() =>
      _ReportDetailsBottomSheetState();
}

class _ReportDetailsBottomSheetState extends State<_ReportDetailsBottomSheet> {
  String _selectedProblem = 'Inappropriate Behavior';
  final TextEditingController _commentController = TextEditingController();
  int _commentLength = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Header: Back button + Title
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16.r,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Report',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // Dummy spacer to balance the back button
              SizedBox(width: 38.r),
            ],
          ),
          SizedBox(height: 24.h),

          // Subtitle
          Text(
            'Which best describes the problem?',
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),

          // Radio list options
          ...[
            'Inappropriate Behavior',
            'Spam or fake account',
            'Scams or fraud',
            'Impersonation',
          ].map((reason) {
            final isSelected = _selectedProblem == reason;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedProblem = reason;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFF1F3F5), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      reason,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.black
                            : const Color(0xFF1C1C1E),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 22.r,
                      height: 22.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? const Color(0xFFE13353) : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFE13353)
                              : const Color(0xFFD1D1D6),
                          width: 1.5.w,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 6.r,
                                height: 6.r,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 24.h),

          // Comments input
          Text(
            'Any Comments',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8E8E93),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE5E5EA), width: 1.w),
            ),
            padding: EdgeInsets.all(12.r),
            child: Column(
              children: [
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  maxLength: 200,
                  buildCounter:
                      (
                        context, {
                        required currentLength,
                        required isFocused,
                        maxLength,
                      }) => null,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'What happened?',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFFC7C7CC),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _commentLength = val.length;
                    });
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '$_commentLength/200',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),

          // Submit button with loading feedback
          GestureDetector(
            onTap: _isSubmitting
                ? null
                : () {
                    setState(() {
                      _isSubmitting = true;
                    });
                    // Premium submission delay indicator
                    Future.delayed(const Duration(milliseconds: 900), () {
                      if (context.mounted) {
                        Navigator.pop(context); // Close details sheet
                        _showReportSuccessSheet(context, widget.avatarUrl);
                      }
                    });
                  },
            child: Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE13353),
                borderRadius: BorderRadius.circular(100.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE13353).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: _isSubmitting
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Submit Report',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportSuccessBottomSheet extends StatefulWidget {
  const _ReportSuccessBottomSheet({required this.avatarUrl});
  final String avatarUrl;

  @override
  State<_ReportSuccessBottomSheet> createState() => _ReportSuccessBottomSheetState();
}

class _ReportSuccessBottomSheetState extends State<_ReportSuccessBottomSheet> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          SizedBox(height: 10.h),

          // Close button on top right
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 34.r,
                height: 34.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 18.r,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Centered avatar with pulsing exclamation badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) =>
                        Container(color: Colors.grey.shade300),
                  ),
                ),
              ),
              Positioned(
                bottom: -2.h,
                right: -2.w,
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE13353),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE13353).withValues(alpha: 0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '!',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Success Title
          Text(
            'Report Submitted',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),

          // Success Subtitle
          Text(
            "We're taking a look to keep FanEasy safe.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8E8E93),
            ),
          ),
          SizedBox(height: 32.h),

          // Continue button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE13353),
                borderRadius: BorderRadius.circular(100.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE13353).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Continue',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
