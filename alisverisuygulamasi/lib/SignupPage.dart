import 'package:alisverisuygulamasi/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// BLoC Events
abstract class AuthEvent {}

class SignupEvent extends AuthEvent {
  final String name;
  final String surname;
  final String username;
  final String password;
  final String phoneNumber;

  SignupEvent({
    required this.name,
    required this.surname,
    required this.username,
    required this.password,
    required this.phoneNumber,
  });
}

// BLoC State
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthenticatedState extends AuthState {
  final String username;

  AuthenticatedState({required this.username});
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignupEvent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Kullanıcı adını anahtar olarak kullanarak kullanıcı bilgilerini sakla
      await prefs.setString('name_${event.username}', event.name);
      await prefs.setString('surname_${event.username}', event.surname);
      await prefs.setString('password_${event.username}', event.password);
      await prefs.setString('phoneNumber_${event.username}', event.phoneNumber);

      yield AuthenticatedState(username: event.username);
    }
  }
}

// Signup Page
class SignupPage extends StatefulWidget {
  final bool isDarkMode;
  final bool isTurkish;

  const SignupPage({Key? key, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,

      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,

        title: Text(
          widget.isTurkish! ? 'Kayıt ol' : 'Sign up',
          style: TextStyle(fontWeight: FontWeight.bold,
            color: widget.isDarkMode ? Colors.white : Colors.black,),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: SingleChildScrollView(
          child: SignupForm(isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final bool isDarkMode;
  final bool isTurkish;

  const SignupForm({Key? key, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
        }
      },
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 6),
                        child: Row(
                          children: [
                            Text(
                              widget.isTurkish! ? 'Ad' : 'First name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: widget.isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Type here',
                            hintStyle: TextStyle(
                              color: Color(0xFFB6A9A9),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0xFFE7DBDB),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 6),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 9.0),
                              child: Text(
                                widget.isTurkish! ? 'Soyad' : 'Last name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: widget.isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: _surnameController,
                          decoration: InputDecoration(
                            hintText: 'Type here',
                            hintStyle: TextStyle(
                              color: Color(0xFFB6A9A9),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0xFFE7DBDB),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 6),
              child: Row(
                children: [
                  Text(
                    widget.isTurkish! ? 'Kullanıcı Adı' : 'Username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'example123',
                hintStyle: TextStyle(
                  color: Color(0xFFB6A9A9),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color(0xFFE7DBDB),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 6),
              child: Row(
                children: [
                  Text(
                    widget.isTurkish! ? 'Parola' : 'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
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
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color(0xFFE7DBDB),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 6),
              child: Row(
                children: [
                  Text(
                    widget.isTurkish! ? 'Telefon' : 'Phone' ,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                hintText: '+9011111111',
                hintStyle: TextStyle(
                  color: Color(0xFFB6A9A9),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color(0xFFE7DBDB),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
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
                  _signUp();
                },
                child: Text(
                  widget.isTurkish! ? 'Kayıt ol' : 'Sign up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isTurkish! ? 'Zaten hesabın var mı? ' : 'Already have an account? ',
                  style: TextStyle(fontSize: 17,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    widget.isTurkish! ? 'Giriş Yap' : 'Sign in',
                    style: TextStyle(
                      color: Color(0xFFFA0B0B),
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signUp() {
    final name = _nameController.text;
    final surname = _surnameController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final phoneNumber = _phoneNumberController.text;

    if (name.isEmpty || surname.isEmpty || username.isEmpty || password.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen tüm alanları doldurun.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      BlocProvider.of<AuthBloc>(context).add(SignupEvent(
        name: name,
        surname: surname,
        username: username,
        password: password,
        phoneNumber: phoneNumber,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kayıt Başarılı!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}

