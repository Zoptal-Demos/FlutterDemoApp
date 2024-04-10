import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../res/Colors.dart';

class AppWidets{
  AppWidets._();

  // show text for next and save the view details common method with inner gradient
  static  Align commontext(BuildContext context, double textSize, double padding, String textHint, double fontsize,  {required Function(String data) callback}){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(textSize),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(0, 170, 79, 1),
                Color.fromRGBO(3, 160, 85, 1),
                Color.fromRGBO(13, 133, 103, 1),
                Color.fromRGBO(27, 90, 131, 1),
                Color.fromRGBO(38, 59, 151, 1),
              ],
            )),
        width: MediaQuery.of(context).size.width,


        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: (){
            callback("callback");
          },
          child: Container(
            padding: EdgeInsets.all(padding),
            child: Text(
              textHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Berlin",
                  fontWeight: FontWeight.w400,
                  color: AppColors.whiteColor,
                  fontSize: fontsize),
            ),
          ),
        ),
      ),
    );
  }

  // show gradient loader
  static Widget circularProgress(){
    return  CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(AppColors.themeColor),
      strokeWidth: 5.0,);

  }

}