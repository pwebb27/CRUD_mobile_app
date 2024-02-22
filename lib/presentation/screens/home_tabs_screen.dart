// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:crud_mobile_app/presentation/screens/data_entry_view_screen.dart';
import 'package:crud_mobile_app/presentation/screens/view_data_screen.dart';

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
        if (_tabController.index == 1 && _tabController.previousIndex == 0) {
          FocusScope.of(context).unfocus();
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _tabController.index==1? Colors.white:Colors.transparent,
        //Used to show background container color when keyboard drops
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
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
  const CustomTabBarViewPhysics({super.parent});

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
