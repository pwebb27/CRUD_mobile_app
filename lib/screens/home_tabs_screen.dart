import 'package:crud_mobile_app/screens/data_entry_view_screen.dart';
import 'package:crud_mobile_app/screens/view_data_screen.dart';
import 'package:flutter/material.dart';

class HomeTabsScreen extends StatefulWidget {
  const HomeTabsScreen({super.key});

  @override
  State<HomeTabsScreen> createState() => _HomeTabsScreenState();
}

class _HomeTabsScreenState extends State<HomeTabsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,

      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 119, 179,1),
          title: const Text('Simple CRUD App'),
          bottom: const TabBar(indicatorColor: Colors.white, tabs: <Widget>[
            Tab(child: Text('Data Entry')),
            Tab(
              child: Text('Messages'),
            )
          ]),
        ),
        body: const TabBarView( 

          
            children: [
              DataEntryViewScreen(),
              ViewDataScreen(),
            ],
          ),
        ),
      );
}
