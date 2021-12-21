abstract class Mapper<T, R> {
  R mapTo(T objectToMap);

  T mapFrom(R objectToMap);
}
