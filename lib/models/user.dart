import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final String tenantId;
  final String tenantName;
  final String token;

  const Client({
    required this.tenantId,
    required this.tenantName,
    required this.token,
  });

  @override
  List<Object?> get props => [tenantId, tenantName, token];
}

