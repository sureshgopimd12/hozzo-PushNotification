class AppDropDownItem<T> {
  final T value;
  final String name;

  AppDropDownItem({this.value, this.name});
  
  bool isEqual(AppDropDownItem model) {
    return this?.value == model?.value;
  }

  @override
  String toString() => name ?? '';
}
