// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../ble/ble_manager.dart' as _i3;
import '../ui/home_page/home_page_view_model.dart' as _i4;
import '../ui/settings_page/settings_view_model.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.BleManager>(_i3.BleManager());
  gh.factory<_i4.HomePageViewModel>(
      () => _i4.HomePageViewModel(get<_i3.BleManager>()));
  gh.factory<_i5.SettingsViewModel>(
      () => _i5.SettingsViewModel(get<_i3.BleManager>()));
  return get;
}
