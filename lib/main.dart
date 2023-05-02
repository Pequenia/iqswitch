import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root', // reemplaza por tu usuario
        password: '', // reemplaza por tu contraseña
        db: 'iq_switch',
      ),
    );

    final results = await conn.query(
        'SELECT * FROM users WHERE username = ? AND password = ?',
        [_usernameController.text, _passwordController.text]);

    if (results.isNotEmpty) {
      // si el resultado no está vacío, el usuario y la contraseña son válidos
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      // si el resultado está vacío, el usuario y la contraseña no son válidos
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error de autenticación'),
              content: Text(
                  'Nombre de usuario o contraseña incorrectos. Inténtalo de nuevo.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cerrar'))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                  hintText: 'Nombre de usuario', icon: Icon(Icons.person)),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Contraseña', icon: Icon(Icons.lock)),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar sesión'),
            )
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página principal'),
      ),
      body: Center(
        child: Text('Bienvenido!'),
      ),
    );
  }
}
