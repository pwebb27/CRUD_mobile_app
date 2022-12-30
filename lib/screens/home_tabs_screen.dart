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
                             backgroundColor: Color.fromRGBO(103 , 154, 175, 1),

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
          physics: const CustomTabBarViewPhysics(),
          controller: _tabController,
          children: const [
            DataEntryViewScreen(),
            ViewDataScreen(),
          ],
        ),
      );
}

class CustomTabBarViewPhysics extends ScrollPhysics {
  const CustomTabBarViewPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomTabBarViewPhysics applyTo(ScrollPhysics? ancestor) =>
     CustomTabBarViewPhysics(parent: buildParent(ancestor)!);

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 100,
        stiffness: 100,
        damping: 0.5,
      );
}
