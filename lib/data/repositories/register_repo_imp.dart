import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitcoachaz/data/services/firestore_service.dart';
import 'package:fitcoachaz/domain/repositories/register/register_repository.dart';

import '../helpers/table_key.dart';
import '../storage/sharedPrefs/key_store.dart';
import '../storage/sharedPrefs/key_value_store.dart';

class RegisterRepositoryImp extends RegisterRepository {
  RegisterRepositoryImp(
      {required KeyValueStore sharedPrefs, required FirestoreService service})
      : _sharedPrefs = sharedPrefs,
        _service = service;

  final auth = FirebaseAuth.instance;
  final FirestoreService _service;

  final KeyValueStore _sharedPrefs;

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @override
  Future<String?> verifyAndLogin(
    AuthCredential credential,
    String phone,
  ) async {
    // PhoneAuthCredential credential = PhoneAuthProvider.credential(
    //   verificationId: verificationId,
    //   smsCode: smsCode,
    // );
    final authCredential = await auth.signInWithCredential(credential);
    if (authCredential.user == null) return null;
    final uid = authCredential.user!.uid;
    final userData = await _service.read(TableKey.users, uid);
    if (!userData.exists) {
      await _service.create(TableKey.users, uid, {
        'uid': uid,
        'phone': phone,
      });
    }

    return uid;
  }

  @override
  Future<String?> getCredential(PhoneAuthCredential credential) async {
    final authCredential = await auth.signInWithCredential(credential);
    return authCredential.user?.uid;
  }

  @override
  Future<String?> getPhoneNumberPrefs(String phoneNumber) async => _sharedPrefs
      .read<String>(TypeStoreKey<String>(KeyStore.entranceBy + phoneNumber));

  @override
  Future<void> setLimitedTimePrefs(
      String phoneNumber, DateTime futureTime) async {
    await _sharedPrefs.write<String>(
        TypeStoreKey<String>(KeyStore.limitedTime + phoneNumber),
        futureTime.toIso8601String());
    await _sharedPrefs.write<String>(
        TypeStoreKey<String>(KeyStore.entranceBy + phoneNumber), phoneNumber);
  }

  @override
  Future<String?> getLimtedTimePrefs(String phoneNumber) async => _sharedPrefs
      .read<String>(TypeStoreKey<String>(KeyStore.limitedTime + phoneNumber));

  @override
  Future<void> setUserIdPrefs(String? uid) async =>
      await _sharedPrefs.write<String>(TypeStoreKey<String>(KeyStore.uid), uid);
}
