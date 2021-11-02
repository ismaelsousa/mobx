import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_test/screens/home/list_store.dart';
import 'package:mobx_test/screens/login/login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ListStore listStore = ListStore();

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          backgroundColor: Colors.blue,
          resizeToAvoidBottomInset: false,
          body: Container(
            margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Todo',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 32),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()));
                          },
                          icon: const Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 16,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Observer(builder: (context) {
                            return TextField(
                              controller: controller,
                              onChanged: listStore.setNewTodoTitle,
                              decoration: InputDecoration(
                                  hintText: 'Todo',
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40))),
                                  suffixIcon: listStore.isValidInput
                                      ? GestureDetector(
                                          onTap: () {
                                            listStore.addTodo();
                                            controller.clear();
                                          },
                                          child: const Icon(Icons.add,
                                              color: Colors.black),
                                        )
                                      : null),
                            );
                          }),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(child: Observer(builder: (context) {
                            return ListView.separated(
                                itemBuilder: (_, index) {
                                  final todo = listStore.todoList[index];
                                  return Observer(builder: (context) {
                                    return ListTile(
                                      title: Text(todo.title,
                                          style: TextStyle(
                                              color: todo.done
                                                  ? Colors.grey
                                                  : Colors.black,
                                              decoration: todo.done
                                                  ? TextDecoration.lineThrough
                                                  : null)),
                                      onTap: todo.toggleDone,
                                    );
                                  });
                                },
                                separatorBuilder: (_, __) {
                                  return const Divider();
                                },
                                itemCount: listStore.todoList.length);
                          }))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
