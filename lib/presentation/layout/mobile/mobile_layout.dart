import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:kyc_test/core/constants/themes/app_theme.dart';
import 'package:kyc_test/main.dart';
import 'package:kyc_test/presentation/layout/mobile/drawer.dart';
import 'package:kyc_test/presentation/layout/mobile/widgets/app_bar.dart';
import 'package:kyc_test/presentation/pages/home/deals_room.dart';
import 'package:kyc_test/presentation/pages/home/investor_dashBoard.dart';
import 'package:kyc_test/presentation/pages/home/mentor_dashboard.dart';
import 'package:kyc_test/presentation/pages/home/start_up_dashbord.dart';
import 'package:kyc_test/presentation/pages/messages/messages.dart';
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
      backgroundColor: AppTheme.cardDark,
      appBar: MobileAppBar(),
      drawer: const MobileDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color(0xFFF0EAE0),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Iconify(
              Mdi.view_dashboard,
              color: Color(0xFFF0EAE0),
              size: 25,
            ),
            label: "DashBoard",
          ),
          BottomNavigationBarItem(
            icon: Iconify(Mdi.message, color: Color(0xFFF0EAE0), size: 25),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Iconify(Mdi.search, color: Color(0xFFF0EAE0), size: 30),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Iconify(Mdi.face_profile, color: Color(0xFFF0EAE0), size: 25),
            label: "Profile",
          ),
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
        // return DealRoom();
        // return const MentorDashboardPage();
      // return const InvestorDashboardPage();
      return const StartupDashboardPage();

      case 1:
        //! Search
        return const Messages();
      case 3:
        //! Profile
        return const ProfilePage(
          name: 'Bilal DaaDaa',
          profession: 'Startup',
          countryCode: '+963',
          phoneNumber: '980 817 760',
          email: 'BialallDaaDaa@gmail.com',
          avatarUrl:
              // 'https://app.requestly.io/delay/2000/avatars.githubusercontent.com/u/124599?v=4',
              // "https://i.pinimg.com/736x/ef/26/71/ef2671102b52b630f6d2590b9e09678b.jpg",
              "https://i.pinimg.com/736x/03/eb/d6/03ebd625cc0b9d636256ecc44c0ea324.jpg"
        );
      case 2:
        //! Search
        return const SearchPage();

      default:
        return const MentorDashboardPage();
    }
  }
}
