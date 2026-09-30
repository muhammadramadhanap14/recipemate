import 'package:flutter_test/flutter_test.dart';
import 'package:recipemate/utils/auth_route_resolver.dart';

void main() {
  group('AuthRouteResolver Tests', () {
    test('resolveRoute returns /login when user is null', () async {
      final route = await AuthRouteResolver.resolveRoute(null);
      expect(route, '/login');
    });
  });
}
