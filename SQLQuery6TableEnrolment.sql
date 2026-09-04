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
