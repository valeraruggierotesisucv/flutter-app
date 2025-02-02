import 'package:flutter/material.dart';

// Define the tab data structure
class TabItem {
  final int id;
  final String title;

  TabItem({required this.id, required this.title});
}

class Tabs extends StatefulWidget {
  final List<TabItem> tabs;  
  final Function(int) onTabTap;
  const Tabs({super.key, required this.tabs, required this.onTabTap});
  
  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin{
   late TabController _tabController;
    
   @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.tabs.length);
  }

 @override
 void dispose() {
   _tabController.dispose();
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
    length: 3,
    child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.blue,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 3, color: Colors.blue),
          insets: EdgeInsets.symmetric(horizontal: 16.0),
          borderRadius: BorderRadius.circular(10),
        ),
          tabs: widget.tabs.map((tab) => Tab(text: tab.title)).toList(),
          onTap: (index) {
            widget.onTabTap(widget.tabs[index].id);
          },
        ),
    );
  }
}
