import 'package:mockito/annotations.dart';
import 'package:todo_app/repositories/auth_repository.dart';
import 'package:todo_app/repositories/todo_repository.dart';
import 'package:todo_app/services/api_service.dart';

@GenerateMocks([ApiService, AuthRepository, TodoRepository])
void main() {}
