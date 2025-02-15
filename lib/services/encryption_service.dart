import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';

class EncryptionService {
  static final key = encrypt.Key.fromUtf8('16byteslongkey!!');
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  // Generate a unique file hash (SHA-256)
  static Future<String> getFileHash(File file) async {
    List<int> fileBytes = await file.readAsBytes();
    return sha256.convert(fileBytes).toString();
  }

  // 🔹 Encrypt a file (Added Debugging Logs)
  static Future<File?> encryptFile(File file) async {
    try {
      print("🔹 Encrypting file: ${file.path}");
      Uint8List fileBytes = await file.readAsBytes();
      print("✅ Read file bytes: ${fileBytes.length} bytes");

      final encryptedBytes = encrypter.encryptBytes(fileBytes, iv: iv).bytes;
      print("✅ Encrypted file bytes: ${encryptedBytes.length} bytes");

      Directory tempDir = await getApplicationDocumentsDirectory();
      File encryptedFile = File('${tempDir.path}/encrypted_${file.path.split('/').last}');
      await encryptedFile.writeAsBytes(Uint8List.fromList(encryptedBytes));
      print("✅ File encrypted successfully: ${encryptedFile.path}");

      return encryptedFile;
    } catch (e, stackTrace) {
      print("❌ Encryption Failed: $e\n$stackTrace");
      return null; // Return null if encryption fails
    }
  }

  // 🔹 Decrypt a file (Added Debugging Logs)
  static Future<File?> decryptFile(File encryptedFile) async {
    try {
      print("🔹 Decrypting file: ${encryptedFile.path}");
      Uint8List encryptedBytes = await encryptedFile.readAsBytes();
      print("✅ Read encrypted file bytes: ${encryptedBytes.length} bytes");

      final decryptedBytes = encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);
      print("✅ Decrypted file bytes: ${decryptedBytes.length} bytes");

      Directory tempDir = await getApplicationDocumentsDirectory();
      File decryptedFile = File('${tempDir.path}/decrypted_${encryptedFile.path.split('/').last}');
      await decryptedFile.writeAsBytes(Uint8List.fromList(decryptedBytes));
      print("✅ File decrypted successfully: ${decryptedFile.path}");

      return decryptedFile;
    } catch (e, stackTrace) {
      print("❌ Decryption Failed: $e\n$stackTrace");
      return null; // Return null if decryption fails
    }
  }
}