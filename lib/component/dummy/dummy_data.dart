import 'package:bank_sampah/domain/entities/transaction_waste.dart';
import 'package:bank_sampah/domain/entities/user.dart';
import 'package:bank_sampah/domain/entities/waste.dart';
import 'package:bank_sampah/domain/entities/waste_price.dart';

import '../../domain/entities/point_balance.dart';
import '../../domain/entities/report.dart';

class DummyData {
  static final dummyUser = <User>[
    const User(
      id: '01',
      phoneNumber: '882-3824-9898',
      role: 'warga',
      password: '',
      fullName: 'Juna Cilok',
      photoUrl: 'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
      pointBalance: PointBalance(
        userId: '01',
        currentBalance: 0,
        waste: Waste(
          organic: 0,
          inorganic: 0,
        ),
      ),
      rt: "001",
      rw: "001",
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
      pointBalance: PointBalance(
        userId: '01',
        currentBalance: 0,
        waste: Waste(
          organic: 0,
          inorganic: 0,
        ),
      ),
      rt: "001",
      rw: "001",
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
        id: '06',
        phoneNumber: '000-0000-0000',
        role: 'admin',
        password: '',
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
        rt: "001",
        rw: "001",
        pointBalance: PointBalance(
          userId: '01',
          currentBalance: 0,
          waste: Waste(
            organic: 0,
            inorganic: 0,
          ),
        ),
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
        rt: "001",
        rw: "001",
        photoUrl:
            'https://images.unsplash.com/photo-1608889175123-8ee362201f81?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1480&q=80',
        pointBalance: PointBalance(
          userId: '01',
          currentBalance: 0,
          waste: Waste(
            organic: 0,
            inorganic: 0,
          ),
        ),
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
    ),
  ];

  static final dummyTransaction = <TransactionWaste>[
    const TransactionWaste(
      id: '01',
      createdAt: 1689303011000,
      updatedAt: 1689303011000,
      user: User(
        id: '02',
        phoneNumber: '981-3123-5432',
        role: 'warga',
        password: '',
        rt: "001",
        rw: "001",
        fullName: 'Sigit Rendang',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
        pointBalance: PointBalance(
          userId: '01',
          currentBalance: 0,
          waste: Waste(
            organic: 0,
            inorganic: 0,
          ),
        ),
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
        pointBalance: PointBalance(
          userId: '01',
          currentBalance: 0,
          waste: Waste(
            organic: 0,
            inorganic: 0,
          ),
        ),
        rt: "001",
        rw: "001",
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
      withdrawnBalance: WithdrawnBalance(balance: 1000000, withdrawn: 200000, currentBalance: 800000),
      storeWaste: StoreWaste(
        earnedBalance: 1000000,
        waste: Waste(organic: 100, inorganic: 200),
        wastePrice: WastePrice(
          id: '01',
          organic: 2000,
          inorganic: 3000,
          createdAt: 1679094315000,
          admin: User(
            id: '09',
            phoneNumber: '882-9819-2342',
            role: 'Admin',
            password: '',
            rt: "001",
            rw: "001",
            pointBalance: PointBalance(
              userId: '01',
              currentBalance: 0,
              waste: Waste(
                organic: 0,
                inorganic: 0,
              ),
            ),
            createdAt: 1679094315000,
            updatedAt: 1679094315000,
          ),
        ),
      ),
      historyUpdate: <HistoryWaste>[],
    ),
    const TransactionWaste(
      id: '02',
      createdAt: 1689303011000,
      updatedAt: 1689303011000,
      user: User(
        id: '02',
        phoneNumber: '981-3123-5432',
        role: 'warga',
        password: '',
        fullName: 'Arlene McCoy',
        photoUrl:
            'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
        pointBalance: PointBalance(
          userId: '01',
          currentBalance: 0,
          waste: Waste(
            organic: 0,
            inorganic: 0,
          ),
        ),
        rt: "001",
        rw: "001",
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
        pointBalance: PointBalance(
          userId: '01',
          currentBalance: 0,
          waste: Waste(
            organic: 0,
            inorganic: 0,
          ),
        ),
        rt: "001",
        rw: "001",
        createdAt: 1679094315000,
        updatedAt: 1679094315000,
      ),
      withdrawnBalance: WithdrawnBalance(balance: 1000000, withdrawn: 200000, currentBalance: 800000),
      storeWaste: StoreWaste(
        earnedBalance: 1000000,
        waste: Waste(organic: 100, inorganic: 200),
        wastePrice: WastePrice(
          id: '01',
          organic: 2000,
          inorganic: 3000,
          createdAt: 1679094315000,
          admin: User(
            id: '09',
            phoneNumber: '882-9819-2342',
            role: 'Admin',
            password: '',
            pointBalance: PointBalance(
              userId: '01',
              currentBalance: 0,
              waste: Waste(
                organic: 0,
                inorganic: 0,
              ),
            ),
            rt: "001",
            rw: "001",
            createdAt: 1679094315000,
            updatedAt: 1679094315000,
          ),
        ),
      ),
      historyUpdate: <HistoryWaste>[],
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
