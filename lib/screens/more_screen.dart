import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_background.dart';
import '../services/language_service.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Consumer<LanguageService>(
          builder: (context, languageService, child) {
            print('MoreScreen rebuilding with language: ${languageService.currentLocale}'); // Debug
            
            final screenWidth = MediaQuery.of(context).size.width;
            final isSmallScreen = screenWidth < 400;

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Header Section
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F5F0),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.more_horiz_rounded,
                                        color: Colors.deepOrange.shade700,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        languageService.get('more_services'),
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 22 : 26,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF061C42),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    languageService.get('more_services_description'),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF061C42),
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Quick Actions Grid
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.1,
                                children: [
                                  _buildQuickActionCard(
                                    icon: Icons.credit_card_rounded,
                                    title: languageService.get('donations'),
                                    subtitle: languageService.get('online_giving'),
                                    color: Colors.green,
                                    onTap: () {},
                                  ),
                                  _buildQuickActionCard(
                                    icon: Icons.volunteer_activism_rounded,
                                    title: languageService.get('volunteer'),
                                    subtitle: languageService.get('register_service'),
                                    color: Colors.orange,
                                    onTap: () {},
                                  ),
                                  _buildQuickActionCard(
                                    icon: Icons.shopping_basket_rounded,
                                    title: languageService.get('prasad_center'),
                                    subtitle: languageService.get('order_offerings'),
                                    color: Colors.purple,
                                    onTap: () {},
                                  ),
                                  _buildQuickActionCard(
                                    icon: Icons.language_rounded,
                                    title: languageService.get('language'),
                                    subtitle: languageService.get('multilingual'),
                                    color: Colors.blue,
                                    onTap: () => _showLanguageDialog(context),
                                  ),
                                ],
                              ),
                            ),

                            // Test Button to verify language change
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  _showLanguageDialog(context);
                                },
                                child: Text('Test Language Change - Current: ${languageService.currentLocale.languageCode}'),
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
          },
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(languageService.get('select_language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(context, 'English', 'en'),
              _buildLanguageOption(context, 'हिन्दी', 'hi'),
              _buildLanguageOption(context, 'ગુજરાતી', 'gu'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String languageName, String languageCode) {
    return ListTile(
      leading: const Icon(Icons.language, color: Colors.blue),
      title: Text(languageName),
      onTap: () {
        final languageService = Provider.of<LanguageService>(context, listen: false);
        print('Changing to: $languageCode');
        languageService.changeLanguage(languageCode);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF061C42),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}