import 'package:ecommerce_app/src/features/auth/domain/entity/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// mapper for user entity
extension UserModelExtension on UserModel {
  User toUser() {
    return User(
      id: id,
      email: email,
      name: displayName ?? '',
      photoUrl: photoUrl ?? '',
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}
