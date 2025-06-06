// ignore_for_file: sort_child_properties_last, prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthMode { Signup, Login}

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email' : '',
    'password': '',
  };

  final _firebaseAuth = FirebaseAuth.instance;

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    setState(() {
      if(_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  String _translateFirebaseError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'O e-mail fornecido não é válido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este e-mail já está sendo utilizado.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      default:
        return 'Erro inesperado. Tente novamente mais tarde.';
   }
  }

  void _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if(!isValid) return;
    
    setState(() => _isLoading = true);
    _formKey.currentState?.save();

    try {
      if (_isLogin()) {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: _authData['email']!,
          password: _authData['paswword']!,
        );

        Timer(Duration(hours: 1), () async {
          await _firebaseAuth.signOut();
        });

      } else {
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: _authData['email']!,
          password: _authData['paswword']!,
        );
      }
    } on FirebaseAuthException catch (e) {
      final message = _translateFirebaseError(e.code);
      _showErrorDialog(message);
    }  catch (e) {
    _showErrorDialog('Erro inesperado. Tente novamente.');
  }


    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 390 : 480,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                _isLogin() ? 'Login' : 'Cadastro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
    
              TextFormField(
                decoration: InputDecoration(labelText:  'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if(email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe e-mail válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText:  'Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (paswword) => _authData['paswword'] = paswword ?? '',
                validator: (_password) {
                  final password = _password ?? '';
                  if(password.isEmpty || password.length < 5) {
                    return 'Senha muito curta';
                  }
                  return null;
                },
              ), 
              if(_isSignup())
                TextFormField(
                  decoration: InputDecoration(labelText:  'Confirmar senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _isLogin()
                    ? null 
                    : (_password) {
                      final password = _password ?? '';
                      if (password != _passwordController.text) {
                        return 'Senhas não combinam';
                      }
                      return null;
                    },
                ),
              SizedBox(height: 20),
              if(_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit, 
                  child: Text(
                    _authMode == AuthMode.Login ? 'Entrar' : 'Registrar',
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8
                    )
                  ),
                ),
              Spacer(),
              TextButton(
                onPressed: _switchAuthMode, 
                child: Text(
                  _isLogin() ? 'Registre-se' : 'Já possui conta?',
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}