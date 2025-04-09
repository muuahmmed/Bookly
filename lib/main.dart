import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:bookly/features/splash/presentation_layer/views/widgets/splash_view.dart';
import 'constants.dart';
import 'features/home/domain_layer/entities/book_entity.dart';

void main() async {
  runApp(const BooklyApp());
  await Hive.initFlutter();
  Hive.registerAdapter(BookEntityAdapter());
  await Hive.openBox('featured_box');
}

class BooklyApp extends StatelessWidget {
  const BooklyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kPrimaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: kPrimaryColor,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: SplashView(),
    );
  }
}
