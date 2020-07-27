import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriteria { READY_FIRST, READY_LAST }

//Bloc to control the orders screen

class OrdersBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List>();

//Stream that returns a list with all the orders
  Stream<List> get outOrders => _ordersController.stream;

//This variable was create just so i can write "_firestore" instead of "Firestore.instance" everytime on this bloc
  Firestore _firestore = Firestore.instance;

//Local list of all the orders
  List<DocumentSnapshot> _orders = [];

//The current criteria to sort the orders list
  SortCriteria _criteria;

  OrdersBloc() {
    _addOrdersListener();
  }

/*
function to add a listener on the order colletion on the database,
so that when some change happens there the local list will be uptaded
*/
  void _addOrdersListener() {
    _firestore.collection("orders").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String oid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(change.document);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.documentID == oid);
            _orders.add(change.document);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.documentID == oid);
            break;
        }
      });

      _sort();
    });
  }

//function to set the current sort criteria
  void setOrderCriteria(SortCriteria criteria) {
    _criteria = criteria;
    _sort();
  }

//function to sort the orders based on the current sort criteria
  void _sort() {
    switch (_criteria) {
      case SortCriteria.READY_FIRST:
        _orders.sort((a, b) {
          int sa = a.data["status"];
          int sb = b.data["status"];

          if (sa < sb)
            return 1;
          else if (sa > sb)
            return -1;
          else
            return 0;
        });
        break;
      case SortCriteria.READY_LAST:
        _orders.sort((a, b) {
          int sa = a.data["status"];
          int sb = b.data["status"];

          if (sa > sb)
            return 1;
          else if (sa < sb)
            return -1;
          else
            return 0;
        });
        break;
    }

    _ordersController.add(_orders);
  }

  @override
  void dispose() {
    _ordersController.close();
  }
}
