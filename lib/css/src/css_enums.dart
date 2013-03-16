part of pwt_proto;

class Unit extends Enum {
  static const Unit CM = const Unit._internal('cm');
  static const Unit EM = const Unit._internal('em');
  static const Unit EX = const Unit._internal('ex');
  static const Unit IN = const Unit._internal('in');
  static const Unit MM = const Unit._internal('mm');
  static const Unit PC = const Unit._internal('pc');
  static const Unit PCT = const Unit._internal('%');
  static const Unit PT = const Unit._internal('pt');
  static const Unit PX = const Unit._internal('px');
  
  const Unit._internal(String name) : super(name);
  
  static Unit enum(String value) { 
    value = value.toLowerCase();
    
    switch (value) {
      case 'cm':
        return CM;
      case 'em':
        return EM;
      case 'ex':
        return EX;
      case 'in':
        return IN;
      case 'mm':
        return MM;
      case 'pc':
        return PC;
      case '%':
        return PCT;
      case 'pt':
        return PT;
      case 'px':
        return PX;
      default:
        throw new NoneExistingUnit();
    }
  }
}

class NoneExistingUnit {}

