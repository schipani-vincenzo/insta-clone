import 'package:flutter/cupertino.dart';

class ProfileModel{
  final UserModel user;
  final List<PostModel> posts;

  const ProfileModel({@required this.user, @required this.posts});

  //factory di default con i vari parametri che permettono di creare istante utilizzano sorgenti esterne - json, csv etc-
  factory ProfileModel.fromData(dynamic data){
    final UserModel user = UserModel.fromData(data['graphql']['user']);
    final List<dynamic> postDynamic = data["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"];
    final List<PostModel> posts = postDynamic.map((postData) => PostModel.fromData(postData["node"])).toList();

    return ProfileModel(
        user: user,
        posts: posts
    );
  }
}

class UserModel{
  final String fullname;
  final String username;
  final String imageUrl;
  final String bio;
  final String link;
  final int numPosts;
  final int numFollowers;
  final int numFollowing;

  //costruttore di default con i vari parametri che permettono di creare istante
  const UserModel({@required this.fullname,
    @required this.username,
    @required this.imageUrl,
    @required this.bio,
    @required this.link,
    @required this.numPosts,
    @required this.numFollowers,
    @required this.numFollowing
  });


  // ignore: missing_return
  factory UserModel.fromData(dynamic data){
    final String fullname = data['full_name'];
    final String username = data['username'];
    final String imageUrl = data['profile_pic_url'];
    final String bio = data['biography'];
    final String link = data['external_url'];
    final int numPosts = data['edge_owner_to_timeline_media']['count'];
    final int numFollowers = data['edge_followed_by']['count'];
    final int numFollowing = data['edge_follow']['count'];

    return UserModel(
        fullname: fullname,
        username: username,
        imageUrl: imageUrl,
        bio: bio,
        link: link,
        numPosts: numPosts,
        numFollowers: numFollowers,
        numFollowing: numFollowing
    );
  }

}
class PostModel{
  final String imageUrl;

  const PostModel({@required this.imageUrl});
  factory PostModel.fromData(dynamic data){
    final String imageUrl = data["display_url"];
    return PostModel(imageUrl: imageUrl);

  }
}