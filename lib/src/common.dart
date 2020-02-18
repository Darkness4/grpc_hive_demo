import 'package:grpc_test_demo/src/generated/grpc_test_demo.pb.dart';
import 'package:hive/hive.dart';

abstract class UserServiceDB {
  User findUserByUsername(String username);
  Iterable<User> getAll();
  User getUser(int uid);
}

class UserServiceDBImpl implements UserServiceDB {
  static UserServiceDBImpl _instance;

  final Box<User> box;

  factory UserServiceDBImpl(Box<User> box) {
    return _instance ??= UserServiceDBImpl._internal(box);
  }

  UserServiceDBImpl._internal(this.box);

  @override
  User findUserByUsername(String username) {
    return box.values.firstWhere(
      (element) => element.username == username,
      orElse: () => User()..username = username,
    );
  }

  @override
  Iterable<User> getAll() {
    return box.values;
  }

  @override
  User getUser(int uid) {
    return box.get(uid);
  }
}
