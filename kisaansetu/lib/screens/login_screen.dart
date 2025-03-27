// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// // LoginScreen with Skip button
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _phoneController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   String? _verificationId;

//   Future<void> phoneSignIn({required String phoneNumber}) async {
//     if (phoneNumber.isEmpty || phoneNumber.length < 10) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Enter a valid phone number')));
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: '+91$phoneNumber',
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await FirebaseAuth.instance.signInWithCredential(credential);
//           Navigator.pushReplacementNamed(context, '/home');
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(e.message ?? 'Verification Failed')),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             _verificationId = verificationId;
//           });
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OTPScreen(verificationId: verificationId),
//             ),
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {},
//         timeout: const Duration(seconds: 60),
//         forceResendingToken: null,
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }

//     setState(() => _isLoading = false);
//   }

//   void _skipToHome() {
//     // Navigate to home screen without authentication
//     Navigator.pushReplacementNamed(context, '/home');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login with OTP"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/home');
//             },
//             child: const Text(
//               'Skip',
//               style: TextStyle(color: Colors.white),
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
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(
//                   labelText: 'Phone Number',
//                   hintText: 'Enter 10-digit number',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.phone,
//                 maxLength: 10,
//                 validator: (value) {
//                   if (value == null || value.length != 10) {
//                     return 'Enter a valid 10-digit number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               _isLoading
//                   ? const CircularProgressIndicator()
//                   : Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               phoneSignIn(phoneNumber: _phoneController.text.trim());
//                             }
//                           },
//                           child: const Text('Send OTP'),
//                         ),
//                         const SizedBox(width: 16),
//                         TextButton(
//                           onPressed: _skipToHome,
//                           child: const Text('Skip Login'),
//                           style: TextButton.styleFrom(
//                             foregroundColor: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//               const SizedBox(height: 16),
//               Text(
//                 'Having trouble with billing? Skip login to use the app.',
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

// class OTPScreen extends StatefulWidget {
//   final String verificationId;

//   OTPScreen({required this.verificationId});

//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final _otpController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> verifyOTP() async {
//     if (_otpController.text.length != 6) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Enter a valid 6-digit OTP')));
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: widget.verificationId,
//         smsCode: _otpController.text.trim(),
//       );
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       Navigator.pushReplacementNamed(context, '/home');
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Invalid OTP')));
//     }

//     setState(() => _isLoading = false);
//   }

//   void _skipToHome() {
//     // Navigate to home screen without authentication
//     Navigator.pushReplacementNamed(context, '/home');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enter OTP'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/home');
//             },
//             child: const Text(
//               'Skip',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _otpController,
//               decoration: InputDecoration(
//                 labelText: 'OTP',
//                 hintText: 'Enter 6-digit OTP',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//               maxLength: 6,
//             ),
//             const SizedBox(height: 16),
//             _isLoading
//                 ? const CircularProgressIndicator()
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: verifyOTP,
//                         child: const Text('Verify OTP'),
//                       ),
//                       const SizedBox(width: 16),
//                       TextButton(
//                         onPressed: _skipToHome,
//                         child: const Text('Skip Login'),
//                         style: TextButton.styleFrom(
//                           foregroundColor: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//             const SizedBox(height: 16),
//             Text(
//               'Having trouble with billing? Skip login to use the app.',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 12,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _phoneController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   String _selectedLanguage = 'English'; // Default language
  
//   // List of available languages
//   final List<String> _languages = [
//     'English', 
//     'Hindi', 
//     'Punjabi', 
//     'Bengali', 
//     'Tamil', 
//     'Telugu', 
//     'Marathi', 
//     'Gujarati'
//   ];

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
//         SnackBar(content: Text('Enter a valid phone number'))
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
    
//     // Navigate to home screen without authentication
//     Navigator.pushReplacementNamed(context, '/home');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login"),
//         actions: [
//           TextButton(
//             onPressed: _skipToHome,
//             child: const Text(
//               'Skip',
//               style: TextStyle(color: Colors.white),
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
//                   labelText: 'Phone Number',
//                   hintText: 'Enter 10-digit number',
//                   border: OutlineInputBorder(),
//                   prefixText: '+91 ',
//                 ),
//                 keyboardType: TextInputType.phone,
//                 maxLength: 10,
//                 validator: (value) {
//                   if (value == null || value.length != 10) {
//                     return 'Enter a valid 10-digit number';
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
//                 padding: EdgeInsets.symmetric(horizontal: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0, left: 4),
//                       child: Text(
//                         'Select Language',
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
//                           }
//                         },
//                         items: _languages.map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
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
//                           child: const Text('Continue'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                             textStyle: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         TextButton(
//                           onPressed: _skipToHome,
//                           child: const Text('Skip Login'),
//                           style: TextButton.styleFrom(
//                             foregroundColor: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
              
//               const SizedBox(height: 16),
              
//               Text(
//                 'Your preferred language will be used by the Voice Assistant',
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
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedLanguage = 'English';
  
  // Map language names to their locale codes
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

  // Load any previously saved language preference
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  // Save user phone and language preference
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
      
      // Save phone number
      await prefs.setString('phoneNumber', _phoneController.text.trim());
      
      // Save selected language
      await prefs.setString('selectedLanguage', _selectedLanguage);
      
      // Update app locale immediately
      Locale newLocale = _languageMap[_selectedLanguage] ?? Locale('en');
      KisaanSetuApp.of(context).setLocale(newLocale);
      
      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'))
      );
    }

    setState(() => _isLoading = false);
  }

  void _skipToHome() async {
    // Even when skipping, save the selected language
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', _selectedLanguage);
    
    // Update app locale immediately
    Locale newLocale = _languageMap[_selectedLanguage] ?? Locale('en');
    KisaanSetuApp.of(context).setLocale(newLocale);
    
    // Navigate to home screen without authentication
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    // Get current localization
    final localizations = AppLocalizations.of(context);
    
    // Get list of languages with their localized names
    final languages = _languageMap.keys.map((langName) {
      // Use localized name if available, otherwise use original name
      return localizations.languageNames[_languageMap[langName]!.languageCode] ?? langName;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.loginTitle),
        actions: [
          TextButton(
            onPressed: _skipToHome,
            child: Text(
              localizations.skipLoginText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Phone number input
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: localizations.phoneNumberLabel,
                  hintText: localizations.phoneHint,
                  border: const OutlineInputBorder(),
                  prefixText: '+91 ',
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
              
              const SizedBox(height: 24),
              
              // Language selection dropdown
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 4),
                      child: Text(
                        localizations.selectLanguageTitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLanguage,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedLanguage = newValue;
                            });
                            
                            // Immediately update the app's locale
                            Locale newLocale = _languageMap[newValue] ?? Locale('en');
                            KisaanSetuApp.of(context).setLocale(newLocale);
                          }
                        },
                        items: languages.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: _languageMap.keys.toList()[languages.indexOf(value)],
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Login button and skip option
              _isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveUserData();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: Text(localizations.continueButtonText),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: _skipToHome,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                          child: Text(localizations.skipLoginText),
                        ),
                      ],
                    ),
              
              const SizedBox(height: 16),
              
              Text(
                localizations.voiceAssistantLanguageNote,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}