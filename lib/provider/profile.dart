import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insta_clone/models/profile.dart';

//se asincrona restituire un future
Future<ProfileModel> downloadUserProfile() async{
  final response = await http.get("https://www.instagram.com/schipani.vincenzo/?__a=1");
  if(response.statusCode != 200){
    throw Exception("Error while download file");
  }

  final data = json.decode(response.body);
  return  ProfileModel.fromData(data);


}