import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'app_exceptions.dart';

class ApiBaseHelper {
  Future<dynamic> post(String strUrl, Map<String, String> header,
      {required Map<String, String> body}) async {
    print('Api Post, url $strUrl');
    var responseJson;
    var url = Uri.parse(strUrl);
    try {
      final response = await http.post(url, body: body, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on BadRequestException catch (e) {
      throw BadRequestException(e);
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> get(String strUrl) async {
    print('Api Post, url $strUrl');
    var responseJson;
    var url = Uri.parse(strUrl);
    try {
      final response = await http.post(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on BadRequestException catch (e) {
      throw BadRequestException(e);
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> post_withoutBody(
      String strUrl, Map<String, String> header) async {
    print('Api Post, url $strUrl');
    var responseJson;
    var url = Uri.parse(strUrl);
    try {
      final response = await http.post(url, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on BadRequestException catch (e) {
      throw BadRequestException(e);
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> get_withoutBody(
      String strUrl, Map<String, String> header) async {
    print('Api GET, url $strUrl');
    var responseJson;
    var url = Uri.parse(strUrl);
    try {
      final response = await http.post(url, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on BadRequestException catch (e) {
      throw BadRequestException(e);
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> post_withoutBodyParams(String strUrl) async {
    print('Api Post, url $strUrl');
    var responseJson;
    var url = Uri.parse(strUrl);
    try {
      final response = await http.post(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on BadRequestException catch (e) {
      throw BadRequestException(e);
    }
    print('api post.');
    return responseJson;
  }

  Upload(
      String imagePath,
      String uploadURL,
      String user_id,
      String customer_name,
      String description,
      String latitude,
      String longitude,
      Map<String, String> header) async {
    print('Api Post, url $uploadURL');
    try {
      var uri = Uri.parse(uploadURL);
      var request = new http.MultipartRequest("POST", uri);
      if (imagePath.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('images', imagePath));
      }
      request.fields.addAll({
        'user_id': user_id,
        'customer_name': customer_name,
        'description': description,
        'latitude': latitude,
        'longitude': longitude
      });

      request.headers.addAll(header);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      print(respStr);
      return respStr;
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on BadRequestException catch (e) {
      throw BadRequestException(e);
    }
  }

  UploadWithMedia(
    String imageKey,
    String imagePath,
    String uploadURL,
    Map<String, String> body,
  ) async {
    print('Api Post, url $uploadURL');
    try {
      var uri = Uri.parse(uploadURL);
      var request = new http.MultipartRequest("POST", uri);
      if (imagePath.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath(imageKey, imagePath));
      }
      request.fields.addAll(body);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      print(respStr);
      return respStr;
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on BadRequestException catch (e) {
      throw BadRequestException(e);
    }
  }

  UploadWithMultiplaeMedia(
    String imageKey,
    String imagePath,
    String secondImageKey,
    String secondImagePath,
    String uploadURL,
    Map<String, String> header,
    Map<String, String> body,
  ) async {
    print('Api Post, url $uploadURL');
    print("=====Update Profile 2======>>>");

    try {
      var uri = Uri.parse(uploadURL);
      var request = new http.MultipartRequest("POST", uri);
      if (imagePath.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath(imageKey, imagePath));
      }
      if (secondImagePath.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath(secondImageKey, secondImagePath));
      }
      request.fields.addAll(body);
      request.headers.addAll(header);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      print(respStr);
      return respStr;
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on BadRequestException catch (e) {
      throw BadRequestException(e);
    }
  }

  Future<dynamic> getData(Uri url, Map<String, String> header) async {
    print('Api Post, url $url');
    var responseJson;
    try {
      final response = await http.get(url, headers: header);
      responseJson = _returnCorrectResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } on BadRequestException catch (e) {
      throw BadRequestException(e);
    }
    print('api post.');
    return responseJson;
  }
}

dynamic _returnResponse(http.Response response) {
  print("response code ====>>>>>" + response.statusCode.toString());
  // print("response body ====>>>>>" + response.body.toString());

  switch (response.statusCode) {
    case 201:
    case 200:
      print("success......!!!!!!!!!!");
      return response.body.toString();

    case 400:
      var responseJson = json.decode(response.body.toString());
      //throw UnauthorisedException(responseJson['response']['message']);
      throw FetchDataException(responseJson['response']['message']);

    /// case 333 for patient deactivated by provider
    case 333:
      var responseJson = json.decode(response.body.toString());
      throw PatientDeactivatedException(responseJson['response']['message']);

    /// case 555 for provider deactivated by super admin
    case 555:
      var responseJson = json.decode(response.body.toString());
      throw ProviderDeactivatedException(responseJson['response']['message']);
    case 515:
      var responseJson = json.decode(response.body.toString());
      throw UnauthorisedException(responseJson['response']['message']);
    case 401:
    case 403:
    case 410:
      var responseJson = json.decode(response.body.toString());
      // throw UnauthorisedException(responseJson['errors'][0][0]);
      throw UnauthorisedException(responseJson['response']['message']);
    case 101:
      throw UnauthorisedException(response.body.toString());
    case 404:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

dynamic _returnCorrectResponse(http.Response response) {
  print("response code ====>>>>>" + response.statusCode.toString());
  print("response body ====>>>>>" + response.body.toString());
  if (response.statusCode == 200 || response.statusCode == 201) {
    print("success......!!!!!!!!!!");
    return response.body.toString();
  } else {
    var responseJson = json.decode(response.body.toString());
    throw UnauthorisedException(responseJson['message']);
  }
}
