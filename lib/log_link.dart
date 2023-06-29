import 'package:graphql/client.dart';

class LogLink extends Link {
  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    final operationType = request.type.name.toUpperCase();
    final operationName = request.operation.operationName;
    final variables = request.variables;

    print('[REQUEST] ($operationType) $operationName => variables: $variables');

    return forward!(request).map((response) {
      print('[RESPONSE] (DATA) $operationName => data: $response');

      final GraphQLError error = response.errors!.first;

      error.extensions?['code'];
      return response;
    }).handleError((err) {
      print('[RESPONSE] (ERROR) $operationName => error: $err');
    });
  }
}
