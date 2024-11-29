import 'dart:convert';

class AuthData {
  final String userId;
  final String accessToken;
  final String tokenType;
  final DateTime expiresAt;
  final String email;
  AuthData({
    required this.userId,
    required this.accessToken,
    required this.tokenType,
    required this.expiresAt,
    required this.email,
  });

  AuthData copyWith({
    String? userId,
    String? email,
    String? accessToken,
    String? tokenType,
    DateTime? expiresAt,
  }) {
    return AuthData(
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresAt: expiresAt ?? this.expiresAt,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_at': expiresAt.millisecondsSinceEpoch,
    };
  }

//authdata로 매핑
  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      userId: map['user_id'],
      email: map['email'],
      accessToken: map['access_token'],
      tokenType: map['token_type'],
      expiresAt: DateTime.fromMillisecondsSinceEpoch(map['expires_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthData.fromJson(String source) =>
      AuthData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuthData(accessToken: $accessToken, tokenType: $tokenType, expiresAt: $expiresAt)';
}
