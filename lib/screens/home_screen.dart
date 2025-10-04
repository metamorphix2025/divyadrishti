import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sih2025/screens/darshan_ticket_screen.dart';
import '../widgets/gradient_background.dart';
import '../services/language_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final List<String> images = [
    'assets/images/bg.jpg',
    'assets/images/22.jpg',
    'assets/images/Dwaraka.jpg',
    'assets/images/map.jpg',
  ];
  late Timer _timer;
  int _currentPage = 0;

  // Sample data for demonstration
  final Map<String, List<String>> _spiritualQuotes = {
    'en': [
      "The soul is neither born, and nor does it die.",
      "Yoga is the journey of the self, through the self, to the self.",
      "The mind is everything. What you think you become.",
      "Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.",
    ],
    'hi': [
      "आत्मा न तो पैदा होती है और न ही मरती है।",
      "योग स्वयं के माध्यम से स्वयं की ओर स्वयं की यात्रा है।",
      "मन ही सब कुछ है। आप जो सोचते हैं वही बन जाते हैं।",
      "अतीत में मत रहो, भविष्य के सपने मत देखो, वर्तमान क्षण पर मन को केंद्रित करो।",
    ],
    'gu': [
      "આત્મા ન તો જન્મે છે અને ન મરે છે.",
      "યોગ એ આત્મદ્વારા આત્માની ઓળખની યાત્રા છે.",
      "મન જ સર્વસ્વ છે. તમે જે વિચારો છો તે બનો છો.",
      "ભૂતકાળમાં ન રહો, ભવિષ્યના સપના ન જુઓ, વર્તમાન ક્ષણ પર ધ્યાન કેન્દ્રિત કરો.",
    ],
  };

  final Map<String, List<String>> _aartiNames = {
    'en': ["Sandhya Aarti", "Shayan Aarti", "Mangla Aarti"],
    'hi': ["संध्या आरती", "शयन आरती", "मंगला आरती"],
    'gu': ["સંધ્યા આરતી", "શયન આરતી", "મંગળા આરતી"],
  };

  int _currentQuoteIndex = 0;
  int _currentAartiIndex = 0;
  int _minutesToNextAarti = 45;

  @override
  void initState() {
    super.initState();
    // Start auto-scroll every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _autoScroll());

    // Rotate quotes every minute
    Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _currentQuoteIndex = (_currentQuoteIndex + 1) % 4;
      });
    });

    // Update aarti countdown every minute
    Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        if (_minutesToNextAarti > 0) {
          _minutesToNextAarti--;
        } else {
          // Reset for next aarti
          _minutesToNextAarti = 119; // 2 hours minus 1 minute
          _currentAartiIndex = (_currentAartiIndex + 1) % 3;
        }
      });
    });
  }

  void _autoScroll() {
    if (_pageController.hasClients) {
      _currentPage++;
      if (_currentPage >= images.length) {
        _currentPage = 0; // loop back
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String _getAartiName(BuildContext context, String languageCode) {
    return _aartiNames[languageCode]?[_currentAartiIndex] ?? _aartiNames['en']![_currentAartiIndex];
  }

  String _getQuote(BuildContext context, String languageCode) {
    return _spiritualQuotes[languageCode]?[_currentQuoteIndex] ?? _spiritualQuotes['en']![_currentQuoteIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final isSmallScreen = screenWidth < 400;
        final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

        // Calculate responsive grid crossAxisCount
        int gridCrossAxisCount = 2;
        if (screenWidth > 700) {
          gridCrossAxisCount = 3;
        } else if (screenWidth < 350) {
          gridCrossAxisCount = 1;
        }

        final currentLanguage = languageService.currentLocale.languageCode;
        final nextAarti = _getAartiName(context, currentLanguage);
        const nextAartiTime = "18:30";
        final currentQuote = _getQuote(context, currentLanguage);

        return GradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Spiritual quote of the day
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.deepOrange.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    languageService.get('spiritual_quote'),
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF061C42),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    currentQuote,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 13 : 14,
                                      fontStyle: FontStyle.italic,
                                      color: const Color(0xFF061C42),
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            // Description text
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 16,
                              ),
                              child: Text(
                                languageService.get('temple_description'),
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: const Color(0xFF061C42),
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            // Aarti countdown
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                              margin: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.orange.shade100,
                                    Colors.orange.shade50,
                                    Colors.yellow.shade50,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.orange.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Header with icon
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.deepOrange.shade700,
                                        size: isSmallScreen ? 18 : 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        languageService.get('next_aarti'),
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 14 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange.shade700,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Aarti name with decorative elements
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Decorative elements
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.celebration,
                                            color: Colors.orange.shade300,
                                            size: isSmallScreen ? 16 : 20,
                                          ),
                                          Icon(
                                            Icons.celebration,
                                            color: Colors.orange.shade300,
                                            size: isSmallScreen ? 16 : 20,
                                          ),
                                        ],
                                      ),

                                      // Aarti name
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.deepOrange.shade700,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          nextAarti.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 16 : 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Time information
                                  Text(
                                    "${languageService.get('starts_at')} $nextAartiTime",
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Countdown with progress indicator
                                  Column(
                                    children: [
                                      Text(
                                        "${languageService.get('in_minutes')} $_minutesToNextAarti ${languageService.get('minutes')}",
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 14 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value: (_minutesToNextAarti / 180).clamp(
                                          0.0,
                                          1.0,
                                        ), // Assuming max 180 minutes
                                        backgroundColor: Colors.grey.shade300,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.deepOrange,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Auto-scrolling horizontal images
                            SizedBox(
                              height: isSmallScreen ? 160 : 200,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                          image: AssetImage(images[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.5,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      bottomLeft: Radius.circular(
                                                        16,
                                                      ),
                                                      bottomRight: Radius.circular(
                                                        16,
                                                      ),
                                                    ),
                                              ),
                                              child: Text(
                                                languageService.get('live_darshan_available'),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: isSmallScreen ? 12 : 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 12 : 16),

                            // Quick action buttons section
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 12 : 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    languageService.get('quick_services'),
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 18 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF061C42),
                                    ),
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 8 : 12),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 8 : 16,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      isSmallScreen ? 12 : 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        // First row of circular buttons
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _buildCircularActionButton(
                                              icon: Icons.confirmation_number,
                                              label: languageService.get('darshan_ticket'),
                                              color: Colors.blue.shade700,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const DarshanTicketScreen(),
                                                  ),
                                                );
                                              },
                                              isSmallScreen: isSmallScreen,
                                            ),
                                            _buildCircularActionButton(
                                              icon: Icons.celebration,
                                              label: languageService.get('aarti_booking'),
                                              color: Colors.orange.shade700,
                                              onTap: () {},
                                              isSmallScreen: isSmallScreen,
                                            ),
                                            _buildCircularActionButton(
                                              icon: Icons.volunteer_activism,
                                              label: languageService.get('seva_donation'),
                                              color: Colors.green.shade700,
                                              onTap: () {},
                                              isSmallScreen: isSmallScreen,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: isSmallScreen ? 16 : 20),
                                        // Second row of circular buttons
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _buildCircularActionButton(
                                              icon: Icons.live_tv,
                                              label: languageService.get('live_darshan'),
                                              color: Colors.purple.shade700,
                                              onTap: () {},
                                              isSmallScreen: isSmallScreen,
                                            ),
                                            _buildCircularActionButton(
                                              icon: Icons.calendar_today,
                                              label: languageService.get('festival_calendar'),
                                              color: Colors.red.shade700,
                                              onTap: () {},
                                              isSmallScreen: isSmallScreen,
                                            ),
                                            _buildCircularActionButton(
                                              icon: Icons.history_edu,
                                              label: languageService.get('temple_history'),
                                              color: Colors.teal.shade700,
                                              onTap: () {},
                                              isSmallScreen: isSmallScreen,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 16 : 24),
                              ],
                            ),

                            // Temple feature cards section
                            Column(
                              children: [
                                // Section header with decorative elements
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 8 : 16,
                                    vertical: isSmallScreen ? 12 : 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.orange.shade300,
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text(
                                          languageService.get('temple_services_info'),
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 16 : 20,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF061C42),
                                            shadows: [
                                              Shadow(
                                                blurRadius: 2.0,
                                                color: Colors.white.withOpacity(
                                                  0.5,
                                                ),
                                                offset: const Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.orange.shade300,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Feature cards grid
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 8 : 16,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final gridWidth = constraints.maxWidth;
                                      final crossAxisCount = gridWidth > 600
                                          ? 3
                                          : gridWidth > 400
                                              ? 2
                                              : 1;
                                      final childAspectRatio = gridWidth > 600
                                          ? 1.1
                                          : gridWidth > 400
                                              ? 1.3
                                              : 1.5;

                                      return GridView.count(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        crossAxisCount: crossAxisCount,
                                        childAspectRatio: childAspectRatio,
                                        crossAxisSpacing: isSmallScreen ? 12 : 16,
                                        mainAxisSpacing: isSmallScreen ? 12 : 16,
                                        children: [
                                          _buildEnhancedFeatureCard(
                                            icon: Icons.access_time,
                                            title: languageService.get('darshan_timings'),
                                            subtitle: languageService.get('daily_schedule'),
                                            color: Colors.blue.shade700,
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.blue.shade50,
                                                Colors.lightBlue.shade50,
                                              ],
                                            ),
                                            onTap: () {},
                                            isSmallScreen: isSmallScreen,
                                          ),
                                          _buildEnhancedFeatureCard(
                                            icon: Icons.event,
                                            title: languageService.get('temple_events'),
                                            subtitle: languageService.get('festivals_ceremonies'),
                                            color: Colors.orange.shade700,
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.orange.shade50,
                                                Colors.amber.shade50,
                                              ],
                                            ),
                                            onTap: () {},
                                            isSmallScreen: isSmallScreen,
                                          ),
                                          _buildEnhancedFeatureCard(
                                            icon: Icons.room_service,
                                            title: languageService.get('temple_services'),
                                            subtitle: languageService.get('book_pooja'),
                                            color: Colors.green.shade700,
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.green.shade50,
                                                Colors.lightGreen.shade50,
                                              ],
                                            ),
                                            onTap: () {},
                                            isSmallScreen: isSmallScreen,
                                          ),
                                          if (crossAxisCount > 1 || gridWidth > 400)
                                            _buildEnhancedFeatureCard(
                                              icon: Icons.calendar_today,
                                              title: languageService.get('festival_calendar'),
                                              subtitle: languageService.get('dates_panchang'),
                                              color: Colors.purple.shade700,
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.purple.shade50,
                                                  Colors.deepPurple.shade50,
                                                ],
                                              ),
                                              onTap: () {},
                                              isSmallScreen: isSmallScreen,
                                            ),
                                          if (crossAxisCount > 1 || gridWidth > 400)
                                            _buildEnhancedFeatureCard(
                                              icon: Icons.notifications,
                                              title: languageService.get('announcements'),
                                              subtitle: languageService.get('temple_news'),
                                              color: Colors.red.shade700,
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.red.shade50,
                                                  Colors.orange.shade50,
                                                ],
                                              ),
                                              onTap: () {},
                                              isSmallScreen: isSmallScreen,
                                            ),
                                          if (crossAxisCount > 1 || gridWidth > 400)
                                            _buildEnhancedFeatureCard(
                                              icon: Icons.history,
                                              title: languageService.get('temple_history'),
                                              subtitle: languageService.get('sacred_heritage'),
                                              color: Colors.teal.shade700,
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.teal.shade50,
                                                  Colors.cyan.shade50,
                                                ],
                                              ),
                                              onTap: () {},
                                              isSmallScreen: isSmallScreen,
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                                // View all button
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    bottom: 8,
                                  ),
                                  child: Container(
                                    width: 140,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.orange.shade600,
                                          Colors.orange.shade800,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            languageService.get('view_all'),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.arrow_forward, size: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),
                              ],
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Circular action button method
  Widget _buildCircularActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    final buttonSize = isSmallScreen ? 70.0 : 80.0;
    final iconSize = isSmallScreen ? 24.0 : 28.0;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(buttonSize / 2),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(icon, color: color, size: iconSize),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced feature card method
  Widget _buildEnhancedFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Gradient gradient,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.circle,
                  size: 40,
                  color: color.withOpacity(0.1),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Icon(
                  Icons.circle,
                  size: 40,
                  color: color.withOpacity(0.1),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: isSmallScreen ? 18 : 22,
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 11 : 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}