import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoomer_management/Screens/homeScreen.dart';
import 'package:zoomer_management/Widgets/Login/input_field_widget.dart';
import 'package:zoomer_management/blocs/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Erro"),
                    content: Text("Tente entrar com uma conta administradora"),
                  ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(55, 55, 55, 1),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
        },
        child: StreamBuilder<LoginState>(
            stream: _loginBloc.outState,
            initialData: LoginState.LOADING,
            builder: (context, snapshot) {
              print(snapshot.data);
              switch (snapshot.data) {
                case LoginState.LOADING:
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                    ),
                  );
                case LoginState.IDLE:
                case LoginState.FAIL:
                case LoginState.SUCCESS:
                  return SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/login_background.png"),
                            fit: BoxFit.fill),
                      ),
                      child: Column(
                        children: <Widget>[
                          //! Icon
                          Container(
                            margin: EdgeInsets.only(top: 100),
                            width: 135,
                            height: 135,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "images/Zoomer_Icon_recolor1.png"),
                              ),
                            ),
                          ),

                          //! Form Container
                          Container(
                            alignment: Alignment.center,
                            height: 200,
                            padding: EdgeInsets.only(left: 25, right: 25),
                            margin: EdgeInsets.only(top: 50),
                            child: Column(
                              children: <Widget>[
                                InputField(
                                  label: "Usuário",
                                  obscure: false,
                                  stream: _loginBloc.outEmail,
                                  onSubmitted: _loginBloc.changeEmail,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InputField(
                                  label: "Senha",
                                  obscure: true,
                                  stream: _loginBloc.outPassword,
                                  onSubmitted: _loginBloc.changePassword,
                                ),
                              ],
                            ),
                          ),

                          //! Login Button
                          StreamBuilder<bool>(
                              stream: _loginBloc.outSubmitValid,
                              builder: (context, snapshot) {
                                return GestureDetector(
                                  onTap: snapshot.hasData
                                      ? _loginBloc.submit
                                      : null,
                                  child: Container(
                                    width: 290,
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: snapshot.hasData
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .primaryColorDark,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0))),
                                    child: Text(
                                      "Entrar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  );
                default:
                  return Container(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Se você está vendo isso tem muita sorte",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
              }
            }),
      ),
    );
  }
}
