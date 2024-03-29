import 'package:fitcoachaz/data/repositories/register_repo_imp.dart';
import 'package:fitcoachaz/data/services/firebase_auth_service.dart';
import 'package:fitcoachaz/data/services/firestore_service.dart';
import 'package:fitcoachaz/data/storage/sharedPrefs/key_value_store.dart';
import 'package:fitcoachaz/data/storage/sharedPrefs/shared_prefs.dart';
import 'package:fitcoachaz/domain/repositories/email_repository.dart';
import 'package:fitcoachaz/ui/bloc/main/main_bloc.dart';
import 'package:fitcoachaz/ui/bloc/timer/timer_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/account_name_repo_imp.dart';
import '../../data/repositories/email_repo_imp.dart';
import '../../data/repositories/session_repo_imp.dart';
import '../../domain/repositories/account_name_repository.dart';
import '../../data/repositories/congratulation_repo_imp.dart';
import '../../domain/repositories/congratulation_repository.dart';
import '../../domain/repositories/main_repository.dart';
import '../../domain/repositories/register_repository.dart';
import '../../domain/repositories/session_repository.dart';
import '../../ui/bloc/account_name/account_name_bloc.dart';
import '../../ui/bloc/congratulation/congratulation_bloc.dart';
import '../../ui/bloc/email/email_bloc.dart';
import '../../ui/bloc/register/register_bloc.dart';
import '../../ui/bloc/session/session_bloc.dart';

@module
abstract class AssembleModule {
  @injectable
  Ticker providerTicker() => const Ticker();

  @singleton
  @preResolve
  Future<KeyValueStore> providerKeyValueStore() async {
    final prefs = SharedPrefs();
    await prefs.init();
    return prefs;
  }

  @injectable
  FirestoreService providerFirestoreService() => FirestoreService();

  @injectable
  FirebaseAuthService providerFirebaseAuthService() => FirebaseAuthService();

  @injectable
  RegisterRepository providerRegisterRepo(
    KeyValueStore sharedPrefs,
    FirestoreService service,
    FirebaseAuthService authService,
  ) =>
      RegisterRepositoryImp(
        sharedPrefs: sharedPrefs,
        service: service,
        authService: authService,
      );

  @injectable
  RegisterBloc providerRegisterBloc(RegisterRepository repository) =>
      RegisterBloc(repository: repository);

  @injectable
  TimerBloc providerTimerBloc(Ticker ticker) => TimerBloc(ticker: ticker);

  @injectable
  EmailRepository providerEmailRepository(
    KeyValueStore sharedPrefs,
    FirestoreService service,
  ) =>
      EmailRepositoryImp(sharedPrefs: sharedPrefs, service: service);

  @injectable
  EmailBloc providerEmailBloc(EmailRepository repository) =>
      EmailBloc(repository: repository);

  @injectable
  AccountNameRepository providerAccountNameRepository(
    KeyValueStore sharedPrefs,
    FirestoreService service,
  ) =>
      AccountNameRepositoryImp(sharedPrefs: sharedPrefs, service: service);

  @injectable
  AccountNameBloc provideerAccountNameBloc(AccountNameRepository repository) =>
      AccountNameBloc(repository: repository);

  @injectable
  CongratulationRepository providerCongratulationRepository(
    KeyValueStore sharedPrefs,
    FirestoreService service,
  ) =>
      CongratulationRepositoryImp(sharedPrefs: sharedPrefs, service: service);

  @injectable
  CongratulationBloc providerCongratulationBloc(
          CongratulationRepository repository) =>
      CongratulationBloc(repository: repository);

  @injectable
  SessionRepository providerSessionRepo(
    KeyValueStore sharedPrefs,
    FirestoreService service,
    FirebaseAuthService authService,
  ) =>
      SessionRepositoryImp(
        sharedPrefs: sharedPrefs,
        service: service,
      );

  @singleton
  SessionBloc providerSessionBloc(SessionRepository repository) =>
      SessionBloc(repository: repository);

  @lazySingleton
  MainBloc providerMainBloc(MainRepository repository) =>
      MainBloc(repository: repository);
}
