import 'package:cloud_firestore/cloud_firestore.dart';

extension FirestoreX on FirebaseFirestore {
  CollectionReference get userColRef => collection('users');
  CollectionReference get pointBalanceColRef => collection('point-balances');
  CollectionReference get wastePriceColRef => collection('waste-price');
  CollectionReference get transactionColRef => collection('transaction');
  DocumentReference userDocRef(String id) => userColRef.doc(id);
  DocumentReference pointBalanceDocRef(String id) => pointBalanceColRef.doc(id);
  DocumentReference wastePriceDocRef(String id) => wastePriceColRef.doc(id);
  DocumentReference transactionDocRef(String id) => transactionColRef.doc(id);
}
