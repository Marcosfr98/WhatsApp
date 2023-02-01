import "package:firebase_storage/firebase_storage.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import "package:firebase_auth/firebase_auth.dart";
import "dart:io";

import '../Themes/Cores.dart';

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
  bool _subindoImagem = false;
  String? _urlImagemRecuperada;

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _idUsuarioLogado = auth.currentUser?.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection("usuarios").doc(_idUsuarioLogado).get();

    Map<String, dynamic>? dados = snapshot.data();
    setState(
        (){
          _nomeController.text = dados?["nome"];
          _urlImagemRecuperada = dados?["urlImagem"];
        }
    );
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
      _subindoImagem = true;
      if (_imagem != null) {
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    UploadTask uploadTask = pastaRaiz
        .child("perfil")
        .child("$_idUsuarioLogado.jpg")
        .putFile(_imagem!);
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      if (taskSnapshot.state == TaskState.running) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (taskSnapshot.state == TaskState.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });
    uploadTask.then((TaskSnapshot snapshot) {
      _recuperarUrlImagem(snapshot);
    }).catchError((Object e) {

    });
  }

  _recuperarUrlImagem(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImageFirestore(url);
    setState(
        (){
          _urlImagemRecuperada = url;
        }
    );
  }

  _atualizarUrlImageFirestore(String url){
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "urlImagem": url
    };

    db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);
  }

   _atualizarNomeFirestore(){
    String nome = _nomeController.text;
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "nome": nome
    };

    db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);
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
                  _subindoImagem
                  ? const CircularProgressIndicator()
                  : Container(),
          CircleAvatar(
            radius: 100,
            backgroundColor: Colors.grey,
            backgroundImage: _urlImagemRecuperada != null ? NetworkImage(_urlImagemRecuperada!) : null,
          ),
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
            onPressed: () {
              _atualizarNomeFirestore();
            },
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
