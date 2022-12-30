import 'package:crud_mobile_app/screens/data_entry_view_screen.dart';
import 'package:crud_mobile_app/screens/view_data_screen.dart';
import 'package:flutter/material.dart';

class HomeTabsScreen extends StatefulWidget {
  const HomeTabsScreen({super.key});

  @override
  State<HomeTabsScreen> createState() => _HomeTabsScreenState();
}

class _HomeTabsScreenState extends State<HomeTabsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) FocusScope.of(context).unfocus();
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 119, 179, 1),
          title: const Text('Simple CRUD App'),
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: const <Tab>[
                Tab(child: Text('Data Entry')),
                Tab(
                  child: Text('Messages'),
                )
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            DataEntryViewScreen(),
            ViewDataScreen(),
          ],
        ),
      );
}
