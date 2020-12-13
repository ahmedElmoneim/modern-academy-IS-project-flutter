import 'package:flutter/material.dart';
import 'package:modern_adacemy/enums/auth_enum.dart';
import 'package:modern_adacemy/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthType authType = AuthType.Login;

  bool _isLoading = false;

  DateTime _selectedDate = DateTime.now();
  bool _newDateSelected = false;

  List<bool> _selectedGender = [false, false];

  TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Map<String, String> _savedFormMap = {
    'email': '',
    'password': '',
  };
  Map<String, Object> _savedInfo = {
    'firstName': '',
    'lastName': '',
    'birthDate': DateTime.now(),
    'gender': '',
  };

  FocusNode _lastNameScope = FocusNode();
  FocusNode _emailScope = FocusNode();
  FocusNode _passwordScope = FocusNode();
  FocusNode _confirmPasswordScope = FocusNode();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      currentDate: _selectedDate,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _newDateSelected = true;
        // print(_selectedDate.toIso8601String());
      });
    // Toast.show(
    //   _selectedDate.toString(),
    //   context,
    //   duration: Toast.LENGTH_LONG,
    //   gravity: Toast.BOTTOM,
    // );
  }

  Future<void> _authenticateUser() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _formKey.currentState.validate();
    final genderPicked = _selectedGender[0] || _selectedGender[1];
    if (authType == AuthType.Login) {
      _formKey.currentState.save();

      try {
        await Provider.of<Auth>(context, listen: false)
            .signInUser(_savedFormMap['email'], _savedFormMap['password']);
      } catch (error) {
        print(error.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (isValid && genderPicked && _newDateSelected) {
        _formKey.currentState.save();
        _savedInfo['birthDate'] = _selectedDate;
        _savedInfo['gender'] = _selectedGender[0] == true ? 'Male' : 'Female';

        try {
          final authData = Provider.of<Auth>(context, listen: false);
          await authData.signUpUser(
              _savedFormMap['email'], _savedFormMap['password']);
          await authData.saveUserData(
            _savedInfo['firstName'],
            _savedInfo['lastName'],
            _savedInfo['birthDate'],
            _savedInfo['gender'],
          );
          setState(() {
            _isLoading = false;
          });
        } catch (error) {
          print(error.toString());
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('M3lesh, Error Happened, try again later'),
                  actions: [
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
          // setState(() {
          //   _isLoading = false;
          // });
        }
      } else {
        Toast.show(
          "Fix the missing data",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lastNameScope.dispose();
    _emailScope.dispose();
    _passwordScope.dispose();
    _confirmPasswordScope.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: authType == AuthType.Login
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: _emailScope,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passwordScope);
                          },
                          onSaved: (emailText) {
                            _savedFormMap['email'] = emailText;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                          ),
                          focusNode: _passwordScope,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          controller: _passwordController,
                          obscureText: true,
                          onSaved: (passwordText) {
                            _savedFormMap['password'] = passwordText;
                          },
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: RaisedButton(
                            child: Text('Login'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onPressed: _isLoading
                                ? null
                                : () {
                                    _authenticateUser();
                                  },
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        FlatButton(
                          child: Text(authType == AuthType.Login
                              ? 'New User? Sign Up Now'
                              : 'Already a user? Login Now'),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  setState(() {
                                    if (authType == AuthType.Login) {
                                      authType = AuthType.SignUp;
                                    } else {
                                      authType = AuthType.SignUp;
                                    }
                                  });
                                },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'First Name',
                                    labelText: 'First Name',
                                  ),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return 'Field empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_lastNameScope);
                                  },
                                  onSaved: (text) {
                                    _savedInfo['firstName'] = text;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    labelText: 'Last Name',
                                  ),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _lastNameScope,
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return 'Field empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_emailScope);
                                  },
                                  onSaved: (text) {
                                    _savedInfo['lastName'] = text;
                                  },
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            focusNode: _emailScope,
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Email field is empty';
                              } else if (!text.contains('@')) {
                                return 'Enter a valid Email';
                              } else {
                                return null;
                              }
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordScope);
                            },
                            onSaved: (emailText) {
                              _savedFormMap['email'] = emailText;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                              labelText: 'Password',
                            ),
                            focusNode: _passwordScope,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            controller: _passwordController,
                            obscureText: true,
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Password field is empty';
                              } else if (text.length < 6) {
                                return 'Your password should be at least 6 characters';
                              } else {
                                return null;
                              }
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_confirmPasswordScope);
                            },
                            onSaved: (passwordText) {
                              _savedFormMap['password'] = passwordText;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              labelText: 'Confirm Password',
                            ),
                            focusNode: _confirmPasswordScope,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Password confirmation is missing';
                              } else if (text != _passwordController.text) {
                                return 'Password confirmation is wrong!';
                              } else {
                                return null;
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('What is your Birth Date?'),
                                Column(
                                  children: [
                                    OutlineButton(
                                      onPressed: () {
                                        _selectDate(context);
                                      },
                                      child: Text(
                                        'Pick a Date',
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    if (_newDateSelected)
                                      Text(
                                        'Date picked successfully!',
                                        style: TextStyle(color: Colors.green),
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('What is your Gender?'),
                                ToggleButtons(
                                  constraints: BoxConstraints(
                                    minWidth: 75,
                                    minHeight: 50,
                                  ),
                                  children: [
                                    Text('Male'),
                                    Text('Female'),
                                  ],
                                  onPressed: (clickedIndex) {
                                    setState(() {
                                      if (clickedIndex == 0) {
                                        _selectedGender[0] = true;
                                        _selectedGender[1] = false;
                                      } else {
                                        _selectedGender[0] = false;
                                        _selectedGender[1] = true;
                                      }
                                    });
                                  },
                                  isSelected: _selectedGender,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: RaisedButton(
                                child: Text('Sign Up'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        _authenticateUser();
                                      },
                              ),
                            ),
                          ),
                          FlatButton(
                            child: Text(authType == AuthType.Login
                                ? 'New User? Sign Up Now'
                                : 'Already a user? Login Now'),
                            onPressed: _isLoading
                                ? null
                                : () {
                                    setState(() {
                                      if (authType == AuthType.Login) {
                                        authType = AuthType.SignUp;
                                      } else {
                                        authType = AuthType.Login;
                                      }
                                    });
                                  },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
