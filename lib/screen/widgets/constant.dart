import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data.dart';

// const kMainColor = Color(0xFF3F8CFF);
const kPrimaryColor = Color(0xFF69B22A);
const kNeutralColor = Color(0xFF121F3E);
const kSubTitleColor = Color(0xFF4F5350);
const kLightNeutralColor = Color(0xFF8E8E8E);
const kDarkWhite = Color(0xFFF6F6F6);
const kWhite = Color(0xFFFFFFFF);
const kBorderColorTextField = Color(0xFFE3E3E3);
const ratingBarColor = Color(0xFFFFB33E);

final kTextStyle = GoogleFonts.inter(
  color: kNeutralColor,
);

const kButtonDecoration = BoxDecoration(
  color: kPrimaryColor,
  borderRadius: BorderRadius.all(
    Radius.circular(40.0),
  ),
);

InputDecoration kInputDecoration = const InputDecoration(
  hintStyle: TextStyle(color: kSubTitleColor),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(6.0),
    ),
    borderSide: BorderSide(color: kNeutralColor, width: 2),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(
      color: kBorderColorTextField,
    ),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

bool isClient = false;
bool isFreelancer = false;
bool isFavorite = false;
const String currencySign = '₹';

//__________Gender______________________________________________________
List<String> gender = [
  'Male',
  'Female',
];
String selectedGender = 'Male';

List<String> catName = [
  'Graphics Design',
  'Video Editing',
  'Digital Marketing',
  'Business',
  'Writing & Translation',
  'Programming',
  'Lifestyle'
];

List<String> catIcon = [
  'images/graphic.png',
  'images/videoicon.png',
  'images/dm.png',
  'images/b.png',
  'images/t.png',
  'images/p.png',
  'images/l.png'
];


//__________Language List_______________________________________________
List<String> language = [
  'English',
  'Bengali',
];
String selectedLanguage = 'English';

//__________Language Level_______________________________________________
List<String> languageLevel = [
  'Fluent',
  'Weak',
];
String selectedLanguageLevel = 'Fluent';

//__________Skill Level_______________________________________________
List<String> skillLevel = [
  'Expert',
  'Fresher',
];
String selectedSkillLevel = 'Expert';

//__________performance_period___________________________________________________
List<String> period = [
  'Last Month',
  'This Month',
];
String selectedPeriod = 'Last Month';

//__________statistics_period___________________________________________________
List<String> staticsPeriod = [
  'Last Month',
  'This Month',
];
String selectedStaticsPeriod = 'Last Month';

//__________statistics_period___________________________________________________
List<String> earningPeriod = [
  'Last Month',
  'This Month',
];
String selectedEarningPeriod = 'Last Month';

Map<String, double> dataMap = {
  "Impressions": 5,
  "Interaction": 3,
  "Reached-Out": 2,
};

//__________Category______________________________________________________
List<String> category = [
  'Digital Marketing',
  'App Development',
  'Graphics Design',
];

String selectedCategory = 'App Development';

//__________SubCategory______________________________________________________
List<String> subcategory = [
  'Flutter',
  'React Native',
  'Java',
];

String selectedSubCategory = 'Flutter';

//__________ServiceType______________________________________________________
List<String> serviceType = [
  'Online',
  'Offline',
];

String selectedServiceType = 'Online';

//__________time______________________________________________________
List<String> deliveryTime = [
  '3 days',
  '5 days',
  '7 days',
  '12 days',
  '15 days',
  '20 days',
];

String selectedDeliveryTime = '3 days';

//__________time______________________________________________________
List<String> pageCount = [
  '10 screen',
  '15 days',
  '20 days',
];

String selectedPageCount = '10 screen';

List<TitleModel> list = [
  TitleModel("Responsive design", false),
  TitleModel("Prototype", false),
  TitleModel("Source file", false),
];

List<TitleModel> selectedTitle = [];

List<String> titleList = [
  'Active',
  'Pending',
  'Completed',
  'Cancelled',
];

String isSelected = 'Active';

List<String> deliveryTimeList = [
  '3 days',
  '5 days',
  '7 days',
  '12 days',
  '15 days',
  '20 days',
];

String selectedDeliveryTimeList = '3 days';

List<String> revisionTime = [
  '1 time',
  '2 time',
  '3 time',
  '4 time',
];

String selectedRevisionTime = '1 time';

List<String> reportTitle = [
  'Non original content',
  'Trademark Violations',
  'Copyright Violations',
  'Other reasons',
];

String selectedReportTitle = 'Non original content';

List<String> gateWay = [
  'PayPal',
  'Credit Card',
  'Bkash',
];

String selectedGateWay = 'PayPal';

List<String> currency = [
  '₹',
  '\$',
];

String selectedCurrency = '₹';


List<Color> colorList = [
  const Color(0xFF69B22A),
  const Color(0xFF144BD6),
  const Color(0xFFFF3B30),
];
