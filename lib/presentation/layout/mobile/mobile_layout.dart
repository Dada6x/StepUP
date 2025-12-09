import 'package:flutter/material.dart';
import 'package:kyc_test/main.dart';
import 'package:kyc_test/presentation/layout/mobile/mobile_drawer.dart';
import 'package:kyc_test/presentation/layout/mobile/widgets/mobile_app_bar.dart';
import 'package:kyc_test/presentation/pages/home/mobile_home.dart';
import 'package:kyc_test/presentation/pages/profile/profile_page.dart';
import 'package:kyc_test/presentation/pages/search/search_page.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    logger.i("working on Mobile Device");

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // backgroundColor: Color(0xFF040404),

      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.background,
      //   actions: [
      //     IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      //     Obx(
      //       () => IconButton(
      //         icon: Icon(
      //           app.isDarkMode ? Icons.dark_mode : Icons.light_mode,
      //         ),
      //         onPressed: app.toggleTheme,
      //       ),
      //     ),
      //   ],
      //   title: const Text("Obsidian"),
      // ),
      appBar: mobileAppBar(),
      drawer: const MobileDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Theme.of(context).cardColor,
        fixedColor: app.isDarkMode ? Colors.white : Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: "Passwords"),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Memos"),
        ],
      ),
      body: _buildMobilePage(_selectedIndex),
    );
  }

  /// Map bottom nav index -> Mobile page widget
  Widget _buildMobilePage(int index) {
    switch (index) {
      case 0:
        //! Home
        return const HomePage();
      case 1:
        //! Search
        return const SearchPage();
      case 2:
        //! Profile
        return const ProfilePage();

      default:
        return const HomePage();
    }
  }
}
