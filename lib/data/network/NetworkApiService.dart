import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import '../../res/AppStrings.dart';
import '../../utils/shared_pref.dart';
import '../response/AppException.dart';
import 'ApiEndPoints.dart';
import 'BaseApiService.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getResponse(String url) async {
    dynamic responseJson;
    try {

      // Initialize SharedPreferencesService asynchronously
      SharedPreferencesService sharedPreferencesService = await SharedPreferencesService.getInstance();
      var headers = {'Content-Type': 'application/json',
        'token': '${getUserToken(sharedPreferencesService)}',};
   
      final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl + url),
        headers: headers,

      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }
  @override
  Future postURLResponse(String url) async {
    dynamic responseJson;
    try {

      // Initialize SharedPreferencesService asynchronously
      SharedPreferencesService sharedPreferencesService = await SharedPreferencesService.getInstance();
      var headers = {'Content-Type': 'application/json',
        'token': '${getUserToken(sharedPreferencesService)}',};
      print("Demo URL ${ApiEndPoints.baseUrl + url}");
      final response = await http.post(
        Uri.parse(ApiEndPoints.baseUrl + url),
        headers: headers,

      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }
  @override
  Future patchURLResponse(String url) async {
    dynamic responseJson;
    try {

      // Initialize SharedPreferencesService asynchronously
      SharedPreferencesService sharedPreferencesService = await SharedPreferencesService.getInstance();
      var headers = {'Content-Type': 'application/json',
        'token': '${getUserToken(sharedPreferencesService)}',};
      print("Demo URL ${ApiEndPoints.baseUrl + url}");
      final response = await http.patch(
        Uri.parse(ApiEndPoints.baseUrl + url),
        headers: headers,

      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
  dynamic returnResponseMultipart(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with the server with status code: ${response.statusCode}');
    }
  }

  Future handleMultipartResponse(http.StreamedResponse response) async {
    final String responseBody = await utf8.decodeStream(response.stream);
    final int statusCode = response.statusCode;
    switch (response.statusCode) {
      case 200:
        return jsonDecode(responseBody);
      case 400:
        throw BadRequestException(responseBody);
      case 401:
      case 403:
        throw UnauthorisedException(responseBody);
      case 404:
        throw UnauthorisedException(responseBody.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with the server with status code: ${response.statusCode}');
    }

  }



  @override
  Future postResponse(String url, Map<String, dynamic> JsonBody) async {
    dynamic responseJson;
    try {
      // Initialize SharedPreferencesService asynchronously
      SharedPreferencesService sharedPreferencesService = await SharedPreferencesService.getInstance();

      var headers = {'Content-Type': 'application/json',
        'token': '${getUserToken(sharedPreferencesService)}',};
      print("Demo URL ${ApiEndPoints.baseUrl + url}");
      print("Demo URL Headers ${headers}");

      final response = await http.post(
        Uri.parse(ApiEndPoints.baseUrl + url),
        headers: headers,
        body: json.encode(JsonBody), // Use json.encode instead of jsonEncode
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }


  @override
  Future patchResponse(String url, Map<String, dynamic> JsonBody) async {
    dynamic responseJson;
    try {
      // Initialize SharedPreferencesService asynchronously
      SharedPreferencesService sharedPreferencesService = await SharedPreferencesService.getInstance();

      var headers = {'Content-Type': 'application/json',
        'token': '${getUserToken(sharedPreferencesService)}',};
      print("Demo URL ${ApiEndPoints.baseUrl + url}");
      print("Demo URL Headers ${headers}");
      print("Demo URL BODY ${JsonBody}");

      final response = await http.patch(
        Uri.parse(ApiEndPoints.baseUrl + url),
        headers: headers,
        body: json.encode(JsonBody), // Use json.encode instead of jsonEncode
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  // Assume you have a method to get the user token from SharedPreferences
  String getUserToken(SharedPreferencesService sharedPreferencesService) {

    var token =sharedPreferencesService.getStringValue(AppStrings.token);
    // Return the user token (you may need to adjust this based on your UserModel structure)
    return  token??'';
  }

  @override
  Future deleteResponse(String url) async{
    dynamic responseJson;
    try {
      // Initialize SharedPreferencesService asynchronously
      SharedPreferencesService sharedPreferencesService = await SharedPreferencesService.getInstance();
      var headers = {'Content-Type': 'application/json',
        'token': '${getUserToken(sharedPreferencesService)}',};
      print("Demo URL ${ApiEndPoints.baseUrl + url}");
      print("Demo URL Headers ${headers}");
      final response = await http.delete(
        Uri.parse(ApiEndPoints.baseUrl + url),
        headers: headers,

      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postMultipartFiles(String url, Map<String, dynamic> jsonBody, List<File>? imageFiles) async {
    dynamic responseJson;
    try {
      // Initialize SharedPreferencesService asynchronously
      SharedPreferencesService sharedPreferencesService = await SharedPreferencesService.getInstance();

      var headers = {
        'Content-Type': 'multipart/form-data',
        'token': '${getUserToken(sharedPreferencesService)}',
      };

      print("Demo URL ${ApiEndPoints.baseUrl + url}");
      print("Demo URL Headers ${headers}");
      print("Demo URL JsonBody ${jsonBody}");
      print("Demo URL imageFiles ${imageFiles}");

      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.baseUrl + url));
      request.headers.addAll(headers);

      // Add form data
      jsonBody.forEach((key, value) {
        // Check if the value is a list, and if so, encode it as JSON
        if (value is List) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      if (imageFiles != null) {
        // Add all image files to the "files" parameter
        List<http.MultipartFile> multipartFiles = [];
        for (int i = 0; i < imageFiles.length; i++) {
          var imageFile = imageFiles[i];
          var stream = http.ByteStream(imageFile.openRead());
          var length = await imageFile.length();
          String fileName = basename(imageFile.path);

          var multipartFile = http.MultipartFile(
            'files', // Use 'files[]' as the field name to represent an array
            stream,
            length,
            filename: fileName,
            contentType: MediaType('image', 'application/octet-stream'),
          );

          multipartFiles.add(multipartFile);
        }

        request.files.addAll(multipartFiles);
      }

      final response = await request.send();
      responseJson = handleMultipartResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }
  @override
  Future patchMultipartFiles(String url, Map<String, dynamic> jsonBody, List<File>? imageFiles) async {
    dynamic responseJson;
    try {
      // Initialize SharedPreferencesService asynchronously
      SharedPreferencesService sharedPreferencesService = await SharedPreferencesService.getInstance();

      var headers = {
        'Content-Type': 'multipart/form-data',
        'token': '${getUserToken(sharedPreferencesService)}',
      };

      print("Demo URL ${ApiEndPoints.baseUrl + url}");
      print("Demo URL Headers ${headers}");
      print("Demo URL JsonBody ${jsonBody}");
      print("Demo URL imageFiles ${imageFiles}");

      var request = http.MultipartRequest('PATCH', Uri.parse(ApiEndPoints.baseUrl + url));
      request.headers.addAll(headers);

      // Add form data
      jsonBody.forEach((key, value) {
        // Check if the value is a list, and if so, encode it as JSON
        if (value is List) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      if (imageFiles != null) {
        // Add all image files to the "files" parameter
        List<http.MultipartFile> multipartFiles = [];
        for (int i = 0; i < imageFiles.length; i++) {
          var imageFile = imageFiles[i];
          var stream = http.ByteStream(imageFile.openRead());
          var length = await imageFile.length();
          String fileName = basename(imageFile.path);

          var multipartFile = http.MultipartFile(
            'files', // Use 'files[]' as the field name to represent an array
            stream,
            length,
            filename: fileName,
            contentType: MediaType('image', 'application/octet-stream'),
          );

          multipartFiles.add(multipartFile);
        }

        request.files.addAll(multipartFiles);
      }

      final response = await request.send();
      responseJson = handleMultipartResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future patchMultipart(String url, Map<String, dynamic> jsonBody, File? imageFile ,String fileparam) async {
    dynamic responseJson;
    try {
      // Initialize SharedPreferencesService asynchronously
      SharedPreferencesService sharedPreferencesService = await SharedPreferencesService.getInstance();

      var headers = {
        'Content-Type': 'multipart/form-data',
        'token': '${getUserToken(sharedPreferencesService)}',
      };

      print("Demo URL ${ApiEndPoints.baseUrl + url}");
      print("Demo URL Headers ${headers}");

      var request = http.MultipartRequest('PATCH', Uri.parse(ApiEndPoints.baseUrl + url));
      request.headers.addAll(headers);



      // Add form data
      jsonBody.forEach((key, value) {
        // Check if the value is a list, and if so, encode it as JSON
        if (value is List) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });
      if(imageFile!=null){
        // Add the image file to the request
        var stream = http.ByteStream(imageFile!.openRead());
        var length = await imageFile.length();
        String fileName = basename(imageFile.path);

        var multipartFile = http.MultipartFile(
          fileparam, // Replace with your desired field name
          stream,
          length,
          filename: fileName, // Replace with your desired filename
          contentType: MediaType('image', 'application/octet-stream'), // Adjust the content type accordingly
        );

        request.files.add(multipartFile);
      }


      final response = await request.send();
      responseJson = handleMultipartResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future patchMultipartImage(String url, File imageFile,String fileparam) async {
    dynamic responseJson;
    try {
      // Initialize SharedPreferencesService asynchronously
      SharedPreferencesService sharedPreferencesService = await SharedPreferencesService.getInstance();

      var headers = {
        'Content-Type': 'multipart/form-data',
        'token': '${getUserToken(sharedPreferencesService)}',
      };

      print("Demo URL ${ApiEndPoints.baseUrl + url}");
      print("Demo URL Headers ${headers}");

      var request = http.MultipartRequest('PATCH', Uri.parse(ApiEndPoints.baseUrl + url));
      request.headers.addAll(headers);



      // Add the image file to the request
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      String fileName = basename(imageFile.path);

      var multipartFile = http.MultipartFile(
        fileparam, // Replace with your desired field name
        stream,
        length,
        filename: fileName, // Replace with your desired filename
        contentType: MediaType('image', 'application/octet-stream'), // Adjust the content type accordingly
      );

      request.files.add(multipartFile);

      final response = await request.send();
      responseJson = handleMultipartResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postMultipartImage(String url, File imageFile,String fileparam) async {
    dynamic responseJson;
    try {
      // Initialize SharedPreferencesService asynchronously
      SharedPreferencesService sharedPreferencesService = await SharedPreferencesService.getInstance();

      var headers = {
        'Content-Type': 'multipart/form-data',
        'token': '${getUserToken(sharedPreferencesService)}',
      };

      print("Demo URL ${ApiEndPoints.baseUrl + url}");
      print("Demo URL Headers ${headers}");

      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.baseUrl + url));
      request.headers.addAll(headers);



      // Add the image file to the request
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      String fileName = basename(imageFile.path);

      var multipartFile = http.MultipartFile(
        fileparam, // Replace with your desired field name
        stream,
        length,
        filename: fileName, // Replace with your desired filename
        contentType: MediaType('image', 'application/octet-stream'), // Adjust the content type accordingly
      );

      request.files.add(multipartFile);

      final response = await request.send();
      responseJson = handleMultipartResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }


}
