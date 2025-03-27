import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
String get newsScreen {
    switch (locale.languageCode) {
      case 'hi':
        return 'समाचार';
      case 'pa':
        return 'ਖ਼ਬਰ';
      case 'bn':
        return 'সংবাদ';
      case 'gu':
        return 'સમાચાર';
      case 'mr':
        return 'बातम्या';
      case 'te':
        return 'వార్తలు';
      case 'ta':
        return 'செய்திகள்';
      case 'en':
        return 'News';
      default:
        return 'News'; // Default fallback value
    }
  }
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Language names in their respective languages
  Map<String, String> get languageNames {
    return {
      'en': 'English',
      'hi': 'हिन्दी',
      'pa': 'ਪੰਜਾਬੀ',
      'bn': 'বাংলা',
      'ta': 'தமிழ்',
      'te': 'తెలుగు',
      'mr': 'मराठी',
      'gu': 'ગુજરાતી',
    };
  }

  // Localized strings for login screen
  String get loginTitle {
    switch (locale.languageCode) {
      case 'hi':
        return 'लॉगिन';
      case 'pa':
        return 'ਲੌਗਿਨ';
      case 'bn':
        return 'লগইন';
      case 'ta':
        return 'உள்நுழைவு';
      case 'te':
        return 'లాగిన్';
      case 'mr':
        return 'लॉगिन';
      case 'gu':
        return 'લૉગિન';
      default:
        return 'Login';
    }
  }

  String get phoneNumberLabel {
    switch (locale.languageCode) {
      case 'hi':
        return 'फोन नंबर';
      case 'pa':
        return 'ਫੋਨ ਨੰਬਰ';
      case 'bn':
        return 'ফোন নম্বর';
      case 'ta':
        return 'தொலைபேசி எண்';
      case 'te':
        return 'ఫోన్ నంబర్';
      case 'mr':
        return 'फोन नंबर';
      case 'gu':
        return 'ફોન નંબર';
      default:
        return 'Phone Number';
    }
  }

  String get phoneHint {
    switch (locale.languageCode) {
      case 'hi':
        return '10 अंकों का नंबर दर्ज करें';
      case 'pa':
        return '10 ਅੰਕਾਂ ਦਾ ਨੰਬਰ ਦਰਜ਼ ਕਰੋ';
      case 'bn':
        return '10 সংখ্যার নম্বর লিখুন';
      case 'ta':
        return '10 இலக்க எண்ணை உள்ளிடவும்';
      case 'te':
        return '10 అంకెల నంబర్ను నమోదు చేయండి';
      case 'mr':
        return '10 अंकी क्रमांक प्रविष्ट करा';
      case 'gu':
        return '10 અંક નો નંબર દાખલ કરો';
      default:
        return 'Enter 10-digit number';
    }
  }

  String get continueButtonText {
    switch (locale.languageCode) {
      case 'hi':
        return 'जारी रखें';
      case 'pa':
        return 'ਜਾਰੀ ਰੱਖੋ';
      case 'bn':
        return 'চালিয়ে যান';
      case 'ta':
        return 'தொடரவும்';
      case 'te':
        return 'కొనసాగించండి';
      case 'mr':
        return 'सुरु ठेवा';
      case 'gu':
        return 'ચાલુ રાખો';
      default:
        return 'Continue';
    }
  }

  String get skipLoginText {
    switch (locale.languageCode) {
      case 'hi':
        return 'लॉगिन छोड़ें';
      case 'pa':
        return 'ਲੌਗਿਨ ਛੱਡੋ';
      case 'bn':
        return 'লগইন বাদ দিন';
      case 'ta':
        return 'உள்நுழைவை தவிர்க்கவும்';
      case 'te':
        return 'లాగిన్ వదలండి';
      case 'mr':
        return 'लॉगिन वगळा';
      case 'gu':
        return 'લૉગિન રદ કરો';
      default:
        return 'Skip Login';
    }
  }

  String get selectLanguageTitle {
    switch (locale.languageCode) {
      case 'hi':
        return 'भाषा चुनें';
      case 'pa':
        return 'ਭਾਸ਼ਾ ਚੁਣੋ';
      case 'bn':
        return 'ভাষা নির্বাচন করুন';
      case 'ta':
        return 'மொழி தேர்ந்தெடுக்கவும்';
      case 'te':
        return 'భాషను ఎంచుకోండి';
      case 'mr':
        return 'भाषा निवडा';
      case 'gu':
        return 'ભાષા પસંદ કરો';
      default:
        return 'Select Language';
    }
  }

  String get voiceAssistantLanguageNote {
    switch (locale.languageCode) {
      case 'hi':
        return 'आपकी पसंदीदा भाषा वॉइस असिस्टेंट द्वारा उपयोग की जाएगी';
      case 'pa':
        return 'ਤੁਹਾਡੀ ਪਸੰਦੀਦਾ ਭਾਸ਼ਾ ਵੌਇਸ ਸਹਾਇਕ ਦੁਆਰਾ ਵਰਤੀ ਜਾਵੇਗੀ';
      case 'bn':
        return 'আপনার পছন্দসই ভাষা ভয়েস সাহায্যকারী দ্বারা ব্যবহৃত হবে';
      case 'ta':
        return 'உங்கள் விருப்பமான மொழி குரல் உதவியாளரால் பயன்படுத்தப்படும்';
      case 'te':
        return 'మీ preferred భాష వాయిస్ అసిస్టెంట్ ద్వారా ఉపయోగించబడుతుంది';
      case 'mr':
        return 'आपली प्राधान्य असलेली भाषा व्हॉइस असिस्टंटद्वारे वापरली जाईल';
      case 'gu':
        return 'તમારી પસંદની ભાષા વૉઇસ આસિસ્ટન્ટ દ્વારા વાપરવામાં આવશે';
      default:
        return 'Your preferred language will be used by the Voice Assistant';
    }
  }

  String get invalidPhoneNumber {
    switch (locale.languageCode) {
      case 'hi':
        return 'वैध 10 अंकों का नंबर दर्ज करें';
      case 'pa':
        return 'ਵੈਧ 10 ਅੰਕਾਂ ਦਾ ਨੰਬਰ ਦਰਜ਼ ਕਰੋ';
      case 'bn':
        return 'বৈধ 10 সংখ্যার নম্বর লিখুন';
      case 'ta':
        return 'சரியான 10 இலக்க எண்ணை உள்ளிடவும்';
      case 'te':
        return 'చెల్లుబాటు అయ్యే 10 అంకెల నంబర్ను నమోదు చేయండి';
      case 'mr':
        return 'वैध 10 अंकी क्रमांक प्रविष्ट करा';
      case 'gu':
        return 'માન્ય 10 અંકનો નંબર દાખલ કરો';
      default:
        return 'Enter a valid 10-digit number';
    }
  }

  String get todaysWeather {
    switch (locale.languageCode) {
      case 'hi':
        return 'आज का मौसम';
      case 'pa':
        return 'ਅੱਜ ਦਾ ਮੌਸਮ';
      case 'bn':
        return 'আজকের আবহাওয়া';
      case 'gu':
        return 'આજનું હવામાન';
      case 'mr':
        return 'आजचे हवामान';
      default:
        return 'Today\'s Weather';
    }
  }

  String get detailedWeather {
    switch (locale.languageCode) {
      case 'hi':
        return 'विस्तृत मौसम';
      case 'pa':
        return 'ਵਿਸਥਾਰਤ ਮੌਸਮ';
      case 'bn':
        return 'বিস্তারিত আবহাওয়া';
      case 'gu':
        return 'વિગતવાર હવામાન';
      case 'mr':
        return 'तपशीलवार हवामान';
      default:
        return 'Detailed Weather';
    }
  }

  String get aiAssistant {
    switch (locale.languageCode) {
      case 'hi':
        return 'एआई सहायक';
      case 'pa':
        return 'ਏਆਈ ਸਹਾਇਕ';
      case 'bn':
        return 'AI সাহায্যকারী';
      case 'gu':
        return 'AI સહાયક';
      case 'mr':
        return 'एआय सहाय्यक';
      default:
        return 'AI Assistant';
    }
  }

  String get diseaseDetection {
    switch (locale.languageCode) {
      case 'hi':
        return 'रोग पहचान';
      case 'pa':
        return 'ਰੋਗ ਪਛਾਣ';
      case 'bn':
        return 'রোগ সনাক্তকরণ';
      case 'gu':
        return 'રોગ શોધ';
      case 'mr':
        return 'रोग शोधन';
      default:
        return 'Disease Detection';
    }
  }

  String get cropRecommendations {
    switch (locale.languageCode) {
      case 'hi':
        return 'फसल सिफारिशें';
      case 'pa':
        return 'ਫਸਲ ਸਿਫਾਰਸ਼ਾਂ';
      case 'bn':
        return 'ফসলের পরামর্শ';
      case 'gu':
        return 'પાક ભલામણો';
      case 'mr':
        return 'पीक शिफारशी';
      default:
        return 'Crop Recommendations';
    }
  }

  String get marketPrices {
    switch (locale.languageCode) {
      case 'hi':
        return 'बाजार भाव';
      case 'pa':
        return 'ਮੰਡੀ ਦੀਆਂ ਕੀਮਤਾਂ';
      case 'bn':
        return 'বাজার দাম';
      case 'gu':
        return 'બજાર ભાવ';
      case 'mr':
        return 'बाजार भाव';
      default:
        return 'Market Prices';
    }
  }

  String get governmentSchemes {
    switch (locale.languageCode) {
      case 'hi':
        return 'सरकारी योजनाएं';
      case 'pa':
        return 'ਸਰਕਾਰੀ ਯੋਜਨਾਵਾਂ';
      case 'bn':
        return 'সরকারি প্রকল্প';
      case 'gu':
        return 'સરકારી યોજનાઓ';
      case 'mr':
        return 'शासकीय योजना';
      default:
        return 'Government Schemes';
    }
  }

  String get governmentSchemesTitle {
    switch (locale.languageCode) {
      case 'hi':
        return 'किसान सेतु - सरकारी योजनाएं';
      case 'pa':
        return 'ਕਿਸਾਨ ਸੇਤੂ - ਸਰਕਾਰੀ ਯੋਜਨਾਵਾਂ';
      case 'bn':
        return 'কিসান সেতু - সরকারি প্রকল্প';
      case 'ta':
        return 'கிசான் செடு - அரசு திட்டங்கள்';
      case 'te':
        return 'కిసాన్ సేతు - ప్రభుత్వ పథకాలు';
      case 'mr':
        return 'किसान सेतू - शासकीय योजना';
      case 'gu':
        return 'કિસાન સેતુ - સરકારી યોજનાઓ';
      default:
        return 'Kisan Setu - Government Schemes';
    }
  }

  String get searchSchemesHint {
    switch (locale.languageCode) {
      case 'hi':
        return 'योजनाएं खोजें...';
      case 'pa':
        return 'ਯੋਜਨਾਵਾਂ ਖੋਜੋ...';
      case 'bn':
        return 'স্কিম অনুসন্ধান করুন...';
      case 'ta':
        return 'திட்டங்களைத் தேடு...';
      case 'te':
        return 'పథకాలను శోధించండి...';
      case 'mr':
        return 'योजना शोधा...';
      case 'gu':
        return 'યોજનાઓ શોધો...';
      default:
        return 'Search schemes...';
    }
  }

  String get filterButton {
    switch (locale.languageCode) {
      case 'hi':
        return 'फ़िल्टर';
      case 'pa':
        return 'ਫਿਲਟਰ';
      case 'bn':
        return 'ফিল্টার';
      case 'ta':
        return 'வடிகட்டி';
      case 'te':
        return 'ఫిల్టర్';
      case 'mr':
        return 'फिल्टर';
      case 'gu':
        return 'ફિલ્ટર';
      default:
        return 'Filter';
    }
  }

  String get clearFilters {
    switch (locale.languageCode) {
      case 'hi':
        return 'फ़िल्टर साफ़ करें';
      case 'pa':
        return 'ਫਿਲਟਰ ਸਾਫ਼ ਕਰੋ';
      case 'bn':
        return 'ফিল্টার সাফ করুন';
      case 'ta':
        return 'வடிகட்டிகளை அழிக்கவும்';
      case 'te':
        return 'ఫిల్టర్లను క్లియర్ చేయండి';
      case 'mr':
        return 'फिल्टर साफ करा';
      case 'gu':
        return 'ફિલ્ટર્સ સાફ કરો';
      default:
        return 'Clear Filters';
    }
  }

  String get schemesAvailable {
    switch (locale.languageCode) {
      case 'hi':
        return 'योजनाएं उपलब्ध';
      case 'pa':
        return 'ਯੋਜਨਾਵਾਂ ਉਪਲਬਧ';
      case 'bn':
        return 'স্কিম উপলব্ধ';
      case 'ta':
        return 'திட்டங்கள் கிடைக்கின்றன';
      case 'te':
        return 'పథకాలు అందుబాటులో ఉన్నాయి';
      case 'mr':
        return 'योजना उपलब्ध';
      case 'gu':
        return 'યોજનાઓ ઉપલબ્ધ છે';
      default:
        return 'Schemes Available';
    }
  }

  String get noSchemesFound {
    switch (locale.languageCode) {
      case 'hi':
        return 'कोई योजना नहीं मिली!\nफ़िल्टर बदलकर पुनः प्रयास करें।';
      case 'pa':
        return 'ਕੋਈ ਯੋਜਨਾ ਨਹੀਂ ਮਿਲੀ!\nਫਿਲਟਰ ਬਦਲ ਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
      case 'bn':
        return 'কোন স্কিম পাওয়া যায়নি!\nফিল্টার পরিবর্তন করে আবার চেষ্টা করুন।';
      case 'ta':
        return 'திட்டங்கள் எதுவும் கிடைக்கவில்லை!\nவடிகட்டிகளை மாற்றி மீண்டும் முயற்சிக்கவும்.';
      case 'te':
        return 'పథకాలు ఏవీ కనుగొనబడలేదు!\nఫిల్టర్లను మార్చి మళ్లీ ప్రయత్నించండి.';
      case 'mr':
        return 'योजना सापडली नाही!\nफिल्टर बदलून पुन्हा प्रयत्न करा.';
      case 'gu':
        return 'કોઈ યોજના મળી નથી!\nફિલ્ટર્સ બદલીને ફરીથી પ્રયાસ કરો.';
      default:
        return 'No schemes found!\nTry changing the filters and try again.';
    }
  }

  String get moreInfo {
    switch (locale.languageCode) {
      case 'hi':
        return 'अधिक जानकारी';
      case 'pa':
        return 'ਹੋਰ ਜਾਣਕਾਰੀ';
      case 'bn':
        return 'আরও তথ্য';
      case 'ta':
        return 'மேலும் தகவல்';
      case 'te':
        return 'మరిన్ని వివరాలు';
      case 'mr':
        return 'अधिक माहिती';
      case 'gu':
        return 'વધુ માહિતી';
      default:
        return 'More Info';
    }
  }

  String get applyNow {
    switch (locale.languageCode) {
      case 'hi':
        return 'अभी आवेदन करें';
      case 'pa':
        return 'ਹੁਣੇ ਅਰਜ਼ੀ ਦਿਓ';
      case 'bn':
        return 'এখনই আবেদন করুন';
      case 'ta':
        return 'இப்போதே விண்ணப்பிக்கவும்';
      case 'te':
        return 'ఇప్పుడే దరఖాస్తు చేసుకోండి';
      case 'mr':
        return 'आत्ताच अर्ज करा';
      case 'gu':
        return 'હમણાં જ અરજી કરો';
      default:
        return 'Apply Now';
    }
  }

  String get description {
    switch (locale.languageCode) {
      case 'hi':
        return 'विवरण';
      case 'pa':
        return 'ਵੇਰਵਾ';
      case 'bn':
        return 'বিবরণ';
      case 'ta':
        return 'விளக்கம்';
      case 'te':
        return 'వివరణ';
      case 'mr':
        return 'वर्णन';
      case 'gu':
        return 'વર્ણન';
      default:
        return 'Description';
    }
  }

  String get benefits {
    switch (locale.languageCode) {
      case 'hi':
        return 'लाभ';
      case 'pa':
        return 'ਫਾਇਦੇ';
      case 'bn':
        return 'সুবিধা';
      case 'ta':
        return 'நன்மைகள்';
      case 'te':
        return 'ప్రయోజనాలు';
      case 'mr':
        return 'फायदे';
      case 'gu':
        return 'લાભો';
      default:
        return 'Benefits';
    }
  }

  String get eligibilityCriteria {
    switch (locale.languageCode) {
      case 'hi':
        return 'पात्रता मानदंड';
      case 'pa':
        return 'ਯੋਗਤਾ ਦੇ ਮਾਪਦੰਡ';
      case 'bn':
        return 'যোগ্যতার মানদণ্ড';
      case 'ta':
        return 'தகுதி விதிமுறைகள்';
      case 'te':
        return 'అర్హత నిబంధనలు';
      case 'mr':
        return 'पात्रता निकष';
      case 'gu':
        return 'યોગ્યતા માપદંડ';
      default:
        return 'Eligibility Criteria';
    }
  }

  String get landSize {
    switch (locale.languageCode) {
      case 'hi':
        return 'भूमि आकार';
      case 'pa':
        return 'ਜ਼ਮੀਨ ਦਾ ਆਕਾਰ';
      case 'bn':
        return 'জমির আকার';
      case 'ta':
        return 'நில அளவு';
      case 'te':
        return 'భూమి పరిమాణం';
      case 'mr':
        return 'जमीन आकार';
      case 'gu':
        return 'જમીનનું કદ';
      default:
        return 'Land Size';
    }
  }

  String get aadharRequirement {
    switch (locale.languageCode) {
      case 'hi':
        return 'आधार आवश्यकता';
      case 'pa':
        return 'ਆਧਾਰ ਲੋੜ';
      case 'bn':
        return 'আধার প্রয়োজন';
      case 'ta':
        return 'ஆதார் தேவை';
      case 'te':
        return 'ఆధార్ అవసరం';
      case 'mr':
        return 'आधार आवश्यकता';
      case 'gu':
        return 'આધાર જરૂરિયાત';
      default:
        return 'Aadhar Requirement';
    }
  }

  String get applicationProcess {
    switch (locale.languageCode) {
      case 'hi':
        return 'आवेदन प्रक्रिया';
      case 'pa':
        return 'ਅਰਜ਼ੀ ਪ੍ਰਕਿਰਿਆ';
      case 'bn':
        return 'আবেদন প্রক্রিয়া';
      case 'ta':
        return 'விண்ணப்ப செயல்முறை';
      case 'te':
        return 'దరఖాస్తు ప్రక్రియ';
      case 'mr':
        return 'अर्ज प्रक्रिया';
      case 'gu':
        return 'અરજી પ્રક્રિયા';
      default:
        return 'Application Process';
    }
  }

  String get contactInformation {
    switch (locale.languageCode) {
      case 'hi':
        return 'संपर्क जानकारी';
      case 'pa':
        return 'ਸੰਪਰਕ ਜਾਣਕਾਰੀ';
      case 'bn':
        return 'যোগাযোগের তথ্য';
      case 'ta':
        return 'தொடர்பு தகவல்';
      case 'te':
        return 'సంప్రదింపు సమాచారం';
      case 'mr':
        return 'संपर्क माहिती';
      case 'gu':
        return 'સંપર્ક માહિતી';
      default:
        return 'Contact Information';
    }
  }

  String get expires {
    switch (locale.languageCode) {
      case 'hi':
        return 'समाप्ति:';
      case 'pa':
        return 'ਮਿਆਦ:';
      case 'bn':
        return 'মেয়াদ শেষ:';
      case 'ta':
        return 'காலாவதி:';
      case 'te':
        return 'గడువు:';
      case 'mr':
        return 'कालबाह्य:';
      case 'gu':
        return 'સમાપ્ત:';
      default:
        return 'Expires:';
    }
  }

  String get filterSchemes {
    switch (locale.languageCode) {
      case 'hi':
        return 'योजनाएं फ़िल्टर करें';
      case 'pa':
        return 'ਯੋਜਨਾਵਾਂ ਫਿਲਟਰ ਕਰੋ';
      case 'bn':
        return 'স্কিম ফিল্টার করুন';
      case 'ta':
        return 'திட்டங்களை வடிகட்டவும்';
      case 'te':
        return 'పథకాలను ఫిల్టర్ చేయండి';
      case 'mr':
        return 'योजना फिल्टर करा';
      case 'gu':
        return 'યોજનાઓને ફિલ્ટર કરો';
      default:
        return 'Filter Schemes';
    }
  }

  String get department {
    switch (locale.languageCode) {
      case 'hi':
        return 'विभाग';
      case 'pa':
        return 'ਵਿਭਾਗ';
      case 'bn':
        return 'বিভাগ';
      case 'ta':
        return 'துறை';
      case 'te':
        return 'శాఖ';
      case 'mr':
        return 'विभाग';
      case 'gu':
        return 'વિભાગ';
      default:
        return 'Department';
    }
  }

  String get farmingType {
    switch (locale.languageCode) {
      case 'hi':
        return 'कृषि प्रकार';
      case 'pa':
        return 'ਖੇਤੀ ਦੀ ਕਿਸਮ';
      case 'bn':
        return 'চাষের ধরন';
      case 'ta':
        return 'விவசாய வகை';
      case 'te':
        return 'వ్యవసాయ రకం';
      case 'mr':
        return 'शेतीचा प्रकार';
      case 'gu':
        return 'ખેતીનો પ્રકાર';
      default:
        return 'Farming Type';
    }
  }

  String get cropType {
    switch (locale.languageCode) {
      case 'hi':
        return 'फसल प्रकार';
      case 'pa':
        return 'ਫਸਲ ਦੀ ਕਿਸਮ';
      case 'bn':
        return 'ফসলের ধরন';
      case 'ta':
        return 'பயிர் வகை';
      case 'te':
        return 'పంట రకం';
      case 'mr':
        return 'पिकाचा प्रकार';
      case 'gu':
        return 'પાકનો પ્રકાર';
      default:
        return 'Crop Type';
    }
  }

  String get hectares {
    switch (locale.languageCode) {
      case 'hi':
        return 'हेक्टेयर';
      case 'pa':
        return 'ਹੈਕਟੇਅਰ';
      case 'bn':
        return 'হেক্টর';
      case 'ta':
        return 'ஹெக்டேர்';
      case 'te':
        return 'హెక్టార్లు';
      case 'mr':
        return 'हेक्टर';
      case 'gu':
        return 'હેક્ટર';
      default:
        return 'hectares';
    }
  }

  String get aadharRequired {
    switch (locale.languageCode) {
      case 'hi':
        return 'आधार आवश्यक';
      case 'pa':
        return 'ਆਧਾਰ ਲੋੜੀਂਦਾ';
      case 'bn':
        return 'আধার প্রয়োজন';
      case 'ta':
        return 'ஆதார் தேவை';
      case 'te':
        return 'ఆధార్ అవసరం';
      case 'mr':
        return 'आधार आवश्यक';
      case 'gu':
        return 'આધાર જરૂરી';
      default:
        return 'Aadhar Required';
    }
  }

  String get aadharNotRequired {
    switch (locale.languageCode) {
      case 'hi':
        return 'आधार आवश्यक नहीं';
      case 'pa':
        return 'ਆਧਾਰ ਲੋੜੀਂਦਾ ਨਹੀਂ';
      case 'bn':
        return 'আধার প্রয়োজন নেই';
      case 'ta':
        return 'ஆதார் தேவையில்லை';
      case 'te':
        return 'ఆధార్ అవసరం లేదు';
      case 'mr':
        return 'आधार आवश्यक नाही';
      case 'gu':
        return 'આધાર જરૂરી નથી';
      default:
        return 'Aadhar Not Required';
    }
  }

  String get reset {
    switch (locale.languageCode) {
      case 'hi':
        return 'रीसेट';
      case 'pa':
        return 'ਰੀਸੈੱਟ';
      case 'bn':
        return 'রিসেট';
      case 'ta':
        return 'மீட்டமை';
      case 'te':
        return 'రీసెట్';
      case 'mr':
        return 'रीसेट';
      case 'gu':
        return 'રીસેટ';
      default:
        return 'Reset';
    }
  }

  String get apply {
    switch (locale.languageCode) {
      case 'hi':
        return 'लागू करें';
      case 'pa':
        return 'ਲਾਗੂ ਕਰੋ';
      case 'bn':
        return 'প্রয়োগ করুন';
      case 'ta':
        return 'விண்ணப்பிக்கவும்';
      case 'te':
        return 'దరఖాస్తు చేయండి';
      case 'mr':
        return 'लागू करा';
      case 'gu':
        return 'લાગુ કરો';
      default:
        return 'Apply';
    }
  }
}

// Localization Delegate
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'en',
      'hi',
      'pa',
      'bn',
      'ta',
      'te',
      'mr',
      'gu',
    ].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
