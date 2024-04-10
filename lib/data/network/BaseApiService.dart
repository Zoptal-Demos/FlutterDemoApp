import 'dart:io';

abstract class BaseApiService {


  // Request methods
  Future<dynamic> getResponse(String url);
  Future<dynamic> postURLResponse(String url);
  Future<dynamic> patchURLResponse(String url);
  Future<dynamic> postResponse(String url,Map<String, dynamic> jsonBody);
  Future<dynamic> patchMultipart(String url,Map<String, dynamic> jsonBody,File? imageFile,String fileparam);
  Future<dynamic> postMultipartFiles(String url, Map<String, dynamic> jsonBody, List<File>? imageFiles);
  Future<dynamic> patchMultipartImage(String url,File imageFile,String fileparam);
  Future<dynamic> postMultipartImage(String url,File imageFile,String fileparam);
  Future<dynamic> patchMultipartFiles(String url, Map<String, dynamic> jsonBody, List<File>? imageFiles);
  Future<dynamic> patchResponse(String url,Map<String, dynamic> jsonBody);
  Future<dynamic> deleteResponse(String url);

}