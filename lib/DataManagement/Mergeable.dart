class Mergeable<T> {
  merge() => null;
}

T resolveValue<T>(T oldValue, T newValue) {
  return newValue == null ? oldValue : newValue;
}
