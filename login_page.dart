import 'package:flutter/material.dart';
import 'api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService api = ApiService();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool logado = false;
  List<dynamic> itens = [];

  Future<void> tentarLogin() async {
    final ok = await api.login(emailCtrl.text, passwordCtrl.text);
    if (ok) {
      final data = await api.getItens();
      setState(() {
        logado = true;
        itens = data;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login falhou: email ou senha inválidos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!logado) {
      return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 10),
              TextField(controller: passwordCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Senha')),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: tentarLogin, child: const Text('Entrar')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Itens')),
      body: itens.isEmpty
          ? const Center(child: Text('Nenhum item encontrado'))
          : ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, i) {
                final item = itens[i];
                return ListTile(
                  title: Text(item['titulo'] ?? 'Sem título'),
                  subtitle: Text(item['descricao'] ?? ''),
                );
              },
            ),
    );
  }
}
