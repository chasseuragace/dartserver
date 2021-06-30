// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

import '../api/auth.dart';
import '../api/mongo_db.dart';

var portEnv = Platform.environment['PORT'];
var _hostname = portEnv == null ? 'localhost' : '0.0.0.0';

Future main(List<String> args) async {
  //setup database
  database = Database();
  await database.init();

  // Serve files from the file system.
  final _staticHandler =
      shelf_static.createStaticHandler('public', defaultDocument: 'index.html');
  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
// For Google Cloud Run, we respect the PORT environment variable
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);
  var portStr = result['port'] ?? portEnv ?? '8080';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  // See https://pub.dev/documentation/shelf/latest/shelf/Cascade-class.html
  final cascade = Cascade()
      // First, serve files from the 'public' directory
      .add(_staticHandler)
      // If a corresponding file is not found, send requests to a `Router`
      .add(_router);

  // See https://pub.dev/documentation/shelf/latest/shelf/Pipeline-class.html
  final pipeline = Pipeline()
      // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
      .addMiddleware(logRequests())
      .addHandler(cascade.handler);

  // See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    pipeline,
    _hostname, // Allows external connections
    port,
  );

  print('Serving at http://${server.address.host}:${server.port}');
}

// Router instance to handler requests.
final _router = shelf_router.Router()
//user related routes
  ..post('/users/update', UserAuthentication().update)
  ..post('/users/update-password', UserAuthentication().updatePassword)
  ..get('/users', UserAuthentication().getAll)
  ..get('/users/login', UserAuthentication().login)
  ..get('/users/find', UserAuthentication().find)
  ..put('/users/add', UserAuthentication().add)
  ..delete('/users/delete', UserAuthentication().delete);
//
