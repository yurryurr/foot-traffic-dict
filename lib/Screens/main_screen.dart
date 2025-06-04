import 'package:dict_foot_traffic/Model/user.dart';
import 'package:dict_foot_traffic/Providers/user_provider.dart';
import 'package:dict_foot_traffic/Screens/add_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' as orient;

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends ConsumerState<MainScreen> {
  final _formKey1 = GlobalKey<FormState>();
  List<User> users = [];

  void _addScreen() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddUserScreen(),
    ));
  }

  void _showModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 150,
        width: double.infinity,
        child: Center(
          child: Form(
            key: _formKey1,
            child: Column(
              children: [
                const Text('Input Password'),
                TextFormField(
                  decoration:
                      const InputDecoration(label: Text('Password ********')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      Navigator.of(context).pop;
                    }
                    return null;
                  },
                  onSaved: (newValue) async {
                    Navigator.of(context).pop();
                    if (newValue == '9877') {
                      ref.read(usersProvider.notifier).sendEmail(context);
                    }
                    if (newValue == '6060') {
                      setState(() {
                        ref.read(usersProvider.notifier).clearDBYurr();
                      });
                    }
                    listOfUsers = ref.read(usersProvider.notifier).listed();
                  },
                ),
                IconButton(
                  onPressed: () {
                    if (_formKey1.currentState!.validate()) {
                      _formKey1.currentState!.save();
                    }
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  var listOfUsers = [];
  @override
  void initState() {
    super.initState();
    ref.read(usersProvider.notifier).loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    orient.SystemChrome.setPreferredOrientations([
      orient.DeviceOrientation.landscapeLeft,
      orient.DeviceOrientation.landscapeRight,
      orient.DeviceOrientation.portraitUp,
    ]);
    final listOfUsers = ref.watch(usersProvider);

    Widget content = const Center(
      child: Text("no Entry yet"),
    );
    /**
  * Database based   
final listings = _updateList();
print("listings = $listings");
content = FutureBuilder<List<User>>(future: listings, builder: 
(context, snapshot) {
  if(snapshot.connectionState != ConnectionState.done){
    return CircularProgressIndicator();
  }
  if(snapshot.hasError){
    print("ERRRROOOOOOORRRRR = ${snapshot.error}");
    return Text("There is an Error");
  }
  List<User> users = snapshot.data ?? [];
  if(users.length <=0){
    return const Text('No Entries Yet');
  }
  print("snapshot.data = ${snapshot.data}");
  return ListView.builder(itemCount: users.length,
    itemBuilder: (context, index) {
    User user = users[index];
    return ListTile(
      title: Text(user.fullName),
      subtitle: Text(user.use),
    );
  },);
},);
*/
    if (listOfUsers.isNotEmpty) {
      content = ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(listOfUsers[index].fullName.toUpperCase()),
            onTap: () {
              //Opens the detailed version
            },
            subtitle: Text(
              listOfUsers[index].use.toUpperCase(),
              style: const TextStyle(fontSize: 10),
            ),
          );
        },
        itemCount: listOfUsers.length,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("DICT ROIX&BASULTA"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _addScreen();
              });
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(onPressed: _showModal, icon: const Icon(Icons.home)),
        ],
      ),
      body: Center(child: content),
      // body: FutureBuilder(
      //     future: _usersFuture,
      //     builder: (context, snapshot) =>
      //         snapshot.connectionState == ConnectionState.waiting
      //             ? const Center(child: CircularProgressIndicator())
      //             : content),
    );
  }
}
