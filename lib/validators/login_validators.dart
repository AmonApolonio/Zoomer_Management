import 'dart:async';

/*
code to validate the email and passaword, the email must have an @ 
and the password must have at least 8 characters
otherwise the function returns an error
*/
class LoginValidators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@")) {
      sink.add(email);
    } else {
      sink.addError("Insira um e-mail válido");
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 7) {
      sink.add(password);
    } else {
      sink.addError("A senha deve ter pelo menos 8 caracteres");
    }
  });
}
