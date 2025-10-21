import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://notas-api-qvzz.onrender.com';

  // Login
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', data['token']);
      await prefs.setInt('usuarioId', data['userId']);
      return true;
    }
    return false;
  }

  // Buscar itens do usuário
  Future<List<dynamic>> getItens() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');
    final usuarioId = prefs.getInt('usuarioId');

    if (token == null || usuarioId == null) return [];

    final response = await http.get(
      Uri.parse('$baseUrl/itens/usuario/$usuarioId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
}
