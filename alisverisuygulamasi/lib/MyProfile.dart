import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// HomeBloc Event
abstract class HomeEvent {}

class LoadUserInfo extends HomeEvent {
  final String username;

  LoadUserInfo(this.username);
}

// HomeBloc State
abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String name;
  final String surname;
  final String password;
  final String phoneNumber;

  HomeLoaded(this.name, this.surname, this.password, this.phoneNumber);
}

// HomeBloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadUserInfo) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('name_${event.username}') ?? '';
      final surname = prefs.getString('surname_${event.username}') ?? '';
      final password = prefs.getString('password_${event.username}') ?? '';
      final phoneNumber = prefs.getString('phoneNumber_${event.username}') ?? '';
      yield HomeLoaded(name, surname, password, phoneNumber);
    }
  }
}

class MyProfile extends StatefulWidget {
  final String username;
  final bool isDarkMode;
  final bool isTurkish;
  const MyProfile({Key? key, required this.username, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late final HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc()..add(LoadUserInfo(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: Text(widget.isTurkish! ? 'Profilim' : 'My Profile',style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black
        ),
        ),
      ),
      body: BlocProvider<HomeBloc>(
        create: (_) => _homeBloc,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is HomeLoaded) {
              return _buildProfileUI(state);
            }
            return Container(); // Hata durumu için boş bir Container döndürülebilir
          },
        ),
      ),
    );
  }

  Widget _buildProfileUI(HomeLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 70),
        CircleAvatar(
          radius: 50,
          child: Icon(Icons.account_circle, size: 80),
        ),
        SizedBox(height: 50),
        _buildProfileInfoRow(Icons.person, widget.isTurkish! ? 'Ad:' : 'Name:', state.name),
        _buildProfileInfoRow(Icons.person_outline, widget.isTurkish! ? 'Soyad:' : 'Surname:', state.surname),
        _buildProfileInfoRow(Icons.lock, widget.isTurkish! ? 'Parola:' : 'Password:', '********'), // Şifreyi gizlemek için sabit metin
        _buildProfileInfoRow(Icons.phone, widget.isTurkish! ? 'Telefon:' : 'Phone:', state.phoneNumber),
        // İstediğiniz diğer bilgileri buraya ekleyebilirsiniz
      ],
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18,
              color: widget.isDarkMode ? Colors.white : Colors.black,),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }
}
