import 'package:flutter/material.dart';
import 'package:shop_app/face_auth/pages/home.dart';
import 'package:shop_app/face_auth/pages/sign-up.dart';


import '../../components/socal_card.dart';
import '../../constants.dart';
import '../../face_auth/pages/db/databse_helper.dart';
import '../../size_config.dart';
import 'components/sign_up_form.dart';

// Pantalla para registrarse

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Text("Registra cuenta", style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,)),
                  Text(
                    "Completa tus detalles",
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  SignUpForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  IconButton(onPressed: (){

                    DatabaseHelper _dataBaseHelper = DatabaseHelper.instance;
                    _dataBaseHelper.deleteAll();
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SignUp()));

                  }, icon: Icon(Icons.camera)),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Text(
                    'Al continuar aceptas \n nuestros terminos y condiciones',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
          ),
        ),
      );

  }
}
