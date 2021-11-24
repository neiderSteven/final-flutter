import 'package:final_flutter/screens/add_user/add_user.screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Programación movil"),
        backgroundColor: Colors.blue[900],
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Text('Final de programación móvil'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final route = MaterialPageRoute(
            builder: (_) => AddUserScreen(),
          );
          final result = await Navigator.push(
            context,
            route,
          );

          if (result != null && result) {
            setState(() {
              AddUserScreen();
            });
          }
        },
        backgroundColor: Color(0xFF005288),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
