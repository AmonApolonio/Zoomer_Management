import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onSubmitted;

  InputField({
    this.label,
    this.obscure,
    this.stream,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.zero,
            width: 295,
            height: 65,
            color: Theme.of(context).primaryColorDark,
            child: Center(
              child: TextFormField(
                onFieldSubmitted: onSubmitted,
                obscureText: obscure,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 17),
                  contentPadding: EdgeInsets.only(
                    top: 5,
                    right: 0,
                    bottom: 0,
                    left: 20,
                  ),
                  errorStyle: TextStyle(),
                  errorText: snapshot.hasError ? snapshot.error : null,
                ),
              ),
            ),
          );
        });
  }
}
