import 'package:demo_project/model/auth/base_model.dart';
import 'package:demo_project/model/auth/booking_list_model.dart';

import '../../model/auth/models_list_model.dart';
import '../../model/auth/user_model.dart';

class AuthRepo{
  // declare API's Name
  Future<UserModel?> loginAPI(Map<String, dynamic> jsonBody) async {}
  Future<BaseModel?> logput_api(Map<String, dynamic> jsonBody) async {}
  Future<BaseModel?> addBooking_api(Map<String, dynamic> jsonBody) async {}
  Future<ModelsListModel?> modelList_api() async {}
  Future<BookingListModel?> bookingList_api(String month,String modelID) async {}

}