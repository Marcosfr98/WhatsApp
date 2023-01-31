import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import 'routes/RouteGenerator.dart';
import 'Themes/Cores.dart';
import 'model/Usuario.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  _validarCampos() {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      EasyLoading.showError('Preencha todos os campos!');
    } else {
      Usuario usuario = Usuario();
      usuario.nome = nome;
      usuario.email = email;
      usuario.senha = senha;
      _cadastrarUsuario(usuario);
    }
  }

  _cadastrarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      //EasyLoading.showSuccess("Sucesso ao cadastrar o usuário!");
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection("usuario").doc(auth.currentUser?.uid).set(usuario.toMap());
      Navigator.pushNamedAndRemoveUntil(
          context, RouteGenerator.ROTA_CADASTRO, (_) => false);
    }).catchError((onError) {
      EasyLoading.showError("Erro ao cadastrar o usuário!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Cores.verde_tom1,
        appBar: AppBar(
          title: const Text("Cadastro"),
          backgroundColor: Cores.verde_tom1,
          elevation: 8,
        ),
        body: Container(
            padding: const EdgeInsets.all(16),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Image.asset(
                      width: 250, height: 250, "imagens/usuario.png"),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerNome,
                      keyboardType: TextInputType.text,
                      //autofocus: true,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20.0),
                          hintText: "Nome",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20.0),
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerSenha,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20.0),
                          hintText: "Senha",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        _validarCampos();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.green,
                          minimumSize: const Size.fromHeight(55)),
                      child: const Text("Cadastrar-se"),
                    )),
              ],
            )))));
  }
}
