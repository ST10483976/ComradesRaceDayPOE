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