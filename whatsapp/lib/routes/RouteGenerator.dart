import "package:flutter/material.dart";
import "package:whatsapp/Cadastro.dart";
import "package:whatsapp/Home.dart";

import '../Configuracao.dart';
import '../Login.dart';

class RouteGenerator {

  static const String ROTA_HOME = "/home";
  static const String ROTA_LOGIN = "/login";
  static const String ROTA_CADASTRO = "/cadastro";
  static const String ROTA_CONFIG = "/config";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
      case ROTA_LOGIN:
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
      case ROTA_CADASTRO:
        return MaterialPageRoute(
          builder: (_) => const Cadastro(),
        );
      case ROTA_HOME:
        return MaterialPageRoute(
          builder: (_) => const Home(),
        );
      case ROTA_CONFIG:
        return MaterialPageRoute(
          builder: (_) => const Configuracao(),
        );
      default:
        _erroRota();
    }
    return null;
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Tela não encontrada!"),
              ),
              body: const Center(
                child: Text("Tela não encontrada!"),
              )
          );
        }
    );
  }
}