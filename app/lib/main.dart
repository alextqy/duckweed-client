import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "package:app/common/lang.dart";

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const HomePage(title: "Duck Weed"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int? groupValue = 1;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    Drawer actionMenu(BuildContext context) {
      return Drawer(
        width: screenSize.width * 0.5,
        backgroundColor: Colors.black54,
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            ListTile(
              horizontalTitleGap: 20,
              leading: const Icon(Icons.search_outlined, size: 20),
              title: Text(
                Lang().forgotPassword,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              onTap: () async {
                Navigator.of(context).pop();
              },
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      );
    }

    return Scaffold(
      endDrawer: actionMenu(context),
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white70),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            CupertinoSlidingSegmentedControl<int>(
              backgroundColor: Colors.white70,
              thumbColor: Colors.deepPurpleAccent,
              padding: const EdgeInsets.all(3),
              groupValue: groupValue,
              children: {
                0: groupValue == 0 ? selectedTabFont(Lang().network) : unselectedTabFont(Lang().network),
                1: groupValue == 1 ? selectedTabFont(Lang().signIn) : unselectedTabFont(Lang().signIn),
                2: groupValue == 2 ? selectedTabFont(Lang().signUp) : unselectedTabFont(Lang().signUp),
              },
              onValueChanged: (value) {
                setState(() {
                  groupValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  selectedTabFont(String t) {
    return Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white));
  }

  unselectedTabFont(String t) {
    return Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black));
  }
}
