import 'package:client_flutter/bloc/auth_bloc.dart';
import 'package:client_flutter/components/appbar.dart';
import 'package:client_flutter/pages/login.dart';
import 'package:client_flutter/services/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Dio dio = DioService().getApi();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadData() async {
    await dio.get('auth/status').then((value) {
      final Map responseMap = value.data;
      if (responseMap['success']) {
        print(responseMap['data']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'SkyReal',
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Loading) {
            // Showing the loading indicator while the user is signing in
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is Authenticated) {
            return RefreshIndicator(
                onRefresh: _loadData,
                // child: SafeArea(
                child: CustomScrollView(slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height:
                                Size.fromHeight(kToolbarHeight).height + 30),
                        Text('Welcome ${state.authenticatedUser.username}'),
                        SizedBox(height: 2000),
                        Container(
                          height: 50,
                          color: Colors.red,
                          // Full width
                          width: double.infinity,
                        )
                      ],
                    ),
                  )
                ]));
          }
          // print(state);
          return Center(
            child: Text("Not Authenticated - ERROR"),
          );
        },
      ),
    );
  }
}
