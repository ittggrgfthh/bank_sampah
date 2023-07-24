import 'package:cloud_firestore/cloud_firestore.dart';

extension FirestoreX on FirebaseFirestore {
  CollectionReference get userColRef => collection('users');
  CollectionReference get pointBalanceColRef => collection('point_balances');
  DocumentReference userDocRef(String id) => userColRef.doc(id);
  DocumentReference pointBalanceDocRef(String id) => pointBalanceColRef.doc(id);
}
