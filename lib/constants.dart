import 'package:flutter/material.dart';

// Colors
const primaryTextColor = Color(0xFF000000);
const tertiaryTextColor = Color(0xFFA0A0A0);
const eventTypeChipColor = Color(0xFFF4F4F4);
const eventTypeChipTextColor = Color(0xFF1D1D1D);
const genreChipColor = Color(0x59000000);
const genreChipTextColor = Color(0xFFFFFFFF);
const curateDateTextColor = Color(0xFF48484A);
const filterMenuChipBorderColor = Color(0xFFE5E5EA);
const filterMenuChipTextColor = Color(0xFF636366);
const dDayTextColor = Color(0xFF9D9D9D);
const dDayChipColor = Color(0x99000000);

class Constants {
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);

  //MARK: - dark
  static const dark100 = Color(0xFF141414);
  static const dark80 = Color(0xFF1F1F1F);
  static const dark60 = Color(0xFF282828);
  static const dark40 = Color(0xFF414042);
  static const dark20 = Color(0xFF57585B);
  static const dark00 = Color(0xFF929497);
  //MARK: - grey
  static const grey100 = Color(0xFFA7A9AC);
  static const grey80 = Color(0xFFBBBDC0);
  static const grey60 = Color(0xFFD1D2D3);
  static const grey40 = Color(0xFFE6E6E6);
  static const grey20 = Color(0xFFF6F6F6);

  static const title1TextStyle = TextStyle(
    color: dark100,
    fontSize: 48,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w700,
  );

  static const title2TextStyle = TextStyle(
    color: dark100,
    fontSize: 32,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w700,
  );

  static const title3TextStyle = TextStyle(
    color: dark100,
    fontSize: 24,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w700,
  );

  static const largeBoldTextStyle = TextStyle(
    color: dark100,
    fontSize: 18,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w700,
  );

  static const largeNormalTextStyle = TextStyle(
    color: dark100,
    fontSize: 18,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w500,
  );

  static const largeThinTextStyle = TextStyle(
    color: dark100,
    fontSize: 18,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w400,
  );

  static const regularBoldTextStyle = TextStyle(
    color: dark100,
    fontSize: 16,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w700,
  );

  static const regularNormalTextStyle = TextStyle(
    color: dark100,
    fontSize: 16,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w500,
  );

  static const regularThinTextStyle = TextStyle(
    color: dark100,
    fontSize: 14,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w400,
  );

  static const smallBoldTextStyle = TextStyle(
    color: dark100,
    fontSize: 14,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w700,
  );

  static const smallNormalTextStyle = TextStyle(
    color: dark100,
    fontSize: 14,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w500,
  );

  static const smallThinTextStyle = TextStyle(
    color: dark100,
    fontSize: 14,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w400,
  );

  static const tinyBoldTextStyle = TextStyle(
    color: dark100,
    fontSize: 12,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w700,
  );

  static const tinyNormalTextStyle = TextStyle(
    color: dark100,
    fontSize: 12,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w500,
  );

  static const tinyThinTextStyle = TextStyle(
    color: dark100,
    fontSize: 12,
    // fontFamily: 'Epilogue',
    fontWeight: FontWeight.w400,
  );
}

// Text Styles
var navTextStyle = const TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w600,
  color: primaryTextColor,
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var selectedTabTextStyle = const TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
  color: primaryTextColor,
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var unselectedTabTextStyle = const TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
  color: tertiaryTextColor,
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var eventTypeChipTextStyle = const TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  color: eventTypeChipTextColor,
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var genreChipTextStyle = const TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  color: genreChipTextColor,
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var curateEventTitleStyle = const TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.w600,
  color: primaryTextColor,
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var curateEventDateTextStyle = const TextStyle(
  fontSize: 13.0,
  fontWeight: FontWeight.w400,
  color: curateDateTextColor,
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var filterMenuChipTextStyle = const TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  color: curateDateTextColor,
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var dDayChipTextStyle = const TextStyle(
  fontSize: 13.0,
  fontWeight: FontWeight.w400,
  color: Colors.white,
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var eventDetailTypeTextStyle = const TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  color: Color(0xFF1D1D1D),
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var eventDetailGenreTextStyle = const TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  color: Color(0xFFFFFFFF),
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var eventDetailNameTextStyle = const TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
  color: Color(0xFF000000),
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);

var eventDetailDateTextStyle = const TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
  color: Color(0xFF5D5D5D),
  fontFamily: 'Pretendard',
  decoration: TextDecoration.none,
);
