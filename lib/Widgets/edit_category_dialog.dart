import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zoomer_management/Widgets/confirm_exclusion_dialog.dart';
import 'package:zoomer_management/Widgets/image_source_sheet.dart';
import 'package:zoomer_management/blocs/category_bloc.dart';

class EditCategoryDialog extends StatefulWidget {
  final DocumentSnapshot category;

  EditCategoryDialog({this.category});

  @override
  _EditCategoryDialogState createState() =>
      _EditCategoryDialogState(category: category);
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final CategoryBloc _categoryBloc;
  final TextEditingController _controller;

  _EditCategoryDialogState({DocumentSnapshot category})
      : _categoryBloc = CategoryBloc(category),
        _controller = TextEditingController(
            text: category != null ? category.data["title"] : "");

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => ImageSourceSheet(
                            onImageSelected: (image) {
                              Navigator.of(context).pop();
                              _categoryBloc.setImage(image);
                            },
                          ));
                },
                child: StreamBuilder(
                    stream: _categoryBloc.outImage,
                    builder: (context, snapshot) {
                      if (snapshot.data != null)
                        return CircleAvatar(
                          child: snapshot.data is File
                              ? Image.file(
                                  snapshot.data,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  snapshot.data,
                                  fit: BoxFit.cover,
                                ),
                          backgroundColor: Colors.transparent,
                        );
                      else
                        return Icon(
                          Icons.image,
                          size: 30,
                        );
                    }),
              ),
              title: StreamBuilder<String>(
                  stream: _categoryBloc.outTitle,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: _controller,
                      onChanged: _categoryBloc.setTitle,
                      decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                      ),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder<bool>(
                    stream: _categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return FlatButton(
                        child: Text("Excluir"),
                        textColor: Colors.red,
                        onPressed: snapshot.data
                            ? () {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ConfirmExclusionDialog(_categoryBloc));
                              }
                            : null,
                      );
                    }),
                StreamBuilder<bool>(
                    stream: _categoryBloc.submitValid,
                    builder: (context, snapshot) {
                      return FlatButton(
                        child: Text(
                          "Salvar",
                          style: TextStyle(color: Colors.green[700]),
                        ),
                        onPressed: snapshot.hasData
                            ? () async {
                                await _categoryBloc.saveData();
                                Navigator.of(context).pop();
                              }
                            : null,
                      );
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
