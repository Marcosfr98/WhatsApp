import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import "package:firebase_auth/firebase_auth.dart";
import "dart:io";

import "Themes/Cores.dart";

class Configuracao extends StatefulWidget {
  const Configuracao({Key? key}) : super(key: key);

  @override
  State<Configuracao> createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  final TextEditingController _nomeController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late File? _imagem;
  String? _idUsuarioLogado;

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
    _nomeController.text = "Jamilton Damasceno";
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _idUsuarioLogado = auth.currentUser?.uid;
  }

  Future _recuperarImagem(String origemImagem) async {
    XFile? imagemSelecionada;
    switch (origemImagem) {
      case "camera":
        imagemSelecionada = await _picker.pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        imagemSelecionada =
            await _picker.pickImage(source: ImageSource.gallery);
        break;
    }
    setState(() {
      _imagem = File(imagemSelecionada!.path.toString());
      if (_imagem != null) {
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    pastaRaiz.child("perfil").child("${_idUsuarioLogado}.jpg");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Configurações"),
          backgroundColor: Cores.verde_tom1,
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(children: [
          const Icon(size: 300, Icons.person_pin),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                  child: const Text("Câmera"),
                  onPressed: () {
                    _recuperarImagem("camera");
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                  child: const Text("Galeria"),
                  onPressed: () {
                    _recuperarImagem("galeria");
                  },
                ),
              ]),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: const BorderSide(color: Colors.grey, width: 1)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
            child: const Text("Salvar"),
          )
        ]))));
  }
}
