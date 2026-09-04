RaceDay Event Management System
Project Description

RaceDay is a web-based event management system designed for the South African road running, walking, and cycling community. The platform supports two types of users: Organisers, who create and manage events, and Participants, who browse events, enter them, and track their own results.

This repository contains Part 1 of the RaceDay Portfolio of Evidence (PoE) for PROG6212 — the system planning and database design stage. Part 1 focuses on the Entity Relationship Diagram, the API Endpoint Plan, and the SQL database script that will form the foundation for the API and MVC application built in Parts 2 and 3.

User Roles
Organiser
Create, edit, and delete events.
Manage event categories.
View enrolments for events they manage.
Capture participant results.
Participant
Create an account and log in.
Browse available events.
Enter an event and select a category.
View their own enrolments.
Track their own race results and performance history.
Part 1 Deliverables
Deliverable	File
Entity Relationship Diagram	docs/FinalERd.png
API Endpoint Plan	docs/PROG6212RamsA1.pdf
SQL Database Script	docs/SQLQuery1ComradesRaceDayy.sql
Entity Relationship Diagram

The ERD defines six entities — User, Event, Category, Route, Enrolment, and Result — along with their attributes, primary keys, foreign keys, and relationship cardinality. The User entity represents both Organisers and Participants, distinguished by a Role field. The Enrolment entity resolves the many-to-many relationship between Participants and Categories.

API Endpoint Plan

The endpoint plan defines the RESTful API that will be implemented in Part 2, covering Authentication, User Profile, Events, Categories, Event Enrolments, and Results. Each endpoint specifies its HTTP method, route, description, required role, request body, and expected response codes.

SQL Database Script

The SQL script is written for Microsoft SQL Server (SSMS) and creates the ComradesRaceday database from scratch, including all six tables, primary and foreign key constraints, check constraints, indexes, and realistic seed data (2 Organisers, 2 Participants, 3 Events, categories per event, routes, and sample enrolments and results).

Repository Structure
ComradesRaceDayPOE/
├── README.md
├── docs/
│   ├── FinalERd.png
│   ├── PROG6212RamsA1.pdf
│   └── SQLQuery1ComradesRaceDayy.sql
└── .github/
    └── workflows/
        └── part1-ci.yml

The /docs folder contains all three core Part 1 planning documents. The .github/workflows folder contains the GitHub Actions workflow used to validate that the required files are present.

Database Setup

To run the database locally:

Open SQL Server Management Studio (SSMS) and connect to your SQL Server instance.
Open a new query window.
Open docs/SQLQuery1ComradesRaceDayy.sql.
Execute the entire script (F5). This will:
Drop and recreate the ComradesRaceday database if it already exists.
Create all six tables with their constraints and indexes.
Insert the seed data.
Confirm the tables and data were created successfully by expanding the database in Object Explorer, or by running SELECT * FROM queries against each table.
CI/CD

This repository uses a GitHub Actions workflow (.github/workflows/part1-ci.yml) that runs automatically on every push and pull request. It verifies that the required Part 1 documentation files exist in the correct locations:

/docs folder is present.
ERD file exists.
API Endpoint Plan exists.
SQL Database Script exists and is not empty.
README.md exists.
