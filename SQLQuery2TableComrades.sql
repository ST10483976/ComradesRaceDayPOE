
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
SELECT * FROM dbo.[User];
SELECT * FROM dbo.Event;
SELECT * FROM dbo.Category;
SELECT * FROM dbo.Route;
SELECT * FROM dbo.Enrolment;
SELECT * FROM dbo.Result;
