import 'package:flutter/material.dart';
import 'package:ms_project/screens/file_receiving_screen.dart';
import 'file_transfer_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});  // Using super.key for cleaner code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FlyDrop"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FileTransferScreen()));
              },
              child: const Text("Transfer File"),
            ),

              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FileReceivingScreen()));
                  },
                  child: const Text("Receive File "))
            ],
        ),
      ),
    );
  }
}

