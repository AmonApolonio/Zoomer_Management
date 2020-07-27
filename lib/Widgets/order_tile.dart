import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zoomer_management/Widgets/order_header.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;

  OrderTile(this.order);

  final states = [
    "",
    "Em preparação",
    "Em transporte",
    "aguardando entrega",
    "Entregue"
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.green,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black),
          subtitle1: TextStyle(color: Colors.black),
          caption: TextStyle(color: Colors.black),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
          child: ExpansionTile(
            key: Key(order.documentID),
            initiallyExpanded: order.data["status"] != 4,
            title: Text(
              "#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)} - "
              "${states[order.data["status"]]}",
              style: TextStyle(
                  color: order.data["status"] != 4
                      ? Colors.grey[850]
                      : Colors.green),
            ),
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    OrderHeader(order),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: order.data["products"].map<Widget>((p) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(p["product"]["title"] + " " + p["size"],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 17)),
                          subtitle: Text(p["category"] + "/" + p["pid"],
                              style: TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 11)),
                          trailing: Text(
                            p["quantity"].toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Firestore.instance
                                .collection("users")
                                .document(order["clientId"])
                                .collection("orders")
                                .document(order.documentID)
                                .delete();
                            order.reference.delete();
                          },
                          textColor: Colors.red,
                          child: Text("Excluir"),
                        ),
                        FlatButton(
                          onPressed: order.data["status"] > 1
                              ? () {
                                  order.reference.updateData(
                                      {"status": order.data["status"] - 1});
                                }
                              : null,
                          textColor: Colors.grey[850],
                          child: Text("Regredir"),
                        ),
                        FlatButton(
                          onPressed: order.data["status"] < 4
                              ? () {
                                  order.reference.updateData(
                                      {"status": order.data["status"] + 1});
                                }
                              : null,
                          textColor: Colors.green,
                          child: Text("Avançar"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
