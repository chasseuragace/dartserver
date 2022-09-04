// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../main.dart' as entrypoint;
import '../routes/index.dart' as index;
import '../routes/user/profile.dart' as user_profile;
import '../routes/items/update.dart' as items_update;
import '../routes/items/delete.dart' as items_delete;
import '../routes/items/create.dart' as items_create;
import '../routes/items/all.dart' as items_all;
import '../routes/auth/verify.dart' as auth_verify;
import '../routes/auth/register.dart' as auth_register;
import '../routes/auth/login.dart' as auth_login;

import '../routes/_middleware.dart' as middleware;
import '../routes/user/_middleware.dart' as user_middleware;
import '../routes/items/_middleware.dart' as items_middleware;

void main() => createServer();

Future<HttpServer> createServer() async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final handler = Cascade().add(buildRootHandler()).handler;
  return entrypoint.run(handler, ip, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/auth', (r) => buildAuthHandler()(r))
    ..mount('/items', (r) => buildItemsHandler()(r))
    ..mount('/user', (r) => buildUserHandler()(r))
    ..mount('/', (r) => buildHandler()(r));
  return pipeline.addHandler(router);
}

Handler buildAuthHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/verify', auth_verify.onRequest)..all('/register', auth_register.onRequest)..all('/login', auth_login.onRequest);
  return pipeline.addHandler(router);
}

Handler buildItemsHandler() {
  final pipeline = const Pipeline().addMiddleware(items_middleware.middleware);
  final router = Router()
    ..all('/update', items_update.onRequest)..all('/delete', items_delete.onRequest)..all('/create', items_create.onRequest)..all('/all', items_all.onRequest);
  return pipeline.addHandler(router);
}

Handler buildUserHandler() {
  final pipeline = const Pipeline().addMiddleware(user_middleware.middleware);
  final router = Router()
    ..all('/profile', user_profile.onRequest);
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', index.onRequest);
  return pipeline.addHandler(router);
}
