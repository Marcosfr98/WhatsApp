import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../routes/RouteGenerator.dart';
import '../themes/Cores.dart';
import '../model/Usuario.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    if (email.isEmpty || senha.isEmpty) {
      EasyLoading.showError("Preencha todos os campos!");
    } else {
      Usuario usuario = Usuario();
      usuario.email = email;
      usuario.senha = senha;
      _logarUsuario(usuario);
    }
  }

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
      email: usuario.email,
      password: usuario.senha,
    )
        .then((firebaseUser) {
      Navigator.pushReplacementNamed(context, RouteGenerator.ROTA_HOME);
    }).catchError((onError) {
      EasyLoading.showError("Erro ao fazer login! Por favor, tente novamente.");
    });
  }

  Future _verificaUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    if (usuarioLogado != null) {
      if(mounted){
        Navigator.pushReplacementNamed(context, RouteGenerator.ROTA_HOME);
      }
    }
  }

  @override
  void initState() {
    _verificaUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Cores.verde_tom1,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Center(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Image.asset(
                        width: 250, height: 250, "imagens/logo.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextField(
                      //autofocus: true,
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20.0),
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextField(
                      obscureText: true,
                      controller: _controllerSenha,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20.0),
                          hintText: "Senha",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        _validarCampos();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(55),
                      ),
                      child: const Text("Entrar"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteGenerator.ROTA_CADASTRO);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 8, top: 8),
                      child: Text(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          "Não tem uma conta? Cadastre-se!"),
                    ),
                  ),
                ],
              ),
            ))));
  }
}
