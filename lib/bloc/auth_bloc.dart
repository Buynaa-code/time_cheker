import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:time_cheker/service/app/di.dart';
import 'package:time_cheker/service/model/member_model.dart';
import 'package:time_cheker/service/network/dio_factory.dart';
import 'package:time_cheker/service/repository/repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class AuthPageLoad extends AuthEvent {}

class MeInfoLoad extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String token;

  const LoggedIn({required this.token});

  @override
  List<Object> get props => [token];
}

class LoggedOut extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthPageLoaded extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class MeInfoError extends AuthState {
  final String error;

  const MeInfoError(this.error);
}

class MeInfoLoaded extends AuthState {
  final List<Member> memberList;

  const MeInfoLoaded(this.memberList);

  @override
  List<Object> get props => [memberList];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _storage = instance<FlutterSecureStorage>();
  final dioFactory = instance<DioFactory>();
  final _repository = instance<Repository>();

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<AuthPageLoad>(_onAuthPageLoad);
    on<MeInfoLoad>(_onMeInfoLoad);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final token = await _storage.read(key: 'auth_token');

    if (token != null) {
      dioFactory.setToken(token);
      try {
        final members = await _repository.getMemberService(); // List<Member>

        if (members.isNotEmpty) {
          emit(MeInfoLoaded(members)); // Эхний гишүүнийг авах
        } else {
          emit(const MeInfoError("No members found"));
        }
      } catch (error) {
        emit(MeInfoError(error.toString()));
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onAuthPageLoad(AuthPageLoad event, Emitter<AuthState> emit) {
    emit(AuthPageLoaded());
  }

  void _onMeInfoLoad(MeInfoLoad event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final members = await _repository.getMemberService();
      emit(MeInfoLoaded(members));
    } catch (error) {
      emit(MeInfoError(error.toString())); // Алдааг дэлгэрэнгүй харуулж байна
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _storage.write(key: 'auth_token', value: event.token);
    dioFactory.setToken(event.token);
    try {
      final members = await _repository.getMemberService();
      emit(MeInfoLoaded(members));
    } catch (error) {
      if (kDebugMode) {
        print('error is $error');
      }
      emit(MeInfoError(error.toString())); // Алдааг дэлгэрэнгүй харуулж байна
    }
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _storage.delete(key: 'auth_token');
    dioFactory.setToken('');
    emit(AuthUnauthenticated());
  }
}
