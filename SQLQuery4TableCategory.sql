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