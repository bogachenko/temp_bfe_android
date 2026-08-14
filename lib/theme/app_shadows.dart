import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const List<BoxShadow> none = <BoxShadow>[];

  static const List<BoxShadow> subtle = <BoxShadow>[
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> floating = <BoxShadow>[
    BoxShadow(
      color: Color(0x24000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}