/// email : ""
/// name : ""
/// phone : ""
/// userGroup : 0
/// registerDate : ""
/// token : ""

class UserResponse {
  UserResponse({
      String? email, 
      String? name, 
      String? phone, 
      int? userGroup, 
      String? registerDate, 
      String? token,}){
    _email = email;
    _name = name;
    _phone = phone;
    _userGroup = userGroup;
    _registerDate = registerDate;
    _token = token;
}
//curl -H "Authorization: token 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" https://api.github.com/user

  UserResponse.fromJson(dynamic json) {
    _email = json['email'];
    _name = json['name'];
    _phone = json['phone'];
    _userGroup = json['userGroup'];
    _registerDate = json['registerDate'];
    _token = json['token'];
  }
  String? _email;
  String? _name;
  String? _phone;
  int? _userGroup;
  String? _registerDate;
  String? _token;

  String? get email => _email;
  String? get name => _name;
  String? get phone => _phone;
  int? get userGroup => _userGroup;
  String? get registerDate => _registerDate;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['name'] = _name;
    map['phone'] = _phone;
    map['userGroup'] = _userGroup;
    map['registerDate'] = _registerDate;
    map['token'] = _token;
    return map;
  }


  @override
  String toString() {
    return 'UserResponse{_email: $_email, _name: $_name, _phone: $_phone, _userGroup: $_userGroup, _registerDate: $_registerDate, _token: $_token}';
  }

  static UserResponse parseJson(Map<String, dynamic> json) => UserResponse.fromJson(json);
}