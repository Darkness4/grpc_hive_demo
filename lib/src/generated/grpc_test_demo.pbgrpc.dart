///
//  Generated code. Do not modify.
//  source: grpc_test_demo.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'grpc_test_demo.pb.dart' as $0;
export 'grpc_test_demo.pb.dart';

class GrpcTestDemoClient extends $grpc.Client {
  static final _$getUser = $grpc.ClientMethod<$0.Username, $0.User>(
      '/grpctestdemo.GrpcTestDemo/GetUser',
      ($0.Username value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.User.fromBuffer(value));

  GrpcTestDemoClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.User> getUser($0.Username request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getUser, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class GrpcTestDemoServiceBase extends $grpc.Service {
  $core.String get $name => 'grpctestdemo.GrpcTestDemo';

  GrpcTestDemoServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Username, $0.User>(
        'GetUser',
        getUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Username.fromBuffer(value),
        ($0.User value) => value.writeToBuffer()));
  }

  $async.Future<$0.User> getUser_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Username> request) async {
    return getUser(call, await request);
  }

  $async.Future<$0.User> getUser($grpc.ServiceCall call, $0.Username request);
}
