import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;

  const CustomSliverAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFFbdaec6),
      title: Text(
        title, // Menggunakan judul yang diberikan
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      pinned: true,
      expandedHeight: 60,
      automaticallyImplyLeading: false,
      flexibleSpace: const FlexibleSpaceBar(
        background: DecoratedBox(
          decoration: BoxDecoration(color: Color(0xFF666666)),
        ),
      ),
    );
  }
}
