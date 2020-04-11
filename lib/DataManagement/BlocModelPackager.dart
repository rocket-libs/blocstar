import 'package:blocstar/DataManagement/BlocModel.dart';

class BlocModelPackager {
  static final factories = new Map<Type, dynamic Function()>();

  static TBlocModel _getInstance<TBlocModel extends BlocModel>() {
    if (factories.containsKey(TBlocModel)) {
      final factory = factories[TBlocModel];
      return factory() as TBlocModel;
    } else {
      throw new Exception(
          "Could not find a model initializer for type $TBlocModel");
    }
  }

  static List<TBlocModel>
      deserializeMany<TBlocModel extends BlocModel<TBlocModel>>(
          List<dynamic> mapsList) {
    final instance = _getInstance<TBlocModel>();
    final List<TBlocModel> list = new List<TBlocModel>();
    for (var map in mapsList) {
      list.add(deserializeSingle(map, instance: instance));
    }
    return list;
  }

  static TBlocModel deserializeSingle<TBlocModel extends BlocModel>(
      Map<String, dynamic> map,
      {TBlocModel instance}) {
    instance = instance ?? _getInstance<TBlocModel>();
    return instance.singleFromMap(map);
  }

  static List<dynamic> serializeMany<TBlocModel extends BlocModel>(
      List<TBlocModel> models) {
    final result = new List<dynamic>();
    for (TBlocModel item in models) {
      result.add(item.toJson());
    }
    return result;
  }
}
