import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';

class CPI extends StatelessWidget {
  final bool positioned;
  const CPI(
    this.positioned, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cpi = CircularProgressIndicator(
      strokeWidth: 3,
      backgroundColor: ServiceProvider
          .instance.instanceStyleService.appStyle.backgroundColor,
      valueColor: AlwaysStoppedAnimation<Color>(
          ServiceProvider.instance.instanceStyleService.appStyle.leBleu),
    );
    // Center CPI
    return positioned
        ? Positioned(
            left: ServiceProvider.instance.screenService
                .getWidthByPercentage(context, 45),
            top: ServiceProvider.instance.screenService
                .getHeightByPercentage(context, 50),
            child: cpi,
          )
        : cpi;
  }
}
