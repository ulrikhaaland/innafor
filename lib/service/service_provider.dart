import 'package:bss/service/instance_style_service.dart';
import 'package:bss/service/theme_service.dart';

import './screen_service.dart';

class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._();

  static ServiceProvider get instance => _instance;

  ServiceProvider._();

  ScreenService screenService;
  InstanceStyleService instanceStyleService;
  ThemeService themeService;
}
