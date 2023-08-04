import 'package:bank_sampah/domain/entities/user.dart';

class DummyData {
  static final dummyUser = <User>[
    const User(
      id: '01',
      phoneNumber: '882-3824-9898',
      role: 'warga',
      password: '',
      fullName: 'Juna Cilok',
      photoUrl: 'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
    ),
    const User(
      id: '02',
      phoneNumber: '981-3123-5432',
      role: 'warga',
      password: '',
      fullName: 'Sigit Rendang',
      photoUrl: 'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
    ),
  ];

  static final dummyEditHarga = [];
}
