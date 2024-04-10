import 'package:demo_project/data/network/ApiEndPoints.dart';
import 'package:demo_project/model/auth/models_list_model.dart';
import 'package:demo_project/res/AppIcons.dart';
import 'package:demo_project/res/Colors.dart';
import 'package:demo_project/views/model_module/calender_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:provider/provider.dart';
import '../../app_widgets/AppWidets.dart';
import '../../data/response/Status.dart';
import '../../res/AppStrings.dart';
import '../../utils/Alert.dart';
import '../../utils/RouteNavigation.dart';
import '../../utils/shared_pref.dart';
import '../../view_model/auth/auth_vm.dart';

class ModelListScreen extends StatefulWidget {
  const ModelListScreen({super.key});

  @override
  State<ModelListScreen> createState() => _ModelListScreenState();
}

class _ModelListScreenState extends State<ModelListScreen> {
  // some controllers and initialize values.
  final AuthVM userViewModel = AuthVM();
  List<DetailModel> mList = [];
  late SharedPreferencesService _sharedPreferencesService;
  String userToken = "";

  @override
  void dispose() {
    // dispose viewmodel and controllers
    userViewModel.dispose();
    userViewModel.removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    mList.clear();
    // call API to get the models list
    getModelLists();
    // method to get the token after login
    getToken();
    super.initState();
  }

  // get  User Data
  Future<void> getToken() async {
    _sharedPreferencesService = await SharedPreferencesService.getInstance();

    // Get the user model from SharedPreferences

    userToken = _sharedPreferencesService.getStringValue(AppStrings.token)!;
    print('User saved to SharedPreferences$userToken');
  }

  // get Models List API
  Future<void> getModelLists() async {
    try {
      await userViewModel.modelList_api();

      // Optionally, you can check the loading status after the API call.
      if (userViewModel.modelListLoading) {
        print("Get Models API is still loading...");
      } else {
        print("Get Models API completed!");
        // Now, you can check the result in youruserViewModel.frogotResponce.
        // You may want to handle different cases based on the API response status.
        switch (userViewModel.modelListResponce.status) {
          case Status.LOADING:
            // Handle loading state (although it should not be here if it completed)
            break;
          case Status.COMPLETED:
            if (userViewModel.modelListResponce.data?.code == 201) {
              // Handle completion with code 201
              // Show an alert or perform actions accordingly
              // Show an alert dialog for successful completion
              Alert.alertDialogWithOk(
                context,
                userViewModel.loginResponce.message!,
                AppStrings.app_name,
                callback: (value) {
                  userViewModel.removeListener(() {});
                  // Your callback logic here
                },
              );
            } else if (userViewModel.modelListResponce.data?.code == 200) {
              mList = userViewModel.modelListResponce.data!.detailModel!;
            } else if (userViewModel.modelListResponce.data?.code == 202) {
              Alert.alertDialogWithOk(
                context,
                userViewModel.loginResponce.message!,
                AppStrings.app_name,
                callback: (value) {
                  userViewModel.removeListener(() {});
                  // Your callback logic here
                },
              );
            } else if (userViewModel.modelListResponce.data?.code == 203) {
              Alert.alertDialogSessionExpire(
                context,
                userViewModel.loginResponce.message!,
                AppStrings.app_name,
              );
            } else {
              Alert.alertDialogSessionExpire(
                context,
                userViewModel.loginResponce.message!,
                AppStrings.app_name,
              );
            }
            break;
          case Status.ERROR:
            // Handle error state
            // Show an alert or perform actions accordingly
            Alert.alertDialogSessionExpire(
              context,
              userViewModel.loginResponce.message!,
              AppStrings.app_name,
            );
            break;
          default:
            // Handle other states if needed
            break;
        }
      }
    } catch (error) {
      print("Error calling Get Models : $error");
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
                      if (userViewModel.modelListResponce.status ==
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
                }))));
  }

  // show View
  Widget showView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40.sp),
                child: Align(
                  child: GradientText(
                    AppStrings.model_lists,
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
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  Alert.alertDialogWithOkCancel(
                      context,
                      AppStrings.are_you_sure_you_want_to_logout,
                      AppStrings.app_name, callback: (returnValue) {
                    print(returnValue);
                    if (returnValue == "OK") {
                      lougoutAPI();
                    }
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(20.sp),
                    margin: EdgeInsets.only(top: 40.sp),
                    child: Image.asset(
                      AppIcons.ic_logout,
                      width: 20.w,
                      height: 20.h,
                    )),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
                itemCount: mList.length,
                itemBuilder: (context, index) {
                  var mModel = mList[index];
                  return showViewItems(mModel, index);
                }),
          ),
        ),
      ],
    );
  }

// show view items
  Widget showViewItems(DetailModel mModel, int index) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalenderScreen(
                  callBack: (returnVal) {
                    mList.clear();
                    getModelLists();
                  },
                  modelId: mModel.id),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(left: 20.sp, right: 20.sp, top: 10.sp),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppIcons.ic_background),
            // Replace 'assets/background_image.jpg' with the path to your image asset
            fit: BoxFit.fill, // Adjust the fit according to your design
          ),
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.sp),
                    child: Container(
                      width: 90.w,
                      height: 85.h,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage(
                            image: NetworkImage(
                              ApiEndPoints.imagebaseUrl + mModel.image,
                            ),
                            placeholder:
                                const AssetImage(AppIcons.ic_place_holder),
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          right: 10.sp, top: 10.sp, bottom: 10.sp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // Set to min to prevent overflow
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mModel.name,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              height: 1,
                              fontFamily: "Berlin",
                              fontWeight: FontWeight.w500,
                              color: AppColors.black_text_color,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 8), // Add some spacing
                          Text(
                            "${mModel.title}",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              height: 1,
                              fontFamily: "Berlin",
                              fontWeight: FontWeight.w400,
                              color: AppColors.themeColor1,
                              fontSize: 14.sp,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Age: ${mModel.age}',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              height: 1,
                              fontFamily: "Berlin",
                              fontWeight: FontWeight.w300,
                              color: AppColors.black_grey,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Height: ${mModel.height}',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              height: 1,
                              fontFamily: "Berlin",
                              fontWeight: FontWeight.w300,
                              color: AppColors.black_grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // logout
  void lougoutAPI() async {
    Map<String, dynamic> body = <String, dynamic>{
      "token": userToken,
    };
    try {
      await userViewModel.logput_api(body);

      // Optionally, you can check the loading status after the API call.
      if (userViewModel.baseLoading) {
        print("logout API is still loading...");
      } else {
        print("logout API completed!");

        // Now, you can check the result in yourViewModel.frogotResponce.
        // You may want to handle different cases based on the API response status.
        switch (userViewModel.baseModelResponce.status) {
          case Status.LOADING:
            // Handle loading state (although it should not be here if it completed)
            break;
          case Status.COMPLETED:
            if (userViewModel.baseModelResponce.data?.code == 201) {
              // Handle completion with code 201
              // Show an alert or perform actions accordingly
              // Show an alert dialog for successful completion
              Alert.alertDialogWithOk(
                context,
                userViewModel.baseModelResponce.data!.message,
                AppStrings.app_name,
                callback: (value) {
                  userViewModel.removeListener(() {});
                },
              );
            } else if (userViewModel.baseModelResponce.data?.code == 200) {
              _sharedPreferencesService.clearAll();
              RouteNavigation.loginScreen(context);
            } else if (userViewModel.baseModelResponce.data?.code == 203) {
              // Handle completion with code 200
              // Show an alert or perform actions accordingly
              Alert.alertDialogSessionExpire(
                context,
                userViewModel.baseModelResponce.data!.message,
                AppStrings.app_name,
              );
            } else {
              Alert.alertDialogWithOk(
                context,
                userViewModel.baseModelResponce.data!.message,
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
              userViewModel.baseModelResponce.message!,
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
      print("Error calling add Booking: $error");
    }
  }
}
