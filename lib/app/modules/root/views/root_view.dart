import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../home/views/home_view.dart';
import '../../saved/views/saved_view.dart';
import '../../search/views/search_view.dart';
import '../controllers/root_controller.dart';
import 'widgets/menu_view.dart';

class RootView extends GetView<RootController> {
  RootView({Key? key}) : super(key: key);

  static final List<PersistentTabConfig> _tabs = [
    PersistentTabConfig(
      screen: const HomeView(),
      item: ItemConfig(
        icon: HeroIcon(HeroIcons.home),
        title: 'Home',
        activeForegroundColor: Colors.blue,
        inactiveForegroundColor: Colors.grey,
        textStyle: GoogleFonts.poppins(fontSize: 10.sp),
      ),
    ),
    PersistentTabConfig(
      screen: const SearchView(),
      item: ItemConfig(
        icon: HeroIcon(HeroIcons.magnifyingGlass),
        title: 'Search',
        activeForegroundColor: Colors.blue,
        inactiveForegroundColor: Colors.grey,
        textStyle: GoogleFonts.poppins(fontSize: 10.sp),
      ),
    ),
    PersistentTabConfig(
      screen: const SavedView(),
      item: ItemConfig(
        icon: HeroIcon(HeroIcons.bookmark),
        title: 'Saved',
        activeForegroundColor: Colors.blue,
        inactiveForegroundColor: Colors.grey,
        textStyle: GoogleFonts.poppins(fontSize: 10.sp),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(width: 0.65.sw, child: const MenuView()),
      drawerEdgeDragWidth: 0.0,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.surface,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: PersistentTabView(
          controller: controller.persistentTabController,
          tabs: _tabs,
          navBarBuilder: (navBarConfig) =>
              Style6BottomNavBar(navBarConfig: navBarConfig),
        ),
      ),
    );
  }
}
