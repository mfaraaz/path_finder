class Node {
  Node(this.parent, this.position, {this.g = 0, this.h = 0, this.f = 0});
  Node parent;
  List<int> position;
  int g, h, f;

  bool eq(Node other) {
    if (this.position[0] == other.position[0] &&
        this.position[1] == other.position[1]) return true;
    return false;
  }
}

List<List<int>> astar(grid, start, end) {
  Node start_node = new Node(null, start);
  start_node.g = start_node.h = start_node.f = 0;
  Node end_node = new Node(null, end);
  end_node.g = end_node.h = end_node.f = 0;

  List<Node> open_list = [];
  List<Node> closed_list = [];

  open_list.add(start_node);

  while (open_list.length > 0) {
    var current_node = open_list[0];
    int current_index = 0;
    int i = 0;
    for (Node x in open_list) {
      if (x.f < current_node.f) {
        current_node = x;
        current_index = i;
      }
      i++;
    }

    open_list.removeAt(current_index);
    closed_list.add(current_node);
    // print(
    //     '${current_node.position} ${end_node.position} ${current_node.eq(end_node)}');
    if (current_node.eq(end_node)) {
      List<List<int>> path = [];
      Node current = current_node;

      while (current != null) {
        path.add(current.position);
        current = current.parent;
      }
      return path;
    }

    List<Node> children = [];
    for (var new_position in [
      [0, -1],
      [0, 1],
      [-1, 0],
      [1, 0],
      // [-1, -1],
      // [-1, 1],
      // [1, -1],
      // [1, 1]
    ]) {
      List<int> node_position = [
        current_node.position[0] + new_position[0],
        current_node.position[1] + new_position[1]
      ];

      if (node_position[0] > (grid.length - 1) ||
          node_position[0] < 0 ||
          node_position[1] > (grid[grid.length - 1].length - 1) ||
          node_position[1] < 0) continue;

      if (grid[node_position[0]][node_position[1]] != 0) continue;

      Node new_node = Node(current_node, node_position);

      children.add(new_node);
    }

    for (Node child in children) {
      for (Node closed_child in closed_list) {
        if (child.eq(closed_child)) continue;
      }

      child.g = current_node.g + 1;
      child.h = ((child.position[0] - end_node.position[0]) *
              (child.position[0] - end_node.position[0])) +
          ((child.position[1] - end_node.position[1]) *
              (child.position[1] - end_node.position[1]));
      child.f = child.g + child.h;

      for (Node open_node in open_list) {
        if (child.eq(open_node) && child.g > open_node.g) {
          continue;
        }
      }
      open_list.add(child);
    }
  }
  return [
    [1, 2, 3]
  ];
}

void main() {
  List<List<int>> grid = [
    [0, 1, 1, 0, 1],
    [0, 1, 1, 0, 1],
    [1, 0, 1, 1, 1],
    [1, 0, 1, 1, 1],
    [0, 1, 1, 0, 1],
    [0, 1, 0, 1, 0],
    [1, 0, 0, 1, 0],
    [1, 1, 1, 1, 0]
  ];
  List<int> start = [0, 0];
  List<int> end = [7, 4];

  List<List<int>> path = astar(grid, start, end);
  print(path);
}
