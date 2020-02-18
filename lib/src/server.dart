import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:grpc_hive_demo/src/common.dart';
import 'package:grpc_hive_demo/src/generated/grpc_hive_demo.pbgrpc.dart';
import 'package:hive/hive.dart';

Future<void> initializeBox(Box box) async {
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
    Hive.init('./box.db');
    Hive.registerAdapter(UserAdapter());
    final box = await Hive.openBox<User>('userBox');
    await initializeBox(box);
    final userServiceDBImpl = UserServiceDBImpl(box);
    final server = grpc.Server([GrpcHiveDemoService(userServiceDBImpl)]);
    await server.serve(address: '127.0.0.1', port: 8080);
    print('Server listening on port ${server.port}...');
  }
}

// Can be generated automatically
class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    print('${numOfFields} fields written.');
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    final user = User()
      ..uid = Int64(fields[0] as int)
      ..username = fields[1] as String
      ..isAdmin = fields[2] as bool;
    print(user.toString());
    return user;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid.toInt())
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.isAdmin);
  }
}
