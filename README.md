Forte Books & Tuition Hub Management System 📚

A full-stack web management system built for a tuition and book rental business covering everything from student registration to fee collection, with role-based access for admins, tutors, and students.

🔗 Live demo: fortebooks.somee.com/Login

Overview

Forte Books & Tuition Hub was built as a University of Fort Hare assignment to solve a real operational problem: managing students, tutors, book rentals, and payments in one place instead of scattered spreadsheets. It's styled in UFH corporate colours and deployed live on Somee.com.

Features

👥 Student registration-capture and manage student records

🧑‍🏫 Tutor scheduling-assign and manage tutor timetables

📖 Book rentals-track rentals with automatic overdue fine calculation

💳 Fee payments-record and manage student fee payments

🔐 Role-based authentication-separate access levels for Admin, Tutor, and Student

📊 Reports with CSV export-generate and export business reports

🌗 Dark / light mode theming-user-selectable interface theme

📐 Sidebar navigation-vertical nav for easy access across modules

Tech Stack
Layer	Technology
Framework	ASP.NET Web Forms
Data Access	ADO.NET
Database	SQL Server Express
Hosting	Somee.com
Deployment	Visual Studio folder-publish + FTP, via Git/GitHub
Screenshots


Getting Started

Prerequisites

Visual Studio 2022 (with ASP.NET web development workload)

.NET Framework (Web Forms)

SQL Server Express (or full SQL Server)

Installation

bash

git clone https://github.com/MihlaliMandoyi-hub/ForteBooksTuitionHub.git

cd ForteBooksTuitionHub

Open the solution in Visual Studio.

Update the connection string in Web.config to point to your local SQL Server instance.

Run the included SQL scripts (if provided) to set up the database schema.

Build and run (F5) or publish via FTP to your own host, as done here with Somee.com.
Roles & Access

Role	Access

Admin	Full access - manage students, tutors, payments, reports

Tutor	View schedules, manage assigned students

Student	View own records, rentals, and payments

Why This Project

Built to practice full-stack development on the .NET stack from database design in SQL Server through to a deployed, publicly accessible system - while solving a genuine small-business management problem with multiple user roles and real business logic (fines, payments, reporting).

Author

Mihlali - BCom Information Systems student, University of Fort Hare

License

This project was developed for academic purposes as part of a UFH coursework assignment.
