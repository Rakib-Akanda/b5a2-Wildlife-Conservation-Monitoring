
# PostgreSQL Basic Concepts

এই ডকুমেন্টিতে PostgreSQL এর কিছু গুরুত্বপূর্ণ কনসেপ্ট সুন্দরভাবে ব্যাখ্যা করা হয়েছে ।

---

## What is PostgreSQL?

PostgreSQL একটি শক্তিশালী, open-source object-relational database management system (ORDBMS)। PostgreSQL SQL language ব্যবহার করে ডেটা manage এবং query করে থাকে। PostgreSQL অনেক advanced feature support করে যেমন:

- ACID compliance (reliable transactions)
- Complex queries
- Foreign keys, joins, views
- Stored procedures
- JSON এবং XML ডেটা টাইপ
- Concurrency control ইত্যাদি

---

## Explain the Primary Key and Foreign Key concepts in PostgreSQL.

### Primary Key:
Primary Key এমন একটি কলাম যা একটি row কে চিহ্নিত করে। এই key এর মান সবসময় unique এবং not null হবে।
মানে  প্রতিটি  value আলাদা আলাদা হবে এবং কখনো খালি থাকতে পারবে না।

**Example:**
```sql
CREATE TABLE students(
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100)
);
```

### Foreign Key:
Foreign Key একটি কলাম যা অন্য একটি টেবিলের Primary Key এর সাথে relation তৈরি করে।
এটি একাধিক টেবিল এর মধ্যে রিলেশনশিপ তৈরি করে। একই ডাটা বার বার থাকতে পারে Null  হতে পারে।


**Example:**
```sql
CREATE TABLE enrollments (
    enroll_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    course_title VARCHAR(250)
);
```
এখানে enrollments টেবিলে student_id  হলো Foreign Key যা students টেবিলের student_id  কে রেফার করতেছে এবং এই দুটি টেবিল এর মধ্যে সম্পর্ক তৈরি করেছে।

---

## What is the difference between the VARCHAR and CHAR data types?
CHAR(n) হলো একটি নির্দিষ্ট length এর  স্ট্রিং ডেটা টাইপ এবং VARCHAR(n) হলো changeable বা পরিবর্তনশীল length এর স্ট্রিং টাইপ। 

## CHAR(n) vs VARCHAR(n)
| বিষয়         | CHAR(n)                         | VARCHAR(n)                                  |
|--------------|---------------------------------- |-------------------------------------------|
| Length       | Fixed length সবসময়               | Variable length                           |
| Storage      | সবসময় n অক্ষরের জায়গা নেয়        | যত অক্ষর ততটাই স্পেস নেয়                  |
| Uses         | কোড, কন্সট্রেইন্ট আইডি (BD, USA)    | নাম, ঠিকানা, ইমেইল ইত্যাদি                  |

---

## Explain the purpose of the WHERE clause in a SELECT statement.
SQL এ  WHERE  clause ব্যবহার করা হয় ডেটা ফিল্টার করতে। যখন একটি টেবিল থেকে ডেটা নিতে চায়, তখন একটি নির্দিষ্ট শর্তে মিল থাকা রেকর্ড বা ডেটা নিতে এই WHERE clause use করা হয়। 


**Example:**
```sql
SELECT * FROM students 
WHERE id = 10;
```

---

## What are the LIMIT and OFFSET clauses used for?

LIMIT এবং OFFSET PostgreSQL এ ব্যবহার করা হয় ডেটা কন্ট্রোল করার জন্য বিশেষ করে অনেক ডেটার মধ্যে একটি নির্দিষ্ট অংশ বের করতে।

- LIMIT  দিয়ে নির্ধারণ করা হয় আমরা কতগুলো রেকর্ড রিটার্ন করতে চাই। শুধু LIMIT প্রথম নির্দিষ্ট ডেটা দিবে। 
- OFFSET দিয়ে নির্ধারণ করা যায় কতগুলো ডেটা Skip করে তার পরের ডেটা দিবে। 
- LIMIT এবং OFFSET Pagination এর জন্য ব্যবহার করা হয়। প্রতিটি পেজ আমরা কতগুলো ডেটা দেখতে চাই তা LIMIT এবং OFFSET একসাথে ব্যবহার করে করতে পারি।

**Examples:**
```sql
-- প্রথম ৫ জন student
SELECT * FROM students LIMIT 5;

-- ৫টি ডেটা skip করে পরেরগুলো
SELECT * FROM students OFFSET 5;

-- Pagination এর জন্য:
SELECT * FROM students LIMIT 5 OFFSET 5 * 0;
SELECT * FROM students LIMIT 5 OFFSET 5 * 1;
SELECT * FROM students LIMIT 5 OFFSET 5 * 2;
/*
ধরি ২০ জন students আছে এই টেবিলে আমারা 
প্রথম পেজে  ডেটা পাবো ১ - ৫ 
দ্বিতীয় পেজে ডেটা পাবো ৬ - ১০ 
তৃতীয় পেজে ডেটা পাবো ১১ - ১৫ 

*/
```

---

## How can you modify data using UPDATE statements?

UPDATE স্টেটমেন্ট SQL-এ ব্যবহার হয় বিদ্যমান ডেটা পরিবর্তনের জন্য। আমরা একটি নির্দিষ্ট row অথবা একাধিক row-এর মান পরিবর্তন করতে পারি ।

**Example:**
```sql
UPDATE students 
SET student_name = 'Rakib Akanda'
WHERE student_id = 1;
```
এখানে আমরা students টেবিলে student_name কালাম এ সেট 
করতেছি  যেখানে student_id = 1

---

## What is the significance of the JOIN operation, and how does it work in PostgresSQL?

JOIN ব্যবহার হয় যখন আমরা একাধিক টেবিলের মধ্যে সম্পর্ক রয়েছে এমন টেবিলের ডেটা একসাথে দেখতে পারি।

## প্রধান কাজ:

1. টেবিল A ও টেবিল B তে থাকা মিল থাকা রেকর্ড গুলো নিয়ে আসে। 
2. একাধিক টেবিল থেকে যুক্ত (combine) করে ডেটা দেখায়। 

**Input Table:**

### students Table

| id | name   |
|----|--------|
| 1  | Rakib  |
| 2  | Shakib |

### results Table

| id | student_id | gpa |
|----|------------|-----|
| 1  | 1          | 3.9 |
| 2  | 2          | 3.5 |


এখন দেখতেচাই যে প্রতিটি student এর name এবং gpa

**Example:**
```sql
SELECT students.name, results.gpa
FROM students
INNER JOIN results
ON students.id = results.student_id;

```


### JOIN এর প্রকারভেদ:

| JOIN টাইপ   | কাজ                                                                 |
|-------------|----------------------------------------------------------------------|
| INNER JOIN  | শুধুমাত্র যাদের মধ্যে মিল আছে                                           |
| LEFT JOIN   | বাম টেবিলের সব রেকর্ড দেখায়, ডান টেবিল  থেকে মিল পাওয়া 
                গেলে যুক্ত করে না পাওয়া গেলে null সেট করে                             |
| RIGHT JOIN  | ডান টেবিলের সব রেকর্ড দেখায়, বাম টেবিল থেকে মিল পাওয়া গেলে যুক্ত 
                করে না পাওয়া গেলে null সেট করে                                      |
| FULL JOIN   | দুই টেবিলের সব রেকর্ডই দেখায়, মিল থাকুক বা না থাকুক                     |

---

## Explain the GROUP BY clause and its role in aggregation operations

GROUP BY ক্লজ SQL-এ ব্যবহৃত হয় ডেটাগুলোর মধ্যে নির্দিষ্ট একটি বা একাধিক কলামের মান অনুযায়ী গ্রুপ তৈরি করতে। 
এর প্রধান উদ্দেশ্য হচ্ছে অ্যাগ্রিগেশন ফাংশন (যেমনঃ SUM(), AVG(), COUNT(), MAX(), MIN() ইত্যাদি) ব্যবহার করে গ্রুপভিত্তিক রেজাল্ট তৈরি করা। 
GROUP BY মানে হচ্ছে একই মান আছে এমন সারিগুলোকে একসাথে গ্রুপ করে ফেলো।

students
| id | name   | department | marks |
|----|--------|------------|-------|
| 1  | Rakib  | CSE        | 85    |
| 2  | Shakib | CSE        | 90    |
| 3  | Abir   | EEE        | 75    |
| 4  | Sabbir | EEE        | 80    |



**Example:**
```sql
SELECT department, AVG(marks) AS avg_marks
FROM students
GROUP BY department;
```
**Output:**

| department | avg_marks |
|------------|-----------|
| CSE        | 87.5      |
| EEE        | 77.5      |


---
