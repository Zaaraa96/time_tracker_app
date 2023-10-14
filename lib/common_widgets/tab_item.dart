
import 'package:flutter/material.dart';

enum TabItem { jobs, entries, account }

class TabItemData {
  const TabItemData({required this.title, required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(title: 'Jobs', icon: Icons.work),
    TabItem.entries: TabItemData(title: 'Entries', icon: Icons.view_headline),
    TabItem.account: TabItemData(title: 'Account', icon: Icons.person),
  };

  static  NavigationDestination _buildItem(TabItemData tabItem) {
    return NavigationDestination(label: tabItem.title, icon: Icon(tabItem.icon));
  }
  static  NavigationRailDestination _buildRailItem(TabItemData tabItem) {
    return NavigationRailDestination(
      label: Text(tabItem.title),
      icon: Icon(tabItem.icon),
    );
  }
  static  List<NavigationDestination> buildNavigationDestination(){
    List<NavigationDestination> navigationDestinations = [];
    for (final item in allTabs.entries)
      {
        navigationDestinations.add(_buildItem(item.value));
      }
    return navigationDestinations;
  }
  static  List<NavigationRailDestination> buildRainNavigationDestination(){
    List<NavigationRailDestination> navigationDestinations = [];
    for (final item in allTabs.entries)
      {
        navigationDestinations.add(_buildRailItem(item.value));
      }
    return navigationDestinations;
  }
}