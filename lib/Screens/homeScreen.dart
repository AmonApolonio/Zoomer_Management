import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:zoomer_management/Widgets/edit_category_dialog.dart';
import 'package:zoomer_management/blocs/orders_bloc.dart';
import 'package:zoomer_management/blocs/user_bloc.dart';
import 'package:zoomer_management/tabs/orders_tab.dart';
import 'package:zoomer_management/tabs/products_tab.dart';
import 'package:zoomer_management/tabs/users.tab.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  PageController _pageController;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).primaryColor,
        animationCurve: Curves.ease,
        animationDuration: Duration(milliseconds: 500),
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(
            Icons.list,
            size: 30,
            color: Theme.of(context).primaryColorDark,
          ),
          Icon(
            Icons.shopping_cart,
            size: 30,
            color: Theme.of(context).primaryColorDark,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Theme.of(context).primaryColorDark,
          ),
        ],
        onTap: (p) {
          if (p != _page) {
            _pageController.animateToPage(p,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          }
        },
      ),
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: BlocProvider<OrdersBloc>(
            bloc: _ordersBloc,
            child: PageView(
              physics: new NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: <Widget>[
                ProductsTab(),
                OrdersTab(),
                UsersTab(),
              ],
              onPageChanged: (p) {
                setState(() {
                  _page = p;
                });
              },
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    Color dark = Theme.of(context).primaryColorDark;
    Color hint = Theme.of(context).primaryColor;

    switch (_page) {
      case 0:
        return SpeedDial(
          marginRight: 30,
          curve: Curves.easeInExpo,
          backgroundColor: hint,
          overlayOpacity: 0,
          overlayColor: Colors.black,
          child: GestureDetector(
            child: Icon(Icons.add, size: 30, color: dark),
            onTap: () {
              showDialog(
                  context: context, builder: (context) => EditCategoryDialog());
            },
          ),
        );
        break;
      case 1:
        return SpeedDial(
          marginRight: 30,
          curve: Curves.easeInExpo,
          child: Icon(
            Icons.sort,
            color: dark,
          ),
          backgroundColor: hint,
          overlayOpacity: 0,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_downward,
                ),
                backgroundColor: dark,
                label: "Concluídos Abaixo",
                labelStyle: TextStyle(fontSize: 14, color: Colors.white),
                labelBackgroundColor: dark,
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
                backgroundColor: dark,
                label: "Concluídos Acima",
                labelStyle: TextStyle(fontSize: 14, color: Colors.white),
                labelBackgroundColor: dark,
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                }),
          ],
        );
        break;
      case 2:
        return null;
        break;

      default:
        return Container();
        break;
    }
  }
}
