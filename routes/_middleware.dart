import 'package:dart_frog/dart_frog.dart';

///logger
Handler middleware(Handler handler) {
  return handler.use(requestLogger());
}
