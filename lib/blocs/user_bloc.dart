import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

//Bloc to control the clients screen
class UserBloc extends BlocBase {
  final _usersController = BehaviorSubject<List>();

//Stream that returns the list of users
  Stream<List> get outUsers => _usersController.stream;

  Map<String, Map<String, dynamic>> _users = {};

  Firestore _firestore = Firestore.instance;

  UserBloc() {
    _addUsersListener();
  }

//function to change the clients list based on what is write on the search bar
  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _usersController.add(_users.values.toList());
    } else {
      _usersController.add(_filter(search.trim()));
    }
  }

//function to transform/filter the text on the search bar to prefend search bugs
  List<Map<String, dynamic>> _filter(String search) {
    List<Map<String, dynamic>> filteredUsers =
        List.from(_users.values.toList());
    filteredUsers.retainWhere((user) {
      return user["name"].toUpperCase().contains(search.toUpperCase());
    });
    return filteredUsers;
  }

/*
function to add a listener on the clients colletion on the database,
so that when some change happens there the local list will be uptaded
*/
  void _addUsersListener() {
    _firestore.collection("users").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.document.data;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(change.document.data);
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }

//function to get the total money spend by the client
  void _subscribeToOrders(String uid) {
    _users[uid]["subscription"] = _firestore
        .collection("users")
        .document(uid)
        .collection("orders")
        .snapshots()
        .listen((orders) async {
      int numOrders = orders.documents.length;
      double money = 0.0;

      for (DocumentSnapshot d in orders.documents) {
        DocumentSnapshot order =
            await _firestore.collection("orders").document(d.documentID).get();

        if (order.data == null) continue;

        money += order.data["totalPrice"];
      }

      _users[uid].addAll({"money": money, "orders": numOrders});

      _usersController.add(_users.values.toList());
    });
  }

  Map<String, dynamic> getUser(String uid) {
    return _users[uid];
  }

//function to remove the listener from the user (which is called when he is removed)
  void _unsubscribeToOrders(String uid) {
    _users[uid]["subscription"].cancel();
  }

  @override
  void dispose() {
    _usersController.close();
  }
}
