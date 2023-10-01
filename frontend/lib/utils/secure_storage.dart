import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{

  //create storage
  final _storage = const FlutterSecureStorage();

  final String _tokenKey = 'token';
  final String _emailKey = 'email';
  final String _passwordKey = 'password';


  //Token
  Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async{
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  //Email
  Future<void> setEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  Future<String?> getEmail() async{
    return await _storage.read(key: _emailKey);
  }

  //Password
  Future<void> setPassword(String password) async {
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<String?> getPassword() async{
    return await _storage.read(key: _passwordKey);
  }

}