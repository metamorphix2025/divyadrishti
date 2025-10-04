import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_colors.dart';
import 'utils/app_images.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/sos_screen.dart';
import 'screens/parking_screen.dart';
import 'screens/more_screen.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/gradient_background.dart';
import 'services/language_service.dart'; // Add this import

void main() {
  runApp(const TempleApp());
}

class TempleApp extends StatelessWidget {
  const TempleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageService(),
      child: MaterialApp(
        title: 'Temple App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.navy,
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: AppColors.navy,
            unselectedItemColor: Colors.grey,
          ),
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const SosScreen(),
    ParkingScreen(),
    const MoreScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "Divya Drishti",
          logoPath: AppImages.logo,
          profileImagePath: AppImages.profile,
          onNotificationTap: () {
            // TODO: Add notification action
          },
          onProfileTap: () {
            // TODO: Add profile action
          },
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTabTapped: _onTabTapped,
        ),
      ),
    );
  }
}