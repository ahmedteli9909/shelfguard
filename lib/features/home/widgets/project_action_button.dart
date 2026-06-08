import 'package:flutter/material.dart';

class ProjectActionButton extends StatelessWidget {
  const ProjectActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9468EC), Color(0xFF7748D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(99),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            offset: const Offset(0, 7),
            blurRadius: 13,
            spreadRadius: -3,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(99),
          onTap: () {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Add Product',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontFamily: 'Mulish',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
