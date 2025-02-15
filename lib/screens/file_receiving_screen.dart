import 'dart:io';
import 'package:flutter/material.dart';
import '../services/file_transfer_service.dart';

class FileReceivingScreen extends StatefulWidget {
  const FileReceivingScreen({super.key});

  @override
  _FileReceivingScreenState createState() => _FileReceivingScreenState();
}

class _FileReceivingScreenState extends State<FileReceivingScreen> {
  final FileTransferService _fileTransferService = FileTransferService();
  String _status = "Waiting for file...";
  File? _receivedFile;

  @override
  void initState() {
    super.initState();
    _fileTransferService.initPeerConnection();
  }

  @override
  void dispose() {
    _fileTransferService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receive File")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            if (_receivedFile != null) ...[
              const SizedBox(height: 20),
              Text("Received File: ${_receivedFile!.path}"),
            ],
          ],
        ),
      ),
    );
  }
}