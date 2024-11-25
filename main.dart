import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
 _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: const Text("Login Screen")
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold
                      )
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Form(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'email',
                                  hintText: 'Enter email',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (String value) {

                                },
                                validator: (value) {
                                  return value!.isEmpty ? 'Please enter email' : null;
                                },
                              ),
                            ),

                            const SizedBox(height: 30,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter password',
                                  prefixIcon: Icon(Icons.password),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (String value) {

                                },
                                validator: (value) {
                                  return value!.isEmpty ? 'Please enter password' : null;
                                },
                              ),
                            ),
                            const SizedBox(height: 30,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35),
                              child: MaterialButton(
                                minWidth: double.infinity,
                                onPressed: () {},
                                color: Colors.purple,
                                textColor: Colors.white,
                                child: const Text('Login'),
                              ),
                            )

                          ],
                        )
                    ),
                  )

                ]
            )
        )
    );
  }
}

