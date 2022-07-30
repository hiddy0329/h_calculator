import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionDecryption {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static encryptAES(text) {
    final plainText = text;
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return encrypted.base16;
  }
}
