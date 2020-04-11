import 'Mergeable.dart';

abstract class BlocModel<TModel> implements Mergeable<TModel> {
  TModel singleFromMap(Map<String, dynamic> map);

  Map<String, dynamic> toJson();
}
