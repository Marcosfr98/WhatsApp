import "package:flutter/material.dart";

import "../model/Conversa.dart";

class AbaConversas extends StatefulWidget {
  const AbaConversas({Key? key}) : super(key: key);

  @override
  State<AbaConversas> createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  List<Conversa> listaConversas = [
    Conversa("Ana Silva", "Olá! Tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-29f73.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=17313509-29c9-4a31-92ce-8b0be8be598d"),
    Conversa("Pedro Almansa", "Como vai a vida?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-29f73.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=7b8983ec-fa26-4118-9d42-05a4023dd264"),
    Conversa("Bruna Freitas", "Te vi ontem no parque",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-29f73.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=05f25437-e86a-478a-b9ba-0be4ead6a6db"),
    Conversa("Luís de Souza", "Qual o seu dia disponível?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-29f73.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=8c0aeaf8-2f74-4806-b642-a741989fdd73"),
    Conversa("Jamilton Damasceno", "Gosto muito dos seus cursos!",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-29f73.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=f863f3fc-3e53-44cd-a36d-bc18f726a478"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listaConversas.length,
        itemBuilder: (context, indice) {
          Conversa conversa = listaConversas[indice];

          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(conversa.caminhoImagem),
            ),
            title: Text(conversa.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text(conversa.mensagem, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          );
        });
  }
}
