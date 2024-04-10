import 'package:demo_project/model/auth/base_model.dart';
import 'package:demo_project/model/auth/booking_list_model.dart';
import 'package:demo_project/model/auth/models_list_model.dart';
import 'package:flutter/cupertino.dart';

import '../../data/response/ApiResponse.dart';
import '../../model/auth/user_model.dart';
import '../../repository/auth_repo_lmp/auth_repo_lmp.dart';

class AuthVM extends ChangeNotifier {
  final _myRepo = AuthRepoImp();

  // ApiResponse objects for various API calls
  ApiResponse<UserModel> loginResponce = ApiResponse.initial();
  ApiResponse<BaseModel> baseModelResponce = ApiResponse.initial();
  ApiResponse<ModelsListModel> modelListResponce = ApiResponse.initial();
  ApiResponse<BookingListModel> bookingListResponce = ApiResponse.initial();


  // Loading flags for various API calls
  bool loginLoading = false;
  bool bookingLoading = false;
  bool modelListLoading = false;
  bool baseLoading = false;

  // Set methods for ApiResponse objects
  void _setLoginMain(ApiResponse<UserModel> response) {
    print("EMP :: $response");
    loginResponce = response;
    notifyListeners();
  }
 void _setModelsList(ApiResponse<ModelsListModel> response) {
    print("EMP :: $response");
    modelListResponce = response;
    notifyListeners();
  }
  void _setBaseModel(ApiResponse<BaseModel> response) {
    print("EMP :: $response");
    baseModelResponce = response;
    notifyListeners();
  }
void _setBookingList(ApiResponse<BookingListModel> response) {
    print("EMP :: $response");
    bookingListResponce = response;
    notifyListeners();
  }


  // API call methods with loading flags

  // Login API
  Future<void> loginAPI(Map<String, dynamic> jsonBody) async {
    try {
      loginLoading = true;
      _setLoginMain(ApiResponse.loading());
      final value = await _myRepo.loginAPI(jsonBody);
      _setLoginMain(ApiResponse.completed(value));
    } catch (error, stackTrace) {
      _setLoginMain(ApiResponse.error(error.toString()));
    } finally {
      loginLoading = false;
      notifyListeners();
    }
  }

  // Add Booking API
Future<void> addBooking_api(Map<String, dynamic> jsonBody) async {
    try {
      baseLoading = true;
      _setBaseModel(ApiResponse.loading());
      final value = await _myRepo.addBooking_api(jsonBody);
      _setBaseModel(ApiResponse.completed(value));
    } catch (error, stackTrace) {
      _setBaseModel(ApiResponse.error(error.toString()));
    } finally {
      baseLoading = false;
      notifyListeners();
    }
  }

  // Logout API
Future<void> logput_api(Map<String, dynamic> jsonBody) async {
    try {
      baseLoading = true;
      _setBaseModel(ApiResponse.loading());
      final value = await _myRepo.logput_api(jsonBody);
      _setBaseModel(ApiResponse.completed(value));
    } catch (error, stackTrace) {
      _setBaseModel(ApiResponse.error(error.toString()));
    } finally {
      baseLoading = false;
      notifyListeners();
    }
  }


  // Model List API
  Future<void> modelList_api() async {
    try {
      modelListLoading = true;
      _setModelsList(ApiResponse.loading());
      final value = await _myRepo.modelList_api();
      _setModelsList(ApiResponse.completed(value));
    } catch (error, stackTrace) {
      _setModelsList(ApiResponse.error(error.toString()));
    } finally {
      modelListLoading = false;
      notifyListeners();
    }
  }

  // booking list API
  Future<void> bookingList_api(String month,String modelID) async {
    try {
      bookingLoading = true;
      _setBookingList(ApiResponse.loading());
      final value = await _myRepo.bookingList_api(month,modelID);
      _setBookingList(ApiResponse.completed(value));
    } catch (error, stackTrace) {
      _setBookingList(ApiResponse.error(error.toString()));
    } finally {
      bookingLoading = false;
      notifyListeners();
    }
  }
}