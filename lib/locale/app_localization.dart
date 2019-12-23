// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';


// /// https://medium.com/@puneetsethi25/flutter-internationalization-switching-locales-manually-f182ec9b8ff0
// /// 
// /// 

// class AppLocalization {
  
//   static Future<AppLocalization> load(Locale locale) {
//     final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
//     final String localeName = Intl.canonicalizedLocale(name);
//     // return initializeMessages(localeName).then((_) {
//     //   Intl.defaultLocale = localeName;
//     //   return AppLocalization();
//     // });
//   }

//   static AppLocalization of(BuildContext context) {
//     return Localizations.of<AppLocalization>(context, AppLocalization);
//   }
  
//   // list of locales
//   String get heyWorld {
//     return Intl.message(
//       'Hey World',
//       name: 'heyWorld',
//       desc: 'Simpel word for greeting ',
//     );
//   }
// }

// class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization>{
//   final Locale overriddenLocale;

//   const AppLocalizationDelegate(this.overriddenLocale);

//   @override
//   bool isSupported(Locale locale) => ['bs', 'en'].contains(locale.languageCode);

//   @override
//   Future<AppLocalization> load(Locale locale) => AppLocalization.load(locale);

//   @override
//   bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false; 
// }