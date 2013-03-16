part of pwt_utils;

class PwtOptions {
  Map<String, dynamic> _map;
  
  PwtOptions() : _map = new Map();
  
  PwtOptions.map(Map <String, dynamic> this._map);
  
  dynamic get(String key) => _map[key];
  
  void set(String key, dynamic value) => _map[key] = value;
  
  void apply(String key, [Function setter, dynamic defaultValue]) {
    //print('$key ${_map[key]}');
    
    if(_map[key] == null) {
      if (defaultValue != null) {
        _map[key] = defaultValue;
      }
    } 
    
    if (_map[key] != null && setter != null) {
      setter(_map[key]);
    }
  }
}