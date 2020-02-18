import 'package:grpc_hive_demo/src/server.dart';

Future<void> main(List<String> args) async {
  await Server().main(args);
}
