import 'package:absensi/rekap_presensi.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:absensi/main.dart';
import 'package:absensi/screens/Guru/daftar_guru.dart';
import 'package:absensi/screens/Siswa/daftar_siswa.dart';

class SideMenuNavigation extends StatefulWidget {
  final String currentPage;

  const SideMenuNavigation({
    Key? key,
    this.currentPage = 'home',
  }) : super(key: key);

  @override
  State<SideMenuNavigation> createState() => _SideMenuNavigationState();
}

class _SideMenuNavigationState extends State<SideMenuNavigation> {
  SideMenuController sideMenu = SideMenuController();
  bool isCollapsed = false;
  late String activePage;

  @override
  void initState() {
    super.initState();
    activePage = widget.currentPage;
    // Set initial page
    sideMenu.changePage(widget.currentPage == 'home'
        ? 0
        : widget.currentPage == 'daftar_siswa'
            ? 1
            : widget.currentPage == 'daftar_guru'
                ? 2
                : widget.currentPage == 'rekap_presensi'
                    ? 3
                    : 0);
  }

  void _navigateTo(BuildContext context, Widget page, String pageId) {
    setState(() {
      activePage = pageId;
    });

    if (MediaQuery.of(context).size.width < 600) {
      Navigator.pop(context);
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildToggleButton({required bool isExpanded}) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          isExpanded ? Icons.chevron_left : Icons.chevron_right,
          key: ValueKey<bool>(isExpanded),
          color: Colors.white,
        ),
      ),
      onPressed: () => setState(() => isCollapsed = !isCollapsed),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final menuWidth =
        isMobile ? screenWidth * 0.7 : (isCollapsed ? 80.0 : 280.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: menuWidth,
      child: Stack(
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              backgroundColor: const Color(0xFF9c8aa5),
              displayMode: isMobile
                  ? SideMenuDisplayMode.auto
                  : (isCollapsed
                      ? SideMenuDisplayMode.compact
                      : SideMenuDisplayMode.auto),
              hoverColor: const Color(0xFF6d5f7c),
              selectedColor: const Color(0xFF6d5f7c),
              selectedTitleTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              unselectedTitleTextStyle: const TextStyle(
                color: Colors.white70,
              ),
              selectedIconColor: Colors.white,
              unselectedIconColor: Colors.white70,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.zero,
              ),
            ),
            title: !isCollapsed
                ? Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6d5f7c),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Progressive Learning Center',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        if (!isMobile)
                          _buildToggleButton(isExpanded: !isCollapsed),
                      ],
                    ),
                  )
                : null,
            items: [
              _buildMenuItem(
                title: 'Absensi Hari Ini',
                icon: Icons.calendar_today,
                pageId: 'home',
                onTap: () => _navigateTo(context, const HomeScreen(), 'home'),
              ),
              _buildMenuItem(
                title: 'Daftar Siswa',
                icon: Icons.menu_book,
                pageId: 'daftar_siswa',
                onTap: () =>
                    _navigateTo(context, const DaftarSiswa(), 'daftar_siswa'),
              ),
              _buildMenuItem(
                title: 'Daftar Guru',
                icon: Icons.assignment_ind,
                pageId: 'daftar_guru',
                onTap: () =>
                    _navigateTo(context, const DaftarGuru(), 'daftar_guru'),
              ),
              _buildMenuItem(
                title: 'Rekap Presensi',
                icon: Icons.assessment,
                pageId: 'rekap_presensi',
                onTap: () => _navigateTo(
                    context, const RekapPresensi(), 'rekap_presensi'),
              ),
            ],
          ),
          if (!isMobile && isCollapsed)
            Positioned(
              top: 20,
              right: 16,
              child: _buildToggleButton(isExpanded: false),
            ),
        ],
      ),
    );
  }

  SideMenuItem _buildMenuItem({
    required String title,
    required IconData icon,
    required String pageId,
    required VoidCallback onTap,
  }) {
    final isActive = activePage == pageId;

    return SideMenuItem(
      title: title,
      icon: Icon(icon, color: isActive ? Colors.white : Colors.white70),
      onTap: (_, __) {
        sideMenu.changePage(pageId == 'home'
            ? 0
            : pageId == 'daftar_siswa'
                ? 1
                : pageId == 'daftar_guru'
                    ? 2
                    : pageId == 'rekap_presensi'
                        ? 3
                        : 0);
        onTap();
      },
    );
  }
}
