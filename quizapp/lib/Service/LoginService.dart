import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../components/SnackBar.dart';
import '../main.dart';
import '../pages/HomePage.dart';
import 'Config.dart';
import 'package:http/http.dart' as http;

class LoginService {

    static void LoginServiceAPI({required TextEditingController emailController, required TextEditingController passwordController}) async {
        if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
            var loginBody = {
                "email": emailController.text,
                "password": passwordController.text
            };

            try {
                var response = await http.post(Uri.parse(login),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode(loginBody));

                if (response.statusCode == 200) {
                    var jsonResponse = jsonDecode(response.body);
                    if (jsonResponse['status'] == true) {
                        MainApp.storage.remove("token");
                        MainApp.storage.write("token", jsonResponse['token']);
                        SnacKBar.success(title: "Congratulations...!", message: "Login Successfully.\nYou may proceed");
                        Get.offAll(() => const HomePage());
                    } else {
                        SnacKBar.error(title: "Warning...!", message: jsonResponse['message']);
                    }
                } else {
                    SnacKBar.error(title: "Error", message: "Server error. Please try again later.");
                }
            } catch (e) {
                print("Exception: $e");
                SnacKBar.error(title: "Error", message: "An error occurred. Please check your internet connection.");
            }
        } else {
            SnacKBar.error(title: "Warning...!", message: "Some fields are Empty...!\nPlease fill all fields");
        }
    }
}
