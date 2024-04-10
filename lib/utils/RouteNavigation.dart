
import 'package:demo_project/views/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../views/model_module/model_list_screen.dart';


class RouteNavigation {
  RouteNavigation._();
  static modelListScreen(BuildContext context){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  ModelListScreen()),
      ModalRoute.withName("/select_user"),
    );
  }

 static loginScreen(BuildContext context){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  LoginScreen()),
      ModalRoute.withName("/login_screen"),
    );
  }



  static navigateToView(BuildContext context, Widget destination) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
  }

}