import 'package:blocstar/DataManagement/BlocModel.dart';
import 'package:blocstar/ObjectFactories/BlocstarObjectsProvider.dart';

class BlocModelPackager {
  static TBlocModel _getInstance<TBlocModel extends BlocModel>() {
    return BlocstarObjectsProvider.objectFactory.getInstance<TBlocModel>();
  }

  static List<TBlocModel>
      deserializeMany<TBlocModel extends BlocModel<TBlocModel>>(
          List<dynamic> mapsList) {
    final List<TBlocModel> list = new List<TBlocModel>.empty(growable: true);
    final instance = _getInstance<TBlocModel>();
    for (var map in mapsList) {
      list.add(deserializeSingle(map, instance: instance));
    }
    return list;
  }

  static TBlocModel deserializeSingle<TBlocModel extends BlocModel>(
      Map<String, dynamic> map,
      {TBlocModel? instance}) {
    instance = instance ?? _getInstance<TBlocModel>();
    return instance.singleFromMap(map);
  }

  static List<dynamic> serializeMany<TBlocModel extends BlocModel>(
      List<TBlocModel> models) {
    final result = new List<dynamic>.empty(growable: true);
    for (TBlocModel item in models) {
      result.add(item.toJson());
    }
    return result;
  }
}
