import 'package:grpc_test_demo/src/generated/grpc_test_demo.pb.dart';
import 'package:hive/hive.dart';

abstract class UserServiceDB {
  User getUser(int uid);
  User findUserByUsername(String username);
  List<User> getAll();
}

class UserServiceDBImpl implements UserServiceDB {
  static UserServiceDBImpl _instance;

  final Box<User> box;

  UserServiceDBImpl._internal(this.box);

  factory UserServiceDBImpl(Box box) {
    return _instance ??= UserServiceDBImpl._internal(box);
  }

  @override
  User getUser(int uid) {
    return box.get(uid);
  }

  @override
  User findUserByUsername(String username) {
    return box.values.firstWhere((element) => element.username == username);
  }

  @override
  List<User> getAll() {
    throw box.values.toList();
  }
}
