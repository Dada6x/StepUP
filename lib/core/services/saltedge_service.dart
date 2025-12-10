import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kyc_test/main.dart';

class SaltEdgeService {
  static final String baseUrl = "http://${LaptopIp}:3000"; // your backend IP

  static Future<bool> createCustomer(String userId) async {
    final url = Uri.parse("$baseUrl/saltedge/customer");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId}),
    );

    print("CreateCustomer response: ${res.body}");

    return res.statusCode == 200;
  }

  static Future<String?> createConnectSession(String userId) async {
    final url = Uri.parse("$baseUrl/saltedge/connect-session");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId}),
    );

    print("ConnectSession response: ${res.body}");

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["connectUrl"];
    }
    return null;
  }

  static Future<bool> checkMinBalance(String userId, double amount) async {
    final url = Uri.parse(
      "$baseUrl/saltedge/has-min-balance?userId=$userId&amount=$amount",
    );

    final res = await http.get(url);

    print("CheckBalance response: ${res.body}");

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["hasMinBalance"];
    }
    return false;
  }
}
