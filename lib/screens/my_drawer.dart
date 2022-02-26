import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final User? user;

  const MyDrawer(this.user, {Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    var res=ModalRoute.of(context)!.settings.arguments;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: CircleAvatar(
              radius: 85,
              backgroundImage: (widget.user) != null
                  ? ((widget.user!.photoURL) != null)
                      ? NetworkImage(widget.user!.photoURL.toString())
                      : const NetworkImage(
                          "https://miro.medium.com/max/554/1*Ld1KM2WSfJ9YQ4oeRf7q4Q.jpeg")
                  : const NetworkImage(
                      "https://miro.medium.com/max/554/1*Ld1KM2WSfJ9YQ4oeRf7q4Q.jpeg"),
            ),
          ),
          (widget.user) != null
              ? Text("Display Name: ${widget.user!.displayName}")
              : const Text("Display Name: --"),
          (widget.user) != null
              ? Text("Email: ${widget.user!.email}")
              : const Text("Email: --"),
        ],
      ),
    );
  }
}
