import 'package:flutter/cupertino.dart';

import 'colors.dart';

Widget l1() => Container(
      height: 1.0,
      color: greyColor6.withOpacity(0.5),
    );

Widget h4() => const SizedBox(height: n4);

Widget h8() => const SizedBox(height: n8);

Widget h12() => const SizedBox(height: n12);

Widget h18() => const SizedBox(height: n18);

Widget h24() => const SizedBox(height: n24);

Widget h36() => const SizedBox(height: n36);

Widget h48() => const SizedBox(height: n48);

Widget w4() => const SizedBox(height: n4);

Widget w8() => const SizedBox(width: n8);

Widget w12() => const SizedBox(width: n12);

Widget w24() => const SizedBox(width: n24);

const n1 = 1.0;
const n4 = 4.0;
const n8 = 8.0;
const n12 = 12.0;
const n16 = 16.0;
const n18 = 18.0;
const n24 = 24.0;
const n36 = 36.0;
const n48 = 48.0;

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
