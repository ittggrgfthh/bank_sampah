import 'package:bank_sampah/domain/entities/transaction.dart';
import 'package:bank_sampah/domain/entities/user.dart';
import 'package:bank_sampah/domain/entities/waste.dart';
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
      createdAt: 1679094315000,
      updatedAt: 1679094315000,
    ),
    const User(
      id: '02',
      phoneNumber: '981-3123-5432',
      role: 'warga',
      password: '',
      fullName: 'Sigit Rendang',
      photoUrl: 'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
      createdAt: 1679094315000,
      updatedAt: 1679094315000,
    ),
  ];

  static final dummyEditHarga = <WastePrice>[
    const WastePrice(
      id: '01',
      organic: 10000,
      inorganic: 50000,
      createdAt: 1679094315000,
      admin: User(
        id: '06',
        phoneNumber: '000-0000-0000',
        role: 'admin',
        password: '',
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
    ),
    const WastePrice(
      id: '02',
      organic: 20000,
      inorganic: 1000000,
      createdAt: 1679094315000,
      admin: User(
        id: '09',
        phoneNumber: '000-0000-0001',
        role: 'admin',
        password: '',
        fullName: 'Juna Cilok',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
    ),
  ];

  static final dummyTransaction = <Transaction>[
    const Transaction(
      id: '01',
      createAt: 1689303011000,
      updateAt: 1689303011000,
      user: User(
        id: '02',
        phoneNumber: '981-3123-5432',
        role: 'warga',
        password: '',
        fullName: 'Sigit Rendang',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
      staff: User(
        id: '10',
        phoneNumber: '985-5959-9696',
        role: 'staff',
        password: '',
        fullName: 'Sigit Rendang',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
      withdrawnBalance: WithdrawnBalance(balance: 1000000, withdrawn: 200000, currentBalance: 800000),
      waste: Waste(organic: 100, inorganic: 200),
      priceWaste: WastePrice(
        id: '01',
        organic: 2000,
        inorganic: 3000,
        createdAt: 1679094315000,
        admin: User(
          id: '09',
          phoneNumber: '882-9819-2342',
          role: 'Admin',
          password: '',
          createdAt: 1679094315000,
          updatedAt: 1679094315000,
        ),
      ),
      historyUpdate: <HistoryWaste>[
        HistoryWaste(waste: Waste(organic: 2000, inorganic: 3000), updateAt: 1679094315000)
      ],
    ),
    const Transaction(
      id: '02',
      createAt: 1689303011000,
      updateAt: 1689303011000,
      user: User(
        id: '02',
        phoneNumber: '981-3123-5432',
        role: 'warga',
        password: '',
        fullName: 'Arlene McCoy',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
      staff: User(
        id: '11',
        phoneNumber: '985-5959-9696',
        role: 'staff',
        password: '',
        fullName: 'Agus Lontong',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
      withdrawnBalance: WithdrawnBalance(balance: 1000000, withdrawn: 200000, currentBalance: 800000),
      waste: Waste(organic: 50, inorganic: 300),
      priceWaste: WastePrice(
        id: '01',
        organic: 2000,
        inorganic: 3000,
        createdAt: 1679094315000,
        admin: User(
          id: '09',
          phoneNumber: '882-9819-2342',
          role: 'Admin',
          password: '',
          createdAt: 1679094315000,
          updatedAt: 1679094315000,
        ),
      ),
      historyUpdate: <HistoryWaste>[],
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
