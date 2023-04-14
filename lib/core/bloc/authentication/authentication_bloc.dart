import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_login_app/core/bloc/authentication/authentication_state.dart';
import '../../repository/authentication_repository.dart';
part 'authentication_event.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    // required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        // _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(_AuthenticationStatusChanged(status)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  // final UserRepository _userRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        // final user = await _tryGetUser();
        // return emit(
        //   user != null
        //       ? AuthenticationState.authenticated(user)
        //       : const AuthenticationState.unauthenticated(),
        // );
        return emit(AuthenticationState.authenticated());
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
    // emit(const AuthenticationState.unauthenticated());
  }

  // Future<User?> _tryGetUser() async {
  //   try {
  //     final user = await _userRepository.getUser();
  //     return user;
  //   } catch (_) {
  //     return null;
  //   }
  // }
}
