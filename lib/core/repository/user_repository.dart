// import 'dart:async';
// import 'package:uuid/uuid.dart';
// import 'package:new_login_app/core/model/user.dart';

// class UserRepository {
//   User? _user;

//   Future<User?> getUser() async {
//     if (_user != null) return _user;
//     return Future.delayed(
//       const Duration(milliseconds: 300),
//       () => _user = User(const Uuid().v4()),
//     );
//   }
// }
