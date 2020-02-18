import 'package:grpc_test_demo/src/server.dart';

Future<void> main(List<String> args) async {
  await Server().main(args);
}
