import 'dart:ui'; // 👈 needed for BackdropFilter
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF6A);
    const darkNavy = Color(0xFF0C1B2A);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // 🌟 Fancy Logo Card
             // 🌟 Fancy Logo Card + Dots Decoration
Center(
  child: Stack(
    clipBehavior: Clip.none,
    children: [
      // Logo Card
      ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: gold.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: gold.withOpacity(0.25),
                  blurRadius: 30,
                  spreadRadius: 4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Image.asset(
              "assets/images/logo.png",
              width: 120,
            ),
          ),
        ),
      ),

      // 🎨 Top-right accent dot
      Positioned(
        top: -6,
        right: -6,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: gold,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: gold.withOpacity(0.6),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),

      // 🎨 Bottom-left accent dot
      Positioned(
        bottom: -6,
        left: -6,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: darkNavy,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: darkNavy.withOpacity(0.6),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),

              const SizedBox(height: 40),

              // Title
              const Text(
                "Find & Reserve Tables Instantly",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Subtitle
              const Text(
                "Discover great restaurants and make reservations in seconds. "
                "No more waiting on hold or wondering if your table is ready.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // Features
              _buildFeatureTile(
                icon: Icons.access_time,
                title: "Instant Booking",
                subtitle: "Reserve tables in real-time",
              ),
              _buildFeatureTile(
                icon: Icons.location_on,
                title: "Location-Based",
                subtitle: "Find restaurants near you",
              ),
              _buildFeatureTile(
                icon: Icons.star_border,
                title: "Verified Reviews",
                subtitle: "Read authentic customer reviews",
              ),
              const SizedBox(height: 40),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkNavy,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => context.go('/signup'),
                  child: const Text("Get Started",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),

              // Already have account
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: gold),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => context.go('/login'),
                  child: const Text("I Already Have an Account",
                      style: TextStyle(fontSize: 16, color: gold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
