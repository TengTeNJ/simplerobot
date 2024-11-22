//捡球机器人捡球时间
class PickupballTime {

  String id = '0';
  String pickupBallTime = '0'; // 捡球机器人工作时间
  String time = ''; // 捡球日期

  PickupballTime({required this.pickupBallTime,required this.time});


  factory PickupballTime.modelFromJson(Map<String, dynamic> json) {
    PickupballTime model =  PickupballTime(
      pickupBallTime: json['pickupBallTime'] ?? '0',
      time: json['time'] ?? '0',
    );
    return model;
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'pickupBallTime': this.pickupBallTime,
        'time': this.time,
        'id': this.id,
      };

}