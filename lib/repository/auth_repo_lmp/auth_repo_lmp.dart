import 'package:demo_project/model/auth/base_model.dart';
import 'package:demo_project/model/auth/booking_list_model.dart';
import 'package:demo_project/model/auth/models_list_model.dart';
import 'package:demo_project/model/auth/user_model.dart';
import 'package:demo_project/repository/auth_repo/auth_repo.dart';

import '../../data/network/ApiEndPoints.dart';
import '../../data/network/BaseApiService.dart';
import '../../data/network/NetworkApiService.dart';

class AuthRepoImp implements AuthRepo{
  BaseApiService _apiService = NetworkApiService();

  // define API's

  @override
  Future<UserModel?> loginAPI(Map<String, dynamic> jsonBody) async {
    try {
      print("Demo PARAMS $jsonBody");
      dynamic response =
          await _apiService.postResponse(ApiEndPoints.login_api, jsonBody);
      print("Demo RESPONCE $response");
      final jsonData = UserModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("EMP-E $e}");
    }
  }
  @override
  Future<BaseModel?> addBooking_api(Map<String, dynamic> jsonBody) async {
    try {
      print("Demo PARAMS $jsonBody");
      dynamic response =
          await _apiService.postResponse(ApiEndPoints.addBooking_api, jsonBody);
      print("Demo RESPONCE $response");
      final jsonData = BaseModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("EMP-E $e}");
    }
  }
  @override
  Future<BaseModel?> logput_api(Map<String, dynamic> jsonBody) async {
    try {
      print("Demo PARAMS $jsonBody");
      dynamic response =
          await _apiService.postResponse(ApiEndPoints.logput_api, jsonBody);
      print("Demo RESPONCE $response");
      final jsonData = BaseModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("EMP-E $e}");
    }
  }
 @override
  Future<ModelsListModel?> modelList_api() async {
    try {
      dynamic response =
          await _apiService.getResponse(ApiEndPoints.modelList_api);
      print("Demo RESPONCE $response");
      final jsonData = ModelsListModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("EMP-E $e}");
    }
  }
 @override
  Future<BookingListModel?> bookingList_api(String month,String modelID) async {
    try {
      dynamic response =
          await _apiService.getResponse(ApiEndPoints.bookingList_api+"?month=$month&modelId=$modelID");
      print("Demo RESPONCE $response");
      final jsonData = BookingListModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("EMP-E $e}");
    }
  }

}