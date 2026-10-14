// ==============================================================================================
// ALLIANCE UNIVERSITY - ALLIANCE SCHOOL OF ADVANCED COMPUTING
// Course: Graph Analytics (E1ITC302)
// Assignment 5: University Course Registration System Using Neo4j
// Student Name: Kaaysha Rao
// Registration Number: 2411021060775
// ==============================================================================================

// ==============================================================================================
// 0. SCHEMA CONSTRAINTS & CLEANUP (Ensures Idempotency and Prevents Duplicate Entities)
// ==============================================================================================

// Optional: Clear existing graph prior to fresh run
// MATCH (n) DETACH DELETE n;

// Create Unique Constraints on Primary Identifiers (Neo4j 4.x / 5.x)
CREATE CONSTRAINT student_id_unique IF NOT EXISTS FOR (s:Student) REQUIRE s.studentId IS UNIQUE;
CREATE CONSTRAINT faculty_id_unique IF NOT EXISTS FOR (f:Faculty) REQUIRE f.facultyId IS UNIQUE;
CREATE CONSTRAINT course_code_unique IF NOT EXISTS FOR (c:Course) REQUIRE c.courseCode IS UNIQUE;
CREATE CONSTRAINT dept_id_unique IF NOT EXISTS FOR (d:Department) REQUIRE d.deptId IS UNIQUE;

// ==============================================================================================
// PART A: GRAPH CREATION AND VERIFICATION
// ==============================================================================================

// ----------------------------------------------------------------------------------------------
// Task 1: Create all student, faculty, course, and department nodes with the given properties
// ----------------------------------------------------------------------------------------------
// Entities:
// 5 Student nodes: S101, S102, S103, S104, S105
// 2 Faculty nodes: F101, F102
// 5 Course nodes: CS301, CS302, CS303, CS304, CS305
// 2 Department nodes: D101, D102

CREATE
  // Student Nodes
  (s1:Student {studentId: 'S101', name: 'Aarav Sharma', semester: 5, email: 'aarav@univ.edu'}),
  (s2:Student {studentId: 'S102', name: 'Priya Das', semester: 5, email: 'priya@univ.edu'}),
  (s3:Student {studentId: 'S103', name: 'Rahul Verma', semester: 3, email: 'rahul@univ.edu'}),
  (s4:Student {studentId: 'S104', name: 'Sneha Roy', semester: 3, email: 'sneha@univ.edu'}),
  (s5:Student {studentId: 'S105', name: 'Arjun Patel', semester: 5, email: 'arjun@univ.edu'}),

  // Faculty Nodes
  (f1:Faculty {facultyId: 'F101', name: 'Dr. Meera Sen', designation: 'Associate Professor', specialization: 'Database Systems'}),
  (f2:Faculty {facultyId: 'F102', name: 'Dr. Amit Roy', designation: 'Assistant Professor', specialization: 'Data Analytics'}),

  // Course Nodes
  (c1:Course {courseCode: 'CS301', courseTitle: 'Graph Analytics', credits: 3, level: 'Advanced'}),
  (c2:Course {courseCode: 'CS302', courseTitle: 'Database Management Systems', credits: 4, level: 'Core'}),
  (c3:Course {courseCode: 'CS303', courseTitle: 'Data Mining', credits: 3, level: 'Advanced'}),
  (c4:Course {courseCode: 'CS304', courseTitle: 'Big Data Analytics', credits: 4, level: 'Advanced'}),
  (c5:Course {courseCode: 'CS305', courseTitle: 'NoSQL Databases', credits: 3, level: 'Core'}),

  // Department Nodes
  (d1:Department {deptId: 'D101', deptName: 'Computer Science', building: 'Block A'}),
  (d2:Department {deptId: 'D102', deptName: 'Information Technology', building: 'Block B'});

// ----------------------------------------------------------------------------------------------
// Tasks 2 & 3: Create relationships with directions and assign properties
// ----------------------------------------------------------------------------------------------
// Direction & Schema:
// 1. BELONGS_TO: Student -> Department
// 2. OFFERS:     Department -> Course
// 3. TEACHES:    Faculty -> Course               [Property: academicYear: '2026-27']
// 4. ENROLLED_IN: Student -> Course              [Properties: semesterEnrolled: 3 or 5, grade: 'Not Published']

// 1. BELONGS_TO (Student -> Department)
MATCH (s:Student {studentId: 'S101'}), (d:Department {deptId: 'D101'}) CREATE (s)-[:BELONGS_TO]->(d);
MATCH (s:Student {studentId: 'S102'}), (d:Department {deptId: 'D101'}) CREATE (s)-[:BELONGS_TO]->(d);
MATCH (s:Student {studentId: 'S103'}), (d:Department {deptId: 'D101'}) CREATE (s)-[:BELONGS_TO]->(d);
MATCH (s:Student {studentId: 'S104'}), (d:Department {deptId: 'D102'}) CREATE (s)-[:BELONGS_TO]->(d);
MATCH (s:Student {studentId: 'S105'}), (d:Department {deptId: 'D102'}) CREATE (s)-[:BELONGS_TO]->(d);

// 2. OFFERS (Department -> Course)
MATCH (d:Department {deptId: 'D101'}), (c:Course {courseCode: 'CS302'}) CREATE (d)-[:OFFERS]->(c);
MATCH (d:Department {deptId: 'D101'}), (c:Course {courseCode: 'CS303'}) CREATE (d)-[:OFFERS]->(c);
MATCH (d:Department {deptId: 'D101'}), (c:Course {courseCode: 'CS305'}) CREATE (d)-[:OFFERS]->(c);
MATCH (d:Department {deptId: 'D102'}), (c:Course {courseCode: 'CS301'}) CREATE (d)-[:OFFERS]->(c);
MATCH (d:Department {deptId: 'D102'}), (c:Course {courseCode: 'CS304'}) CREATE (d)-[:OFFERS]->(c);

// 3. TEACHES (Faculty -> Course) with property: academicYear
MATCH (f:Faculty {facultyId: 'F101'}), (c:Course {courseCode: 'CS302'}) CREATE (f)-[:TEACHES {academicYear: '2026-27'}]->(c);
MATCH (f:Faculty {facultyId: 'F101'}), (c:Course {courseCode: 'CS305'}) CREATE (f)-[:TEACHES {academicYear: '2026-27'}]->(c);
MATCH (f:Faculty {facultyId: 'F102'}), (c:Course {courseCode: 'CS301'}) CREATE (f)-[:TEACHES {academicYear: '2026-27'}]->(c);
MATCH (f:Faculty {facultyId: 'F102'}), (c:Course {courseCode: 'CS303'}) CREATE (f)-[:TEACHES {academicYear: '2026-27'}]->(c);
MATCH (f:Faculty {facultyId: 'F102'}), (c:Course {courseCode: 'CS304'}) CREATE (f)-[:TEACHES {academicYear: '2026-27'}]->(c);

// 4. ENROLLED_IN (Student -> Course) with properties: semesterEnrolled, grade
MATCH (s:Student {studentId: 'S101'}), (c:Course {courseCode: 'CS301'}) CREATE (s)-[:ENROLLED_IN {semesterEnrolled: 5, grade: 'Not Published'}]->(c);
MATCH (s:Student {studentId: 'S101'}), (c:Course {courseCode: 'CS302'}) CREATE (s)-[:ENROLLED_IN {semesterEnrolled: 5, grade: 'Not Published'}]->(c);
MATCH (s:Student {studentId: 'S101'}), (c:Course {courseCode: 'CS305'}) CREATE (s)-[:ENROLLED_IN {semesterEnrolled: 5, grade: 'Not Published'}]->(c);

MATCH (s:Student {studentId: 'S102'}), (c:Course {courseCode: 'CS301'}) CREATE (s)-[:ENROLLED_IN {semesterEnrolled: 5, grade: 'Not Published'}]->(c);
MATCH (s:Student {studentId: 'S102'}), (c:Course {courseCode: 'CS303'}) CREATE (s)-[:ENROLLED_IN {semesterEnrolled: 5, grade: 'Not Published'}]->(c);

MATCH (s:Student {studentId: 'S103'}), (c:Course {courseCode: 'CS302'}) CREATE (s)-[:ENROLLED_IN {semesterEnrolled: 3, grade: 'Not Published'}]->(c);
MATCH (s:Student {studentId: 'S103'}), (c:Course {courseCode: 'CS304'}) CREATE (s)-[:ENROLLED_IN {semesterEnrolled: 3, grade: 'Not Published'}]->(c);

MATCH (s:Student {studentId: 'S104'}), (c:Course {courseCode: 'CS303'}) CREATE (s)-[:ENROLLED_IN {semesterEnrolled: 3, grade: 'Not Published'}]->(c);
MATCH (s:Student {studentId: 'S104'}), (c:Course {courseCode: 'CS305'}) CREATE (s)-[:ENROLLED_IN {semesterEnrolled: 3, grade: 'Not Published'}]->(c);

MATCH (s:Student {studentId: 'S105'}), (c:Course {courseCode: 'CS301'}) CREATE (s)-[:ENROLLED_IN {semesterEnrolled: 5, grade: 'Not Published'}]->(c);
MATCH (s:Student {studentId: 'S105'}), (c:Course {courseCode: 'CS304'}) CREATE (s)-[:ENROLLED_IN {semesterEnrolled: 5, grade: 'Not Published'}]->(c);

// ----------------------------------------------------------------------------------------------
// Alternative Idempotent Ingestion using MERGE (Can be re-run indefinitely without duplicate nodes/edges):
// ----------------------------------------------------------------------------------------------
/*
MERGE (s1:Student {studentId: 'S101'}) ON CREATE SET s1.name = 'Aarav Sharma', s1.semester = 5, s1.email = 'aarav@univ.edu';
MERGE (s2:Student {studentId: 'S102'}) ON CREATE SET s2.name = 'Priya Das', s2.semester = 5, s2.email = 'priya@univ.edu';
MERGE (s3:Student {studentId: 'S103'}) ON CREATE SET s3.name = 'Rahul Verma', s3.semester = 3, s3.email = 'rahul@univ.edu';
MERGE (s4:Student {studentId: 'S104'}) ON CREATE SET s4.name = 'Sneha Roy', s4.semester = 3, s4.email = 'sneha@univ.edu';
MERGE (s5:Student {studentId: 'S105'}) ON CREATE SET s5.name = 'Arjun Patel', s5.semester = 5, s5.email = 'arjun@univ.edu';

MERGE (f1:Faculty {facultyId: 'F101'}) ON CREATE SET f1.name = 'Dr. Meera Sen', f1.designation = 'Associate Professor', f1.specialization = 'Database Systems';
MERGE (f2:Faculty {facultyId: 'F102'}) ON CREATE SET f2.name = 'Dr. Amit Roy', f2.designation = 'Assistant Professor', f2.specialization = 'Data Analytics';

MERGE (c1:Course {courseCode: 'CS301'}) ON CREATE SET c1.courseTitle = 'Graph Analytics', c1.credits = 3, c1.level = 'Advanced';
MERGE (c2:Course {courseCode: 'CS302'}) ON CREATE SET c2.courseTitle = 'Database Management Systems', c2.credits = 4, c2.level = 'Core';
MERGE (c3:Course {courseCode: 'CS303'}) ON CREATE SET c3.courseTitle = 'Data Mining', c3.credits = 3, c3.level = 'Advanced';
MERGE (c4:Course {courseCode: 'CS304'}) ON CREATE SET c4.courseTitle = 'Big Data Analytics', c4.credits = 4, c4.level = 'Advanced';
MERGE (c5:Course {courseCode: 'CS305'}) ON CREATE SET c5.courseTitle = 'NoSQL Databases', c5.credits = 3, c5.level = 'Core';

MERGE (d1:Department {deptId: 'D101'}) ON CREATE SET d1.deptName = 'Computer Science', d1.building = 'Block A';
MERGE (d2:Department {deptId: 'D102'}) ON CREATE SET d2.deptName = 'Information Technology', d2.building = 'Block B';

// Example idempotent relationship:
// MATCH (s:Student {studentId: 'S101'}), (c:Course {courseCode: 'CS301'})
// MERGE (s)-[r:ENROLLED_IN]->(c)
// ON CREATE SET r.semesterEnrolled = 5, r.grade = 'Not Published';
*/

// ----------------------------------------------------------------------------------------------
// Task 4: Display the complete graph
// ----------------------------------------------------------------------------------------------
MATCH (n)-[r]->(m)
RETURN n, r, m;

// ----------------------------------------------------------------------------------------------
// Task 5: Count the number of nodes belonging to each label
// ----------------------------------------------------------------------------------------------
MATCH (n)
RETURN labels(n)[0] AS Label, count(n) AS NodeCount
ORDER BY NodeCount DESC;

// ----------------------------------------------------------------------------------------------
// Task 6: Display all relationship types and verify their directions
// ----------------------------------------------------------------------------------------------
MATCH (a)-[r]->(b)
RETURN DISTINCT type(r) AS RelationshipType,
       labels(a)[0] AS FromNode,
       labels(b)[0] AS ToNode,
       count(r) AS Count
ORDER BY RelationshipType;


// ==============================================================================================
// PART B: RETRIEVAL AND FILTERING QUERIES
// ==============================================================================================

// ----------------------------------------------------------------------------------------------
// Task 7: Retrieve all students studying in Semester 5
// ----------------------------------------------------------------------------------------------
MATCH (s:Student)
WHERE s.semester = 5
RETURN s.studentId AS StudentID,
       s.name AS Name,
       s.semester AS Semester,
       s.email AS Email
ORDER BY s.studentId;

// ----------------------------------------------------------------------------------------------
// Task 8: Find all courses with more than 3 credits
// ----------------------------------------------------------------------------------------------
MATCH (c:Course)
WHERE c.credits > 3
RETURN c.courseCode AS CourseCode,
       c.courseTitle AS CourseTitle,
       c.credits AS Credits,
       c.level AS Level;

// ----------------------------------------------------------------------------------------------
// Task 9: Retrieve the courses taught by Dr. Meera Sen
// ----------------------------------------------------------------------------------------------
MATCH (f:Faculty {name: 'Dr. Meera Sen'})-[:TEACHES]->(c:Course)
RETURN f.name AS FacultyName,
       c.courseCode AS CourseCode,
       c.courseTitle AS CourseTitle,
       c.credits AS Credits;

// ----------------------------------------------------------------------------------------------
// Task 10: Find all students enrolled in Graph Analytics
// ----------------------------------------------------------------------------------------------
MATCH (s:Student)-[:ENROLLED_IN]->(c:Course {courseTitle: 'Graph Analytics'})
RETURN s.studentId AS StudentID,
       s.name AS Name,
       s.semester AS Semester,
       c.courseTitle AS EnrolledCourse;

// ----------------------------------------------------------------------------------------------
// Task 11: Display the names of all students belonging to the Computer Science department
// ----------------------------------------------------------------------------------------------
MATCH (s:Student)-[:BELONGS_TO]->(d:Department {deptName: 'Computer Science'})
RETURN s.studentId AS StudentID,
       s.name AS StudentName,
       d.deptName AS Department;

// ----------------------------------------------------------------------------------------------
// Task 12: Find all courses offered by the Information Technology department
// ----------------------------------------------------------------------------------------------
MATCH (d:Department {deptName: 'Information Technology'})-[:OFFERS]->(c:Course)
RETURN d.deptName AS Department,
       c.courseCode AS CourseCode,
       c.courseTitle AS CourseTitle,
       c.credits AS Credits,
       c.level AS Level;

// ----------------------------------------------------------------------------------------------
// Task 13: Retrieve all students enrolled in NoSQL Databases along with their semester and grade
// ----------------------------------------------------------------------------------------------
MATCH (s:Student)-[r:ENROLLED_IN]->(c:Course {courseTitle: 'NoSQL Databases'})
RETURN s.studentId AS StudentID,
       s.name AS Name,
       r.semesterEnrolled AS SemesterEnrolled,
       r.grade AS Grade,
       c.courseTitle AS Course;

// ----------------------------------------------------------------------------------------------
// Task 14: Find all students enrolled in both Graph Analytics and another course
// ----------------------------------------------------------------------------------------------
MATCH (s:Student)-[:ENROLLED_IN]->(c1:Course {courseTitle: 'Graph Analytics'}),
      (s)-[:ENROLLED_IN]->(c2:Course)
WHERE c1 <> c2
RETURN s.studentId AS StudentID,
       s.name AS StudentName,
       c2.courseCode AS OtherCourseCode,
       c2.courseTitle AS OtherCourseTitle
ORDER BY s.studentId, c2.courseCode;

// Alternative aggregation query grouping complementary courses per student:
// MATCH (s:Student)-[:ENROLLED_IN]->(c1:Course {courseTitle: 'Graph Analytics'}),
//       (s)-[:ENROLLED_IN]->(c2:Course)
// WHERE c1 <> c2
// RETURN s.studentId AS StudentID,
//        s.name AS StudentName,
//        collect(c2.courseTitle) AS ComplementaryCourses
// ORDER BY s.studentId;
