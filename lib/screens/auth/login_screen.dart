import 'package:camlica_pts/components/styled_button.dart';
import 'package:camlica_pts/screens/auth/twofa_login_screen.dart';
import 'package:camlica_pts/services/toast_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '/services/http_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await HttpService.dio.post(
        '/auth/login',
        data: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      ToastService.success(message: "Doğrulama kodu gönderildi!");

      Get.to(TwoFactorLoginScreen(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    } on DioException catch (e) {
      HttpService.handleError(
        e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Spacer(),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Telefon Numarası',
                  helperText: 'Örn: 5551234567',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen kullanıcı adınızı girin";
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  helper: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/forgot-password");
                        },
                        child: Text(
                          'Şifremi unuttum!',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şifrenizi girin';
                  } else if (value.length < 6) {
                    return 'Şifreniz en az 6 karakter olmalıdır';
                  }
                  return null;
                },
              ),
              StyledButton(
                isLoading: _isLoading,
                onPressed: _login,
                fullWidth: true,
                child: const Text('Giriş Yap'),
              ),
              Spacer(),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  void openWeb(String path) async {
    final url = Uri.parse("https://camlica-pts.riteknoloji.com$path");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => openWeb("/tos"),
          child: const Text('Kullanım Koşulları'),
        ),
        TextButton(
          onPressed: () => openWeb("/privacy"),
          child: const Text('Gizlilik Politikası'),
        ),
        TextButton(
          onPressed: () => openWeb("/kvkk"),
          child: const Text('KVKK'),
        ),
      ],
    );
  }
}
