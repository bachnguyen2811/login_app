import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/post_blocs/post_bloc.dart';
import '../widget/post_list.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationLogoutRequested());
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => App(),
                  //     ));
                  // AuthenticationState.unauthenticated();
                },
                icon: const Icon(Icons.logout_sharp))
          ],
        ),
        body: BlocProvider(
          create: (_) =>
              PostBloc(httpClient: http.Client())..add(PostFetched()),
          child: const PostsList(),
        ));
  }
}
