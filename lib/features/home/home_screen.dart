import 'package:flutter/material.dart';

import 'widgets/home_header.dart';
import 'widgets/search_bar.dart';
import 'widgets/quick_actions.dart';
import 'widgets/section_title.dart';
import 'widgets/horizontal_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          HomeHeader(),
          HomeSearchBar(),
          QuickActions(),

          SectionTitle(title: "🔥 Trending"),
          HorizontalList(),

          SectionTitle(title: "⭐ Continue Watching"),
          HorizontalList(),

          SizedBox(height: 30),
        ],
      ),
    );
  }
}