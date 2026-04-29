import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:furora/screen/camera_screen.dart';
import 'package:furora/screen/home_screen.dart';
import 'package:furora/screen/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainNavigation({super.key, required this.cameras});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  void _refreshHome(){
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _pages = [
      HomePage(),
      const Center(child: Text("Camera")),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        onTap: (index) async{
          if (index == 1){
            if(widget.cameras.isEmpty) return;
            await Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => CameraScreen(
                  cameras: widget.cameras, 
                  onGoHome: (){},
                ),
              ),
            );
            setState(() {
              _currentIndex = 0;
            });
          } else {
          setState(() => _currentIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: "Camera",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}