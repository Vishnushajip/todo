import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData prefixIcon;
  final String? suffixText;
  final int? maxLines;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    this.suffixText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(color: Colors.blue[900]),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        suffixText: suffixText,
        hintStyle: GoogleFonts.poppins(color: Colors.blue[200]),
        labelStyle: GoogleFonts.poppins(color: Colors.blue),
        suffixStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.blue[300]),
        prefixIcon: Icon(prefixIcon, color: Colors.blue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
    );
  }
}
