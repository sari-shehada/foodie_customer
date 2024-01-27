part of 'map_extensions.dart';

extension StringDynamicMapExtensions on Map<String, dynamic> {
  Map<String, String> toStringStringMap() {
    //TODO: Test
    // TODO: Handle the case of an object banned called and whether or not it has a proper toMap() method (to iterate through)
    return map(
      (key, value) => MapEntry(
        key,
        value.toString(),
      ),
    );
  }
}
