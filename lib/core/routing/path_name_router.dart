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

  static const String adminCreateUserPath = 'create-user';
  static const String adminCreateUserName = 'create-user';

  static const String adminEditUserPath = 'update/:userId';
  static const String adminEditUserName = 'update-user';

  static const String adminWastePricePath = '/waste/price';
  static const String adminWastePriceName = 'waste-price';

  static const String adminWastePriceLogPath = 'log';
  static const String adminWastePriceLogName = 'waste-price-log';

  static const String adminCreateInorganicWastePath = 'create-inorganic';
  static const String adminCreateInorganicWasteName = 'create-inorganic';

  static const String wargaHomePath = '/warga';
  static const String wargaHomeName = 'warga';

  static const String wargaCreateTransactionPath = '/warga-transaction';
  static const String wargaCreateTransactionName = 'warga-transaction';

  static const String profilePath = '/profile';
  static const String profileName = 'profile';
}
