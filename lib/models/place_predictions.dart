class PlacePredictions{
  String? secondaryText;
  String? mainText;
  String? placeId;

  PlacePredictions({this.secondaryText,this.mainText,this.placeId});

  PlacePredictions.fromJson(Map<String,dynamic> json){
    secondaryText = json['structured_formatting']['secondary_text'];
    mainText = json['structured_formatting']['main_text'];
    placeId = json['place_id'];
  }
}