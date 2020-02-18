import 'package:fixnum/fixnum.dart';
import 'package:grpc/src/server/call.dart';
import 'package:grpc_test_demo/src/common.dart';
import 'package:grpc_test_demo/src/generated/grpc_test_demo.pbgrpc.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:hive/hive.dart';

class GrpcTestDemoService extends GrpcTestDemoServiceBase {
  final UserServiceDB userServiceDB;

  GrpcTestDemoService(this.userServiceDB);

  @override
  Future<User> getUser(ServiceCall call, Username request) async {
    return userServiceDB.findUserByUsername(request.username);
  }
}

class Server {
  Future<void> main(List<String> args) async {
    Hive.init('./box.db');
    Hive.registerAdapter(UserAdapter());
    final box = await Hive.openBox<User>('userBox');
    initializeBox(box);
    final userServiceDBImpl = UserServiceDBImpl(box);
    final server = grpc.Server([GrpcTestDemoService(userServiceDBImpl)]);
    await server.serve(port: 8080);
    print('Server listening on port ${server.port}...');
  }
}

void initializeBox(Box box) {
  box.clear();
  box.add(
    User()
      ..username = 'david'
      ..uid = Int64(0)
      ..isAdmin = true,
  );
  box.add(
    User()
      ..username = 'marc'
      ..uid = Int64(1)
      ..isAdmin = true,
  );
  box.add(
    User()
      ..username = 'eric'
      ..uid = Int64(2)
      ..isAdmin = false,
  );
}

// Can be generated automatically
class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 0;

  @override
  User read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()
      ..uid = Int64(fields[0])
      ..username = fields[1] as String
      ..isAdmin = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.isAdmin);
  }
}
