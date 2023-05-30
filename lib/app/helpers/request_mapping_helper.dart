import 'dart:convert';

abstract class RequestMappingHelper {
  // Por que não fazer um toMap ou algo assim? Porque vai reutilizar bastante.
  // Senão teria que implementar toMap em todos eles, e com uma classe abstrata
  // Ele te obriga a implementar a função map e tudo funciona
  final Map<String, dynamic> data;

  RequestMappingHelper.empty() : data = {};

  RequestMappingHelper(String dataRequest) : data = jsonDecode(dataRequest) {
    map();
  }

  void map();
}
