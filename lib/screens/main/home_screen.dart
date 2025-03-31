import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_cheker/components/home/card.dart';
import 'package:time_cheker/components/home/dropDown.dart';
import 'package:time_cheker/const/colors.dart';
import 'package:time_cheker/const/spacing.dart';
import 'package:time_cheker/const/text_field.dart';
import 'package:time_cheker/screens/login/login_screen.dart';
import 'package:time_cheker/service/app/di.dart';
import 'package:time_cheker/service/model/date_info.dart';
import 'package:time_cheker/service/repository/repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = instance<Repository>();
  String? selectedDate;
  List<DateInfo> dateInfo = [];
  int? selectedMemberId;
  DateInfo? selectedDateInfo;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshData() async {
    // Refresh data logic here if needed
    setState(() {
      // Reset state or fetch new data
    });
  }

  Future<void> logout() async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: whiteColor,
        title: Row(
          children: [
            const Icon(Icons.exit_to_app, color: dangerColor5),
            const SizedBox(width: 10),
            Text(
              "Гарах",
              style: ktsBodyMassiveBold.copyWith(color: greyColor8),
            ),
          ],
        ),
        content: Text(
          "Та системээс гарахдаа итгэлтэй байна уу?",
          style: ktsBodyRegular.copyWith(color: greyColor5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Үгүй",
              style: ktsBodyRegularBold.copyWith(color: greyColor8),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: dangerColor5,
              foregroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Тийм",
              style: ktsBodyRegularBold.copyWith(color: whiteColor),
            ),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor2,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: greyColor2,
        backgroundColor: greyColor2,
        title: Text(
          "Нүүр хуудас",
          style: ktsBodyMassiveBold.copyWith(color: greyColor8),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: dangerColor5),
            onPressed: logout,
            tooltip: 'Гарах',
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: n16),
                DropdownWidget(
                  fetchDateInfo: _repository.fetchDateInfo,
                  onDateSelected: (dateInfo) {
                    setState(() {
                      selectedDateInfo = dateInfo;
                    });
                  },
                ),
                const SizedBox(height: n16),
                Text(
                  "Ирц бүртгэл",
                  style: ktsBodyMassiveBold.copyWith(color: greyColor8),
                ),
                const SizedBox(height: n16),
                Container(
                  height: MediaQuery.of(context).size.height - 240,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Cart(
                    selectedDateInfo: selectedDateInfo,
                  ),
                ),
                h24(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: informationColor6,
        onPressed: () {
          _refreshIndicatorKey.currentState?.show();
        },
        child: const Icon(Icons.refresh, color: whiteColor),
      ),
    );
  }
}
