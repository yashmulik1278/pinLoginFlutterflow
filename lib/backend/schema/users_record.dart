import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userid" field.
  String? _userid;
  String get userid => _userid ?? '';
  bool hasUserid() => _userid != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "Pin" field.
  int? _pin;
  int get pin => _pin ?? 0;
  bool hasPin() => _pin != null;

  void _initializeFields() {
    _userid = snapshotData['userid'] as String?;
    _email = snapshotData['email'] as String?;
    _name = snapshotData['Name'] as String?;
    _pin = castToType<int>(snapshotData['Pin']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? userid,
  String? email,
  String? name,
  int? pin,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userid': userid,
      'email': email,
      'Name': name,
      'Pin': pin,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    return e1?.userid == e2?.userid &&
        e1?.email == e2?.email &&
        e1?.name == e2?.name &&
        e1?.pin == e2?.pin;
  }

  @override
  int hash(UsersRecord? e) =>
      const ListEquality().hash([e?.userid, e?.email, e?.name, e?.pin]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
