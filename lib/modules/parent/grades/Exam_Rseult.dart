import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/Queries/all_queries.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/states.dart';
import 'package:stguard/modules/parent/grades/unannouncedCard.dart';

import 'SubjectCard.dart';
import 'defaultSubjectcard.dart';

class exams extends StatefulWidget {
  const exams({super.key});

  @override
  State<exams> createState() => _examsState();
}

int? IND;
String? classs;
List<dynamic> subs = [];
List<String> Names = [];
String? EXAM;
int? students_num;
String? student_name;
List<dynamic> examss = [];
List<dynamic> student_country2 = [];
List<dynamic> student_school2 = [];
List<dynamic> clas = [];

class _examsState extends State<exams> {
  @override
  void initState() {
    ParentCubit.get(context).query();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Exams'),
            centerTitle: true,
            leading: BackButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  Names.clear();
                  subs.clear();
                  student_name = null;
                  EXAM = null;
                });
              },
            )),
        body: BlocBuilder<ParentCubit, ParentStates>(builder: (context, state) {
          if (state is GetGradesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetGradeSuccess) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 6.0,
                        bottom: 4.0,
                      ),
                      child: Center(
                        child: Text(
                          "Student name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                      width: double.infinity,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left:60),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: DropdownButton(
                            items: Names.map(
                              (map) => DropdownMenuItem<String>(
                                child: Text(map),
                                value: map,
                              ),
                            ).toList(),
                            hint: Text('Please select'),
                            onChanged: (value) {
                              setState(() {
                                examss.clear();
                                subs.clear();
                                student_name = value!;
                                IND = Names.indexOf(value);
                                EXAM = null;
                                getExamsByClass();
                              });
                            },
                            value: student_name,
                          ),
                          
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 5.0,
                        bottom: 4.0,
                      ),
                      child: Center(
                        child: Text(
                          "Exam Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: 50,
                      child: DropdownSearch<String>(
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                          hintText: "Please Select",
                        )),
                        validator: (v) => v == null ? "Please Select" : null,
                        items: examss.cast<String>(),
                        onChanged: (value) {
                          setState(() {
                            EXAM = value;
                          });
                        },
                        selectedItem: EXAM,
                      ),
                    ),
                    ...subs.map((e) {
                      if (EXAM != null) {
                        return FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Countries')
                                .doc(student_country2[IND!])
                                .collection('Schools')
                                .doc(student_school2[IND!])
                                .collection('Classes')
                                .doc(clas[IND!])
                                .collection('Grades')
                                .doc('grades')
                                .collection(EXAM!)
                                .doc(EXAM!)
                                .collection(e)
                                .where('Student name', isEqualTo: student_name)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.docs.isNotEmpty) {
                                  return SizedBox(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          var instance =
                                              (snapshot.data as dynamic)
                                                  .docs[index];
                                          return SubjectCard(
                                            subjectname: e,
                                            grade: instance['grade'],
                                            mark: instance['score'],
                                            note: instance['note'],
                                          );
                                        }),
                                  );
                                } else {
                                  return unannounced(subject: e);
                                }
                              } else {
                                return unannounced(subject: e);
                              }
                            });
                      } else {
                        return defaultCard(subject: e);
                      }
                    }),
                    // EXAM != null
                    //     ? student_name != null
                    //         ? FutureBuilder(
                    //             future: FirebaseFirestore.instance
                    //                 .collection('grades')
                    //                 .doc('q2t62IWIuT4OFSpqjgnT')
                    //                 .collection(EXAM!)
                    //                 .doc(EXAM!)
                    //                 .collection('english')
                    //                 .where('Student name',
                    //                     isEqualTo: student_name)
                    //                 .get(),
                    //             builder: (context, snapshot) {
                    //               if (snapshot.hasData) {
                    //                 if (snapshot.data!.docs.isNotEmpty) {
                    //                   return SizedBox(
                    //                     height:
                    //                         MediaQuery.of(context).size.height /
                    //                             6,
                    //                     child: ListView.builder(
                    //                         shrinkWrap: true,
                    //                         physics:
                    //                             const NeverScrollableScrollPhysics(),
                    //                         itemCount: 1,
                    //                         itemBuilder: (context, index) {
                    //                           var instance =
                    //                               (snapshot.data as dynamic)
                    //                                   .docs[index];
                    //                           return SubjectCard(
                    //                             subjectname: 'English',
                    //                             grade: instance['grade'],
                    //                             mark: instance['score'],
                    //                             note: instance['note'],
                    //                           );
                    //                         }),
                    //                   );
                    //                 } else {
                    //                   return unannounced(subject: 'English');
                    //                 }
                    //               } else {
                    //                 return unannounced(subject: 'English');
                    //               }
                    //             })
                    //         : defaultCard(subject: 'English')
                    //     : defaultCard(subject: 'English'),
                    // EXAM != null
                    //     ? student_name != null
                    //         ? FutureBuilder(
                    //             future: FirebaseFirestore.instance
                    //                 .collection('grades')
                    //                 .doc('q2t62IWIuT4OFSpqjgnT')
                    //                 .collection(EXAM!)
                    //                 .doc(EXAM!)
                    //                 .collection('arabic')
                    //                 .where('Student name',
                    //                     isEqualTo: student_name)
                    //                 .get(),
                    //             builder: (context, snapshot) {
                    //               if (snapshot.hasData) {
                    //                 if (snapshot.data!.docs.isNotEmpty) {
                    //                   return SizedBox(
                    //                     height:
                    //                         MediaQuery.of(context).size.height /
                    //                             6,
                    //                     child: ListView.builder(
                    //                         shrinkWrap: true,
                    //                         physics:
                    //                             const NeverScrollableScrollPhysics(),
                    //                         itemCount: 1,
                    //                         itemBuilder: (context, index) {
                    //                           var instance =
                    //                               (snapshot.data as dynamic)
                    //                                   .docs[index];
                    //                           return SubjectCard(
                    //                             subjectname: 'Arabic',
                    //                             grade: instance['grade'],
                    //                             mark: instance['score'],
                    //                             note: instance['note'],
                    //                           );
                    //                         }),
                    //                   );
                    //                 } else {
                    //                   return unannounced(subject: 'Arabic');
                    //                 }
                    //               } else {
                    //                 return unannounced(subject: 'Arabic');
                    //               }
                    //             })
                    //         : defaultCard(subject: 'Arabic')
                    //     : defaultCard(subject: 'Arabic'),
                    // EXAM != null
                    //     ? student_name != null
                    //         ? FutureBuilder(
                    //             future: FirebaseFirestore.instance
                    //                 .collection('grades')
                    //                 .doc('q2t62IWIuT4OFSpqjgnT')
                    //                 .collection(EXAM!)
                    //                 .doc(EXAM!)
                    //                 .collection('french')
                    //                 .where('Student name',
                    //                     isEqualTo: student_name)
                    //                 .get(),
                    //             builder: (context, snapshot) {
                    //               if (snapshot.hasData) {
                    //                 if (snapshot.data!.docs.isNotEmpty) {
                    //                   return SizedBox(
                    //                     height:
                    //                         MediaQuery.of(context).size.height /
                    //                             6,
                    //                     child: ListView.builder(
                    //                         shrinkWrap: true,
                    //                         physics:
                    //                             const NeverScrollableScrollPhysics(),
                    //                         itemCount: 1,
                    //                         itemBuilder: (context, index) {
                    //                           var instance =
                    //                               (snapshot.data as dynamic)
                    //                                   .docs[index];
                    //                           return SubjectCard(
                    //                             subjectname: 'French',
                    //                             grade: instance['grade'],
                    //                             mark: instance['score'],
                    //                             note: instance['note'],
                    //                           );
                    //                         }),
                    //                   );
                    //                 } else {
                    //                   return unannounced(subject: 'French');
                    //                 }
                    //               } else {
                    //                 return unannounced(subject: 'French');
                    //               }
                    //             })
                    //         : defaultCard(subject: 'French')
                    //     : defaultCard(subject: 'French'),
                    // EXAM != null
                    //     ? student_name != null
                    //         ? FutureBuilder(
                    //             future: FirebaseFirestore.instance
                    //                 .collection('grades')
                    //                 .doc('q2t62IWIuT4OFSpqjgnT')
                    //                 .collection(EXAM!)
                    //                 .doc(EXAM!)
                    //                 .collection('science')
                    //                 .where('Student name',
                    //                     isEqualTo: student_name)
                    //                 .get(),
                    //             builder: (context, snapshot) {
                    //               if (snapshot.hasData) {
                    //                 if (snapshot.data!.docs.isNotEmpty) {
                    //                   return SizedBox(
                    //                     height:
                    //                         MediaQuery.of(context).size.height /
                    //                             6,
                    //                     child: ListView.builder(
                    //                         shrinkWrap: true,
                    //                         physics:
                    //                             const NeverScrollableScrollPhysics(),
                    //                         itemCount: 1,
                    //                         itemBuilder: (context, index) {
                    //                           var instance =
                    //                               (snapshot.data as dynamic)
                    //                                   .docs[index];
                    //                           return SubjectCard(
                    //                             subjectname: 'Science',
                    //                             grade: instance['grade'],
                    //                             mark: instance['score'],
                    //                             note: instance['note'],
                    //                           );
                    //                         }),
                    //                   );
                    //                 } else {
                    //                   return unannounced(subject: 'Science');
                    //                 }
                    //               } else {
                    //                 return unannounced(subject: 'Science');
                    //               }
                    //             })
                    //         : defaultCard(subject: 'Science')
                    //     : defaultCard(subject: 'Science'),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('error'),
            );
          }
        }));
  }
}
