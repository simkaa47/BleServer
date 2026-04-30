class DeviceEvent {

  DeviceEvent({required this.id, required this.description});
  final String id;
  final String description;

  bool get isActive => _isActive;
  DateTime get lastActiveTime => _lastActiveTime;
   DateTime get lastNotActiveTime => _lastNotActiveTime;

  bool _isActive = false;
  DateTime _lastActiveTime = DateTime(1990);
  DateTime _lastNotActiveTime = DateTime(1990);

  void activate(){
    if(!_isActive){
      _isActive = true;
      _lastActiveTime = DateTime.now();
    }
  }

  void disactivate(){
    if(_isActive){
      _isActive = false;
      _lastNotActiveTime = DateTime.now();
    }
  }
   
}