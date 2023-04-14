import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_login_app/core/screen/home.dart';
import 'package:new_login_app/core/screen/login.dart';
import 'package:new_login_app/core/screen/splash.dart';
import 'package:new_login_app/core/bloc/authentication/authentication_bloc.dart';
import 'package:new_login_app/core/bloc/authentication/authentication_state.dart';
import '../repository/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const App());
  }
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  // late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository();
    // _userRepository = UserRepository();
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository,
          // userRepository: _userRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            print("1" + prefs.getString("check").toString());
            if (state.status == AuthenticationStatus.authenticated ||
                prefs.getString("check").toString() == "home_page".toString()) {
              prefs.setString("check", "home_page");
              _navigator.pushAndRemoveUntil<void>(
                HomePage.route(),
                (route) => false,
              );
            } else {
              _navigator.pushAndRemoveUntil<void>(
                LoginPage.route(),
                (route) => false,
              );
            }
            print(prefs.getString("check"));
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
