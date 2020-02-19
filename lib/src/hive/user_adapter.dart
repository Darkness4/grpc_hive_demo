import 'package:grpc_hive_demo/src/generated/grpc_hive_demo.pb.dart';
import 'package:hive/hive.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    final user = User()
      ..uid = fields[0] as int // Ain't going to add an adapter.
      ..username = fields[1] as String
      ..isAdmin = fields[2] as bool;
    return user;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(3) // numOfFields
      ..writeByte(0) // field[0] is ...
      ..write(obj.uid.toInt())
      ..writeByte(1) // field[1] is ...
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.isAdmin);
  }
}
