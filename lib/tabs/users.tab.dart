import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:zoomer_management/Widgets/user_tile.dart';
import 'package:zoomer_management/blocs/user_bloc.dart';
import 'package:zoomer_management/utils.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10, left: 25, bottom: 10),
          child: TextField(
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
                hintText: "Pesquisar",
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none),
            onChanged: _userBloc.onChangedSearch,
          ),
        ),
        Expanded(
          child: StreamBuilder<List>(
              stream: _userBloc.outUsers,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                    ),
                  );
                else if (snapshot.data.length == 0)
                  return Center(
                    child: Text(
                      "Nenhum usuário encontrado!",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                else
                  return ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return UserTile(snapshot.data[index]);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 6,
                            color: Theme.of(context).primaryColorDark,
                          );
                        },
                        itemCount: snapshot.data.length),
                  );
              }),
        ),
        Container(
          color: Theme.of(context).primaryColorDark,
          height: 20,
        )
      ],
    );
  }
}
