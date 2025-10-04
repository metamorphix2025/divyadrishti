import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String logoPath;
  final String profileImagePath;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final int notificationCount;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.logoPath,
    required this.profileImagePath,
    this.onProfileTap,
    this.onNotificationTap,
    this.notificationCount = 0,
    this.showBackButton = false,
    this.onBackTap,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(160);
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _lightRayAnimation;
  late Animation<Color?> _backgroundAnimation;
  late Animation<double> _floatingOmAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _titleFadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.8), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _lightRayAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _backgroundAnimation = ColorTween(
      begin: Colors.deepOrange.shade700.withOpacity(0.95),
      end: Colors.orange.shade600.withOpacity(0.95),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _floatingOmAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNotifications = widget.notificationCount > 0;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      automaticallyImplyLeading: false,
      toolbarHeight: 160,
      flexibleSpace: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  _backgroundAnimation.value ?? Colors.deepOrange.shade700,
                  Colors.orange.shade500.withOpacity(0.0),
                  Colors.orange.shade400.withOpacity(0.0),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  // Divine Light Rays Animation
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _LightRayPainter(_lightRayAnimation.value),
                    ),
                  ),

                  // Floating OM Symbol Animation
                  Positioned(
                    top: 20,
                    left: MediaQuery.of(context).size.width * 0.1,
                    child: Opacity(
                      opacity: _floatingOmAnimation.value * 0.5,
                      child: Text(
                        'ॐ',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white.withOpacity(1.0),
                          fontFamily: 'Devanagari',
                        ),
                      ),
                    ),
                  ),

                  // Floating OM Symbol Animation
                  Positioned(
                    top: 60,
                    left: MediaQuery.of(context).size.width * 0.3,
                    child: Opacity(
                      opacity: _floatingOmAnimation.value * 0.5,
                      child: Text(
                        'ॐ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(1.0),
                          fontFamily: 'Devanagari',
                        ),
                      ),
                    ),
                  ),

                   Positioned(
                    top: 80,
                    right: MediaQuery.of(context).size.width * 0.3,
                    child: Opacity(
                      opacity: _floatingOmAnimation.value * 0.5,
                      child: Text(
                        'ॐ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(1.0),
                          fontFamily: 'Devanagari',
                        ),
                      ),
                    ),
                  ),


                  Positioned(
                    top: 60,
                    right: MediaQuery.of(context).size.width * 0.1,
                    child: Opacity(
                      opacity: _floatingOmAnimation.value * 0.5,
                      child: Text(
                        'ॐ',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white.withOpacity(1.0),
                          fontFamily: 'Devanagari',
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Stack(
                      children: [
                        // Centered Logo and Title Section
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Animated Logo with Divine Glow
                              ScaleTransition(
                                scale: _logoScaleAnimation,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.8),
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.shade300.withOpacity(_lightRayAnimation.value * 0.5),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      widget.logoPath,
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => 
                                          Container(
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.temple_buddhist_rounded,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // Animated Title with Fade Effect
                              FadeTransition(
                                opacity: _titleFadeAnimation,
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    letterSpacing: 0.8,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 6,
                                        color: Colors.black45,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                              // Subtle Temple Location
                              
                            ],
                          ),
                        ),

                        // Animated Back Button
                        if (widget.showBackButton)
                          Positioned(
                            left: 0,
                            top: 8,
                            child: ScaleTransition(
                              scale: Tween<double>(
                                begin: 1.0,
                                end: 1.1,
                              ).animate(CurvedAnimation(
                                parent: _controller,
                                curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
                              )),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: widget.onBackTap ?? () => Navigator.of(context).pop(),
                                  icon: Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  splashRadius: 20,
                                ),
                              ),
                            ),
                          ),

                        // Animated Notification and Profile Section
                        Positioned(
                          right: 0,
                          top: 8,
                          child: Row(
                            children: [
                              // Animated Notification Icon with Pulse Effect
                              ScaleTransition(
                                scale: hasNotifications 
                                    ? Tween<double>(
                                        begin: 1.0,
                                        end: 1.2,
                                      ).animate(CurvedAnimation(
                                        parent: _controller,
                                        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
                                      ))
                                    : const AlwaysStoppedAnimation(1.0),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: widget.onNotificationTap,
                                        icon: Icon(
                                          Icons.notifications_outlined,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        splashRadius: 20,
                                      ),
                                    ),
                                    
                                    // Pulsating Notification Badge
                                    if (hasNotifications)
                                      Positioned(
                                        right: -2,
                                        top: -2,
                                        child: ScaleTransition(
                                          scale: Tween<double>(
                                            begin: 1.0,
                                            end: 1.3,
                                          ).animate(CurvedAnimation(
                                            parent: _controller,
                                            curve: const Interval(0.2, 0.5, curve: Curves.easeInOut),
                                          )),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(
                                              minWidth: 18,
                                              minHeight: 18,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade600,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Text(
                                              widget.notificationCount > 9 ? '9+' : widget.notificationCount.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                height: 1,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              
                              // Animated Profile Avatar with Gentle Bounce
                              ScaleTransition(
                                scale: Tween<double>(
                                  begin: 1.0,
                                  end: 1.05,
                                ).animate(CurvedAnimation(
                                  parent: _controller,
                                  curve: const Interval(0.6, 0.8, curve: Curves.easeInOut),
                                )),
                                child: GestureDetector(
                                  onTap: widget.onProfileTap,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.8),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundImage: AssetImage(widget.profileImagePath),
                                        onBackgroundImageError: (exception, stackTrace) => 
                                            const Icon(
                                              Icons.person_rounded,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom Painter for Divine Light Rays
class _LightRayPainter extends CustomPainter {
  final double animationValue;

  _LightRayPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color.fromARGB(255, 255, 153, 0).withOpacity(animationValue * 0.5),
          const Color.fromARGB(255, 255, 68, 0).withOpacity(animationValue * 0.5),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, 0),
        radius: size.width * 0.8,
      ))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, 0), size.width * 0.8, paint);
  }

  @override
  bool shouldRepaint(covariant _LightRayPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}