part of "router.dart";

class AppRouterName {
  static const String rootPath = '/';
  static const String rootName = '/';

  static const String loginPath = '/login';
  static const String loginName = 'login';

  static const String adminReportPath = '/report';
  static const String adminReportName = 'report';

  static const String adminListUsersPath = '/list-user';
  static const String adminListUsersName = 'list-user';

  static const String adminCreateUserPath = 'create';
  static const String adminCreateUserName = 'create-user';

  static const String adminEditUserPath = 'update/:userId';
  static const String adminEditUserName = 'update-user';

  static const String adminWastePricePath = '/waste/price';
  static const String adminWastePriceName = 'waste-price';

  static const String adminWastePriceLogPath = 'log';
  static const String adminWastePriceLogName = 'waste-price-log';

  static const String staffWasteTransactionPath = '/waste';
  static const String staffWasteTransactionName = 'transaction-waste';

  static const String staffStoreWastePath = 'store/:userId';
  static const String staffStoreWasteName = 'store';

  static const String staffHistoryTransactionPath = '/history';
  static const String staffHistoryTransactionName = 'transaction-history';

  static const String staffEditHistoryPath = 'edit';
  static const String staffEditHistoryName = 'edit-history';

  static const String staffBalanceTransactionPath = '/balance';
  static const String staffBalanceTransactionName = 'transaction-balance';

  static const String staffWithdrawPath = 'withdraw/:userId';
  static const String staffWithdrawName = 'withdraw';

  static const String wargaHomePath = '/warga';
  static const String wargaHomeName = 'warga';

  static const String profilePath = '/profile';
  static const String profileName = 'profile';
}
