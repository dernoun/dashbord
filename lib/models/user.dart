import 'package:equatable/equatable.dart';

class Client extends Equatable {

  const Client({
    required this.tenantId,
    required this.tenantName,
    required this.token,
  });
  final String tenantId;
  final String tenantName;
  final String token;

  @override
  List<Object?> get props => <Object?>[tenantId, tenantName, token];
}

