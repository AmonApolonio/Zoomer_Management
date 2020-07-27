import 'package:flutter/material.dart';
import 'package:zoomer_management/blocs/category_bloc.dart';

class ConfirmExclusionDialog extends StatelessWidget {
  final CategoryBloc _categoryBloc;

  ConfirmExclusionDialog(this._categoryBloc);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Text(
                "Se excluir uma categoria todos os produtos dentro dela seram excluídos, tem certeza disso?",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  onPressed: () {
                    _categoryBloc.delete();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.green[700]),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
