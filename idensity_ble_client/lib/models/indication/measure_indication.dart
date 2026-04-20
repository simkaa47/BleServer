class MeasureIndication {
  bool get isActive => _isActive;
  bool _isActive = false;

  int get secondsLasted => _secondsLasted;
  int  _secondsLasted = 0;

  DateTime _started = DateTime.now();

  void activate(){
    if(!_isActive){
      _started = DateTime.now();
      _isActive = true;
      _secondsLasted = 0;
    }
  }

  void disactivate(){
    if(_isActive){     
      _isActive = false;
    }
  }

  void updateTime(int? setDuration){
    if(_isActive){     
      final now =  DateTime.now(); 
      _secondsLasted = (now.difference(_started)).inSeconds;
      if(setDuration != null){
        if(_started.add(Duration(seconds: setDuration)).isBefore(now)){
          disactivate();
        }
      }
    }
  }
  


}