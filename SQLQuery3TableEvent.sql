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