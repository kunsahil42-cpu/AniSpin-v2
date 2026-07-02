import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Start typing to search anime",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}