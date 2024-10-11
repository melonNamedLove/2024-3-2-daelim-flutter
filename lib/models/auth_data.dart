import 'dart:convert';

class AuthData {
  final String accessToken;
  final String tokenType;
  final DateTime expiresAt;
  AuthData({
    required this.accessToken,
    required this.tokenType,
    required this.expiresAt,
  });

  AuthData copyWith({
    String? accessToken,
    String? tokenType,
    DateTime? expiresAt,
  }) {
    return AuthData(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_at': expiresAt.millisecondsSinceEpoch,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
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
