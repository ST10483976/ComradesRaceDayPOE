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