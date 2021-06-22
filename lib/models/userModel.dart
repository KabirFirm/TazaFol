import 'dataModel.dart';
class ProfileResponse{
    int status;
    int userId;
    String msg;

    ProfileResponse({this.userId, this.status, this.msg});

    factory ProfileResponse.fromJson(Map<String, dynamic> parsedJson){
      return ProfileResponse(
        status: parsedJson['status'],
        userId: parsedJson['userid'],
        msg: parsedJson['msg'],
      );
    }
  }
class UserValidationData{
  int status;
  int userId;
  String msg;
  Profile profile;

  UserValidationData({this.userId, this.status, this.msg, this.profile});

  factory UserValidationData.fromJson(Map<String, dynamic> parsedJson){
    return UserValidationData(
      status: parsedJson['status'],
      userId: parsedJson['userid'] != null ? parsedJson['userid'] : null,
      msg: parsedJson['msg'],
      profile: parsedJson['profile'] != null
          ? Profile.fromJson(parsedJson['profile'])
          : null,
    );
  }
}

class User{
  String name = "";
  String mobile = "";
  String house = "";
  String flat = "";
  String road = "";
  String block = "";
  String area = "";
  String instruction = "";
  bool isVerified = false;

  /*void save(String userId) async {
    var url = "http://tazafolbd.com/app-api/save_user.php";
    var response = await http.post(url, body: {"userid": userId, "name" : name, "mobile": mobile, "house": house, "flat": flat, "road": road, "block": block, "area": area, "instruction": instruction});
    if(response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      ProfileResponse serverData = ProfileResponse.fromJson(jsonResponse);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt('userid', serverData.userId);
    }else{

    }
    
  }*/
}

