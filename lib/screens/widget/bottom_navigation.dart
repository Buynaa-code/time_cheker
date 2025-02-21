import 'package:flutter/material.dart';
import 'package:time_cheker/const/colors.dart';
import 'package:time_cheker/const/text_field.dart';
import 'package:time_cheker/screens/main/home_screen.dart';
import 'package:time_cheker/screens/main/profile_screen.dart';
import 'package:time_cheker/screens/main/search_screen.dart';

class BottomNavigationDemo extends StatefulWidget {
  const BottomNavigationDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationDemoState createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: greyColor8,
          boxShadow: [
            BoxShadow(
              color: greyColor8.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: AnimatedIconWidget(iconData: Icons.home),
              label: 'Нүүр',
            ),
            BottomNavigationBarItem(
              icon: AnimatedIconWidget(iconData: Icons.search),
              label: 'Хайх',
            ),
            BottomNavigationBarItem(
              icon: AnimatedIconWidget(iconData: Icons.person),
              label: 'Бүртгэл',
            ),
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          showUnselectedLabels: false,
          selectedLabelStyle: ktsBodySmall,
          unselectedLabelStyle: ktsBodySmall,
        ),
      ),
    );
  }
}

class AnimatedIconWidget extends StatefulWidget {
  final IconData iconData;

  const AnimatedIconWidget({super.key, required this.iconData});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedIconWidgetState createState() => _AnimatedIconWidgetState();
}

class _AnimatedIconWidgetState extends State<AnimatedIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(widget.iconData, size: 28),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
