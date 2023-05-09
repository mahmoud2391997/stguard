import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stguard/modules/parent/grades/Exam_Rseult.dart';
import 'package:stguard/modules/teacher/add_grades/add_grades.dart';
import 'package:stguard/shared/components/constants.dart';

List<dynamic> CLAsses = [];

void getCountry() async {
  List<dynamic> student_id = [];
  List<dynamic> student_country = [];
  List<dynamic> student_school = [];
  var students;
  await FirebaseFirestore.instance
      .collection('Parents')
      .doc(userID)
      .collection('Students')
      .get()
      .then((value) {
    students = value.docs.length;
    value.docs.forEach((element) {
      student_country.add(element['country']);
      student_school.add(element['school']);
      student_id.add(element.id);
    });
  });
}

void getExamsByClass() async {
  await FirebaseFirestore.instance
      .collection('Countries')
      .doc(student_country2[IND!])
      .collection('Schools')
      .doc(student_school2[IND!])
      .collection('Classes')
      .doc(clas[IND!])
      .collection('Grades')
      .doc('grades')
      .get()
      .then((value) {
    examss.addAll(value['exams']);
    subs.addAll(value['subjects']);
  });
}

void getTeacherinfo() async {
  await FirebaseFirestore.instance
      .collection('Teachers')
      .doc(userID)
      .collection('Community')
      .get()
      .then((value) {
    value.docs.forEach((element) {
      Tcountry = element['country'];
      Tschool = element['school'];
    });
  });
}
void getStudentsNames() {
  FirebaseFirestore.instance
      .collection('Countries')
      .doc(Tcountry)
      .collection('Schools')
      .doc(Tschool)
      .collection('Students')
      .where('class_name', isEqualTo: Class)
      .snapshots()
      .forEach((element) {
    element.docs.forEach((element) {
      students_names.add(element['name']);
    });
  });
}

void Exam() async {
  await FirebaseFirestore.instance
      .collection('Countries')
      .doc(Tcountry)
      .collection('Schools')
      .doc(Tschool)
      .collection('Classes')
      .where('class_name', isEqualTo: Class)
      .snapshots()
      .forEach((element) {
    element.docs.forEach(
      (element) {
        FirebaseFirestore.instance
            .collection('Countries')
            .doc(Tcountry)
            .collection('Schools')
            .doc(Tschool)
            .collection('Classes')
            .doc(Class)
            .collection('Grades')
            .doc('grades')
            .snapshots()
            .forEach((element) {
          examsss.addAll(element['exams']);
          print(exams);
          Subjects.addAll(element['subjects']);
        });
      },
    );
  });
}
