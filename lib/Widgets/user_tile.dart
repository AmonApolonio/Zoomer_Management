import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserTile(this.user);

  @override
  Widget build(BuildContext context) {
    if (user.containsKey("money"))
      return Theme(
        data: ThemeData(
          primarySwatch: Colors.green,
          textTheme: TextTheme(
            subtitle1: TextStyle(color: Colors.white),
            caption: TextStyle(color: Colors.white),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color.fromRGBO(70, 70, 70, 1),
            ),
            child: ListTile(
              title: Text(user["name"]),
              subtitle: Text(user["email"]),
              trailing: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Pedidos: ${user["orders"]}",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Gasto: R\$: ${user["money"].toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    else
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 300,
              height: 20,
              child: Shimmer.fromColors(
                child: Container(
                  color: Colors.white.withAlpha(50),
                  margin: EdgeInsets.only(bottom: 8),
                ),
                baseColor: Colors.white,
                highlightColor: Colors.grey,
              ),
            ),
            SizedBox(
              width: 200,
              height: 20,
              child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    margin: EdgeInsets.symmetric(vertical: 4),
                  ),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey),
            ),
          ],
        ),
      );
  }
}
