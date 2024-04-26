import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignupPage.dart';
import 'HomePage.dart';

// BLoC Events
class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent({required this.username, required this.password});
}

// BLoC State
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthenticatedState extends AuthState {
  final String username;

  AuthenticatedState({required this.username});
}

class UnauthenticatedState extends AuthState {}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final savedPassword = prefs.getString('password_${event.username}');

      if (savedPassword == event.password) {
        yield AuthenticatedState(username: event.username);
      } else {
        yield UnauthenticatedState();
      }
    }
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isDarkMode = false;
  String selectedLanguage = 'English'; // Varsayılan dil İngilizce
  bool isTurkish = false; // Türkçe dil seçeneği kontrolü

  void _onLanguageChanged(String value) {
    setState(() {
      selectedLanguage = value;
      // Seçilen dil Türkçe ise isTurkish true olacak, aksi halde false
      isTurkish = value == 'Turkish';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        backgroundColor: _isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,
        title: Text(
          'Sign in',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black, // Metin rengini ayarla
          ),
        ),
        centerTitle: true,

      ),

      drawer: Drawer(
        backgroundColor: _isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFAB0606),
              ),
              child: Text(
                isTurkish! ? 'Ayarlar' : 'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 50,),
            ListTile(
              title: Text(isTurkish! ? 'Karanlık Mod' : 'Dark Mode',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black, // Metin rengini ayarla

              ),),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(isTurkish! ? 'Dil Seçin' : 'Select Language',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black, // Metin rengini ayarla
              ),),
              trailing: DropdownButton<String>(
                value: selectedLanguage,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  _onLanguageChanged(newValue!);
                },
                items: <String>['English', 'Turkish']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: SingleChildScrollView(
          child: LoginForm(
            isDarkMode: _isDarkMode,
            toggleDarkMode: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            isTurkish: isTurkish, // Türkçe dil seçeneğini iletiliyor
            onLanguageChanged: _onLanguageChanged,
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleDarkMode;
  final bool isTurkish; // Türkçe dil seçeneği
  final ValueChanged<String> onLanguageChanged; // Dil değişikliği bildirimi

  const LoginForm({Key? key, required this.isDarkMode, required this.toggleDarkMode, required this.isTurkish, required this.onLanguageChanged}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(username: state.username, isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,)),
          );
        } else if (state is UnauthenticatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lütfen bilgilerinizi kontrol edin.'),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Text(
                    widget.isTurkish! ? 'Kullanıcı Adı' : 'Username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: widget.isDarkMode ? Colors.white : Colors.black, // Metin rengini ayarla
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: widget.isTurkish! ? 'Kullanıcı Adı' : 'username',
                hintStyle: TextStyle(
                  color: Color(0xFFB6A9A9),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFE7DBDB)),
                ),
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Text(
                    widget.isTurkish! ? 'Parola' : 'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: widget.isDarkMode ? Colors.white : Colors.black, // Metin rengini ayarla
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '**********',
                hintStyle: TextStyle(
                  color: Color(0xFFB6A9A9),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFE7DBDB)),
                ),
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFA0B0B),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  final username = _usernameController.text;
                  final password = _passwordController.text;
                  BlocProvider.of<AuthBloc>(context).add(LoginEvent(
                    username: username,
                    password: password,
                  ));
                },
                child: Text(
                  widget.isTurkish! ? 'Giriş Yap' : 'Log in',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFECE3E3),
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Image.asset('images/apple.png', width: 39, height: 39),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFECE3E3),
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset('images/facebook.png', width: 70, height: 70),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFECE3E3),
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Image.asset('images/google.png', width: 46, height: 46),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isTurkish! ? 'Hesabınız yok mu? ' : 'Dont have an account? ',
                  style: TextStyle(
                    fontSize: 17,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage(isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,)),
                    );
                  },
                  child: Text(
                    widget.isTurkish! ? 'Kayıt Ol' : "Sign up",
                    style: TextStyle(
                      color: Color(0xFFFA0B0B),
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
