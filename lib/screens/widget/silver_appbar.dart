import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatefulWidget {
  final String title;
  final VoidCallback? onAddPressed; // Callback untuk ikon "+"
  final double searchBarWidth; // Lebar search bar (default: 250)

  const CustomSliverAppBar({
    Key? key,
    required this.title,
    this.onAddPressed,
    this.searchBarWidth = 250.0, // Default panjang search bar
  }) : super(key: key);

  @override
  _CustomSliverAppBarState createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  bool _isSearchBarVisible = false; // Untuk toggle search bar

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFFbdaec6),
      title: Row(
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      pinned: true,
      expandedHeight: 60,
      automaticallyImplyLeading: false,
      actions: [
        // Search bar yang bisa muncul di sisi kanan
        if (_isSearchBarVisible)
          Container(
            width: widget.searchBarWidth, // Mengatur panjang search bar
            margin: const EdgeInsets.only(right: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        // Tombol search untuk mengaktifkan/deactivate search bar
        IconButton(
          icon: Icon(
            _isSearchBarVisible ? Icons.close : Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isSearchBarVisible = !_isSearchBarVisible;
            });
          },
        ),
        // Tombol "+"
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: widget.onAddPressed,
          ),
        ),
      ],
    );
  }
}
