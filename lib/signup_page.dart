import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String user_first_name = '';
  String user_last_name = '';
  String user_email = '';
  String user_contact = '';
  String Address = '';
  String password = '';

  // "user_first_name" :  user_first_name,
  //   "user_last_name" :user_last_name,
  //   "user_email" : user_email,
  //   "user_contact" : user_contact,
  //   "address" : Address,
    // "password": hashedPassword,

  
  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Create the payload
      final Map<String, String> payload = {
        "user_first_name" : user_first_name,
        "user_last_name" :user_last_name,
        "user_email" : user_email,
        "user_contact" : user_contact,
        "address" : Address,
        "password": password,
      };

      // Send the POST request
     
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/users/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(payload),
      );
      
      if (response.statusCode == 201) {
        // If the server returns a 200 OK response, navigate to the home page

        // Navigator.pushReplacementNamed(context, '/home');
        print('Signup successful!');
        print(response.body);
      } else {
        print("failerd : ${response.body}");
        // If the server returns an error response, display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to signup: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Fist Name';
                  }
                  return null;
                },
                onSaved: (value) {
                  user_first_name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Last Name';
                  }
                  return null;
                },
                onSaved: (value) {
                  user_last_name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  user_email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Contact Number';
                  }
                  return null;
                },
                onSaved: (value) {
                  user_contact = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Address';
                  }
                  return null;
                },
                onSaved: (value) {
                  Address = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
