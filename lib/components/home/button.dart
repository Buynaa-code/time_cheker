import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_cheker/const/colors.dart';
import 'package:time_cheker/const/text_field.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({super.key});

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  String? selectedDate;
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedDate', selectedDate ?? 'null');
    // Хадгалсан өгөгдлийг үүгээр тохируулах боломжтой
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Өгөгдлийг амжилттай хадгаллаа!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: saveData,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: informationColor6, // Үсгийн өнгө
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Дугуйруулах өнцөг
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 40, vertical: 15), // Доторх зай
        elevation: 5, // Тень үүсгэх
      ),
      child: Text(
        'Хадгалах',
        style: ktsBodyMediumBold.copyWith(color: whiteColor),
      ),
    );
  }
}
