import 'dart:convert';

abstract class RequestMappingHelper {
  final Map<String, dynamic> data;

  RequestMappingHelper.empty() : data = {};

  RequestMappingHelper(String dataRequest) : data = jsonDecode(dataRequest) {
    map();
  }
  
  void map();
}
