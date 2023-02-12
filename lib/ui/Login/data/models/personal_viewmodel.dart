import 'dart:convert';

class Personal {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? cpfcnpj;
  bool? auth = false;
  String? token;
  String? tokenIdentify;
  bool? contractFinished = false;
  String? contractLeadtoken;
  String? deviceId;
  bool? passRequired = false;
  String? telematicDeviceToken;
  String? telematicJwtToken;
  String? telematicJwtRefreshToken;
  bool? isTelematicAuth;
  DateTime? expireTelematicToken;
  int? eventIdCreated;

  Personal({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.cpfcnpj,
    this.auth,
    this.token,
    this.tokenIdentify,
    this.contractLeadtoken,
    this.contractFinished,
    this.deviceId,
    this.passRequired,
    this.telematicDeviceToken,
    this.telematicJwtToken,
    this.telematicJwtRefreshToken,
    this.isTelematicAuth = false,
    this.expireTelematicToken,
    this.eventIdCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'cpfcnpj': cpfcnpj,
      'auth': auth,
      'token': token,
      'token_identify': tokenIdentify,
      'contractFinished': contractFinished,
      'contractLeadtoken': contractLeadtoken,
      'device_id': deviceId,
      'pass_required': passRequired,
      'telematicDeviceToken': telematicDeviceToken,
      'telematicJwtToken': telematicJwtToken,
      'telematicJwtRefreshToken': telematicJwtRefreshToken,
      'isTelematicAuth': isTelematicAuth,
      'expireTelematicToken': expireTelematicToken?.toIso8601String(),
      "eventIdCreated": eventIdCreated
    };
  }

  factory Personal.fromMap(Map<String, dynamic> map) {
    return Personal(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      cpfcnpj: map['cpfcnpj'],
      auth: map['auth'],
      token: map['token'],
      tokenIdentify: map['token_identify'],
      contractFinished: map['contractFinished'],
      contractLeadtoken: map['contractLeadtoken'],
      deviceId: map['device_id'],
      passRequired: map['passRequired'],
      telematicDeviceToken: map['telematicDeviceToken'],
      telematicJwtToken: map['telematicJwtToken'],
      telematicJwtRefreshToken: map['telematicJwtRefreshToken'],
      isTelematicAuth: map['isTelematicAuth'],
      expireTelematicToken:
          DateTime.tryParse(map['expireTelematicToken'] ?? ""),
      eventIdCreated: map["eventIdCreated"],
    );
  }

  String toJson() => json.encode(toMap());

  factory Personal.fromJson(String source) =>
      Personal.fromMap(json.decode(source));

  @override
  bool operator ==(covariant Personal other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.cpfcnpj == cpfcnpj &&
        other.auth == auth &&
        other.token == token &&
        other.tokenIdentify == tokenIdentify &&
        other.contractFinished == contractFinished &&
        other.contractLeadtoken == contractLeadtoken &&
        other.deviceId == deviceId &&
        other.passRequired == passRequired &&
        other.telematicDeviceToken == telematicDeviceToken &&
        other.telematicJwtToken == telematicJwtToken &&
        other.telematicJwtRefreshToken == telematicJwtRefreshToken &&
        other.isTelematicAuth == isTelematicAuth &&
        other.expireTelematicToken == expireTelematicToken &&
        other.eventIdCreated == eventIdCreated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        cpfcnpj.hashCode ^
        auth.hashCode ^
        token.hashCode ^
        tokenIdentify.hashCode ^
        contractFinished.hashCode ^
        contractLeadtoken.hashCode ^
        deviceId.hashCode ^
        passRequired.hashCode ^
        telematicDeviceToken.hashCode ^
        telematicJwtToken.hashCode ^
        telematicJwtRefreshToken.hashCode ^
        isTelematicAuth.hashCode ^
        expireTelematicToken.hashCode ^
        eventIdCreated.hashCode;
  }

  Personal copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? cpfcnpj,
    bool? auth,
    String? token,
    String? tokenIdentify,
    bool? contractFinished,
    String? contractLeadtoken,
    String? deviceId,
    bool? passRequired,
    String? telematicDeviceToken,
    String? telematicJwtToken,
    String? telematicJwtRefreshToken,
    bool? isTelematicAuth,
    DateTime? expireTelematicToken,
    int? eventIdCreated,
  }) {
    return Personal(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        cpfcnpj: cpfcnpj ?? this.cpfcnpj,
        auth: auth ?? this.auth,
        token: token ?? this.token,
        tokenIdentify: tokenIdentify ?? this.tokenIdentify,
        contractFinished: contractFinished ?? this.contractFinished,
        contractLeadtoken: contractLeadtoken ?? this.contractLeadtoken,
        deviceId: deviceId ?? this.deviceId,
        passRequired: passRequired ?? this.passRequired,
        telematicDeviceToken: telematicDeviceToken ?? this.telematicDeviceToken,
        telematicJwtToken: telematicJwtToken ?? this.telematicJwtToken,
        telematicJwtRefreshToken:
            telematicJwtRefreshToken ?? this.telematicJwtRefreshToken,
        isTelematicAuth: isTelematicAuth ?? this.isTelematicAuth,
        expireTelematicToken: expireTelematicToken ?? this.expireTelematicToken,
        eventIdCreated: eventIdCreated ?? this.eventIdCreated);
  }
}
