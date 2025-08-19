import 'package:flutter/material.dart';

class MainDrawerWidget extends StatelessWidget {
  const MainDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),            
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF28BCBA),
                  Color(0xFF28BCBA).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [                
                  Image.asset('assets/images/konvels_logo.png')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
