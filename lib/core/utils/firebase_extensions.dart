import 'package:cloud_firestore/cloud_firestore.dart';

extension FirestoreX on FirebaseFirestore {
  CollectionReference<Map<String, dynamic>> get userColRef => collection('users');
  CollectionReference<Map<String, dynamic>> get pointBalanceColRef => collection('point-balances');
  CollectionReference<Map<String, dynamic>> get wastePriceColRef => collection('waste-price');
  CollectionReference<Map<String, dynamic>> get transactionColRef => collection('transactions');
  CollectionReference<Map<String, dynamic>> get rtColRef => collection('rts');
  CollectionReference<Map<String, dynamic>> get rwColRef => collection('rws');
  DocumentReference<Map<String, dynamic>> userDocRef(String id) => userColRef.doc(id);
  DocumentReference<Map<String, dynamic>> pointBalanceDocRef(String id) => pointBalanceColRef.doc(id);
  DocumentReference<Map<String, dynamic>> wastePriceDocRef(String id) => wastePriceColRef.doc(id);
  DocumentReference<Map<String, dynamic>> transactionDocRef(String id) => transactionColRef.doc(id);
  DocumentReference<Map<String, dynamic>> rtDocRef(String id) => rtColRef.doc(id);
  DocumentReference<Map<String, dynamic>> rwDocRef(String id) => rwColRef.doc(id);
}
