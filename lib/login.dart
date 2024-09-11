import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'textonly.dart';
import 'api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'pallete.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  static late String userz;
  bool isLoginForm = true;
 
  TextEditingController loginUsernameController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController registrationUsernameController = TextEditingController();
  TextEditingController registrationPasswordController = TextEditingController();
  TextEditingController registrationPasswordTrueController = TextEditingController();
  TextEditingController ipController = TextEditingController();
  Color indicatorColor = Colors.red;
  String l = 'Login';
  String r = 'Register';

  final gradient = GradientPalettePresets.nih.getLinearGradient(2);
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadIPAddress();
    updateIndicatorColor();
     registrationPasswordController.addListener(updateIndicatorColor);
  registrationPasswordTrueController.addListener(updateIndicatorColor);
      userz = loginUsernameController.text;
  }
@override
  void dispose() {
  // Remove listeners to prevent memory leaks
  registrationPasswordController.removeListener(updateIndicatorColor);
  registrationPasswordTrueController.removeListener(updateIndicatorColor);

  loginUsernameController.dispose();
  loginPasswordController.dispose();
  registrationUsernameController.dispose();
  registrationPasswordController.dispose();
  registrationPasswordTrueController.dispose();

  super.dispose();
}
 static String getUsername() {
    return userz;
  }

  Future<void> _loadIPAddress() async {
    String? storedIP = await storage.read(key: 'ip_address');
    if (storedIP == null || storedIP.isEmpty) {
      _promptForIPAddress();
    } else {
      setState(() {
        API.setLocalIP(storedIP);
      });
    }
  }

  Future<void> _promptForIPAddress() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter IP Address'),
          content: TextField(
            controller: ipController,
            decoration: const InputDecoration(labelText: 'IP Address'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                String ip = ipController.text.trim();
                if (ip.isNotEmpty) {
                  await storage.write(key: 'ip_address', value: ip);
                  API.setLocalIP(ip);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void updateIndicatorColor() {
    setState(() {
      indicatorColor = registrationPasswordController.text == registrationPasswordTrueController.text
          ? Colors.green
          : Colors.red;
    });
  }

  Future<void> loginUser() async {
    try {
      final response = await http.post(
        Uri.parse(API.loginz),
        body: {
          'username': loginUsernameController.text,
          'password': loginPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == "1") { // Change success check to "1"
          final token = data['token'];
          final username = data['username'];

          if (token != null && username != null) {
            await storage.write(key: 'token', value: token);
            await storage.write(key: 'username', value: username);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Textonly(token: token)),
            );
          } else {
            showErrorDialog('Login failed. Token or username is missing.');
          }
        } else {
          showErrorDialog(data['message']);
        }
      } else {
        showErrorDialog('An error occurred while connecting to the server.');
      }
    } catch (error) {
      showErrorDialog('An error occurred: $error');
    }
  }

  Future<void> registerUser() async {
    try {
        final response = await http.post(
            Uri.parse(API.registerz),
            body: {
                'username': registrationUsernameController.text,
                'password': registrationPasswordController.text,
            },
        );

        if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data['success'] == "1") {
                // Registration successful, navigate to the next screen
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Textonly(username: data['username'])),
                );
            } else {
                showErrorDialog(data['message']);
            }
        } else {
            showErrorDialog('An error occurred while connecting to the server.');
        }
    } catch (error) {
        showErrorDialog('An error occurred: $error');
    }
}

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(gradient: gradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (isLoginForm) loginForm() else registrationForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginForm() {
    return Column(
      children: <Widget>[
        Align(alignment: Alignment.topCenter, child: title()),
        const SizedBox(height: 100),
        Align(alignment: Alignment.topLeft, child: Text(l, style: const TextStyle(fontSize: 20))),
        const SizedBox(height: 10),
        textField('Username/Email', loginUsernameController),
        const SizedBox(height: 10),
        textField('Password', loginPasswordController, obscureText: true),
        const SizedBox(height: 10),
        ElevatedButton(
          style: buttonStyle(),
          onPressed: loginUser,
          child: const Text('Login'),
        ),
        const SizedBox(height: 20),
        const Text('Don\'t have an account?'),
        TextButton(
          onPressed: () {
            setState(() {
              isLoginForm = false;
            });
          },
          child: const Text('Click Here', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget registrationForm() {
    return Column(
      children: <Widget>[
        Align(alignment: Alignment.topCenter, child: title()),
        const SizedBox(height: 100),
        Align(alignment: Alignment.topLeft, child: Text(r, style: const TextStyle(fontSize: 20))),
        const SizedBox(height: 10),
        textField('Username/Email', registrationUsernameController),
        const SizedBox(height: 10),
        textField('Password', registrationPasswordController, obscureText: true),
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            textField('Confirm Password', registrationPasswordTrueController, obscureText: true),
            Positioned(
              right: 10,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 4),
                ),
                child: IndicatorWidget(indicatorColor: indicatorColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: buttonStyle(),
          onPressed: registerUser,
          child: const Text('Register'),
        ),
        const SizedBox(height: 20),
        const Text('Already have an account?'),
        TextButton(
          onPressed: () {
            setState(() {
              isLoginForm = true;
            });
          },
          child: const Text('Click Here', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget textField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Container(
      width: 350,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colores.smokey,
      ),
      padding: const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          labelText: label,
        ),
        obscureText: obscureText,
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.grey,
      backgroundColor: Colores.smokey,
      elevation: 5,
      padding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }

  Widget title() {
    return SizedBox(
      height: 100,
      width: 300,
      child: Center(
        child: Column(
          children: [
            Image.asset('assets/Filpen.png'),
          ],
        ),
      ),
    );
  }
}

class IndicatorWidget extends StatelessWidget {
  final Color indicatorColor;

  const IndicatorWidget({super.key, required this.indicatorColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: indicatorColor,
      ),
    );
  }
}
