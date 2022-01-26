// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../ble/ble_manager.dart' as _i4;
import '../ui/footswitch_page/fooswitch_page_view_model.dart' as _i6;
import '../ui/footswitch_page/footswitch_configuration/footswitch_configuration_view_model.dart'
    as _i5;
import '../ui/home_page/home_page_view_model.dart' as _i7;
import '../ui/settings_page/settings_view_model.dart' as _i8;
import 'di_module.dart' as _i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final bleModule = _$BleModule();
  gh.singleton<_i3.FlutterReactiveBle>(bleModule.flutterReactiveBle);
  gh.singleton<_i4.BleManager>(_i4.BleManager(get<_i3.FlutterReactiveBle>()));
  gh.factory<_i5.FootswitchConfigurationViewModel>(
      () => _i5.FootswitchConfigurationViewModel(get<_i4.BleManager>()));
  gh.factory<_i6.FootswitchPageViewModel>(
      () => _i6.FootswitchPageViewModel(get<_i4.BleManager>()));
  gh.factory<_i7.HomePageViewModel>(
      () => _i7.HomePageViewModel(get<_i4.BleManager>()));
  gh.factory<_i8.SettingsViewModel>(
      () => _i8.SettingsViewModel(get<_i4.BleManager>()));
  return get;
}

class _$BleModule extends _i9.BleModule {}
