import 'dart:convert';
import 'dart:async';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ulid/ulid.dart';

import '../../component/widget/filter_button.dart';
import '../../component/widget/modal_checkbox.dart';
import '../../domain/entities/filter_user.dart';
import '../../presentation/bloc/filter_user/filter_user_bloc.dart';
import '../constant/colors.dart';
import '../constant/default_data.dart';
import '../constant/theme.dart';

class AppHelper {
  static String generateUniqueId() {
    final ulid = Ulid();
    return ulid.toUuid();
  }

  static String hashPassword(String password) {
    final salt = dotenv.env['SALT'] ?? ''; // Mengambil salt dari environment variable
    const codec = utf8;
    final key = utf8.encode(salt);
    final bytes = codec.encode(password);

    final hmacSha256 = Hmac(sha256, key); // Gunakan algoritma yang sesuai
    final digest = hmacSha256.convert(bytes);

    return digest.toString();
  }

  static String formatToThousands(String text) {
    final formatter = NumberFormat("#,##0", "id_ID");
    final parsedValue = int.tryParse(text) ?? 0;
    return formatter.format(parsedValue);
  }

  static String formatToThousandsInt(int number) {
    final formatter = NumberFormat("#,##0", "id_ID");
    return formatter.format(number);
  }

  static int parseToInteger(String formattedText) {
    return int.parse(formattedText.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  static String intToIDR(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(amount);
  }

  static String millisecondEpochtoString(int millisecondsSinceEpoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String millisecondEpochtoDay(int millisecondsSinceEpoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return DateFormat('EEEE').format(dateTime);
  }

  static int stringToMillisecondEpoch(String dateTime) {
    return DateFormat('dd MMMM yyyy').parse(dateTime).millisecondsSinceEpoch;
  }

  static String timeAgoFromMillisecond(int millisecondsSinceEpoch) {
    DateTime itemDateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    DateTime now = DateTime.now();
    Duration difference = now.difference(itemDateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} detik yang lalu';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      int years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }

  static bool isWithin30Minutes(int millisecondsSinceEpoch) {
    DateTime now = DateTime.now();
    int nowInMillisecondsSinceEpoch = now.millisecondsSinceEpoch;
    int differenceMillisecondsEpoch = nowInMillisecondsSinceEpoch - millisecondsSinceEpoch;

    return (differenceMillisecondsEpoch / (1000 * 60)) < 30;
  }

  static bool isWithin5Minutes(int millisecondsSinceEpoch) {
    DateTime now = DateTime.now();
    int nowInMillisecondsSinceEpoch = now.millisecondsSinceEpoch;
    int differenceMillisecondsEpoch = nowInMillisecondsSinceEpoch - millisecondsSinceEpoch;

    return (differenceMillisecondsEpoch / (1000 * 60)) < 5;
  }

  static Duration? getDurationLastTransactionEpoch(int? lastTransactionEpoch) {
    if (lastTransactionEpoch == null) {
      return null;
    }

    /// 5 menit * 60 detik * 1000 milidetik
    const durationCanEdit = 5 * 60 * 1000;

    final duration = (lastTransactionEpoch + durationCanEdit) - DateTime.now().millisecondsSinceEpoch;

    if (duration <= 0) {
      return null;
    }

    return Duration(milliseconds: duration);
  }

  static String generateFilterText(List<String>? items, String placeholder) {
    if (items != null) {
      if (items.length == 1) {
        return items[0];
      } else if (items.length > 1) {
        final hiddenCount = items.length - 1;
        return '${items[0]} (+$hiddenCount)';
      }
    }
    return placeholder;
  }

  static List<Widget> defaultFilterUser(BuildContext context, FilterUser filter) {
    return [
      SizedBox(
        height: 26,
        child: FilterButton(
          label: AppHelper.generateFilterText(filter.villages, 'Desa'),
          onPressed: () => showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (context) => ModalCheckBox(
              items: DefaultData.village,
              initial: filter.villages ?? [],
              title: 'Filter Desa',
              onSelectedChanged: (value) {
                context.read<FilterUserBloc>().add(FilterUserEvent.apply(filter.copyWith(villages: value)));
                context.pop();
              },
            ),
          ),
        ),
      ),
      SizedBox(
        height: 26,
        child: FilterButton(
          label: AppHelper.generateFilterText(filter.rts, 'RT'),
          onPressed: () => showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (context) => ModalCheckBox(
              initial: filter.rts ?? [],
              items: DefaultData.rtrw,
              title: 'Filter RT',
              onSelectedChanged: (value) {
                context.read<FilterUserBloc>().add(FilterUserEvent.apply(filter.copyWith(rts: value)));
                context.pop();
              },
            ),
          ),
          backgroundColor: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
        ),
      ),
      SizedBox(
        height: 26,
        child: FilterButton(
          label: AppHelper.generateFilterText(filter.rws, 'RW'),
          onPressed: () => showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (context) => ModalCheckBox(
              initial: filter.rws ?? [],
              items: DefaultData.rtrw,
              title: 'Filter RW',
              onSelectedChanged: (value) {
                context.read<FilterUserBloc>().add(FilterUserEvent.apply(filter.copyWith(rws: value)));
                context.pop();
              },
            ),
          ),
          backgroundColor: MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
        ),
      ),
    ];
  }
}

class Debouncer {
  Debouncer({required this.milliseconds});
  final int milliseconds;
  Timer? _timer;
  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
