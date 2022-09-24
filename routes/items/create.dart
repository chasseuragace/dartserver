import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../app/database/db.dart';
import '../../app/database/models/items/items.dart';
import '../../app/database/models/user.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post) {
      return Response.json(
          statusCode: HttpStatus.badRequest,
          body: {'message': 'use POST for create'});
    }
    final user = await context.read<Future<User>>();
    final body = await context.request.body();
    return Response.json(
      body: {
        'message': 'Success!',
        'item': (await _createNewProduct(body)).toMap()
      },
    );
  } on AppExceptions catch (e) {
    return Response.json(
        statusCode: HttpStatus.expectationFailed, body: e.toResponse());
  } on LogicEception {
    return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'message': 'Action not permitted!'});
  } on Exception catch (e) {
    return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'message': 'Something went wrong $e'});
  }
}

Future<Items> _createNewProduct(String body) async {
  Items item;

  try {
    item = Items.fromJson(body);
  } on Exception {
    throw AppExceptions(
        json: Items.dummy().toMap(), messgae: "Payload is not valid!");
  }

  return item = Items.fromMap(await Collection<Items>().save(item));
}
