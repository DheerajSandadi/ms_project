import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/file_transfer_service.dart';
import '../services/device_discovery_service.dart';

class FileTransferScreen extends StatefulWidget {
  const FileTransferScreen({super.key});

  @override
  _FileTransferScreenState createState() => _FileTransferScreenState();
}

class _FileTransferScreenState extends State<FileTransferScreen> {
  final FileTransferService _fileTransferService = FileTransferService();
  final DeviceDiscoveryService _deviceDiscoveryService = DeviceDiscoveryService();
  File? _selectedFile;
  List<String> _devices = [];
  String _status = "Searching for devices...";

  @override
  void initState() {
    super.initState();
    _fileTransferService.initPeerConnection();
    _deviceDiscoveryService.startDiscovery((devices) {
      setState(() => _devices = devices);
    });
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _status = "File selected: ${_selectedFile!.path}";
      });
    }
  }

  Future<void> _sendFile() async {
    if (_selectedFile == null || _devices.isEmpty) return;
    setState(() => _status = "Sending file...");
    await _fileTransferService.sendFile(_selectedFile!);
    setState(() => _status = "File sent successfully!");
  }

  @override
  void dispose() {
    _fileTransferService.dispose();
    _deviceDiscoveryService.stopDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Transfer")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _selectFile, child: const Text("Select File")),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _sendFile, child: const Text("Send File")),
            const SizedBox(height: 20),
            if (_devices.isNotEmpty) ...[
              const Text("Available Devices:", style: TextStyle(fontSize: 18)),
              for (String device in _devices) Text(device),
            ],
          ],
        ),
      ),
    );
  }
}