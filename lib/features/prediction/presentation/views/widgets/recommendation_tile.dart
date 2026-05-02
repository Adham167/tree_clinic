
import 'package:flutter/material.dart';

class RecommendationTile extends StatelessWidget {
  const RecommendationTile({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: Icon(icon, color: Colors.green),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          children: children,
        ),
      ),
    );
  }
}
