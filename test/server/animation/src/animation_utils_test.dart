part of pwt_animation;

void buildNumTest1() {
  final String number = buildNum(0.83, 3.5, 15.1);
  assert('13.1' == number);
  
  print('buildNumTest1() executed');
}

void buildColorTest1() {
  final String color = buildColor(0.83, 
                                  new Color(200,3,3), 
                                  new Color(255,5,5));
  assert('rgba(245,4,4,1.0)' == color);
  
  print('buildColorTest1() executed');
}

void buildSizeTest1() {
  final String size = buildSize(0.83, 
                                  new Size(0, Unit.PX), 
                                  new Size(255, Unit.PX));
  assert('211px' == size);
  
  print('buildSizeTest1() executed');
}

void buildSizeInRangeTest1() {
  final String size = buildSize(0.83, 
                                  new Size(0, Unit.PX), 
                                  new Size(255, Unit.PX));
  assert('211px' == size);
  
  print('buildSizeInRangeTest1() executed');
}

void buildSizeInRangeTest2() {
  final String size = buildSizeInRange(-0.10, 
                                  new Size(0, Unit.PX), 
                                  new Size(255, Unit.PX));
  assert('0.0px' == size);
  
  print('buildSizeInRangeTest2() executed');
}

void buildDsizeTest1() {
  final String size = buildDsize(0.76, 
      new DSize(new Size(0, Unit.PCT), new Size(0, Unit.PCT)), 
      new DSize(new Size(100, Unit.PCT), new Size(100, Unit.PCT)));

  assert('76.0% 76.0%' == size);
  
  print('buildDsizeTest1() executed');
}

// Not a test
void incrementNumTest() {
  double i = 0.0;
  String number = null;
  
  do {
    number = buildNum(i, 0, 100);
    
    print(number);
    i += 0.001;
  } while (double.parse(number) < 100.0);
}

// Not a test
void incrementColorTest() {
  double i = 0.0;
  String color = null;
  
  while ('rgb(255,255,255)' != color) {
    color = buildColor(i, new Color(200,3,3), new Color(255,255,255));
    
    print(color);
    i += 0.001;
  }
}

// Not a test
void incrementSizeTest() {
  double i = 0.0;
  String size = null;
  
  do {
    size = buildSizeInRange(i, new Size(0, Unit.PX), new Size(255, Unit.PX));
    
    print(size);
    i += 0.001;
  } while ('255.0px' != size);
}

// Not a test
void incrementDsizeTest() {
  double i = 0.0;
  String dSize = null;
  
  while ('100.0% 100.0%' != dSize) {
    dSize = buildDsize(i, 
        new DSize(new Size(0, Unit.PCT), new Size(0, Unit.PCT)), 
        new DSize(new Size(100, Unit.PCT), new Size(100, Unit.PCT)));
    
    print(dSize);
    i += 0.001;
  }
}