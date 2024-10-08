import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:klr/barcode_scanner_page.dart'; // Ensure correct import path
import 'package:klr/demobarcode.dart';
import 'package:klr/scert.dart';
import 'package:klr/search_page.dart'; // Ensure correct import path
import 'package:provider/provider.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (context) => Result(),)],child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MainWidget> {
  int _selectedIndex = 0;
  String appVersion = 'Version: 1.0.0';
  String _selectedLanguage = 'English'; // Default language
  bool isLoading=false;

  final List<Widget> _pages = [
    Home(),
    SearchPage(),
    // ScannerPage(),
    DemoScanner(),
    
  ];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Result>(context,listen: false).FetchLang("english");

  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _selectLanguage(String language)async {
    setState(() {
      isLoading=true;
    });
    log(isLoading.toString());
         await Provider.of<Result>(context,listen: false).FetchLang(language);
    
    setState(() {
      _selectedLanguage = language;
      isLoading=false;
    });
  
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _titles = [
      'K-Lottery',
      'Search',
      'Scanner',
      'Profile',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'K-Lottery' : _titles[_selectedIndex],
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 20, 28, 137),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            onSelected: _selectLanguage,
            icon: Icon(Icons.language, color: Colors.white),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'english',
                  child: Text('English'),
                ),
                PopupMenuItem(
                  value: 'malayalam',
                  child: Text('Malayalam'),
                ),
                PopupMenuItem(
                  value: 'tamil',
                  child: Text('Tamil'),
                ),
                PopupMenuItem(
                  value: 'hindi',
                  child: Text('Hindi'),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 28, 137),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'K-Lottery Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    appVersion,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.update),
              title: Text('Update'),
              onTap: () {
                Navigator.pop(context);
                // Add functionality here for "Update"
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Disclaimer'),
              onTap: () {
                Navigator.pop(context);
                // Add functionality here for "Disclaimer"
              },
            ),
            ListTile(
              leading: Icon(Icons.star_rate),
              title: Text('Rate Us'),
              onTap: () {
                Navigator.pop(context);
                // Add functionality here for "Rate Us"
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                // Add functionality here for "Privacy Policy"
              },
            ),
          ],
        ),
      ),
      body:  isLoading==false?
      _pages[_selectedIndex]:Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2_outlined),
            label: 'Scanner',
          ),
         
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}
