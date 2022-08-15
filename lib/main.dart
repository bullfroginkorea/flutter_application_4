import 'package:flutter/material.dart';




final List<Task> _items = [];





void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /* dvar tab = 0;
  var data = [];
  var userImage;

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('이름', '데이터');
    storage.get('name');
    storage.setBool('bool', true);
    storage.setStringList('listname', []);
    storage.remove('name');
  }*/
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo',
      home: MyStateFulWidget(),
    );
  }
}

class MyStateFulWidget extends StatefulWidget {
  const MyStateFulWidget({super.key});

  @override
  State<MyStateFulWidget> createState() => _MyStateFulWidgetState();
}




class _MyStateFulWidgetState extends State<MyStateFulWidget> {
  //플러팅버튼에 사용할 showdialog
  //플러팅버튼을 이용하여 키보드와 입력창 활성화
  //내용을 입력하고 완료버튼 혹은 전송아이콘 누르면 입력한내용 저장
  Future<void> _showMyDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white),
            contentTextStyle: TextStyle(color: Colors.white),

            //dialog 만들게요
            title: const Text('New Task'),
            content: TextField(
              style: TextStyle(color: Colors.white), //글씨색 안보여서바꿀게요
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ), //테두리만들게요
                labelText: '할일을 입력하세요',
              ),
              autofocus: true, //텍스트필드 아이디박스 커서 깜빡이
              onSubmitted: (String text) {
                //_items에 Task(title:text)로 저장, 적는값은text
                setState(() {
                  _items.add(Task(title: text));
                });

                Navigator.of(context).pop(); //이전화면 데이터반환
              },
              textInputAction: TextInputAction.send, //키보드 우측하단버튼임
              //send로 되어있으니 넘어가는모양
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text('Todos'),
          )),

      //플러팅버튼
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[700],
        child: Icon(Icons.add),
        onPressed: () {
          _showMyDialog();
        },
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black), //검은배경
        child: ListView(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 16), //패딩주겠습니다

          children: <Widget>[
            for (int index = 0; index < _items.length; index += 1)
              Container(
                key: Key('$index'),
                padding: const EdgeInsets.all(1.0),
                child: TaskTile(
                    itemIndex: index, //tasktile 내의 index
                    onDeleted: () {
                      //tasktile 내의 삭제기능
                      setState(() {
                        _items.removeAt(index);
                      });
                    }),
              )
          ],
        ),
      ),
    );
  }
}

//TaskTile 만들겠습니다
class TaskTile extends StatefulWidget {
  TaskTile({
    Key? key,
    required this.itemIndex, //required 변수명 앞에 붙이면 값을 무조건 받아야한다
    required this.onDeleted,
  }) : super(key: key);

  final int itemIndex;
  final Function onDeleted;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color evenItemColor = colorScheme.primary;
    final Task item = _items[widget.itemIndex];
    return Material(
      child: Container(
        constraints: const BoxConstraints(minHeight: 60),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[900], //타일 색깔
        ),
        child: Row(
          //좌 체크박스 중 리스트내용(title) 우 삭제아이콘
          children: [
            Checkbox(
              activeColor: Colors.white, //체크시 색상
              checkColor: Colors.black, //체크표시 색상

              key: widget.key, //먼뜻?
              value: item.finished,
              onChanged: (checked) {
                //체크되었다면
                //체크되었다면 밑으로 갔음 좋겠는데..
                setState(() {
                  item.finished = checked ?? false; //null체크/없다면false
                });
              },
            ),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              //삭제아이콘
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () => widget.onDeleted(), //누르면 딜리트위젯으로
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  Task({
    required String title,
  })  : finished = false,
        _title = title;

  Task.fromJson(dynamic json)
      : _title = json['title'] ?? "",
        finished = json['finished'] ?? false;

  String _title;
  bool finished;

  String get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['title'] = _title;
    map['finished'] = finished;
    return map;
  }
}



