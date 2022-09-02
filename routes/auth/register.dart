import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';

import '../../app/database/db.dart';

import '../../app/database/models/user.dart';
import '../../app/mail_sender/mail_sender.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'message': 'Use POST for registration'},
    );
  }
  try {
    final body = await context.request.body();
    final email = (jsonDecode(body) as Map)['email'] as String;

    final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);

    if (!emailValid) {
      return Response.json(
        statusCode: HttpStatus.expectationFailed,
        body: {'message': '$email is not a valid email address'},
      );
    }
    final code = Random().nextInt(67898) + 11111;
    final user = User(
      email: email,
      hashedPassword: 'Sd',
      name: 's',
      code: code.toString(),
    );
    final res =
        await Collection<User>().save(user, check: {'email': user.email});

    MailService().sendMail(
      'Veriying your phone number',
      'use <b>$code</b> to confirm your account!',
      'chasseuragace@gmail.com',
    );

    return Response.json(
      body: {'message': 'Registration Successfull', 'data': res},
    );
  } on LogicEception {
    return Response.json(
      statusCode: HttpStatus.preconditionFailed,
      body: {'error': 'The email is already taken.'},
    );
  } on Exception catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}
