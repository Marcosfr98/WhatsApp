import "package:flutter/material.dart";

class AbaContatos extends StatefulWidget {
  const AbaContatos({Key? key}) : super(key: key);

  @override
  State<AbaContatos> createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text("Contatos"),
    );
  }
}
