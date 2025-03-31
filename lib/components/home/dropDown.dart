// ignore: file_names
import 'package:flutter/material.dart';
import 'package:time_cheker/const/colors.dart';
import 'package:time_cheker/const/text_field.dart';
import 'package:time_cheker/service/model/date_info.dart';

class DropdownWidget extends StatefulWidget {
  final Future<List<DateInfo>> Function() fetchDateInfo;
  final void Function(DateInfo) onDateSelected;

  const DropdownWidget(
      {super.key, required this.fetchDateInfo, required this.onDateSelected});

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  DateInfo? selectedDateInfo;
  late Future<List<DateInfo>> futureDates;

  @override
  void initState() {
    super.initState();
    futureDates = widget.fetchDateInfo();
    _initializeSelectedDate();
  }

  Future<void> _initializeSelectedDate() async {
    try {
      final dates = await futureDates;
      if (dates.isNotEmpty) {
        if (mounted) {
          // Find the date that matches the kharuulakh value
          DateInfo defaultDate = dates.last; // Default to last

          // Get the kharuulakh value from the first date (all dates have the same value)
          String? kharuulakhValue = dates.first.kharuulakh;

          if (kharuulakhValue != null && kharuulakhValue.isNotEmpty) {
            // Find the date that matches the kharuulakh value
            for (var date in dates) {
              if ("${date.date} - ${date.day}" == kharuulakhValue) {
                defaultDate = date;
                break;
              }
            }
          }

          setState(() {
            selectedDateInfo = defaultDate;
          });
          widget.onDateSelected(defaultDate);
        }
      }
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DateInfo>>(
      future: futureDates,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Алдаа гарлаа: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Огноо олдсонгүй'));
        }

        List<DateInfo> dates = snapshot.data!;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: informationColor6,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButton<DateInfo>(
            focusColor: informationColor6,
            dropdownColor: informationColor6,
            borderRadius: BorderRadius.circular(20),
            value: selectedDateInfo,
            hint: Text(
              dates.isNotEmpty && dates.first.kharuulakh != null
                  ? dates.first.kharuulakh!
                  : "03/30 - Ням",
              style: ktsBodyLargeBold.copyWith(color: whiteColor),
            ),
            isExpanded: true,
            underline: const SizedBox(),
            iconEnabledColor: whiteColor,
            items: dates
                .map((dateInfo) => DropdownMenuItem<DateInfo>(
                      value: dateInfo,
                      child: Text(
                        "${dateInfo.date} - ${dateInfo.day}",
                        style: ktsBodyLargeBold.copyWith(color: whiteColor),
                      ),
                    ))
                .toList(),
            onChanged: (newDateInfo) {
              setState(() {
                selectedDateInfo = newDateInfo;
              });
              if (newDateInfo != null) {
                widget.onDateSelected(newDateInfo); // Callback-аар дамжуулах
              }
            },
          ),
        );
      },
    );
  }
}
