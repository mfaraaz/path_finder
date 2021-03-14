import 'package:flutter/material.dart';
import 'package:search_demo/widget/custom_button.dart';
import 'package:search_demo/widget/custom_container.dart';
import 'dart:math';
import 'a_star.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Path Finder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int rows = 8;
  int colums = 6;
  List<Color> col = [];
  List<Image> img = [];
  List<List<int>> grid = [];
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    List<Widget> myRowChildren = [];
    List<List<int>> numbers = [];
    List<int> columnNumbers = [];
    List<int> tempNumbers = [];

    int z = 0;
    grid.clear();
    for (int i = 0; i < rows; i++) {
      for (int y = 0; y < colums; y++) {
        int currentNumber = z + y; // 0,1,2,3,4,5,6,7,8,9,10, 10,11, 12, 13,14
        columnNumbers.add(currentNumber);
        Color tempCol = Colors.teal;
        col.add(tempCol);
        img.add(Image.asset('images/open.jpg'));
      }
      z += colums;
      numbers.add(columnNumbers);
      columnNumbers = [];
    }

    for (int i = 0; i < rows; i++) {
      List<int> temp = [];
      for (int j = 0; j < colums; j++) {
        temp.add(col[colums * i + j] == Colors.teal ? 0 : 1);
      }
      grid.add(temp);
    }

    // print(grid);
    // print(col.length);

    myRowChildren = numbers
        .map(
          (columns) => Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: columns.map((nr) {
                int min = 0;
                Image openImage = Image.asset('images/open.jpg');
                Image blockedImage = Image.asset('images/close.jpg');

                Color blocked = Colors.white;
                Color open = Colors.teal;
                Color color = open;
                Random rnd = new Random();
                return Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      // print(nr);
                      int x = (nr / colums).floor();
                      int y = (nr - x * colums) % rows;
                      setState(() {
                        grid[x][y] = 1;
                        img[nr] = col[nr] == open ? blockedImage : openImage;
                        col[nr] = col[nr] == open ? blocked : open;
                      });
                    },
                    child: Container(
                      height: double.infinity,
                      // padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          // color: col[nr],
                          border: Border.all(width: 1, color: Colors.white38)),
                      child: FittedBox(
                        child: img[nr],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        )
        .toList();

    void getPath() {
      List<int> start = [0, 0];
      List<int> end = [rows - 1, colums - 1];

      List<List<int>> path = astar(grid, start, end);
      // print(path);
      setState(() {
        for (var loc in path) {
          int index = colums * loc[0] + loc[1];
          col[index] = Color(0xff004d40);
          img[index] = Image.asset('images/path.jpg');
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      setState(() {
                        rows++;
                      });
                    },
                    text: 'Row+',
                    color: Colors.deepOrange,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      setState(() {
                        rows--;
                      });
                    },
                    text: 'Row-',
                    color: Colors.deepOrange,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      setState(() {
                        colums++;
                      });
                    },
                    text: 'Col+',
                    color: Colors.deepOrange,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      setState(() {
                        colums--;
                      });
                    },
                    text: 'Col-',
                    color: Colors.deepOrange,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: CustomContainer(
                color: Colors.white, //Color(0xff00695c),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: myRowChildren,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      setState(() {
                        col = [];
                        img = [];
                        isActive = true;
                      });
                    },
                    text: 'CLEAR',
                    color: Colors.white38,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    onPressed: isActive
                        ? () {
                            getPath();
                            setState(() {
                              isActive = false;
                            });
                          }
                        : null,
                    text: 'GET PATH',
                    color: Colors.blueGrey,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
