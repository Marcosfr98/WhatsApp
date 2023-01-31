import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

import 'routes/RouteGenerator.dart';
import 'Themes/Cores.dart';
import 'fragments/AbaContatos.dart';
import 'fragments/AbaConversas.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> itensMenu = ["Confirgurações", "Deslogar"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    if(mounted){
      Navigator.pushReplacementNamed(context, RouteGenerator.ROTA_LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Cores.verde_tom1,
            title: const Text("WhatsApp"),
            bottom: TabBar(
                indicatorWeight: 4,
                labelStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                controller: _tabController,
                indicatorColor: Colors.white,
                tabs: const [
                  Tab(text: "Conversas"),
                  Tab(text: "Contatos"),
                ]),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'configuracao',
                    child: Text("Confirgurações"),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text("Logout"),
                  ),
                ],
                onSelected: (value){
                  if(value == 'configuracao'){
                    Navigator.pushNamed(context, RouteGenerator.ROTA_CONFIG);
                  }else if(value == "logout"){
                    _deslogarUsuario();
                  }
                },
              ),
            ]),
        body: TabBarView(controller: _tabController, children: const [
          AbaConversas(),
          AbaContatos(),
        ]));
  }
}
