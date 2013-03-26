import 'dart:html';
import 'dart:json';
import '../../lib/dnd/pwt_dnd.dart';
import '../../lib/pwt/pwt.dart';
import '../../lib/widgets/pwt_widgets.dart';

class Item {
  int id;
  String value;
  List<Item> children;
  
  Item(this.id, this.value, [this.children]);
}

class School {
  int id;
  String schoolName;
  
  List<Grade> grades;
  
  School(this.id, this.schoolName, [this.grades]);
}

class Grade {
  int id;
  String schoolGrade;
  
  List<Student> students;
  
  Grade(this.id, this.schoolGrade, [this.students]);
}

class Student {
  int id;
  String firstname;
  String lastname;
  
  Student(this.id, this.firstname, this.lastname);
}

main() {
  /*
   * - Item 1
   * - Item 2
   * | - Item 2.1
   * | - Item 2.2
   * | | - Item 2.2.1
   * | | - Item 2.2.2
   * - Item 3
   * | - Item 3.1
   * - Item 4
   */
  final Item item1 = new Item(1, 'Item 1');
  final Item item2_2_1 = new Item(8, 'Item 2.2.1'); 
  final Item item2_2_2 = new Item(9, 'Item 2.2.2'); 
  final Item item2_2 = new Item(6, 'Item 2.2', [item2_2_1, item2_2_2]); 
  final Item item2_1 = new Item(5, 'Item 2.1'); 
  final Item item2 = new Item(2, 'Item 2', [item2_1, item2_2]); 
  final Item item3_1 = new Item(7, 'Item 3.1');
  final Item item3 = new Item(3, 'Item 3', [item3_1]);
  final Item item4 = new Item(4, 'Item 4');
  final List<Item> items = [item1, item2, item3, item4];
  
  /*
   * - School 1
   * - School 2
   * | - Grade 2.1
   * | - Grade 2.2
   * | | - Student 2.2.1
   * | | - Student 2.2.2
   * - School 3
   * | - Grade 3.1
   * - School 4
   */
  final School school1 = new School(1, 'School 1');
  final Student student2_2_1 = new Student(8, 'Person',  '2.2.1'); 
  final Student student2_2_2 = new Student(9, 'Person',  '2.2.2'); 
  final Grade grade2_2 = new Grade(6, 'Grade 2.2', [student2_2_1, student2_2_2]); 
  final Grade grade2_1 = new Grade(5, 'Grade 2.1'); 
  final School school2 = new School(2, 'School 2', [grade2_1, grade2_2]); 
  final Grade grade3_1 = new Grade(7, 'Grade 3.1');
  final School school3 = new School(3, 'School 3', [grade3_1]);
  final School school4 = new School(4, 'School 4');
  final List<School> schools = [school1, school2, school3, school4];

  //---- Ex1
  final Tree tree1 = new Tree.noFeature((Item item) => item.value, (Item item) => item.children)
    ..data = items
    ..addTo('#ex1');
  
  
  //---- Ex2
  final Tree tree2 = new Tree.noFeature()
    ..addTreeConfig(new TreeConfig(
        (School s) => s.schoolName,
        (School s) => s.grades))
    ..addTreeConfig(new TreeConfig(
        (Grade g) => g.schoolGrade,
        (Grade g) => g.students))
    ..addTreeConfig(new TreeConfig(
        (Student s) => '${s.firstname} ${s.lastname}'))
    ..data = schools
    ..addTo('#ex2');
  
  //---- Ex3
  final Tree tree3 = new Tree.noFeature((Item item) => item.value, 
                                        (Item item) => item.children)
    ..data = items
    ..globalTreeConfig.conditionalUlClasses = ((data, wrapper) {
      if (wrapper.depth == 1) {
        return 'blue';
      } else {
        return '';
      }
    })
    ..globalTreeConfig.conditionalLiClasses = ((data, wrapper) {
      if (wrapper.depth == 2) {
        return 'green';
      } else {
        return '';
      }
    })
    ..addTo('#ex3');

  //---- Ex4
  final Tree tree4 = new Tree((Item item) => item.value, (Item item) => item.children)
    ..data = items
    ..addTo('#ex4');

  //---- Ex5
  final TreeConfig treeNode5_1 = new TreeConfig((Item item) => item.value, (Item item) => item.children);
  treeNode5_1.conditionalOpenedAtFirst = (data, wrapper) => wrapper.depth == 1;
  final Tree tree5 = new Tree()
    ..addTreeConfig(treeNode5_1)
    ..data = items
    ..addTo('#ex5');
  
  //---- Ex6
  final TreeConfig treeNode6_1 = new TreeConfig((Item item) => item.value, (Item item) => item.children);
  treeNode6_1.conditionalOpenedAtFirst = (data, wrapper) => wrapper.depth == 0;
  final Tree tree6 = new Tree()
    ..addTreeConfig(treeNode6_1)
    ..data = items
    ..addTo('#ex6');

  //---- Ex7
  final TreeConfig treeNode7_1 = new TreeConfig((Item item) => item.value, (Item item) => item.children);
  treeNode7_1.conditionalAlwaysOpened = (data, wrapper) => wrapper.depth == 0;
  treeNode7_1.conditionalLiClasses = (data, wrapper) => wrapper.hasChildren && wrapper.depth != 0 ? 'pointer' : '';
  final Tree tree7 = new Tree()
    ..addTreeConfig(treeNode7_1)
    ..data = items
    ..addTo('#ex7');

  //---- Ex8
  final TreeConfig treeNode8_1 = new TreeConfig((Item item) => item.value, (Item item) => item.children)
    //..onClick = (MouseEvent e, dynamic data, TreeNodeDataWrapper wrapper) => print('ok'); 
    ..conditionalOnClick = (dynamic data, TreeNodeDataWrapper wrapper) {
      if (!wrapper.hasChildren) {
        return (MouseEvent e, Item data, TreeNodeDataWrapper wrapper) => window.alert(data.value);
      }
    };
  final Tree tree8 = new Tree()
    ..addTreeConfig(treeNode8_1)
    ..data = items
    ..animate = true
    ..sortable = true
    ..addTo('#ex8');
} 

