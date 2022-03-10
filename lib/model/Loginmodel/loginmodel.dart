import 'dart:convert';

class EmpInfo {
  int? id;
  String? userId;
  String image;
  String firstName;
  String lastName;
  String identityNumber;
  String? dateOfBirth;
  String mobileNo;
  String email;
  Null? password;
  String? address;
  String? status;
  String? createdAt;
  String? updatedAt;
  EmpInfo({
    this.id,
    this.userId,
    required this.image,
    required this.firstName,
    required this.lastName,
    required this.identityNumber,
    this.dateOfBirth,
    required this.mobileNo,
    required this.email,
    this.password,
    this.address,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  EmpInfo copyWith({
    int? id,
    String? userId,
    String? image,
    String? firstName,
    String? lastName,
    String? identityNumber,
    String? dateOfBirth,
    String? mobileNo,
    String? email,
    Null? password,
    String? address,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return EmpInfo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      image: image ?? this.image,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      identityNumber: identityNumber ?? this.identityNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'image': image,
      'firstName': firstName,
      'lastName': lastName,
      'identityNumber': identityNumber,
      'dateOfBirth': dateOfBirth,
      'mobileNo': mobileNo,
      'email': email,
      'password': password?.toMap(),
      'address': address,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory EmpInfo.fromMap(Map<String, dynamic> map) {
    return EmpInfo(
      id: map['id']?.toInt(),
      userId: map['userId'],
      image: map['image'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      identityNumber: map['identityNumber'],
      dateOfBirth: map['dateOfBirth'],
      mobileNo: map['mobileNo'],
      email: map['email'],
      password: map['password'],
      address: map['address'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EmpInfo.fromJson(String source) =>
      EmpInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EmpInfo(id: $id, userId: $userId, image: $image, firstName: $firstName, lastName: $lastName, identityNumber: $identityNumber, dateOfBirth: $dateOfBirth, mobileNo: $mobileNo, email: $email, password: $password, address: $address, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmpInfo &&
        other.id == id &&
        other.userId == userId &&
        other.image == image &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.identityNumber == identityNumber &&
        other.dateOfBirth == dateOfBirth &&
        other.mobileNo == mobileNo &&
        other.email == email &&
        other.password == password &&
        other.address == address &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        image.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        identityNumber.hashCode ^
        dateOfBirth.hashCode ^
        mobileNo.hashCode ^
        email.hashCode ^
        password.hashCode ^
        address.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
