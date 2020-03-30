import 'package:flutter/material.dart';

class LoginError extends StatelessWidget {
  LoginError(this.error);

  final error;

  @override
  Widget build(BuildContext context) => Text(error);
}