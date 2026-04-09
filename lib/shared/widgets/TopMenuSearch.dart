import 'package:flutter/material.dart';

class SearchApp extends StatefulWidget {
  const SearchApp({super.key});
  @override
  State<SearchApp> createState() => _SearchAppState();
}
class _SearchAppState extends State<SearchApp> {
  final FocusNode _focusNode = FocusNode();
  bool _searchFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _searchFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _searchFocused ? Colors.white : const Color(0xFFEEF0F1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _searchFocused
              ? const Color(0xFF0A66C2)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: 'Rechercher',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
