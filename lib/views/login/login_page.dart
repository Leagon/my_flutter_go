// os
import 'package:flutter/material.dart';

// 3rd
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

// custom
import 'package:my_flutter_go/network/network.dart';
import 'package:my_flutter_go/model/user_info.dart';
import 'package:my_flutter_go/model/user_info_cache.dart';


// LoginPage
class LoginPage extends StatefulWidget {

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  _LoginPageState();

  
  // 利用FocusNode和_focusScopeNode来控制焦点 可以通过FocusNode.of(context)来获取widget树中默认的_focusScopeNode
  FocusNode _emailFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();
  FocusScopeNode _focusScopeNode = new FocusScopeNode();

  GlobalKey<FormState> _signInFormKey = new GlobalKey();
  TextEditingController _userNameEditingController = new TextEditingController();
  TextEditingController _passwordEditingController = new TextEditingController();

  UserInfoController _userInfoControl = new UserInfoController();


  bool isLoading = false;
  bool isPasswordSecure = true;
  String userName = '';
  String password = '';


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, color: Theme.of(context).primaryColor,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width, 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)), 
                color: Colors.white, 
                image: DecorationImage(image: AssetImage('assets/images/paimaiLogo.png'), fit: BoxFit.scaleDown, alignment: Alignment.bottomRight),
              ),
              child: Stack(children: <Widget>[
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  SizedBox(height: 35.0),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Image.asset('assets/images/gitHub.png', fit: BoxFit.contain, width: 60.0, height: 60.0),
                    Image.asset('assets/images/arrow.png', fit: BoxFit.contain, width: 40.0, height: 30.0),
                    Image.asset('assets/images/FlutterGo.png', fit: BoxFit.contain, width: 60.0, height: 60.0),
                  ],),
                  buildSignInTextForm(context),
                  buildSignInButton(context),
                  SizedBox(height: 15.0),
                  Container(height: 1, width: MediaQuery.of(context).size.width, color: Colors.grey[400], margin: const EdgeInsets.only(bottom: 10.0)),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    FlatButton(
                      child: Text('GitHub OAuth', style: TextStyle(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline)),
                      onPressed: () {

                      },
                    ),
                    FlatButton(
                      child: Text('游客登录', style: TextStyle(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline)),
                      onPressed: () {
                        
                      },
                    ),
                  ],),
                ],),
                Positioned(child: buildLoading(context), top: 0, left: 0, bottom: 0),
              ]),
            ),
          ),
        ),
      )
    );
  }

  Widget buildLoading(BuildContext context) {
    if (isLoading) {
      return Opacity(
        opacity: 0.5, 
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), color: Colors.black),
          child: SpinKitPouringHourglass(color: Colors.white),
        ),
      );
    }
    return Container();
  }

  Widget buildSignInTextForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8, height: 190,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Form(
        key: _signInFormKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          userNameTextForm(context),
          Container(height: 1, width: MediaQuery.of(context).size.width * 0.75, color: Colors.grey[400]),
          passwordTextForm(context),
          Container(height: 1, width: MediaQuery.of(context).size.width * 0.75, color: Colors.grey[400]),
        ]),
      ),
    );
  }

  Widget userNameTextForm(BuildContext context) {
    return Flexible(
      child: Padding(padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0, bottom: 5.0), 
        child: TextFormField(
          controller: _userNameEditingController, 
          focusNode: _emailFocusNode,
          onEditingComplete: () {
            if (_focusScopeNode == null) {
              _focusScopeNode = FocusScope.of(context);
            }
            _focusScopeNode.requestFocus(_passwordFocusNode);
          },
          decoration: InputDecoration(icon: Icon(Icons.email, color: Colors.black), hintText: 'GitHub登录名', border: InputBorder.none),
          style: TextStyle(color: Colors.black, fontSize: 16.0),
          validator: (value) {
            if (value.isEmpty) {
              return '登录名不可为空';
            }
            return null;
          },
          onSaved: (value) {
            setState(() {
              userName = value;
            });
          },
        ),
      ),
    );
  }

  Widget passwordTextForm(BuildContext context) {
    return Flexible(
      child: Padding(padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0, bottom: 5.0), 
        child: TextFormField(
          controller: _passwordEditingController, 
          focusNode: _passwordFocusNode,
          obscureText: isPasswordSecure,
          decoration: InputDecoration(icon: Icon(Icons.email, color: Colors.black), hintText: 'GitHub登录密码', border: InputBorder.none, suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye, color: Colors.black), onPressed: passwordSecureChanged)),
          style: TextStyle(color: Colors.black, fontSize: 16.0),
          validator: (value) {
            if (value.isEmpty) {
              return '密码不可为空';
            }
            return null;
          },
          onSaved: (value) {
            setState(() {
              password = value;
            });
          },
        ),
      ),
    );
  }

  Widget buildSignInButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 42.0, right: 42.0, top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Theme.of(context).primaryColor),
        child: Text('LOGIN', style: TextStyle(fontSize: 25.0, color: Colors.white)),
      ),
      onTap: () {
        // 利用key来获取widget的状态FormState,可以用过FormState对Form的子孙FromField进行统一的操作
        if (_signInFormKey.currentState.validate()) {
          // 如果输入都检验通过，则进行登录操作
          // Scaffold.of(context)
          //     .showSnackBar(new SnackBar(content: new Text("执行登录操作")));
          //调用所有自孩子��save回调，保存表单内容
          doLogin();
        }
      },
    );
  }

  // Action
  passwordSecureChanged() {
    setState(() {
      isPasswordSecure = !isPasswordSecure;
    });
  }

  doLogin() {
    print("doLogin");
    _signInFormKey.currentState.save();
    setState(() {
      isLoading = true;
    });

    Network.doLogin({'username': userName, 'password': password}).then((value) {

      setState((){
        isLoading = false;
      });

      if (value.runtimeType == UserInformation) {
        try {
          _userInfoControl.deleteAll().then((value){
            _userInfoControl.insert(UserInfo(username: userName, password: password)).then((value){
              print("存储成功$value");
              // Navigator.of(context).pushAndRemoveUntil(newRoute, (route) => false)
            });
          });
        } catch (e) {
          // Navigator.of(context).pushAndRemoveUntil(newRoute, (route) => false)
        }
      } else if (value.runtimeType == String) {
        Fluttertoast.showToast(msg: value, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIos: 1, backgroundColor: Theme.of(context).primaryColor, textColor: Colors.white, fontSize: 16);
      }
    }).catchError((errMsg){

      setState((){
        isLoading = false;
      });

      Fluttertoast.showToast(msg: errMsg.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIos: 1, backgroundColor: Theme.of(context).primaryColor, textColor: Colors.white, fontSize: 16);

    });
  }
}
