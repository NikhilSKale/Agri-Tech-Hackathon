// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../l10n/app_localizations.dart';
// import '../main.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _phoneController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   String _selectedLanguage = 'English';
  
//   // Map language names to their locale codes
//   final Map<String, Locale> _languageMap = {
//     'English': Locale('en'),
//     'Hindi': Locale('hi'),
//     'Punjabi': Locale('pa'),
//     'Bengali': Locale('bn'),
//     'Tamil': Locale('ta'),
//     'Telugu': Locale('te'),
//     'Marathi': Locale('mr'),
//     'Gujarati': Locale('gu'),
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedLanguage();
//   }

//   // Load any previously saved language preference
//   Future<void> _loadSavedLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
//     });
//   }

//   // Save user phone and language preference
//   Future<void> _saveUserData() async {
//     if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(AppLocalizations.of(context).invalidPhoneNumber))
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final prefs = await SharedPreferences.getInstance();
      
//       // Save phone number
//       await prefs.setString('phoneNumber', _phoneController.text.trim());
      
//       // Save selected language
//       await prefs.setString('selectedLanguage', _selectedLanguage);
      
//       // Update app locale immediately
//       Locale newLocale = _languageMap[_selectedLanguage] ?? Locale('en');
//       KisaanSetuApp.of(context).setLocale(newLocale);
      
//       // Navigate to home screen
//       Navigator.pushReplacementNamed(context, '/home');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e'))
//       );
//     }

//     setState(() => _isLoading = false);
//   }

//   void _skipToHome() async {
//     // Even when skipping, save the selected language
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedLanguage', _selectedLanguage);
    
//     // Update app locale immediately
//     Locale newLocale = _languageMap[_selectedLanguage] ?? Locale('en');
//     KisaanSetuApp.of(context).setLocale(newLocale);
    
//     // Navigate to home screen without authentication
//     Navigator.pushReplacementNamed(context, '/home');
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get current localization
//     final localizations = AppLocalizations.of(context);
    
//     // Get list of languages with their localized names
//     final languages = _languageMap.keys.map((langName) {
//       // Use localized name if available, otherwise use original name
//       return localizations.languageNames[_languageMap[langName]!.languageCode] ?? langName;
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(localizations.loginTitle),
//         actions: [
//           TextButton(
//             onPressed: _skipToHome,
//             child: Text(
//               localizations.skipLoginText,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Phone number input
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(
//                   labelText: localizations.phoneNumberLabel,
//                   hintText: localizations.phoneHint,
//                   border: const OutlineInputBorder(),
//                   prefixText: '+91 ',
//                 ),
//                 keyboardType: TextInputType.phone,
//                 maxLength: 10,
//                 validator: (value) {
//                   if (value == null || value.length != 10) {
//                     return localizations.invalidPhoneNumber;
//                   }
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 24),
              
//               // Language selection dropdown
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0, left: 4),
//                       child: Text(
//                         localizations.selectLanguageTitle,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                     ),
//                     DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: _selectedLanguage,
//                         isExpanded: true,
//                         icon: const Icon(Icons.arrow_drop_down),
//                         onChanged: (String? newValue) {
//                           if (newValue != null) {
//                             setState(() {
//                               _selectedLanguage = newValue;
//                             });
                            
//                             // Immediately update the app's locale
//                             Locale newLocale = _languageMap[newValue] ?? Locale('en');
//                             KisaanSetuApp.of(context).setLocale(newLocale);
//                           }
//                         },
//                         items: languages.map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: _languageMap.keys.toList()[languages.indexOf(value)],
//                             child: Text(value),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 32),
              
//               // Login button and skip option
//               _isLoading
//                   ? const CircularProgressIndicator()
//                   : Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               _saveUserData();
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                             textStyle: const TextStyle(fontSize: 16),
//                           ),
//                           child: Text(localizations.continueButtonText),
//                         ),
//                         const SizedBox(width: 16),
//                         TextButton(
//                           onPressed: _skipToHome,
//                           style: TextButton.styleFrom(
//                             foregroundColor: Colors.grey,
//                           ),
//                           child: Text(localizations.skipLoginText),
//                         ),
//                       ],
//                     ),
              
//               const SizedBox(height: 16),
              
//               Text(
//                 localizations.voiceAssistantLanguageNote,
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 12,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedLanguage = 'English';
  
  final Map<String, Locale> _languageMap = {
    'English': Locale('en'),
    'Hindi': Locale('hi'),
    'Punjabi': Locale('pa'),
    'Bengali': Locale('bn'),
    'Tamil': Locale('ta'),
    'Telugu': Locale('te'),
    'Marathi': Locale('mr'),
    'Gujarati': Locale('gu'),
  };

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _saveUserData() async {
    if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).invalidPhoneNumber))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phoneNumber', _phoneController.text.trim());
      await prefs.setString('selectedLanguage', _selectedLanguage);
      Locale newLocale = _languageMap[_selectedLanguage] ?? Locale('en');
      KisaanSetuApp.of(context).setLocale(newLocale);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'))
      );
    }

    setState(() => _isLoading = false);
  }

  void _continueToHome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', _selectedLanguage);
    Locale newLocale = _languageMap[_selectedLanguage] ?? Locale('en');
    KisaanSetuApp.of(context).setLocale(newLocale);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languages = _languageMap.keys.map((langName) {
      return localizations.languageNames[_languageMap[langName]!.languageCode] ?? langName;
    }).toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                // Header (now empty since we moved the button)
                const SizedBox(height: 16),
                
                // Welcome content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          localizations.loginTitle,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Welcome back! Please enter your details",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Phone input field
                        Text(
                          localizations.phoneNumberLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              hintText: localizations.phoneHint,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  '+91 ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            validator: (value) {
                              if (value == null || value.length != 10) {
                                return localizations.invalidPhoneNumber;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Language dropdown
                        Text(
                          localizations.selectLanguageTitle,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedLanguage,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.grey.shade700),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedLanguage = newValue;
                                  });
                                  Locale newLocale = _languageMap[newValue] ?? Locale('en');
                                  KisaanSetuApp.of(context).setLocale(newLocale);
                                }
                              },
                              items: languages.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: _languageMap.keys.toList()[languages.indexOf(value)],
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Continue button (formerly skip login)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _continueToHome,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Continue", // Renamed from skip login
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 24),
                        
                        // Footer note
                        Text(
                          localizations.voiceAssistantLanguageNote,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}