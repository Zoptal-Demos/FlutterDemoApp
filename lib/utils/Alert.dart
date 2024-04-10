
import 'package:demo_project/utils/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../res/AppStrings.dart';
import '../res/Colors.dart';
import 'RouteNavigation.dart';

class Alert {
  Alert._();

  // Alert with Ok button only
  static alertDialogWithOk(BuildContext cntxt, String msg, String tittle,
      {required Function(String data) callback}) {
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: cntxt,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(

          title: Text(
            tittle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontFamily: 'Berlin',
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Text(
            msg,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14.sp,
              fontFamily: 'Berlin',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[

            TextButton(
              onPressed: () {
                Navigator.pop(context);
                callback("OK");
              },
              child: Text(
                "Ok",
                style: TextStyle(
                  color: AppColors.themeColor,
                  fontSize: 16.sp,
                  fontFamily: 'Berlin',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Alert with Ok button only Session Expire
  static alertDialogSessionExpire(BuildContext cntxt, String msg, String tittle) {
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: cntxt,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(

          title: Text(
            tittle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontFamily: 'Berlin',
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Text(
            msg,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14.sp,
              fontFamily: 'Berlin',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[

            TextButton(
              onPressed: () {
                Navigator.pop(context);
                getSharePreference(
                    context
                );

              },
              child: Text(
                "Ok",
                style: TextStyle(
                  color: AppColors.themeColor,
                  fontSize: 16.sp,
                  fontFamily: 'Berlin',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // initialize the sharedpreference and clear user data
  static Future<void> getSharePreference(BuildContext context) async {
    try{
      var _sharedPreferencesService = await SharedPreferencesService.getInstance();
      _sharedPreferencesService.clearAll();
      RouteNavigation.loginScreen(context);
    }catch(error){
      print("error  ==$error");
    }

  }

  // Alert with Ok and Cancel button only
  static alertDialogWithOkCancel(BuildContext cntxt, String msg, String tittle,
      {required Function(String data) callback}) {
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: cntxt,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(

          title: Text(
            tittle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontFamily: 'Berlin',
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Text(
            msg,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14.sp,
              fontFamily: 'Berlin',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[

            TextButton(
              onPressed: () {
                Navigator.pop(context);
                callback("Cancel");
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: AppColors.themeColor,
                  fontSize: 16.sp,
                  fontFamily: 'Berlin',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                callback("OK");
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: AppColors.themeColor,
                  fontSize: 16.sp,
                  fontFamily: 'Berlin',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}