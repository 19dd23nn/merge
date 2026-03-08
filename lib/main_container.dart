import 'package:flutter/material.dart';
import 'package:merge/screens/pets_screen.dart';
import 'package:merge/main.dart';
import 'package:merge/screens/setting_screen.dart';
import 'package:merge/botbar.dart';
import 'package:merge/appbar.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer>
    with TickerProviderStateMixin {
  int _selectedIndex = 1; // Default to Home
  int _previousIndex = 1;
  late AnimationController _animationController;
  late Animation<double> _animation;

  static const List<Widget> _widgetOptions = <Widget>[
    PetsScreen(),
    MainScreen(),
    SettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final isGoingRight = _selectedIndex > _previousIndex;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SharedAppBar(backgroundColor: Colors.transparent),
      body: Stack(
        children: [
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: Offset(isGoingRight ? -1.0 : 1.0, 0.0),
            ).animate(_animation),
            child: _widgetOptions[_previousIndex],
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset(isGoingRight ? 1.0 : -1.0, 0.0),
              end: Offset.zero,
            ).animate(_animation),
            child: _widgetOptions[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BotBar(
        currentScreenIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
