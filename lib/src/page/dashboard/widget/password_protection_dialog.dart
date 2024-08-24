import 'dart:ui';

import 'package:dio_request_inspector/src/page/resources/app_color.dart';
import 'package:flutter/material.dart';

class PasswordProtectionDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final String password;

  PasswordProtectionDialog({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              backgroundColor: const Color(0xFFE0E0E0),
              child: Container(
                  padding: const EdgeInsets.all(16),
                  width: 300,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock,
                          color: Colors.black,
                          size: 50,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Password Protection',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'This page is password protected. Please enter the password to continue.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }

                            if (value != password) {
                              return 'Your password is incorrect';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter your password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(color: AppColor.primary),
                                textStyle: const TextStyle(color: Colors.white),
                                backgroundColor: Colors.white,
                              ),
                              child: Text('Cancel',
                                  style: TextStyle(color: AppColor.primary)),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(color: AppColor.primary),
                                textStyle: const TextStyle(color: Colors.white),
                                backgroundColor: AppColor.primary,
                              ),
                              child: const Text('Submit',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  )))),
    );
  }
}
