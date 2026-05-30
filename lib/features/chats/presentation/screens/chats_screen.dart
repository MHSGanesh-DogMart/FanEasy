import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';

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

class _DataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ── Matches section ─────────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 10.h),
          child: Row(
            children: [
              Icon(Icons.link_rounded, size: 20.r, color: Colors.black),
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
          height: 100.h,
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

        ..._messages.map((msg) => _MessageTile(msg: msg)),
      ],
    );
  }
}

// ── New Likes Bubble ───────────────────────────────────────────────────────

class _NewLikesBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 92.r,
          height: 92.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFB3C1), Color(0xFFE13353)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0xFFE13353), width: 2.5.w),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '24',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // Heart badge at bottom
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 22.r,
                  height: 22.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFE13353),
                      size: 13.r,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'New Likes',
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
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
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFEEEEEE),
                  width: 1.5.w,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  match['avatar'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, _) =>
                      Container(color: Colors.grey.shade300),
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
  const _MessageTile({required this.msg});
  final Map<String, dynamic> msg;

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = (msg['unread'] as int) > 0;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFEEEEEE),
                      width: 1.w,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      msg['avatar'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) =>
                          Container(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ],
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
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
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
                      // Time
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

                  SizedBox(height: 3.h),

                  Row(
                    children: [
                      // Preview text
                      Expanded(
                        child: Text(
                          msg['preview'],
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
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
