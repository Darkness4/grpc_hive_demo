import 'dart:convert';
import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:grpc_test_demo/src/generated/grpc_test_demo.pbgrpc.dart';
import 'package:rxdart/rxdart.dart';

class Client {
  ClientChannel channel;
  GrpcTestDemoClient stub;

  Future<void> main(List<String> args) async {
    // Setup
    channel = ClientChannel(
      '127.0.0.1',
      port: 8080,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    stub = GrpcTestDemoClient(
      channel,
      options: CallOptions(timeout: const Duration(seconds: 60)),
    );

    // DO
    try {
      while (true) {
        await getAll().drain<User>();
        print('Get Username :');
        final line = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
        if (line == 'quit') {
          break;
        }
        final request = Username()..username = line;
        await getUser(request);
      }
    } catch (e, s) {
      print('Caught error: $e. Stacktrace:\n$s');
    }

    // Shutdown
    await channel.shutdown();
  }

  Future<void> getUser(Username username) async {
    print("getUser: ");
    return printUser(await stub.getUser(username));
  }

  Stream<void> getAll() async* {
    print("getAll: ");
    yield* stub.getAll(Empty()).doOnData(printUser);
  }

  void printUser(User user) {
    print(user.toProto3Json());
  }
}
