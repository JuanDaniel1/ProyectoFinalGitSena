import 'package:flutter/material.dart';

import 'components/body.dart';

// pantalla de formulario de perfil

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
      ),
      body: Body(),
    );
  }
}
