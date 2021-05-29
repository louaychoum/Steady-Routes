import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/services/auth_service.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  static late final dynamic args;
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments ?? '';
    // final deviceSize = MediaQuery.of(context).size;
// final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
// transformConfig.translate(-10.0);
    return const Scaffold(
// resizeToAvoidBottomInset: false,
      body: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login();
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  late String _username;
  late String _password;
  late String _errorMessage;

  late bool _isLoading;
  bool _autoLogin = true;

  @override
  void initState() {
    _errorMessage = '';
    _isLoading = false;
    super.initState();
  }

  bool validateAndSave() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit({required bool autoLogin}) async {
    if (!validateAndSave()) {
      // showInSnackBar('Please fix the errors in red before submitting.');
      return;
    }
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });
    try {
      if (!await auth.signIn(
        username: _username,
        password: _password,
        autoLogin: autoLogin,
      )) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Invalid email or password.';
          _formKey.currentState!.reset();
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error.toString(),
        ),
      ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  // AuthMode _authMode = AuthMode.Login;
  // Map<String, String> _authData = {
  //   'username': '',
  //   'password': '',
  // };
  // var _value = true;

  // final _passwordController = TextEditingController();

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text('An Error Occured!'),
  //       content: Text(message),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(ctx).pop();
  //           },
  //           child: Text('Okay'),
  //         )
  //       ],
  //     ),
  //   );
  // }

//   Future<void> _submit() async {
//     if (!_formKey.currentState.validate()) {
// // Invalid!
//       return;
//     }
//     _formKey.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       // if (_authMode == AuthMode.Login) {
// // Log user in
//       Navigator.of(context).pushNamed(AdminDashboard.routeName);
//       // await Provider.of<Auth>(context, listen: false).login(
//       //   _authData['username'],
//       //   _authData['password'],
//       // );

//       // }
//       // else {
// // Sign user up
//       // await Provider.of<Auth>(context, listen: false).signup(
//       //   _authData['username'],
//       //   _authData['password'],
//       // );
//       // }
//     } on HttpException catch (error) {
//       var errorMessage = 'Authentication failed.';
//       if (error.toString().contains('EMAIL_EXISTS')) {
//         errorMessage = 'This email address is already in use.';
//       } else if (error.toString().contains('INVALID_EMAIL')) {
//         errorMessage = 'This is not a valid email address';
//       } else if (error.toString().contains('WEAK_PASSWORD')) {
//         errorMessage = 'This password is too weak.';
//       } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
//         errorMessage = 'Could not find a user with that email.';
//       } else if (error.toString().contains('INVALID_PASSWORD')) {
//         errorMessage = 'Invalid password.';
//       }
//       _showErrorDialog(errorMessage);
//       print(error);
//     } catch (error) {
//       const errorMessage =
//           'Could not authenticate you. Please try again later.';
//       _showErrorDialog(errorMessage);
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

  // void _switchAuthMode() {
  //   if (_authMode == AuthMode.Login) {
  //     setState(() {
  //       _authMode = AuthMode.Signup;
  //     });
  //     _controller.forward();
  //   } else {
  //     setState(() {
  //       _authMode = AuthMode.Login;
  //     });
  //     _controller.reverse();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        _showForm(),
        _showCircularProgress(),
      ],
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container();
  }

  Widget _showForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Image.asset('assets/images/logo.png'),
        ),
        Flexible(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  showUsernameInput(),
                  const SizedBox(
                    height: 20,
                  ),
                  showPasswordInput(),
                  showAutoLoginCheck(),
                  const SizedBox(
                    height: 20,
                  ),
                  showErrorMessage(),
                  showPrimaryButton(),
                  // if (_isLoading)
                  //   CircularProgressIndicator()
                  // else
                  // TextButton(
                  //   onPressed: _submit,
                  //   style: TextButton.styleFrom(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  //     primary: Theme.of(context).primaryColor,
                  //   ),
                  //   child: const Text(
                  //     'Admin Login',
                  //     style: TextStyle(
                  //         // color: Theme.of(context).,
                  //         ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // TextButton(
                  //   child: Text(
                  //     'Driver Login',
                  //     style: TextStyle(
                  //       color: Colors.red,
                  //     ),
                  //   ),
                  //   onPressed: () => Navigator.of(context)
                  //       .pushNamed(DriverDashboardScreen.routeName),
                  //   style: TextButton.styleFrom(
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(
          child: Text(
            _errorMessage,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget showUsernameInput() {
    return TextFormField(
      decoration: kTextFieldDecoration,
      validator: (value) {
        if (value!.isEmpty) {
          return "Username can't be empty!";
        }
        return null;
      },
      onSaved: (value) => _username = value!.trim(),
      // _authData['username'] = value;
    );
  }

  Widget showPasswordInput() {
    return TextFormField(
      decoration: kTextFieldDecoration.copyWith(
          labelText: 'Password', hintText: 'Enter your password'),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password can't be empty!";
        }
        // !if (value.length < 8) {
        //   return 'Password is too short!';
        // }
        return null;
      },
      onSaved: (value) => _password = value!.trim(),
      //   _authData['password'] = value;
      // },
    );
  }

  Widget showAutoLoginCheck() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text('Auto Login'),
      value: _autoLogin,
      onChanged: (value) {
        setState(() {
          _autoLogin = value!;
        });
      },
    );
  }

  Widget showPrimaryButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        onPressed: () => validateAndSubmit(
          autoLogin: _autoLogin,
        ),
        child: const Text(
          'Login',
          // style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }
}
