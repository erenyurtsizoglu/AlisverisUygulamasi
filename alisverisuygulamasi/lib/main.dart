import 'package:flutter/material.dart';
import 'package:alisverisuygulamasi/SplashScreen.dart';
import 'package:alisverisuygulamasi/LoginPage.dart'; // veya uygulamanızın ana sayfasının bulunduğu dosyanın yolu

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Başlık, buton ve vurgu renkleri için ana renk

        textTheme: TextTheme(
          headline6: TextStyle(color: Colors.black), // Başlık metni rengi
          bodyText1: TextStyle(color: Colors.black87), // Ana metin rengi
          bodyText2: TextStyle(color: Colors.black87), // İkincil metin rengi
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple, // App bar arka plan rengi
          foregroundColor: Colors.white, // App bar ön plan metin rengi
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.deepPurple, // Yükseltilmiş düğme arka plan rengi
            onPrimary: Colors.white, // Yükseltilmiş düğme metin rengi
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey), // İpucu metni rengi
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple), // Odaklı çerçeve rengi
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Etkin çerçeve rengi
          ),
        ),
        useMaterial3: true, // Materyal Tasarım 3'ü etkinleştir
      ),
      home: SplashScreen(), // veya uygulamanızın ana sayfasını belirtin
    );
  }
}
