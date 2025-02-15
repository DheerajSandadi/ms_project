import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'encryption_service.dart';

class FileTransferService {
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;

  // Initialize WebRTC Peer Connection
  Future<void> initPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [{"urls": "stun:stun.l.google.com:19302"}]
    };

    _peerConnection = await createPeerConnection(configuration);
    _dataChannel = await _peerConnection!.createDataChannel('fileTransfer', RTCDataChannelInit());

    _dataChannel!.onMessage = (RTCDataChannelMessage message) async {
      if (message.isBinary) {
        await _saveReceivedFile(message.binary);
      }
    };
  }

  // Encrypt & Send File
  Future<void> sendFile(File file) async {
    if (_dataChannel == null) return;

    // Generate File Hash (Integrity Check)
    String fileHash = await EncryptionService.getFileHash(file);
    print("🔹 File Hash (SHA-256): $fileHash");

    // Encrypt the File
    File? encryptedFile = await EncryptionService.encryptFile(file);
    if (encryptedFile == null) {
      print("❌ File Encryption Failed");
      return;
    }

    // Read encrypted bytes
    Uint8List encryptedBytes = await encryptedFile.readAsBytes();
    print("✅ Encrypted File Ready (${encryptedBytes.length} bytes)");

    // Send encrypted file data
    _dataChannel!.send(RTCDataChannelMessage.fromBinary(encryptedBytes));
    print("📤 Encrypted File Sent Successfully");
  }

  // Decrypt & Save Received File
  Future<void> _saveReceivedFile(Uint8List encryptedBytes) async {
    // Save Encrypted File Temporarily
    Directory tempDir = await getApplicationDocumentsDirectory();
    File encryptedFile = File('${tempDir.path}/received_encrypted_file.dat');
    await encryptedFile.writeAsBytes(encryptedBytes);
    print("✅ Encrypted File Received: ${encryptedFile.path}");

    // Decrypt the File
    File? decryptedFile = await EncryptionService.decryptFile(encryptedFile);
    if (decryptedFile == null) {
      print("❌ File Decryption Failed");
      return;
    }

    // Generate Hash & Verify Integrity
    String receivedFileHash = await EncryptionService.getFileHash(decryptedFile);
    print("🔹 Received File Hash (SHA-256): $receivedFileHash");

    print("✅ File Saved at: ${decryptedFile.path}");
  }

  // Dispose Connection
  void dispose() {
    _peerConnection?.close();
    _dataChannel?.close();
  }
}