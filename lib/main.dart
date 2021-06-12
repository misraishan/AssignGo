import 'package:better_assignments/models/assignment.dart';
import 'package:better_assignments/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  // Set path for storage and initalize Hive directory
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();

  // Set orientation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Hive :D
  Hive.init(appDir.path);

  // Register all necessary adapters (Subject & Assignment Adapter)
  Hive.registerAdapter(
    AssignModelAdapter(),
  );
  Hive.registerAdapter(
    SubjectAdapter(),
  );

  // Open new box, subjBox for subjects, assignBox for assignments
  await Hive.openBox("subjBox");
  await Hive.openBox("assignBox");

  // Execute runApp
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Contains all necessary routes + theme related stuff
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Better Assignments',
      theme: ThemeData.dark(),
      routes: {
        "/": (context) => Home(),
      },
    );
  }

  void dispose() {
    Hive.close();
  }
}

/*







 -----------------------------------------------------------------------------------------------------------------
 Home()
 */

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Creates box to store the assignments & subjects
  final assignBox = Hive.box('assignBox');
  final subjBox = Hive.box('subjBox');

  // Controls radius of borders for the panel when shown
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(30.0),
    topRight: Radius.circular(30.0),
  );

  // Creates a panel controller to show panel when add button pressed
  PanelController _pc = new PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListTile(
          title: Text("Test"),
        ),
      ),
      // AppBar contains name of app + Add button
      // Add button leads to SlidingUpPanel
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Assignments",
          style: Theme.of(context).textTheme.headline5,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _title.clear();
              _desc.clear();
              _pc.panelPosition = .7;
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SlidingUpPanel(
        controller: _pc,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height * .6,
        color: Colors.black,
        panel: _panel(),
        body: _listItem(),
        borderRadius: radius,
      ),
    );
  }

/*







 -----------------------------------------------------------------------------------------------------------------
 List Item builder
 */

  Widget _listItem() {
    String desc = "";

    //  assignBox.add(AssignModel(title: "Test", date: "Date"));

    return ListView.builder(
      itemCount: assignBox.length,
      itemBuilder: (BuildContext context, int index) {
        final _assignment = assignBox.get(index) as AssignModel;
        if (_assignment.desc != null) {
          desc = _assignment.desc!;
        }
        return Padding(
          padding: EdgeInsets.all(10),
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            // Favourite slide action
            actions: [
              SlideAction(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    topLeft: Radius.circular(15.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star),
                    Text("Prioritize"),
                  ],
                ),
                // TODO: Check if this will work w/ prioritizationa nd such
                onTap: () {
                  setState(() {
                    assignBox.putAt(0, assignBox.getAt(index));
                  });
                },
              ),
            ],
            // Delete slide action
            secondaryActions: [
              SlideAction(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete),
                    Text("Delete"),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                onTap: () async {
                  setState(() {
                    assignBox.deleteAt(index);
                  });
                },
              ),
            ],
            child: ListTile(
              tileColor: Colors.black,
              title: Text(_assignment.title),
              subtitle: Text(desc),
            ),
          ),
        );
      },
    );
  }

  /*







 -----------------------------------------------------------------------------------------------------------------
 Panel
 */
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  Widget _panel() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // Title
          Container(height: 20),
          TextField(
            controller: _title,
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.assignment),
              labelText: "Assignment name",
            ),
          ),

          // Description
          Container(height: 20),
          TextField(
            controller: _desc,
            autocorrect: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.assignment),
              labelText: "Description",
            ),
          ),

          // Due date selection
          Container(height: 20),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.calendar_today),
            label: Text("Due Date"),
          ),

          // Submit button selection
          Container(height: 20),
          TextButton.icon(
            onPressed: () {
              setState(
                () {
                  if (_title.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Title can't be empty",
                        backgroundColor: Colors.red);
                  } else {
                    assignBox.add(
                      AssignModel(
                        title: _title.text,
                        date: "",
                        desc: _desc.text,
                      ),
                    );
                  }
                },
              );
              _pc.close();
            },
            icon: Icon(Icons.done),
            label: Text("Add assignment"),
          ),
          Container(height: 20),
        ],
      ),
    );
  }
}
