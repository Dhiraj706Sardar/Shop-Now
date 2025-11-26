import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecommerce_app/src/core/errors/exceptions.dart'
    as custom_exceptions;
import 'package:ecommerce_app/src/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
  Future<UserModel> updateUserProfile({
    String? displayName,
    String? phoneNumber,
    String? dateOfBirth,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._supabaseClient);
  final SupabaseClient _supabaseClient;

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const custom_exceptions.AuthException('Sign in failed');
      }

      // Check if email verification is required
      if (response.session == null) {
        throw custom_exceptions.EmailVerificationRequiredException(email);
      }

      return UserModel(
        id: response.user!.id,
        email: response.user!.email!,
        displayName: response.user!.userMetadata?['display_name'],
        photoUrl: response.user!.userMetadata?['photo_url'],
        createdAt: DateTime.parse(response.user!.createdAt!),
      );
    } on AuthApiException catch (e) {
      // Handle Supabase's email not confirmed error
      if (e.code == 'email_not_confirmed') {
        throw custom_exceptions.EmailVerificationRequiredException(email);
      }
      throw custom_exceptions.AuthException(e.message);
    } on custom_exceptions.EmailVerificationRequiredException {
      rethrow;
    } on custom_exceptions.AuthException {
      rethrow;
    } catch (e) {
      throw custom_exceptions.AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmail(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const custom_exceptions.AuthException('Sign up failed');
      }

      if (response.session == null) {
        throw custom_exceptions.EmailVerificationRequiredException(email);
      }

      return UserModel(
        id: response.user!.id,
        email: response.user!.email!,
        displayName: response.user!.userMetadata?['display_name'],
        photoUrl: response.user!.userMetadata?['photo_url'],
        createdAt: DateTime.parse(response.user!.createdAt!),
      );
    } on AuthApiException catch (e) {
      // Handle Supabase's email not confirmed error
      if (e.code == 'email_not_confirmed') {
        throw custom_exceptions.EmailVerificationRequiredException(email);
      }
      throw custom_exceptions.AuthException(e.message);
    } on custom_exceptions.EmailVerificationRequiredException {
      rethrow;
    } on custom_exceptions.AuthException {
      rethrow;
    } catch (e) {
      throw custom_exceptions.AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw custom_exceptions.AuthException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      final session = _supabaseClient.auth.currentSession;

      if (user == null) return null;

      // Check if email verification is required
      if (session == null) {
        throw custom_exceptions.EmailVerificationRequiredException(user.email!);
      }

      return UserModel(
        id: user.id,
        email: user.email!,
        displayName: user.userMetadata?['display_name'],
        photoUrl: user.userMetadata?['photo_url'],
        createdAt: DateTime.parse(user.createdAt!),
      );
    } on custom_exceptions.EmailVerificationRequiredException {
      rethrow;
    } catch (e) {
      throw custom_exceptions.AuthException(e.toString());
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user == null) return null;
      return UserModel(
        id: user.id,
        email: user.email!,
        displayName: user.userMetadata?['display_name'],
        photoUrl: user.userMetadata?['photo_url'],
        createdAt: DateTime.parse(user.createdAt!),
      );
    });
  }

  @override
  Future<UserModel> updateUserProfile({
    String? displayName,
    String? phoneNumber,
    String? dateOfBirth,
  }) async {
    try {
      final Map<String, dynamic> metadata = {};

      if (displayName != null) metadata['display_name'] = displayName;
      if (phoneNumber != null) metadata['phone_number'] = phoneNumber;
      if (dateOfBirth != null) metadata['date_of_birth'] = dateOfBirth;

      final response = await _supabaseClient.auth.updateUser(
        UserAttributes(data: metadata),
      );

      if (response.user == null) {
        throw const custom_exceptions.AuthException('Update profile failed');
      }

      return UserModel(
        id: response.user!.id,
        email: response.user!.email!,
        displayName: response.user!.userMetadata?['display_name'],
        photoUrl: response.user!.userMetadata?['photo_url'],
        createdAt: DateTime.parse(response.user!.createdAt!),
      );
    } catch (e) {
      throw custom_exceptions.AuthException(e.toString());
    }
  }
}
