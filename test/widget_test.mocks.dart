// Mocks generated by Mockito 5.4.5 from annotations
// in eventify/test/widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:ui' as _i5;

import 'package:eventify/models/supabase_user_model.dart' as _i8;
import 'package:eventify/services/auth_service.dart' as _i6;
import 'package:eventify/view_models/auth_view_model.dart' as _i2;
import 'package:flutter/material.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDateTime_0 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [AuthViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthViewModel extends _i1.Mock implements _i2.AuthViewModel {
  @override
  String get name =>
      (super.noSuchMethod(
            Invocation.getter(#name),
            returnValue: _i3.dummyValue<String>(this, Invocation.getter(#name)),
            returnValueForMissingStub: _i3.dummyValue<String>(
              this,
              Invocation.getter(#name),
            ),
          )
          as String);

  @override
  set name(String? _name) => super.noSuchMethod(
    Invocation.setter(#name, _name),
    returnValueForMissingStub: null,
  );

  @override
  String get fullName =>
      (super.noSuchMethod(
            Invocation.getter(#fullName),
            returnValue: _i3.dummyValue<String>(
              this,
              Invocation.getter(#fullName),
            ),
            returnValueForMissingStub: _i3.dummyValue<String>(
              this,
              Invocation.getter(#fullName),
            ),
          )
          as String);

  @override
  set fullName(String? _fullName) => super.noSuchMethod(
    Invocation.setter(#fullName, _fullName),
    returnValueForMissingStub: null,
  );

  @override
  String get email =>
      (super.noSuchMethod(
            Invocation.getter(#email),
            returnValue: _i3.dummyValue<String>(
              this,
              Invocation.getter(#email),
            ),
            returnValueForMissingStub: _i3.dummyValue<String>(
              this,
              Invocation.getter(#email),
            ),
          )
          as String);

  @override
  set email(String? _email) => super.noSuchMethod(
    Invocation.setter(#email, _email),
    returnValueForMissingStub: null,
  );

  @override
  DateTime get dateOfBirth =>
      (super.noSuchMethod(
            Invocation.getter(#dateOfBirth),
            returnValue: _FakeDateTime_0(this, Invocation.getter(#dateOfBirth)),
            returnValueForMissingStub: _FakeDateTime_0(
              this,
              Invocation.getter(#dateOfBirth),
            ),
          )
          as DateTime);

  @override
  set dateOfBirth(DateTime? _dateOfBirth) => super.noSuchMethod(
    Invocation.setter(#dateOfBirth, _dateOfBirth),
    returnValueForMissingStub: null,
  );

  @override
  bool get isLoading =>
      (super.noSuchMethod(
            Invocation.getter(#isLoading),
            returnValue: false,
            returnValueForMissingStub: false,
          )
          as bool);

  @override
  set isLoading(bool? _isLoading) => super.noSuchMethod(
    Invocation.setter(#isLoading, _isLoading),
    returnValueForMissingStub: null,
  );

  @override
  set errorMessage(String? _errorMessage) => super.noSuchMethod(
    Invocation.setter(#errorMessage, _errorMessage),
    returnValueForMissingStub: null,
  );

  @override
  bool get hasListeners =>
      (super.noSuchMethod(
            Invocation.getter(#hasListeners),
            returnValue: false,
            returnValueForMissingStub: false,
          )
          as bool);

  @override
  _i4.Future<void> signUp() =>
      (super.noSuchMethod(
            Invocation.method(#signUp, []),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  void addListener(_i5.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#addListener, [listener]),
    returnValueForMissingStub: null,
  );

  @override
  void removeListener(_i5.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#removeListener, [listener]),
    returnValueForMissingStub: null,
  );

  @override
  void dispose() => super.noSuchMethod(
    Invocation.method(#dispose, []),
    returnValueForMissingStub: null,
  );

  @override
  void notifyListeners() => super.noSuchMethod(
    Invocation.method(#notifyListeners, []),
    returnValueForMissingStub: null,
  );
}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i6.AuthService {
  @override
  _i4.Future<void> signInWithEmailPassword(
    String? email,
    String? password,
    _i7.BuildContext? context,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#signInWithEmailPassword, [
              email,
              password,
              context,
            ]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> signUpWithEmailPassword(
    String? email,
    String? password,
    _i7.BuildContext? context,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#signUpWithEmailPassword, [
              email,
              password,
              context,
            ]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> signOut(_i7.BuildContext? context) =>
      (super.noSuchMethod(
            Invocation.method(#signOut, [context]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i8.SupabaseUserModel? getCurrentUser(_i7.BuildContext? context) =>
      (super.noSuchMethod(
            Invocation.method(#getCurrentUser, [context]),
            returnValueForMissingStub: null,
          )
          as _i8.SupabaseUserModel?);

  @override
  _i4.Future<void> changePassword(
    String? newPassword,
    String? confirmPassword,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#changePassword, [newPassword, confirmPassword]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> sendResetLink(String? email) =>
      (super.noSuchMethod(
            Invocation.method(#sendResetLink, [email]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);
}
