import 'package:blutut_clasic/presentation/auth/bloc/auth_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/bloc/receipt_bloc.dart';
import '../../home/pages/page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( child: ElevatedButton(
          onPressed: (){
            context.read<AuthBloc>().add(Login(username: 'as', password: "d"));
            context.read<ReceiptBloc>().add(FetchOprIncomingReceipts('sfs'));
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PageFetch(),
          ));},
          child: Text('Login')),
    ));
  }
}
