import 'dart:io' show Platform;
import 'package:demo_project/model/auth/booking_list_model.dart';
import 'package:demo_project/res/AppIcons.dart';
import 'package:demo_project/res/Colors.dart';
import 'package:demo_project/utils/Utils.dart';
import 'package:demo_project/views/model_module/add_booking_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'package:intl/intl.dart';

import '../../app_widgets/AppWidets.dart';
import '../../data/response/Status.dart';
import '../../res/AppStrings.dart';
import '../../utils/Alert.dart';
import '../../view_model/auth/auth_vm.dart';

class CalenderScreen extends StatefulWidget {
  final Function(String) callBack;
  final String modelId;

  const CalenderScreen(
      {super.key, required this.callBack, required this.modelId});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  // some controllers and initialize values.
  ItemScrollController _scrollController = ItemScrollController();
  late Map<DateTime, List<dynamic>> events;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final AuthVM userViewModel = AuthVM();
  List<BookingList> mList = [];

  @override
  void dispose() {
    // dispose viewmodel
    userViewModel.dispose();
    userViewModel.removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    mList.clear();
    // initial month
    String monthName = DateFormat('MMMM').format(_focusedDay);
    // call list API
    getBookingList(monthName);
    super.initState();
  }

  // get Booking List API
  Future<void> getBookingList(String month) async {
    try {
      print("Month Name == " + month);
      await userViewModel.bookingList_api(month, widget.modelId);

      // Optionally, you can check the loading status after the API call.
      if (userViewModel.bookingLoading) {
        print("Get bookings API is still loading...");
      } else {
        print("Get bookings API completed!");
        // Now, you can check the result in youruserViewModel.frogotResponce.
        // You may want to handle different cases based on the API response status.
        switch (userViewModel.bookingListResponce.status) {
          case Status.LOADING:
            // Handle loading state (although it should not be here if it completed)
            break;
          case Status.COMPLETED:
            if (userViewModel.bookingListResponce.data?.code == 201) {
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
            } else if (userViewModel.bookingListResponce.data?.code == 200) {
              mList = userViewModel.bookingListResponce.data!.bookingList!;
            } else if (userViewModel.bookingListResponce.data?.code == 202) {
              Alert.alertDialogWithOk(
                context,
                userViewModel.loginResponce.message!,
                AppStrings.app_name,
                callback: (value) {
                  userViewModel.removeListener(() {});
                  // Your callback logic here
                },
              );
            } else if (userViewModel.bookingListResponce.data?.code == 203) {
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
      print("Error calling Get bookings : $error");
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
        top: Platform.isIOS == true ? false : true,
        child: ChangeNotifierProvider<AuthVM>.value(
          value: userViewModel,
          child: Consumer<AuthVM>(
            builder: (context, viewModel, _) {
              return Stack(
                children: [
                  showWidgets(),
                  // Loader overlay
                  if (userViewModel.bookingListResponce.status ==
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
            },
          ),
        ),
      ),
    );
  }

  // show widgets
  Widget showWidgets() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 180.h,
            decoration: BoxDecoration(
              color: Color.fromRGBO(172, 192, 192, 0.6),
            ),
            child: Container(
              margin: EdgeInsets.only(
                  top: Platform.isIOS == true ? 40.sp : 25.sp,
                  left: 20.sp,
                  right: 20.sp),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x00FFFFFF),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
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
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 12.sp),
                        child: Text(
                          'Calendar',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontFamily: 'Berlin',
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(0, 0, 0, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddBookingScreen(
                                  callBack: (returnVal) {
                                    mList.clear();
                                    String monthName =
                                        DateFormat('MMMM').format(_focusedDay);
                                    getBookingList(monthName);
                                  },
                                  modelId: widget.modelId),
                            ));
                      },
                      child: Container(
                          padding: EdgeInsets.all(20.sp),
                          child: Image.asset(
                            AppIcons.ic_add,
                            width: 20.w,
                            height: 20.h,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.sp, 195.sp, 20.sp, 0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 240, 0, 0),
                child: mList.isNotEmpty
                    ? ScrollablePositionedList.builder(
                        itemScrollController: _scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: mList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var mModel = mList[index];
                          return showView(mModel, index);
                        })
                    : Container(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "No Bookings Found",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Berlin',
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 0, 0, 1.0)),
                          ),
                        )),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15, 115, 15, 0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Color(0x32573926),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 3), // Offset in x and y direction
                  ),
                ],
              ),
              child: Container(
                width: double.infinity,
                height: 300.h,
                child: Container(
                  margin: EdgeInsets.all(10.sp),
                  child: TableCalendar(
                    rowHeight: 35.h,
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Berlin',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 1.0),
                      ),
                      formatButtonVisible: false,
                      leftChevronPadding: EdgeInsets.zero,
                      rightChevronPadding: EdgeInsets.zero,
                      leftChevronIcon: Image.asset(
                        AppIcons.assetsArrorLeft,
                        height: 30.sp,
                        width: 30.sp,
                      ),
                      rightChevronIcon: Image.asset(
                        AppIcons.assetsArrowRight,
                        height: 30.sp,
                        width: 30.sp,
                      ),
                    ),
                    onPageChanged: (focusedDay) {
                      setState(() {
                        String monthName =
                            DateFormat('MMMM').format(focusedDay);
                        _focusedDay = focusedDay;
                        print("Page Changed to new one" + monthName);
                        getBookingList(monthName);
                      });
                    },
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'Berlin',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 1.0),
                      ),
                      weekendStyle: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'Berlin',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 1.0),
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Berlin',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 1.0),
                      ),
                      todayTextStyle: TextStyle(
                        fontFamily: 'Berlin',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 1.0),
                      ),
                      todayDecoration: BoxDecoration(
                        color: Color(0xFFFA9902),
                        // Change this color to the desired color
                        shape: BoxShape
                            .circle, // You can also change the shape if needed
                      ),
                      weekendTextStyle: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Berlin',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 1.0),
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Color.fromRGBO(152, 223, 245, 1.0),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Berlin',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 1.0),
                      ),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      outsideTextStyle: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'Berlin',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(103, 105, 105, 0.5),
                      ),
                    ),
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    calendarBuilders:
                        CalendarBuilders(markerBuilder: (context, date, event) {
                      final eventColor = _getEventColor(date);
                      return Container(
                        margin: EdgeInsets.only(top: 10.sp),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: eventColor,
                        ),
                        width: 6.0.sp,
                        height: 6.0.sp,
                      );
                    }),
                    onDaySelected: (selectedDay, focusedDay) {
                      print(selectedDay.microsecondsSinceEpoch);
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay; // Update the focused day here
                        String monthName =
                            DateFormat('MMMM').format(_focusedDay);
                      });
                      scrollToIndex(selectedDay);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// List view
  Widget showView(BookingList mModel, int index) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      margin: EdgeInsets.all(5.sp),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.outline_grey_point_two,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(

                          child: Text(
                            Utils.capitalizeFirstLetter(mModel.title),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Berlin',
                              fontWeight: FontWeight.w600,
                              color: AppColors.black_text_color,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(

                        child: Text(
                          Utils.convertTime(mModel.startDate),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Nexa',
                            fontWeight: FontWeight.w600,
                            color: AppColors.outline_grey_point_six,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(

                    child: Text(
                      Utils.capitalizeFirstLetter(mModel.desc),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Nexa',
                        fontWeight: FontWeight.w600,
                        color: AppColors.outline_grey_point_six,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // show event dot color at bottom of the date in calender
  Color _getEventColor(DateTime date) {
    var matchDate = DateFormat('MM/dd/yyyy').format(date);
    bool containsDate = mList.any((mModel) =>
        DateFormat('MM/dd/yyyy')
            .format(DateTime.fromMillisecondsSinceEpoch(mModel.startDate)) ==
        matchDate);

    if (containsDate) {
      return Color(0xFF98DFF5);
    } else {
      return Colors.transparent;
    }
  }

// method to scroll the date on particular position
  void scrollToIndex(DateTime selectedDay) {
    var mainDate = DateFormat('MM/dd/yyyy').format(selectedDay);
    if (mList.length != 0) {
      setState(() {
        var index = mList.indexWhere((mModel) =>
            DateFormat('MM/dd/yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(mModel.startDate)) ==
            mainDate);
        print("index ==" + index.toString());
        if (index >= 0) {
          _scrollController.scrollTo(
              index: index, duration: Duration(seconds: 1));
        }
      });
    }
  }
}
