import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/common/base/base_widget.dart';
import 'package:shopping_app/common/widgets/loading_widget.dart';
import 'package:shopping_app/data/repositories/authentication_repository.dart';
import 'package:shopping_app/presentations/features/sign_up/sign_up_bloc.dart';
import 'package:shopping_app/presentations/features/sign_up/sign_up_event.dart';
import 'package:shopping_app/common/widgets/progress_listener_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
        providers: [
          Provider(create: (context)=>AuthenticationRepository()),
          ProxyProvider<AuthenticationRepository,SignUpBloc>(
              create: (context)=>SignUpBloc(),
              update:(context,repository,bloc){
                bloc!.setAuthenticationRepository(authenticationRepository: repository);
                return bloc;
              }
          )
        ],
        appBar: AppBar(
          title: Text("Đăng ký")
        ),
        child: SignUpContainer(),
    );
  }
}

class SignUpContainer extends StatefulWidget {
  const SignUpContainer({Key? key}) : super(key: key);

  @override
  State<SignUpContainer> createState() => _SignUpContainerState();
}

class _SignUpContainerState extends State<SignUpContainer> {
  final _displayNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  late SignUpBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc=context.read();
    _bloc.message.stream.listen((event) {
      if (event.isNotEmpty) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: LoadingWidget(
          bloc: _bloc,
          child: ProgressListenerWidget<SignUpBloc>(
            callback: (event) {
              if (event is SignUpSuccessEvent) {
                String email = _emailController.text.toString();
                String password = _passController.text.toString();
                Navigator.pop(context,{'email': email, 'password': password});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Taọ tài khoản thành ")));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    flex: 2, child: Image.asset("assets/images/logo.png")),
                Expanded(
                    flex: 4,
                    child: LayoutBuilder(
                      builder: (context, constraint) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints:
                            BoxConstraints(minHeight: constraint.maxHeight),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildDisplayTextField(),
                                  SizedBox(height: 10),
                                  _buildAddressTextField(),
                                  SizedBox(height: 10),
                                  _buildEmailTextField(),
                                  SizedBox(height: 10),
                                  _buildPhoneTextField(),
                                  SizedBox(height: 10),
                                  _buildPasswordTextField(),
                                  SizedBox(height: 10),
                                  _buildButtonSignUp()
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayTextField() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: _displayNameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Nhập họ tên...",
          fillColor: Colors.black12,
          filled: true,
          prefixIcon: Icon(Icons.person, color: Colors.blue),
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
        ),
      ),
    );
  }

  Widget _buildAddressTextField() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: _addressController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Nhập địa chỉ...",
          fillColor: Colors.black12,
          filled: true,
          prefixIcon: Icon(Icons.map, color: Colors.blue),
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: _emailController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Nhập email...",
          fillColor: Colors.black12,
          filled: true,
          prefixIcon: Icon(Icons.email, color: Colors.blue),
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
        ),
      ),
    );
  }

  Widget _buildPhoneTextField() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Nhập số điện thoại...",
          fillColor: Colors.black12,
          filled: true,
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          prefixIcon: Icon(Icons.phone, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: _passController,
        obscureText: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "Nhập mật khẩu...",
          fillColor: Colors.black12,
          filled: true,
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          prefixIcon: Icon(Icons.lock, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildButtonSignUp() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: ElevatedButtonTheme(
            data: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue[500];
                    } else if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Colors.blueAccent;
                  }),
                  elevation: MaterialStateProperty.all(5),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 5, horizontal: 100)),
                )),
            child: ElevatedButton(
              child: Text("Đăng ký",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () {
                String name = _displayNameController.text.toString();
                String phone = _phoneController.text.toString();
                String address = _addressController.text.toString();
                String password = _passController.text.toString();
                String email = _emailController.text.toString();
                String _showMsg = "";
                if (name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty && password.isNotEmpty && email.isNotEmpty) {
                  _bloc.eventSink.add(SignUpExecuteEvent(
                      email: email,
                      name: name,
                      phone: phone,
                      password: password,
                      address: address));
                } else {
                  if(name.isEmpty) _showMsg ="Vui lòng nhập họ tên";
                  else if(address.isEmpty) _showMsg ="Vui lòng nhập địa chỉ";
                  else if(email.isEmpty) _showMsg ="Vui lòng nhập email";
                  else if(phone.isEmpty) _showMsg ="Vui lòng nhập số điện thoại";
                  else if(password.isEmpty) _showMsg ="Vui lòng nhập mật khẩu";
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_showMsg)));
                  return;
                }
              },
            )));
  }

}




