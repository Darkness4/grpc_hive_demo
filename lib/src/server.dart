import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:grpc_hive_demo/src/common.dart';
import 'package:grpc_hive_demo/src/generated/grpc_hive_demo.pbgrpc.dart';
import 'package:grpc_hive_demo/src/hive/user_adapter.dart';
import 'package:hive/hive.dart';

class GrpcHiveDemoService extends GrpcHiveDemoServiceBase {
  final UserServiceDB userServiceDB;

  GrpcHiveDemoService(this.userServiceDB);

  @override
  Stream<User> getAll(grpc.ServiceCall call, Empty request) {
    return Stream.fromIterable(userServiceDB.getAll());
  }

  @override
  Future<User> getUser(grpc.ServiceCall call, Username request) async {
    return userServiceDB.findUserByUsername(request.username);
  }
}

class Server {
  Future<void> main(List<String> args) async {
    Hive.init('./boxes');
    Hive.registerAdapter(UserAdapter());
    final box = await Hive.openBox<User>('userBox');
    await _initialize(box);

    final UserServiceDB userServiceDB = UserServiceDBImpl(box);
    final server = grpc.Server([GrpcHiveDemoService(userServiceDB)]);
    await server.serve(address: '127.0.0.1', port: 8080);
    print('Server listening on port ${server.port}...');

    ProcessSignal.sigint.watch().listen((ProcessSignal signal) async {
      print("Exiting...");
      await server.shutdown().then((_) => print("Server shutdown."));
      await Hive.close().then((_) => print("Boxes all closed."));
      exit(0);
    });
  }
}

Future<void> _initialize(Box box) async {
  await box.clear();
  await box.add(
    User()
      ..username = 'david'
      ..uid = Int64(0)
      ..isAdmin = true,
  );
  await box.add(
    User()
      ..username = 'marc'
      ..uid = Int64(1)
      ..isAdmin = true,
  );
  await box.add(
    User()
      ..username = 'eric'
      ..uid = Int64(2)
      ..isAdmin = false,
  );
}
