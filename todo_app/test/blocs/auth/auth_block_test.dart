import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:todo_app/blocs/auth/auth_bloc.dart';
import 'package:todo_app/blocs/auth/auth_event.dart';
import 'package:todo_app/blocs/auth/auth_state.dart';

import '../../mocks/mock_services.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(mockAuthRepository);
  });

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when LoginRequested is added',
      build: () {
        when(mockAuthRepository.login('test@example.com', 'password'))
            .thenAnswer((_) async => 'mockToken');
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('test@example.com', 'password')),
      expect: () => [AuthLoading(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when SignupRequested is added',
      build: () {
        when(mockAuthRepository.signup('test@example.com', 'password'))
            .thenAnswer((_) async => null);
        return authBloc;
      },
      act: (bloc) => bloc.add(SignupRequested('test@example.com', 'password')),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] when LogoutRequested is added',
      build: () {
        when(mockAuthRepository.logout()).thenAnswer((_) async => null);
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutRequested()),
      expect: () => [AuthUnauthenticated()],
    );
  });
}
