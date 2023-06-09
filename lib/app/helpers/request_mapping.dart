import 'dart:convert';

abstract class RequestMapping {
  // Por que não fazer um toMap ou algo assim? Porque vai reutilizar bastante.
  // Senão teria que implementar toMap em todos eles, e com uma classe abstrata
  // Ele te obriga a implementar a função map e tudo funciona
  final Map<String, dynamic> data;

  RequestMapping.empty() : data = {};

  RequestMapping(String dataRequest) : data = jsonDecode(dataRequest) {
    map();
  }

  void map();
}
