import 'dart:convert';

import 'package:http/http.dart' as http;

//All employee api call be here
class EmployeeService {
  static get id => null;

  static Future<bool> deleteById(String Id) async {
    final url = 'http://examination.24x7retail.com/api/v1.0/Employee/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchEmployees() async {
    final url = "http://examination.24x7retail.com/api/v1.0/Employee";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }
}
