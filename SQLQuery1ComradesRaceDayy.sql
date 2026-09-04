CREATE DATABASE ComradesRaceDay

GO

USE ComradesRaceday;
GO

-- Table: User
--Stores both Organisers and Participants, distinguished by Role.
CREATE TABLE dbo.[User] (
    UserID          INT IDENTITY(1,1) PRIMARY KEY,
    FirstName       NVARCHAR(100)   NOT NULL,
    LastName        NVARCHAR(100)   NOT NULL,
    Email           NVARCHAR(255)   NOT NULL,
    PasswordHash    NVARCHAR(255)   NOT NULL,
    Role            NVARCHAR(20)    NOT NULL,
    PhoneNumber     NVARCHAR(20)    NULL,
    CreatedAt       DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
 
    CONSTRAINT UQ_User_Email UNIQUE (Email),
    CONSTRAINT CK_User_Role CHECK (Role IN ('Organiser', 'Participant'))
);


-- Table: Event
--Created and managed by a User whose Role = 'Organiser'.
CREATE TABLE dbo.Event (
    EventID         INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID     INT             NOT NULL,
    EventName       NVARCHAR(150)   NOT NULL,
    EventDate       DATE            NOT NULL,
    Location        NVARCHAR(255)   NOT NULL,
    Description     NVARCHAR(MAX)   NULL,
    Status          NVARCHAR(20)    NOT NULL DEFAULT 'Draft',
    CreatedAt       DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
 
    CONSTRAINT FK_Event_Organiser FOREIGN KEY (OrganiserID)
        REFERENCES dbo.[User](UserID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
 
    CONSTRAINT CK_Event_Status CHECK (Status IN ('Draft', 'Published', 'Closed'))
);

--Table: Category
--Belongs to exactly one Event (e.g. 5km, 10km, 21km).
CREATE TABLE dbo.Category (
    CategoryID      INT IDENTITY(1,1) PRIMARY KEY,
    EventID         INT             NOT NULL,
    CategoryName    NVARCHAR(100)   NOT NULL,
    DistanceKM      DECIMAL(6,2)    NOT NULL,
    EntryFee        DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    MaxParticipants INT             NOT NULL DEFAULT 0,
 
    CONSTRAINT FK_Category_Event FOREIGN KEY (EventID)
        REFERENCES dbo.Event(EventID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
 
    CONSTRAINT UQ_Category_Per_Event UNIQUE (EventID, CategoryName)
);

--Table: Route
--Belongs to exactly one Event. An Event may have several Routes.

CREATE TABLE dbo.Route (
    RouteID         INT IDENTITY(1,1) PRIMARY KEY,
    EventID         INT             NOT NULL,
    RouteName       NVARCHAR(150)   NOT NULL,
    StartPoint      NVARCHAR(255)   NULL,
    EndPoint        NVARCHAR(255)   NULL,
    MapURL          NVARCHAR(500)   NULL,
    Elevation       NVARCHAR(100)   NULL,
    ForecastSnapshot NVARCHAR(255)  NULL,
 
    CONSTRAINT FK_Route_Event FOREIGN KEY (EventID)
        REFERENCES dbo.Event(EventID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


--Table: Enrolment
--Links a Participant (User) to a Category they entered.

CREATE TABLE dbo.Enrolment (
    EnrolmentID     INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID   INT             NOT NULL,
    CategoryID      INT             NOT NULL,
    EnrolmentDate   DATE            NOT NULL DEFAULT CAST(SYSDATETIME() AS DATE),
    PaymentStatus   NVARCHAR(20)    NOT NULL DEFAULT 'Pending',
    RaceNumber      NVARCHAR(20)    NULL,

    CONSTRAINT FK_Enrolment_Participant FOREIGN KEY (ParticipantID)
        REFERENCES dbo.[User](UserID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    CONSTRAINT FK_Enrolment_Category FOREIGN KEY (CategoryID)
        REFERENCES dbo.Category(CategoryID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    CONSTRAINT UQ_Participant_Category UNIQUE (ParticipantID, CategoryID),
    CONSTRAINT CK_Enrolment_PaymentStatus CHECK (PaymentStatus IN ('Pending', 'Paid', 'Refunded'))
);


--Table: Result
--Optional (0..1) per Enrolment - only exists once captured by the Organiser after race day.
  
 CREATE TABLE dbo.Result (
    ResultsID               INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID             INT             NOT NULL,
    CapturedByOrganiserID   INT             NOT NULL,
    FinishTime              TIME            NULL,
    CategoryPosition        INT             NULL,
    Status                  NVARCHAR(20)    NOT NULL DEFAULT 'Finished',
    CapturedAt              DATETIME2       NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Result_Enrolment FOREIGN KEY (EnrolmentID)
        REFERENCES dbo.Enrolment(EnrolmentID)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,

    CONSTRAINT FK_Result_Organiser FOREIGN KEY (CapturedByOrganiserID)
        REFERENCES dbo.[User](UserID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    CONSTRAINT UQ_Result_Enrolment UNIQUE (EnrolmentID),
    CONSTRAINT CK_Result_Status CHECK (Status IN ('Finished', 'DNF', 'DQ')),
    CONSTRAINT CK_Result_Finish CHECK (
        (Status <> 'Finished') OR (FinishTime IS NOT NULL)
    )
);


INSERT INTO dbo.[User] (FirstName, LastName, Email, PasswordHash, Role, PhoneNumber)
VALUES
    ('Thabo',  'Nkosi',    'thabo.nkosi@raceday.co.za',    'HASH_PLACEHOLDER_1', 'Organiser',   '0821234567'),
    ('Amanda', 'van Wyk',  'amanda.vanwyk@raceday.co.za',  'HASH_PLACEHOLDER_2', 'Organiser',   '0827654321'),
    ('Sipho',  'Dlamini',  'sipho.dlamini@gmail.com',      'HASH_PLACEHOLDER_3', 'Participant', '0731112222'),
    ('Lerato', 'Molefe',   'lerato.molefe@gmail.com',      'HASH_PLACEHOLDER_4', 'Participant', '0739998888');

    -- ---------- Events: 3 events, one per Organiser (Thabo organises 2) ----------
INSERT INTO dbo.Event (OrganiserID, EventName, EventDate, Location, Description, Status)
VALUES
    (1, 'Johannesburg City Half Marathon', '2026-10-18', 'Sandton, Johannesburg',
     'An annual road running event through the streets of Sandton, offering multiple distance categories.', 'Published'),
    (1, 'Soweto Community Fun Run', '2026-11-08', 'Soweto, Johannesburg',
     'A family-friendly community fun run and walk supporting local youth sports development.', 'Published'),
    (2, 'Cape Winelands Cycle Challenge', '2026-09-27', 'Stellenbosch, Western Cape',
     'A scenic road cycling event through the Cape Winelands, with routes for beginners and experienced riders.', 'Published');
GO
 
-- ---------- Categories: at least one per Event ----------
INSERT INTO dbo.Category (EventID, CategoryName, DistanceKM, EntryFee, MaxParticipants)
VALUES
    (1, '5km Fun Run',     5.00,  100.00, 500),
    (1, '10km Race',       10.00, 150.00, 500),
    (1, '21.1km Half Marathon', 21.10, 250.00, 300),
    (2, '3km Family Walk', 3.00,  50.00,  400),
    (2, '5km Fun Run',     5.00,  80.00,  400),
    (3, '40km Cycle Challenge', 40.00, 300.00, 200),
    (3, '80km Cycle Challenge', 80.00, 450.00, 150);
GO
 
-- ---------- Routes: at least one per Event ----------
INSERT INTO dbo.Route (EventID, RouteName, StartPoint, EndPoint, MapURL, Elevation, ForecastSnapshot)
VALUES
    (1, 'Sandton City Loop', 'Sandton City Mall', 'Nelson Mandela Square',
     'https://maps.raceday.co.za/routes/jhb-half', 'Moderate, rolling hills', 'Sunny, 18C at 06:00 start'),
    (2, 'Soweto Heritage Route', 'Orlando Stadium', 'Orlando Stadium',
     'https://maps.raceday.co.za/routes/soweto-fun-run', 'Flat', 'Partly cloudy, 20C at 07:00 start'),
    (3, 'Stellenbosch Winelands Loop', 'Stellenbosch Town Centre', 'Jonkershoek Valley',
     'https://maps.raceday.co.za/routes/winelands-cycle', 'Hilly, significant climbs', 'Clear skies, 15C at 06:30 start');
GO
 
-- ---------- Enrolments: sample entries from both Participants ----------
INSERT INTO dbo.Enrolment (ParticipantID, CategoryID, PaymentStatus, RaceNumber)
VALUES
    (3, 2, 'Paid',    'JHB-1042'),  -- Sipho enters the 10km Race (Event 1)
    (3, 6, 'Paid',    'CWC-0087'),  -- Sipho enters the 40km Cycle Challenge (Event 3)
    (4, 3, 'Paid',    'JHB-2098'),  -- Lerato enters the 21.1km Half Marathon (Event 1)
    (4, 5, 'Pending', 'SOW-0311');  -- Lerato enters the 5km Fun Run (Event 2)
GO
 
-- ---------- Results: captured for two of the four enrolments ----------
INSERT INTO dbo.Result (EnrolmentID, CapturedByOrganiserID, FinishTime, CategoryPosition, Status)
VALUES
    (1, 1, '00:52:14', 34, 'Finished'),  -- Thabo captures Sipho's 10km result
    (3, 1, '01:58:47', 12, 'Finished');  -- Thabo captures Lerato's half marathon result