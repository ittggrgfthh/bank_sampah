import 'package:bank_sampah/domain/entities/user.dart';
import 'package:bank_sampah/domain/entities/waste_price.dart';

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

  static final dummyEditHarga = <WastePrice>[
    const WastePrice(
      id: '01',
      organic: 10000,
      inorganic: 50000,
      createAt: 1679094315000,
      admin: User(id: '06', phoneNumber: '000-0000-0000', role: 'admin', password: ''),
    ),
    const WastePrice(
      id: '02',
      organic: 20000,
      inorganic: 1000000,
      createAt: 1679094315000,
      admin: User(
        id: '09',
        phoneNumber: '000-0000-0001',
        role: 'admin',
        password: '',
        fullName: 'Juna Cilok',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
      ),
    ),
  ];

  static final months = <String>[
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static final years = <String>['2023', '2024', '2025'];
}
