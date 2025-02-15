import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Currency extends StatelessWidget {
  final num value;
  final TextStyle? style;

  const Currency({
    super.key,
    required this.value,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return Text(
      formatter.format(value),
      style: style,
    );
  }
}
