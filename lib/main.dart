import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ari/ui/listview_product_user.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ui/listview_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

String str_email = "";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();
    if (firebaseuser != null) {
      if (str_email == "admin@gmail.com") {
        return ListViewProduct();
      }
      return ListViewProduct_user();
    }
    return Login_page();
  }
}

class Login_page extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ingresar'),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Correo"),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Contraseña"),
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed: () {
                    str_email = emailController.text.trim();
                    context.read<AuthenticationService>().signIn(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim());
                  },
                  child: Text('Ingresar'),
                )
              ],
            )),
      ),
    );
  }
}
