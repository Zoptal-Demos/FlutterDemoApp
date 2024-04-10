import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app_widgets/AppWidets.dart';
import '../../data/response/Status.dart';
import '../../res/AppIcons.dart';
import '../../res/AppStrings.dart';
import '../../res/Colors.dart';
import '../../utils/Alert.dart';
import '../../utils/Utils.dart';
import '../../view_model/auth/auth_vm.dart';
import 'package:provider/provider.dart';

class AddBookingScreen extends StatefulWidget {
  final Function(String) callBack;
  final String modelId;

  const AddBookingScreen(
      {super.key, required this.callBack, required this.modelId});

  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  // some controllers and initialize values.
  final AuthVM userViewModel = AuthVM();
  String startDate = "Start Date";
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    // dispose viewmodel and controllers
    nameController.dispose();
    descriptionController.dispose();
    userViewModel.dispose();
    userViewModel.removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    print('Test Size == $h $w');
    // String Utils to manage view for all screen sizes
    ScreenUtil.init(context, designSize: Size(w, h));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              padding: EdgeInsets.all(20.sp),
              child: Image.asset(
                AppIcons.ic_back,
                width: 20.w,
                height: 20.h,
              )),
        ),
        title: Text(
          'Add Booking',
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: 'Berlin',
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(0, 0, 0, 1.0),
          ),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: ChangeNotifierProvider<AuthVM>.value(
            value: userViewModel,
            child: Consumer<AuthVM>(builder: (context, viewModel, _) {
              return Stack(
                children: [
                  showWidgets(),
                  // Loader overlay
                  if (userViewModel.baseModelResponce.status == Status.LOADING)
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

  // date picker
  Future<void> _selectDate(BuildContext cntxt) async {
    try {
      final DateTime now = DateTime.now();
      final DateTime? picked = await showDatePicker(

        context: cntxt,
        initialDate: selectedDate,
        firstDate: now,
        lastDate: DateTime(2101),

      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    } on Exception catch (_) {
      print('never reached');
    }

  }

  // show widgets
  Widget showWidgets() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 80.sp),
                  child: Column(
                    children: [
                      // for name
                      Container(
                        margin: EdgeInsets.only(right: 20.sp, left: 20.sp),
                        child: TextField(
                          maxLength: 50,
                          controller: nameController,
                          decoration: InputDecoration(
                            counterText: "",
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
                            hintText: 'Title',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      // for description
                      Container(
                        margin: EdgeInsets.only(right: 20.sp, left: 20.sp),
                        child: TextField(
                          maxLength: 100,
                          maxLines: 3,
                          controller: descriptionController,
                          decoration: InputDecoration(
                            counterText: "",
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
                            hintText: 'Description',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      // for name
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.sp),
                            color: Colors.white,
                            // Set the background color here
                            border: Border.all(
                                color: AppColors.outline_grey), // Border color
                          ),
                          width: double.infinity,
                          margin: EdgeInsets.only(right: 20.sp, left: 20.sp),
                          padding: EdgeInsets.only(top: 16.sp, bottom: 16.sp),
                          child: Container(
                            margin: EdgeInsets.only(right: 20.sp, left: 15.sp),
                            child: Text(
                              Utils.convertTime(
                                  selectedDate.millisecondsSinceEpoch),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.black_text_color,
                                fontFamily: "Nexa",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 100.sp,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                        child: AppWidets.commontext(
                          context,
                          10.sp,
                          14.sp,
                          "Submit",
                          16.sp,
                          callback: (String data) {
                            Utils.keyBoardHide(context);
                            if (validate()) {
                              addBookingAPI();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 150.h,
                ),
                // signINButton()
              ],
            ),
          ),
        ),
      ],
    );
  }

  // validation method with return value
  bool validate() {
    if (nameController.text.trim().isEmpty) {
      Alert.alertDialogWithOk(
          context, AppStrings.please_enter_your_title, AppStrings.app_name,
          callback: (String data) {});
      return false;
    } else if (descriptionController.text.trim().isEmpty) {
      Alert.alertDialogWithOk(context, AppStrings.please_enter_your_description,
          AppStrings.app_name,
          callback: (String data) {});
      return false;
    } else {
      return true;
    }
  }

  // add booking
  void addBookingAPI() async {
    Map<String, dynamic> body = <String, dynamic>{
      "title": nameController.text.trim(),
      "desc": descriptionController.text.trim(),
      "startDate": selectedDate.millisecondsSinceEpoch,
      "modelId": widget.modelId,
    };
    try {
      await userViewModel.addBooking_api(body);

      // Optionally, you can check the loading status after the API call.
      if (userViewModel.baseLoading) {
        print("add Booking API is still loading...");
      } else {
        print("add Booking API completed!");

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
              widget.callBack("OK");
              Navigator.pop(context);
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
