class ObjectWrapper {
  dynamic _value;
  ObjectWrapper.from(dynamic  value){
      if(value!=null){
        _value=value;
      }
  }
  ObjectWrapper();

  get getValue {
    return _value;
  }

  set Value(dynamic value) {
    _value = value;
  }
}
