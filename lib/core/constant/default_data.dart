import '../../domain/entities/point_balance.dart';
import '../../domain/entities/transaction_waste.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/waste.dart';
import '../../domain/entities/waste_price.dart';

class DefaultData {
  static final nowDateEpoch = DateTime.now().microsecondsSinceEpoch;

  static const waste = Waste(
    organic: 0,
    inorganic: 0,
  );

  static const pointBalance = PointBalance(
    userId: 'id-default-user',
    currentBalance: 0,
    waste: waste,
  );

  static final user = User(
    id: 0,
    phoneNumber: 'phoneNumber',
    role: 'warga',
    password: 'password',
    balance: 0,
    fullName: 'fullName',
    rt: 'rt',
    rw: 'rw',
    village: 'village',
    photoUrl: 'photoUrl',
    totalInorganicWeight: 0,
    totalOrganicWeight: 0,
    totalWasteWeight: 0,
    createdAt: nowDateEpoch,
    updatedAt: nowDateEpoch,
  );

  static final wastePrice = WastePrice(
    id: 'id-waste-price',
    organic: 2000,
    inorganic: 3000,
    createdAt: nowDateEpoch,
    admin: user.copyWith(
      id: 0,
      role: 'admin',
    ),
  );

  static const withdrawnBalance = WithdrawnBalance(
    balance: 0,
    withdrawn: 0,
    currentBalance: 0,
  );

  static final storeWaste = StoreWaste(
    earnedBalance: 0,
    waste: waste,
    wasteBalance: waste,
    wastePrice: wastePrice,
  );

  static final transactionWaste = TransactionWaste(
    id: 'id-default-transaction',
    createdAt: nowDateEpoch,
    updatedAt: nowDateEpoch,
    user: user.copyWith(
      id: 0,
    ),
    staff: user.copyWith(
      id: 1,
      role: 'staff',
    ),
    withdrawnBalance: withdrawnBalance,
    storeWaste: storeWaste,
    historyStoreWaste: [],
  );

  static final months = <String>[
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static final years = <String>['2023', '2024', '2025'];

  static final withdrawChoice = <int>[50000, 100000, 200000, 300000, 500000, 1000000];

  static final village = <String>[
    'Banyubiru',
    'Gedong',
    'Kebondowo',
    'Kebumen',
    'Kemambang',
    'Ngrapah',
    'Rowoboni',
    'Sepakung',
    'Tegaron',
    'Wirogomo',
  ];

  static final roles = <String>[
    'warga',
    'staff',
    'admin',
  ];

  static final rtrw = List<String>.generate(20, (int index) {
    final number = (index + 1).toString().padLeft(3, '0');
    return number;
  });
}
