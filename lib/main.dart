import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:insta_clone/models/profile.dart';
import 'package:insta_clone/provider/profile.dart';
void main() {
  runApp(App());
}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white,
      ),
      home: RootPage(),
    );
  }
}

class RootPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Skip"),
        centerTitle: true,
      ),
      body: ProfilePage(),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Colors.indigo),
        unselectedIconTheme: IconThemeData(color: Colors.black),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(SimpleLineIcons.home), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Feather.search), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(SimpleLineIcons.plus), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(SimpleLineIcons.heart), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(SimpleLineIcons.user), title: Text('Home')),
        ],
      ),
    );
  }

}
class ProfilePage extends StatefulWidget{
  @override
  _ProfilePageState createState() => _ProfilePageState();

}


//deve essere stateful perchè ha lo state, richiamato ogni volta che viene costruita per la prima volta
class _ProfilePageState extends State<ProfilePage>{

  UserModel user;
  List<PostModel> posts;



  @override
  void initState() {
    downloadUserProfile().then((profile) {
      setState((){
        this.user = profile.user;
        this.posts = profile.posts;
      });
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        profileHeader(),//header della pagine
        photoGrid(),//griglia delle foto di immagini
      ],
    );
  }

  Widget profileHeader() {
    if (user == null)
      return SliverToBoxAdapter(child: Container());
      final List<String> labels = ["posts","followers","following"];
      final List<String> values = [user.numPosts.toString(),user.numFollowers.toString(),user.numFollowing.toString()];
      return SliverToBoxAdapter(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(user.imageUrl),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('@${user.username}',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w300),),
                            SizedBox(width: 6,),
                            MaterialButton(
                              minWidth: double.infinity,
                              height: 35,
                              color: Colors.blue.shade700,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              onPressed: () {},
                              child: Text('Segui', style: TextStyle(
                                  color: Colors.white, fontSize: 13),),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16,),
                  Text('${user.fullname}',
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 3,),
                  Text('${user.bio}'),
                  FlatButton(
                    padding: EdgeInsets.all(0), //si allinea a sx
                    onPressed: () {},
                    child: Text('${(user.link == null) ? '' : user.link}',
                      style: TextStyle(color: Colors.indigo.shade900),),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.black12, width: 1))
              ),
              child: Row(children: List.generate(3, (index) =>
                  Expanded(
                    child: Container(
                      child: Column(children: <Widget>[
                        Text('${labels[index]}', style: TextStyle(
                            fontWeight: FontWeight.bold),),

                        Text('${values[index]}', style: TextStyle(color: Colors.black54),),

                      ]

                      ),
                    ),
                  ))

              ),
            ),
          ],
        ),
      );
  }
  Widget photoGrid() => SliverGrid(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 1
    ),
    delegate: SliverChildListDelegate(List.generate(posts?.length ?? 0, (index) => Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('${posts[index].imageUrl}'),
            fit: BoxFit.cover,
          )
      ),
    ))),
  );
}
