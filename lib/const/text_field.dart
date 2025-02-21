import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

final textFieldStyle = GoogleFonts.ubuntu(
  color: text100,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.25,
);

final textFieldDisabledStyle = GoogleFonts.ubuntu(
  color: text100.withOpacity(0.8),
  fontSize: 14,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.25,
);

final textFieldHintStyle = GoogleFonts.ubuntu(
  color: greyColor4,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.25,
);

final textFieldDisabledHintStyle = GoogleFonts.ubuntu(
  color: greyColor3,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.25,
);

TextStyle get ktsTitleText => GoogleFonts.sourceSans3(
      fontSize: 26,
      height: 0.95,
      fontWeight: FontWeight.w800,
    );

TextStyle get ktsBodyDundBold => const TextStyle(
      fontFamily: 'GIP', // Use the GIP font family
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );

TextStyle get ktsBodySmall => GoogleFonts.rubik(
      fontSize: 12,
    );
TextStyle get ktsBodySmallBold => GoogleFonts.rubik(
      fontSize: 12,
      fontWeight: FontWeight.w800,
    );

TextStyle get ktsBodyRegular => GoogleFonts.rubik(
      fontSize: 14,
    );

TextStyle get ktsBodyRegularBold => GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.w800,
    );
TextStyle get ktsBodyRegularSemiBold => GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
TextStyle get ktsBodyMediumLight => GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w200,
    );
TextStyle get ktsBodyMedium => GoogleFonts.rubik(
      fontSize: 16,
    );
TextStyle get ktsBodyMediumBold => GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

TextStyle get ktsBodyLarge => GoogleFonts.rubik(
      fontSize: 18,
    );

TextStyle get ktsBodyLargeBold => GoogleFonts.rubik(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );

TextStyle get ktsBodyMassive => GoogleFonts.rubik(
      fontSize: 22,
    );

TextStyle get ktsBodyMassiveBold => GoogleFonts.rubik(
      fontSize: 22,
      fontWeight: FontWeight.w600,
    );

TextStyle get ktsBodyMassivePlus => GoogleFonts.rubik(
      fontSize: 32,
    );
TextStyle get ktsBodyMassivePlusSemiBold => GoogleFonts.rubik(
      fontSize: 32,
      fontWeight: FontWeight.w600,
    );

TextStyle get ktsBodyMassivePlusBold => GoogleFonts.rubik(
      fontSize: 32,
      fontWeight: FontWeight.w800,
    );

TextStyle get ktsBodyMassiveProBold => GoogleFonts.rubik(
      fontSize: 28,
      fontWeight: FontWeight.w600,
    );

TextStyle get ktsBodyMassivePlusPlusBold => GoogleFonts.rubik(
      fontSize: 42,
      fontWeight: FontWeight.w800,
    );
