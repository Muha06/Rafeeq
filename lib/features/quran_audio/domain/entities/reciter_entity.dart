class ReciterEntity {
  final int id;
  final String name;

  const ReciterEntity({required this.id, required this.name});
}

//for debugging
class ReciterLite {
  final int id;
  final String name;

  const ReciterLite({required this.id, required this.name});

  @override
  String toString() => '$id - $name';
}
