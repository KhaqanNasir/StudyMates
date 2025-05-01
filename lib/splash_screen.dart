import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _iconController;
  late Animation<double> _textScaleAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconOpacityAnimation;
  bool _showText = true;
  bool _showIcon = false;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textScaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutQuint,
      ),
    );

    _textOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeInOut,
      ),
    );

    _iconScaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.easeOutBack,
      ),
    );

    _iconOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.easeIn,
      ),
    );

    _textController.forward().then((_) {
      setState(() {
        _showText = false;
        _showIcon = true;
      });
      _iconController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomePage()),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_showText)
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textOpacityAnimation.value,
                    child: Transform.scale(
                      scale: _textScaleAnimation.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Study Mates",
                            style: GoogleFonts.montserrat(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Your Learning Journey Begins",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            if (_showIcon)
              AnimatedBuilder(
                animation: _iconController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _iconOpacityAnimation.value,
                    child: Transform.scale(
                      scale: _iconScaleAnimation.value,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1), // Simple background color
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.school_rounded,
                            size: 72,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
