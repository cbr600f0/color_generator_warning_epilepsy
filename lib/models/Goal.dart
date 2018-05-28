final String tableGoal = "goal";
final String columnId = "id";
final String columnName = "name";

class Goal {
  int id;
  String name;

  Goal();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {columnName: name};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  fromMap(Map map) {
    id = map[columnId];
    name = map[columnName];
    return this;
  }
}