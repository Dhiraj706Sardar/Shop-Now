import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_with_email.dart';
import '../../domain/usecases/listen_to_auth_changes.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final ListenToAuthChanges _listenToAuthChanges;
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthBloc(
    this._signInWithEmail,
    this._signUpWithEmail,
    this._signOut,
    this._getCurrentUser,
    this._listenToAuthChanges,
    this._authRemoteDataSource,
  ) : super(const AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<UpdateUserProfile>(_onUpdateUserProfile);

    _listenToAuthChanges(NoParams()).listen((user) {
      add(AuthStatusChanged(user));
    });
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _signInWithEmail(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        if (failure is EmailVerificationRequiredFailure) {
          emit(AuthEmailVerificationRequired(failure.email));
        } else {
          emit(AuthError(failure.message));
        }
      },
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _signUpWithEmail(
      SignUpParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        if (failure is EmailVerificationRequiredFailure) {
          emit(AuthEmailVerificationRequired(failure.email));
        } else {
          emit(AuthError(failure.message));
        }
      },
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _signOut(NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _getCurrentUser(NoParams());

    result.fold(
      (failure) {
        if (failure is EmailVerificationRequiredFailure) {
          emit(AuthEmailVerificationRequired(failure.email));
        } else {
          emit(const Unauthenticated());
        }
      },
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(const Unauthenticated());
        }
      },
    );
  }

  void _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      emit(const Unauthenticated());
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is! Authenticated) return;

    emit(const AuthLoading());

    try {
      final updatedUser = await _authRemoteDataSource.updateUserProfile(
        displayName: event.displayName,
        phoneNumber: event.phoneNumber,
        dateOfBirth: event.dateOfBirth,
      );
      emit(Authenticated(updatedUser));
    } catch (e) {
      emit(AuthError(e.toString()));
      // Restore previous state
      emit(currentState);
    }
  }
}
