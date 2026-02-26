import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const LoginScreen({super.key, required this.toggleTheme});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  late AnimationController _buttonController;
  late Animation<double> _buttonScale;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void login() {
    if (nameController.text.trim().isNotEmpty) {
      HapticFeedback.lightImpact();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => HomeScreen(
            username: nameController.text.trim(),
            toggleTheme: widget.toggleTheme,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your trainer name!'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1A0000), const Color(0xFF2D0000), const Color(0xFF1A0000)]
                : [const Color(0xFFCC0000), const Color(0xFF990000), const Color(0xFF660000)],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Theme Toggle
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    onPressed: widget.toggleTheme,
                    icon: Icon(
                      isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                      color: Colors.white70,
                      size: 26,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Pokeball Lottie
                      Lottie.asset(
                        "assets/pokeball.json",
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),

                      // App Name
                      Text(
                        'PokéDesk',
                        style: GoogleFonts.poppins(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        'Your Ultimate Pokédex',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Trainer Name Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (_) => login(),
                          decoration: InputDecoration(
                            hintText: 'Enter your Trainer name...',
                            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: Colors.white70,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Enter Button
                      SizedBox(
                        width: double.infinity,
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _isHovering = true),
                          onExit: (_) => setState(() => _isHovering = false),
                          child: GestureDetector(
                            onTapDown: (_) => _buttonController.forward(),
                            onTapUp: (_) {
                              _buttonController.reverse();
                              login();
                            },
                            onTapCancel: () => _buttonController.reverse(),
                            child: ScaleTransition(
                              scale: _buttonScale,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 56,
                                decoration: BoxDecoration(
                                  color: _isHovering
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.92),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Start Adventure →',
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFCC0000),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Footer
                      Text(
                        'Powered by PokéAPI',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}