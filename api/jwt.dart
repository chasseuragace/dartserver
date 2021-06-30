import 'dart:io';
import 'dart:math';

import 'package:jaguar_jwt/jaguar_jwt.dart';

class TokenMaker {
  static final String ISSUER =
      Platform.environment["ISSUER"] ?? "chasseuragace";
  static final SECRET_KEY =
      Platform.environment["SECRET_KEY"] ?? "34klj23*&#jdhlj2s";
  static createTokenForUser(String user) {
    // Create a claim set
    final claimSet = JwtClaim(
      issuer: ISSUER,
      subject: user,
      audience: <String>[
        'mySite.example.com',
      ],
      jwtId: _randomString(32),
      maxAge: const Duration(days: 5),
    );

    // Generate a JWT from the claim set
    return issueJwtHS256(claimSet, SECRET_KEY);
  }

  static Future<dynamic> validateToken(String token) async {
    try {
      final decClaimSet = verifyJwtHS256Signature(token, SECRET_KEY);
      decClaimSet.validate(issuer: ISSUER, audience: 'mySite.example.com');
      return decClaimSet.subject;
    } on JwtException catch (e) {
      print(
          'Error: bad JWT: $e ${e.message == JwtException.tokenExpired.message}');
      return e;
    }
  }

  static String _randomString(int length) {
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final rnd = Random(DateTime.now().millisecondsSinceEpoch);
    final buf = StringBuffer();

    for (var x = 0; x < length; x++) {
      buf.write(chars[rnd.nextInt(chars.length)]);
    }
    return buf.toString();
  }
}
