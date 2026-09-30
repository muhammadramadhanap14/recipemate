import 'package:intl/intl.dart';

class CardBalance {
  final String uid;
  final int saldo;
  final DateTime lastReadTime;
  final String? cardType;
  final String? cardNumber;
  final String? anotherInfo;

  CardBalance({
    required this.uid,
    required this.saldo,
    required this.lastReadTime,
    this.cardType,
    this.cardNumber,
    this.anotherInfo,
  });

  String get formattedSaldo {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(saldo);
  }

  String get formattedLastReadTime {
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm:ss', 'id_ID');
    return dateFormatter.format(lastReadTime);
  }
}

class CardTransaction {
  final DateTime tanggal;
  final int jumlah;
  final String jenisTransaksi;
  final String? lokasi;

  CardTransaction({
    required this.tanggal,
    required this.jumlah,
    required this.jenisTransaksi,
    this.lokasi,
  });

  String get formattedJumlah {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(jumlah);
  }

  String get formattedTanggal {
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
    return dateFormatter.format(tanggal);
  }
}
