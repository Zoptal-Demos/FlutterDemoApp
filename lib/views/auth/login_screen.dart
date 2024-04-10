import 'package:demo_project/model/auth/user_model.dart';
import 'package:demo_project/res/Colors.dart';
import 'package:demo_project/utils/RouteNavigation.dart';
import 'package:demo_project/view_model/auth/auth_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../app_widgets/AppWidets.dart';
import '../../data/response/Status.dart';
import '../../res/AppIcons.dart';
import '../../res/AppStrings.dart';
import '../../utils/Alert.dart';
import '../../utils/Utils.dart';
import 'package:provider/provider.dart';

import '../../utils/shared_pref.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // some controllers and initialize values.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isHidden = true;
  final AuthVM userViewModel = AuthVM();
  late SharedPreferencesService _sharedPreferencesService;

  @override
  void dispose() {
    // dispose viewmodel and controllers
    passwordController.dispose();
    emailController.dispose();
    userViewModel.dispose();
    userViewModel.removeListener(() {});
    super.dispose();
  }


  @override
  void initState() {
    // method to get the token after login
    getToken();
    super.initState();
  }
  // Save User Data
  Future<void> saveUser(UserModel? data) async {
    _sharedPreferencesService = await SharedPreferencesService.getInstance();
    // Save the user model to SharedPreferences
    _sharedPreferencesService.saveStringModel(AppStrings.token, data!.token!);

    print('User saved to SharedPreferences');
  }


  // get  User Data
  Future<void> getToken() async {
    _sharedPreferencesService = await SharedPreferencesService.getInstance();

    // Get the user model from  SharedPreferences

   var token= _sharedPreferencesService.getStringValue(AppStrings.token);
    print('User saved to SharedPreferences$token');

    if(token!=null && token.isNotEmpty){
  RouteNavigation.modelListScreen(context);
}
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    print('Test Size == $h $w');
    // String Utils to manage view for all screen sizes
    ScreenUtil.init(context, designSize: Size(w, h));
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: ChangeNotifierProvider<AuthVM>.value(
            value: userViewModel,
            child: Consumer<AuthVM>(builder: (context, viewModel, _) {
              return Stack(
                children: [
                  showView(),
                  // Loader overlay
                  if (userViewModel.loginResponce.status ==
                      Status.LOADING)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                          child: Center(
                            child: Container(
                                height: 35.h,
                                width: 35.h,
                                child: AppWidets.circularProgress()),
                          )),
                    ),
                ],
              );
            })),
      ),
    );
  }

  // show views
  Widget showView() {
    return Container(

      child: Column(

        children: [
          Container(
            margin: EdgeInsets.only(top: 40.sp),
            child: Align(
              child: GradientText(
              AppStrings.quick_login,
                textAlign: TextAlign.center,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    height: 1,
                    fontFamily: "Berlin",
                    fontWeight: FontWeight.w400,
                    color: AppColors.themeColor,
                    fontSize: 30.sp),
                gradientType: GradientType.linear,
                gradientDirection: GradientDirection.ttb,
                radius: .4,
                colors: [
                  Color.fromRGBO(0, 170, 79, 1),
                  Color.fromRGBO(3, 160, 85, 1),
                  Color.fromRGBO(13, 133, 103, 1),
                  Color.fromRGBO(27, 90, 131, 1),
                  Color.fromRGBO(38, 59, 151, 1),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 10.sp,left: 40.sp,right: 40.sp),
            child: Center(
              child: Text(
                AppStrings.login_sub_heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Nexa",
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black_text_color,
                    fontSize: 12.sp),

              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
              margin: EdgeInsets.only(top: 80.sp),
                    child: Column(
                      children: [
                        // for email
                        Container(
                          margin: EdgeInsets.only(right: 20.sp, left: 20.sp),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Image.asset(
                                  AppIcons.ic_message,
                                  width: 20.sp,
                                ),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(16.sp),
                              hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.hint_color,
                                  fontFamily: "Nexa",
                                  fontWeight: FontWeight.w400),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: BorderSide(
                                    color: AppColors
                                        .black), // Change the color for focused state
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: BorderSide(
                                    color: AppColors
                                        .outline_grey), // Change the color for non-focused state
                              ),
                              hintText: 'Email',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        // for password
                        Container(
                          margin: EdgeInsets.only(right: 20.sp, left: 20.sp),
                          child: TextField(
                            controller: passwordController,
                            obscureText: _isHidden,
                            decoration: InputDecoration(
                              prefixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Image.asset(
                                  AppIcons.ic_lock,
                                  width: 20.sp,
                                ),
                              ),
                              suffix: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    _isHidden = !_isHidden;
                                  });
                                },
                                child: Image.asset(
                                  _isHidden
                                      ? AppIcons.ic_hide_pwd
                                      : AppIcons.ic_show_pwd,
                                  width: 20.sp,
                                ),
                              ),
                              isDense: true,
                              hintStyle: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.hint_color,
                                fontFamily: "Nexa",
                                fontWeight: FontWeight.w400,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: BorderSide(
                                    color: AppColors
                                        .black), // Change the color for focused state
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: BorderSide(
                                    color: AppColors
                                        .outline_grey), // Change the color for non-focused state
                              ),
                              hintText: 'Password',
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 40.sp,
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 150.h,),
                  signINButton()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// widget for SignIn button
  Widget signINButton() {
    return Container(
      margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
      child: AppWidets.commontext(
        context,
        10.sp,
        14.sp,
        AppStrings.sign_in,
        16.sp,
        callback: (String data) {
          Utils.keyBoardHide(context);
          if (validate()) {
            loginAPI();
          }
        },
      ),
    );
  }

  // validation method with return value
  bool validate() {
    if (emailController != null && emailController.text.trim().isEmpty) {
      Alert.alertDialogWithOk(
          context, AppStrings.please_enter_your_email, AppStrings.app_name,
          callback: (String data) {});
      return false;
    } else if (Utils.isEmail(emailController.text.trim()) == false) {
      Alert.alertDialogWithOk(
          context, AppStrings.please_enter_valid_email, AppStrings.app_name,
          callback: (String data) {});
      return false;
    } else if (passwordController.text.trim().isEmpty) {
      Alert.alertDialogWithOk(
          context, AppStrings.please_enter_your_password, AppStrings.app_name,
          callback: (String data) {});
      return false;
    } else {
      return true;
    }
  }



  // login API
  void loginAPI() async {

    Map<String, dynamic> body = <String, dynamic>{
      "user_email": emailController.text.trim(),
      "password":passwordController.text.trim(),

    };
    try {
      await userViewModel.loginAPI(body);

      // Optionally, you can check the loading status after the API call.
      if (userViewModel.loginLoading) {
        print("login API is still loading...");
      } else {
        print("login API completed!");

        // Now, you can check the result in yourViewModel.frogotResponce.
        // You may want to handle different cases based on the API response status.
        switch (userViewModel.loginResponce.status) {
          case Status.LOADING:
          // Handle loading state (although it should not be here if it completed)
            break;
          case Status.COMPLETED:
            if (userViewModel.loginResponce.data?.code == 201) {
              // Handle completion with code 201
              // Show an alert or perform actions accordingly
              // Show an alert dialog for successful completion
              Alert.alertDialogWithOk(
                context,
                userViewModel.loginResponce.data!.message,
                AppStrings.app_name,
                callback: (value) {
                  userViewModel.removeListener(() {});

                },
              );
            } else if (userViewModel.loginResponce.data?.code == 200) {
              saveUser(userViewModel.loginResponce.data!);
RouteNavigation.modelListScreen(context);


            }else if (userViewModel.loginResponce.data?.code == 203) {
              // Handle completion with code 200
              // Show an alert or perform actions accordingly
              Alert.alertDialogSessionExpire(
                context,
                userViewModel.loginResponce.data!.message,
                AppStrings.app_name,
              );


            }else{
              Alert.alertDialogWithOk(
                context,
                userViewModel.loginResponce.data!.message,
                AppStrings.app_name,
                callback: (value) {
                  userViewModel.removeListener(() {});
                },
              );
            }
            break;
          case Status.ERROR:
          // Handle error state
          // Show an alert or perform actions accordingly
            Alert.alertDialogWithOk(
              context,
              userViewModel.loginResponce.message!,
              AppStrings.app_name,
              callback: (value) {
                userViewModel.removeListener(() {});
                // Your callback logic here
              },
            );
            break;
          default:
          // Handle other states if needed
            break;
        }
      }
    } catch (error) {
      print("Error calling changePasswordAPI: $error");}
  }

}
