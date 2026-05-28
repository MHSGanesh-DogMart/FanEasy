import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_assets.dart';

/// Highly polished, interactive Fan Page Detail Screen (e.g. Germany Fans Page).
/// Replicates the mockup with pixel-perfect accuracy, featuring a scenic header image,
/// a fully sticky navigation TabBar, interactive 3-column posts grid, interactive
/// members list with actions, and a stateful WhatsApp-style live group chat box.
class FanPageDetailScreen extends StatefulWidget {
  const FanPageDetailScreen({super.key});

  @override
  State<FanPageDetailScreen> createState() => _FanPageDetailScreenState();
}

class _FanPageDetailScreenState extends State<FanPageDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isFollowing = true;
  bool _isFollowPressed = false;
  bool _isCollapsed = false;

  // Outer scroll controller to programmatically collapse the SliverAppBar
  final ScrollController _nestedScrollCtrl = ScrollController();

  // Stateful messaging system in memory for live group chat
  final TextEditingController _msgCtrl = TextEditingController();
  final FocusNode _msgFocusNode = FocusNode();
  final ScrollController _chatScrollCtrl = ScrollController();
  bool _showSendButton = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'Anna',
      'avatar':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      'message': 'Seriously! Kroos was running the game',
      'time': '08:21',
      'isMe': false,
    },
    {
      'sender': 'Max',
      'avatar':
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
      'message': 'Defense looked solid too, finally 😅',
      'time': '08:21',
      'isMe': false,
    },
    {
      'sender': 'Jonas',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'message': 'If we play like this, we\'re winning the next match 💪',
      'time': '08:21',
      'isMe': false,
    },
    {
      'sender': 'Sophie',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      'message': 'Musiala was unreal today ⚽✨',
      'time': '08:21',
      'isMe': false,
    },
    {
      'sender': 'Me',
      'avatar':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      'message': 'Can\'t wait for the next game 🇩🇪❤️',
      'time': '08:21',
      'isMe': true,
    },
  ];

  // List of 12 Unsplash cover images recreating the 3-column posts tab beautifully
  final List<String> _postImages = [
    'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=400',
    'https://images.unsplash.com/photo-1539628399213-d64c98634399?w=400',
    'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400',
    'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=400',
    'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=400',
    'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400',
    'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=400',
    'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=400',
    'https://images.unsplash.com/photo-1484876065684-b683cf17d276?w=400',
    'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=400',
    'https://images.unsplash.com/photo-1487180142328-054b783fc471?w=400',
    'https://images.unsplash.com/photo-1603048588665-791ca8aea617?w=400',
  ];

  // List of fans/members displayed inside the Members tab
  final List<Map<String, dynamic>> _fans = [
    {
      'name': 'John Smith',
      'country': 'USA',
      'flag': '🇺🇸',
      'online': true,
      'avatar':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      'bio': 'Manchester United fan.\nTravels for stadium energy.',
    },
    {
      'name': 'Rehan Khan',
      'country': 'Germany',
      'flag': '🇩🇪',
      'online': false,
      'avatar':
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
      'bio': 'Bayern Munich supporter.\nAlways live for the match day!',
    },
    {
      'name': 'Hudson',
      'country': 'Spain',
      'flag': '🇪🇸',
      'online': false,
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'bio': 'Real Madrid supporter.\nLoves beautiful tiki-taka football.',
    },
    {
      'name': 'Emily',
      'country': 'USA',
      'flag': '🇺🇸',
      'online': false,
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      'bio': 'Chelsea fan.\nBlue is the color, football is the game.',
    },
    {
      'name': 'Liza',
      'country': 'USA',
      'flag': '🇺🇸',
      'online': false,
      'avatar':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      'bio': 'Arsenal supporter.\nBeliever in the beautiful game.',
    },
    {
      'name': 'Liza',
      'country': 'USA',
      'flag': '🇺🇸',
      'online': false,
      'avatar':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=150',
      'bio': 'Liverpool supporter.\nYou will never walk alone.',
    },
    {
      'name': 'Liza',
      'country': 'USA',
      'flag': '🇺🇸',
      'online': false,
      'avatar':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
      'bio': 'Barcelona enthusiast.\nFutbol Club Barcelona is life.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _msgCtrl.addListener(() {
      setState(() {
        _showSendButton = _msgCtrl.text.trim().isNotEmpty;
      });
    });
    // Track whether the SliverAppBar is collapsed (scrolled past hero)
    _nestedScrollCtrl.addListener(() {
      final collapsed = _nestedScrollCtrl.hasClients &&
          _nestedScrollCtrl.offset > (280.h - kToolbarHeight);
      if (collapsed != _isCollapsed) {
        setState(() => _isCollapsed = collapsed);
      }
    });
    // When keyboard opens → collapse SliverAppBar. When closed → expand back.
    _msgFocusNode.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_nestedScrollCtrl.hasClients) return;
        if (_msgFocusNode.hasFocus) {
          // Keyboard opened — collapse the hero header
          _nestedScrollCtrl.animateTo(
            _nestedScrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOut,
          );
        } else {
          // Keyboard closed — expand the hero header back to top
          _nestedScrollCtrl.animateTo(
            0,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _msgCtrl.dispose();
    _msgFocusNode.dispose();
    _chatScrollCtrl.dispose();
    _nestedScrollCtrl.dispose();
    super.dispose();
  }

  // Scroll to the bottom of the chat dynamically
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollCtrl.hasClients) {
        _chatScrollCtrl.animateTo(
          _chatScrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'Me',
        'avatar':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        'message': text,
        'time': '08:21',
        'isMe': true,
      });
      _msgCtrl.clear();
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: NestedScrollView(
        controller: _nestedScrollCtrl,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [_buildSliverAppBar(), _buildSliverTabBar()];
        },
        body: TabBarView(
          controller: _tabController,
          children: [_buildPostsTab(), _buildFansTab(), _buildChatRoomTab()],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280.h,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xffFAF9F6),
      automaticallyImplyLeading: false,
      leadingWidth: _isCollapsed ? 52.w : 70.w,
      // Back button — translucent circle when expanded, plain arrow when collapsed
      leading: _isCollapsed
          ? GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.black,
                  size: 28.r,
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1.w,
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 26.r,
                  ),
                ),
              ),
            ),
      // Title only visible when collapsed (scrolled up / keyboard open)
      title: _isCollapsed
          ? Text(
              'Germany Fan Page',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            )
          : null,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gorgeous Germany flag crowd background Unsplash cover
            Image.network(
              'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=800',
              fit: BoxFit.cover,
            ),
            // Heavy dark bottom gradient to make overlay text perfectly readable
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x66000000),
                    Color(0xCC000000),
                  ],
                  stops: [0.35, 0.7, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Page Name with verified check icon side-by-side
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Germany Fans Page',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.verified_rounded,
                                  color: Colors.white,
                                  size: 18.r,
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            // Subtitle: fans count
                            Text(
                              '54K Fans  |  Global Germany Supporters.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Following / Follow stateful overlaid button
                      _buildFollowButton(),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Online stats with green dot indicator
                  Row(
                    children: [
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '180 fans online',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF22C55E),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

  Widget _buildFollowButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isFollowPressed = true),
      onTapUp: (_) {
        setState(() {
          _isFollowPressed = false;
          _isFollowing = !_isFollowing;
        });
      },
      onTapCancel: () => setState(() => _isFollowPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isFollowPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 38.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isFollowing
                ? Colors.white.withValues(alpha: 0.18)
                : Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: _isFollowing
                  ? Colors.white.withValues(alpha: 0.35)
                  : Colors.transparent,
              width: 1.w,
            ),
          ),
          child: Text(
            _isFollowing ? 'Following' : 'Follow',
            style: GoogleFonts.inter(
              color: _isFollowing ? Colors.white : Colors.black,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabBarDelegate(
        height: 46.h,
        tabBar: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.brand,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 2.h,
          labelColor: AppColors.brand,
          unselectedLabelColor: const Color(0xff2C2C2C),
          labelPadding: EdgeInsets.zero,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.grid_view_rounded, size: 18.r),
                  SizedBox(width: 8.w),
                  Text(
                    'Posts',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline_rounded, size: 18.r),
                  SizedBox(width: 8.w),
                  Text(
                    'Fans',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded, size: 18.r),
                  SizedBox(width: 8.w),
                  Text(
                    'Chat Rooms',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab 1: Posts (3-column photo grid)
  Widget _buildPostsTab() {
    return GridView.builder(
      padding: EdgeInsets.all(2.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.r,
        mainAxisSpacing: 2.r,
        childAspectRatio: 1.0,
      ),
      itemCount: _postImages.length,
      itemBuilder: (context, index) {
        return Image.network(
          _postImages[index],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: Colors.grey.shade300),
        );
      },
    );
  }

  void _showFanProfileDialog(Map<String, dynamic> fan) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 28.r,
                  spreadRadius: 2.r,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 26.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 64.r,
                      height: 64.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 12.r,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(4.r),
                      child: ClipOval(
                        child: Image.network(
                          fan['avatar']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fan['name']!,
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                fan['flag']!,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                fan['country']!,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF6B7280),
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 4.w, right: 4.w),
                  child: Text(
                    fan['bio'] ?? '',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF4B5563),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),
                ),
                SizedBox(height: 26.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 52.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22.r),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1.2.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                offset: const Offset(0, 4),
                                blurRadius: 8.r,
                              ),
                            ],
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F2937),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 52.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE13353),
                            borderRadius: BorderRadius.circular(22.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFE13353,
                                ).withValues(alpha: 0.22),
                                offset: const Offset(0, 4),
                                blurRadius: 10.r,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_rounded,
                                color: Colors.white,
                                size: 18.r,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Like',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
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
        );
      },
    );
  }

  // Tab 2: Fans (ListView members)
  Widget _buildFansTab() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: _fans.length,
      separatorBuilder: (context, index) => Divider(
        color: const Color(0xffEBEAEA),
        height: 1.h,
        thickness: 1.h,
        indent: 60.w,
      ),
      itemBuilder: (context, index) {
        final fan = _fans[index];
        return _FanListTile(fan: fan, onTap: () => _showFanProfileDialog(fan));
      },
    );
  }

  // Tab 3: Chat Rooms (WhatsApp group chat interactive view)
  Widget _buildChatRoomTab() {
    return Container(
      color: const Color(0xffFAF9F6),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _chatScrollCtrl,
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatMessageBubble(msg: msg);
              },
            ),
          ),
          _buildChatInputBar(),
        ],
      ),
    );
  }

  Widget _buildChatInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xffFAF9F6),
        border: Border(
          top: BorderSide(color: const Color(0xFFEEEEEE), width: 1.h),
        ),
      ),
      child: Row(
        children: [
          // Circular plus icon button
          GestureDetector(
            onTap: () {
              // attachments action
            },
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x12000000),
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Icon(Icons.add_rounded, color: Colors.black, size: 26.r),
            ),
          ),
          SizedBox(width: 8.w),
          // White input body containing send field and microphone
          Expanded(
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100.r),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      focusNode: _msgFocusNode,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 14.sp,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Send a message',
                        hintStyle: GoogleFonts.inter(
                          color: const Color(0xffA3A3A3),
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: _showSendButton ? _sendMessage : null,
                    child: Icon(
                      _showSendButton
                          ? Icons.near_me_rounded
                          : Icons.mic_none_rounded,
                      color: _showSendButton
                          ? AppColors.brand
                          : const Color(0xffA3A3A3),
                      size: 22.r,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom header delegate to build sticky persistent top tab bar.
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate({required this.tabBar, required this.height});

  final TabBar tabBar;
  final double height;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: const Color(0xFFF1F1F1), width: 1.h),
        ),
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.tabBar != tabBar;
  }
}

/// Custom stateful list tile for members inside the Fans tab.
/// Displays user avatars, names, online markers, countries, and side-by-side action items.
class _FanListTile extends StatefulWidget {
  const _FanListTile({required this.fan, required this.onTap});

  final Map<String, dynamic> fan;
  final VoidCallback onTap;

  @override
  State<_FanListTile> createState() => _FanListTileState();
}

class _FanListTileState extends State<_FanListTile> {
  bool _isLiked = false;
  bool _isSent = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.onTap,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  // Avatar with online status marker
                  Stack(
                    children: [
                      Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8.r,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(2.5.r),
                        child: ClipOval(
                          child: Image.network(
                            widget.fan['avatar']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      // if (widget.fan['online'] == true)
                      //   Positioned(
                      //     top: 2.h,
                      //     right: 2.w,
                      //     child: Container(
                      //       width: 10.r,
                      //       height: 10.r,
                      //       decoration: BoxDecoration(
                      //         color: const Color(0xFF22C55E),
                      //         shape: BoxShape.circle,
                      //         border: Border.all(
                      //           color: Colors.white,
                      //           width: 1.5.w,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.fan['name']!,
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.fan['online'] == true) ...[
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
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Text(
                              widget.fan['flag']!,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              widget.fan['country']!,
                              style: GoogleFonts.inter(
                                color: const Color(0xff777777),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Like button — pill "Like Sent" when active, circle when inactive
          GestureDetector(
            onTap: () => setState(() => _isLiked = !_isLiked),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: _isLiked
                  ? _LikeSentPill(key: const ValueKey('liked'))
                  : _circleAction(
                      key: const ValueKey('unliked'),
                      assetPath: AppAssets.navLikes,
                      color: const Color(0xFFE13353),
                      isActive: false,
                    ),
            ),
          ),
          SizedBox(width: 8.w),
          // Plane green icon circle
          _circleAction(
            assetPath: AppAssets.userCardSendMessage,
            color: const Color(0xFF22C55E),
            isActive: _isSent,
            onTap: () => setState(() => _isSent = !_isSent),
          ),
        ],
      ),
    );
  }

  Widget _circleAction({
    Key? key,
    required String assetPath,
    required Color color,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36.r,
        height: 36.r,
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? color : const Color(0xFFECECEC),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            color: isActive ? Colors.white : color,
            width: 16.r,
            height: 16.r,
          ),
        ),
      ),
    );
  }
}

/// Animated "Like Sent" pill — bounces in with elastic scale + fade.
class _LikeSentPill extends StatefulWidget {
  const _LikeSentPill({super.key});

  @override
  State<_LikeSentPill> createState() => _LikeSentPillState();
}

class _LikeSentPillState extends State<_LikeSentPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(color: const Color(0xFFF0E0E4), width: 1.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.navLikes,
                width: 16.r,
                height: 16.r,
                color: const Color(0xFFE17B95),
              ),
              SizedBox(width: 6.w),
              Text(
                'Like Sent',
                style: GoogleFonts.inter(
                  color: const Color(0xFFE17B95),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom bubble widget for chat items in the Chat Rooms tab.
class _ChatMessageBubble extends StatelessWidget {
  const _ChatMessageBubble({required this.msg});

  final Map<String, dynamic> msg;

  @override
  Widget build(BuildContext context) {
    final isMe = msg['isMe'] == true;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            ClipOval(
              child: Image.network(
                msg['avatar']!,
                width: 32.r,
                height: 32.r,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78,
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isMe ? AppColors.brand : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMe ? 16.r : 0),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(isMe ? 0 : 16.r),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMe) ...[
                      Text(
                        msg['sender']!,
                        style: GoogleFonts.inter(
                          color: AppColors.brand,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                    Text(
                      msg['message']!,
                      style: GoogleFonts.inter(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        msg['time']!,
                        style: GoogleFonts.inter(
                          color: isMe
                              ? Colors.white.withValues(alpha: 0.6)
                              : const Color(0xffA3A3A3),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
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
    );
  }
}
