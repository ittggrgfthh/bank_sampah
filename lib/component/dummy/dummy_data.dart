import '../../domain/entities/point_balance.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/waste.dart';
import '../../domain/entities/waste_price.dart';

class DummyData {
  static final dummyUser = <User>[
    const User(
      id: 01,
      phoneNumber: '882-3824-9898',
      role: 'warga',
      password: '',
      fullName: 'Juna Cilok',
      photoUrl: 'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
      rt: "001",
      rw: "001",
      village: 'Cilok',
      totalInorganicWeight: 0,
      totalOrganicWeight: 0,
      totalWasteWeight: 0,
      createdAt: 1679094315000,
      updatedAt: 1679094315000,
    ),
    const User(
      id: 12,
      phoneNumber: '981-3123-5432',
      role: 'warga',
      password: '',
      fullName: 'Sigit Rendang',
      photoUrl: 'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
      rt: "001",
      rw: "001",
      village: 'Cilok',
      totalInorganicWeight: 0,
      totalOrganicWeight: 0,
      totalWasteWeight: 0,
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
        fullName: 'Kukuh Setya',
        photoUrl: null,
        id: 06,
        phoneNumber: '000-0000-0000',
        role: 'admin',
        password: '',
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
        rt: "001",
        rw: "001",
        village: 'Cilok',
        totalInorganicWeight: 0,
        totalOrganicWeight: 0,
        totalWasteWeight: 0,
      ),
    ),
    const WastePrice(
      id: '02',
      organic: 20000,
      inorganic: 1000000,
      createdAt: 1679094315000,
      admin: User(
        id: 09,
        phoneNumber: '000-0000-0001',
        role: 'admin',
        password: '',
        fullName: 'Juna Cilok',
        rt: "001",
        rw: "001",
        photoUrl:
            'https://images.unsplash.com/photo-1608889175123-8ee362201f81?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1480&q=80',
        village: 'Cilok',
        totalInorganicWeight: 0,
        totalOrganicWeight: 0,
        totalWasteWeight: 0,
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
    ),
  ];

  static final dummyTransaction = <Transaction>[
    const Transaction(
      id: 01,
      createdAt: 1689303011000,
      updatedAt: 1689303011000,
      warga: User(
        id: 02,
        phoneNumber: '981-3123-5432',
        role: 'warga',
        password: '',
        rt: "001",
        rw: "001",
        fullName: 'Sigit Rendang',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
        village: 'Cilok',
        totalInorganicWeight: 0,
        totalOrganicWeight: 0,
        totalWasteWeight: 0,
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
      admin: User(
        id: 10,
        phoneNumber: '985-5959-9696',
        role: 'staff',
        password: '',
        fullName: 'Sigit Rendang',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
        rt: "001",
        rw: "001",
        village: 'Cilok',
        totalInorganicWeight: 0,
        totalOrganicWeight: 0,
        totalWasteWeight: 0,
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
      imageUrl: '',
      isVerified: true,
      totalInorganicPrice: 10000,
      totalInorganicWeight: 10,
      totalOrganicPrice: 20000,
      totalOrganicWeight: 20,
      totalPrice: 30000,
      totalWeight: 30,
    ),
    const Transaction(
      id: 02,
      createdAt: 1689303011000,
      updatedAt: 1689303011000,
      warga: User(
        id: 03,
        phoneNumber: '087-3223-5432',
        role: 'warga',
        password: '',
        rt: "001",
        rw: "001",
        fullName: 'Agus Regulator',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
        village: 'Cilok',
        totalInorganicWeight: 0,
        totalOrganicWeight: 0,
        totalWasteWeight: 0,
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
      admin: User(
        id: 10,
        phoneNumber: '985-5959-9696',
        role: 'staff',
        password: '',
        fullName: 'Asep Galon',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
        rt: "001",
        rw: "001",
        village: 'Cilok',
        totalInorganicWeight: 0,
        totalOrganicWeight: 0,
        totalWasteWeight: 0,
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
      imageUrl: '',
      isVerified: true,
      totalInorganicPrice: 10000,
      totalInorganicWeight: 10,
      totalOrganicPrice: 20000,
      totalOrganicWeight: 20,
      totalPrice: 30000,
      totalWeight: 30,
    ),
  ];

  static const dummyPdfReport = Report(
    createdAt: 1679094315000,
    createdAtCity: 'Semarang',
    village: 'Kebumen',
    timeSpan: TimeSpan(start: 1679094315000, end: 1679094315000),
    rowsReport: [
      RowReport(
        rt: '001',
        rw: '001',
        waste: Waste(
          organic: 126,
          inorganic: 111,
        ),
        withdrawBalance: 300000,
      ),
      RowReport(
        rt: '002',
        rw: '001',
        waste: Waste(
          organic: 103,
          inorganic: 96,
        ),
        withdrawBalance: 398000,
      ),
    ],
    total: TotalRowReport(
      waste: Waste(
        organic: 1000000,
        inorganic: 1000000,
      ),
      withdrawBalance: 600000,
      sumWaste: 500,
    ),
  );
}
