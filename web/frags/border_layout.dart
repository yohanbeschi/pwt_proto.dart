import 'dart:html';
import 'dart:json';
import '../../lib/pwt/pwt.dart';
import '../../lib/layouts/pwt_layouts.dart';

void main() {
  //---- Ex1
  getFullBorderLayout().addTo('#ex1');
  
  //---- Ex2
  getNorthMiddleSouth().addTo('#ex2');
  
  //---- Ex3
  getNorthWestMiddleSouthEast()
    ..westFromTop = true
    ..eastToBottom = true
    ..addTo('#ex3');

  //---- Ex4-1
  getFullBorderLayout()
    ..enableExtendedHandles()
    ..addTo('#ex4-1');
  
  //---- Ex4-2
  getFullBorderLayout()
  ..extendNWNE = true
  ..extendSWSE = true
  ..handleNWN = true
  ..handleNNE = true
  ..handleWM = true
  ..handleEM = true
  ..handleSWS = true
  ..handleSSE = true
  ..addTo('#ex4-2');
  
  /* For Testing
  //---- Ex4-3
  getFullBorderLayout()
  ..extendNWSW = true
  ..extendNESE = true
  ..handleNWW = true
  ..handleNEE = true
  ..handleNM = true
  ..handleSM = true
  ..handleWSW = true
  ..handleESE = true
  ..addTo('#ex4-3');
  
  
  //---- Ex4-4
  getFullBorderLayout()
  ..extendNWN = true
  ..extendSWS = true
  ..handleNWN = true
  ..handleWM = true
  ..handleSWS = true
  ..addTo('#ex4-4');
  
  //---- Ex4-5
  getFullBorderLayout()
  ..extendNNE = true
  ..extendSSE = true
  ..handleNNE = true
  ..handleEM = true
  ..handleSSE = true
  ..addTo('#ex4-5');
  
  //---- Ex4-6
  getFullBorderLayout()
  ..extendNWW = true
  ..extendNEE = true
  ..handleNWW = true
  ..handleNM = true
  ..handleNEE = true
  ..addTo('#ex4-6');
  
  //---- Ex4-7
  getFullBorderLayout()
  ..extendWSW = true
  ..extendESE = true
  ..handleWSW = true
  ..handleSM = true
  ..handleESE = true
  ..addTo('#ex4-7');
  */

  //---- Ex5-1
  getNorthWestMiddleSouthEast()
    ..westFromTop = true
    ..eastToBottom = true
    ..extendNWW = true
    ..extendNNE = true
    ..extendESE = true
    ..extendSWS = true
    ..addTo('#ex5-1');
  
  //---- Ex5-2
  getNorthWestMiddleSouthEast()
    ..westToBottom = true
    ..eastFromTop = true
    ..extendNWN = true
    ..extendNEE = true
    ..extendSSE = true
    ..extendWSW = true
    ..addTo('#ex5-2');
  
  //---- Ex6
  getFullBorderLayout()
    ..enableHandles() // Handles
    ..addTo('#ex6');
  
  //---- Ex7
  getFullBorderLayout()
    ..handleNWN = true
    ..handleNNE = true
    ..handleWSW = true
    ..handleSSE = true
    ..extendWSW = true
    ..extendSSE = true
    ..addTo('#ex7');
    
} 

BorderLayout getFullBorderLayout() {
  final ExtElement northWest = new ExtElement(new DivElement());
  northWest.css({'backgroundColor':'#ff8', 'height':'100px', 'width':'200px'});
  northWest.id = 'northWest';
  
  /*
  final ExtElement content = new ExtElement(new DivElement())
    ..style.border = '1px solid #000'
    ..style.height='100%'
    ..css({'overflow':'auto'})
    ..text = 'The overflow property specifies what to do if the content of an element exceeds the size of the element'
    'The overflow property specifies what to do if the content of an element exceeds the size of the element'
        'The overflow property specifies what to do if the content of an element exceeds the size of the element'
        'The overflow property specifies what to do if the content of an element exceeds the size of the element';
  northWest.append(content.element);*/
  
  final ExtElement north = new ExtElement(new DivElement());
  north.css({'backgroundColor':'#99bbe8', 'height':'100px'});
  north.id = 'north';
  
  final ExtElement northEast = new ExtElement(new DivElement());
  northEast.css({'backgroundColor':'#ff8', 'height':'100px', 'width':'200px'});
  northEast.id = 'northEast';
  
  final ExtElement west = new ExtElement(new DivElement());
  west.css({'backgroundColor':'#99bbe8', 'width':'200px'});
  west.id = 'west';
  
  final ExtElement southEast = new ExtElement(new DivElement());
  southEast.css({'backgroundColor':'#ff8', 'height':'100px', 'width':'200px'});
  southEast.id = 'southEast';
  
  final ExtElement south = new ExtElement(new DivElement());
  south.css({'backgroundColor':'#99bbe8', 'height':'100px'});
  south.id = 'south';
  
  final ExtElement southWest = new ExtElement(new DivElement());
  southWest.css({'backgroundColor':'#ff8', 'height':'100px', 'width':'200px'});
  southWest.id = 'southWest';
  
  final ExtElement east = new ExtElement(new DivElement());
  east.css({'backgroundColor':'#99bbe8', 'width':'200px'});
  east.id = 'east';
  
  final ExtElement middle = new ExtElement(new DivElement());
  middle.css({'backgroundColor':'#fff'});
  middle.id = 'middle';
  
  //---- Ex1
  return new BorderLayout()
    ..northWest = northWest
    ..north = north
    ..northEast = northEast
    ..west = west
    ..southWest = southWest
    ..south = south
    ..southEast = southEast
    ..east = east
    ..middle = middle;
}

BorderLayout getNorthMiddleSouth() {
  final ExtElement north = new ExtElement(new DivElement());
  north.css({'backgroundColor':'#99bbe8', 'height':'100px'});
  north.id = 'north';
  
  final ExtElement middle = new ExtElement(new DivElement());
  middle.css({'backgroundColor':'#fff'});
  middle.id = 'middle';
  
  final ExtElement south = new ExtElement(new DivElement());
  south.css({'backgroundColor':'#99bbe8', 'height':'100px'});
  south.id = 'south';

  return new BorderLayout()
    ..north = north
    ..south = south
    ..middle = middle;
}

BorderLayout getNorthWestMiddleSouthEast() {
  final ExtElement north = new ExtElement(new DivElement());
  north.css({'backgroundColor':'#99bbe8', 'height':'100px'});
  north.id = 'north';
  
  final ExtElement west = new ExtElement(new DivElement());
  west.css({'backgroundColor':'#ff8', 'width':'200px'});
  west.id = 'west';
  
  final ExtElement middle = new ExtElement(new DivElement());
  middle.css({'backgroundColor':'#fff'});
  middle.id = 'middle';
  
  final ExtElement east = new ExtElement(new DivElement());
  east.css({'backgroundColor':'#ff8', 'width':'200px'});
  east.id = 'east';
  
  final ExtElement south = new ExtElement(new DivElement());
  south.css({'backgroundColor':'#99bbe8', 'height':'100px'});
  south.id = 'south';

  return new BorderLayout()
    ..north = north
    ..west = west
    ..south = south
    ..east = east
    ..middle = middle;
}