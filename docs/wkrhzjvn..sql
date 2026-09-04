
-- Create the database
CREATE DATABASE RaceDay;

-- Create Users table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(200) NOT NULL,
    [Role] NVARCHAR(50) NOT NULL DEFAULT 'Participant' CHECK ([Role] IN ('Organiser', 'Participant')),
    PhoneNumber NVARCHAR(20),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);


-- Create Events table
CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    EventName NVARCHAR(200) NOT NULL,
    [Description] NVARCHAR(MAX),
    EventDate DATETIME NOT NULL,
    [Location] NVARCHAR(500) NOT NULL,
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'Open' CHECK ([Status] IN ('Open', 'Closed', 'Cancelled')),
    MaxParticipants INT NOT NULL DEFAULT 50 CHECK (MaxParticipants >= 1),
    RegistrationDeadline DATETIME NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Organiser FOREIGN KEY (OrganiserID) REFERENCES Users(UserID)
);

-- Create Categories table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(MAX),
    EntryFee DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (EntryFee >= 0),
    CONSTRAINT FK_Categories_Event FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);


-- Create EventEnrolments table
CREATE TABLE EventEnrolments (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME NOT NULL DEFAULT GETDATE(),
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'Pending' CHECK ([Status] IN ('Pending', 'Confirmed', 'Cancelled')),
    AmountPaid DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (AmountPaid >= 0),
    PaymentStatus NVARCHAR(50) NOT NULL DEFAULT 'Unpaid' CHECK (PaymentStatus IN ('Paid', 'Unpaid')),
    CONSTRAINT FK_Enrolments_User FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Enrolments_Event FOREIGN KEY (EventID) REFERENCES Events(EventID),
    CONSTRAINT FK_Enrolments_Category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT UQ_Enrolment_UserEventCategory UNIQUE (UserID, EventID, CategoryID)
);


-- Create Results table
CREATE TABLE Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL,
    UserID INT NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    FinishTime TIME,
    [Position] INT,
    ResultStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending' CHECK (ResultStatus IN ('Pending', 'Completed', 'DNF', 'Disqualified')),
    [Notes] NVARCHAR(MAX),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Results_Enrolment FOREIGN KEY (EnrolmentID) REFERENCES EventEnrolments(EnrolmentID),
    CONSTRAINT FK_Results_User FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Results_Event FOREIGN KEY (EventID) REFERENCES Events(EventID),
    CONSTRAINT FK_Results_Category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT UQ_Results_Enrolment UNIQUE (EnrolmentID)
);


-- Create indexes for performance
CREATE INDEX IX_Events_OrganiserID ON Events(OrganiserID);

CREATE INDEX IX_Categories_EventID ON Categories(EventID);

CREATE INDEX IX_EventEnrolments_UserID ON EventEnrolments(UserID);

CREATE INDEX IX_EventEnrolments_EventID ON EventEnrolments(EventID);

CREATE INDEX IX_EventEnrolments_CategoryID ON EventEnrolments(CategoryID);

CREATE INDEX IX_Results_UserID ON Results(UserID);

CREATE INDEX IX_Results_EventID ON Results(EventID);

CREATE INDEX IX_Results_CategoryID ON Results(CategoryID);

CREATE INDEX IX_Results_EnrolmentID ON Results(EnrolmentID);

-- This ensures all variables are in scope
INSERT INTO Users (Email, PasswordHash, FullName, [Role], PhoneNumber)
VALUES 
('organiser1@raceday.com', '$2y$10$hashvalue1', 'John Organiser', 'Organiser', '+1234567890'),
('organiser2@raceday.com', '$2y$10$hashvalue2', 'Jane Organiser', 'Organiser', '+9876543210'),
('participant1@raceday.com', '$2y$10$hashvalue3', 'Alex Participant', 'Participant', '+1122334455'),
('participant2@raceday.com', '$2y$10$hashvalue4', 'Taylor Participant', 'Participant', '+5544332211');

-- Declare variables for IDs
DECLARE @Organiser1ID INT, @Organiser2ID INT;
DECLARE @Participant1ID INT, @Participant2ID INT;
DECLARE @Event1ID INT, @Event2ID INT, @Event3ID INT;
DECLARE @Category1ID INT, @Category2ID INT, @Category4ID INT, @Category6ID INT;
DECLARE @Enrolment1ID INT, @Enrolment2ID INT, @Enrolment3ID INT;

-- Get User IDs
SELECT @Organiser1ID = UserID FROM Users WHERE Email = 'organiser1@raceday.com';
SELECT @Organiser2ID = UserID FROM Users WHERE Email = 'organiser2@raceday.com';
SELECT @Participant1ID = UserID FROM Users WHERE Email = 'participant1@raceday.com';
SELECT @Participant2ID = UserID FROM Users WHERE Email = 'participant2@raceday.com';

-- Insert Events
INSERT INTO Events (OrganiserID, EventName, [Description], EventDate, [Location], [Status], MaxParticipants, RegistrationDeadline)
VALUES 
(@Organiser1ID, 'Marathon 2026', 'Annual marathon event with multiple categories', '2026-12-01 08:00:00', 'Central Park, New York', 'Open', 100, '2026-11-15 23:59:59'),
(@Organiser1ID, 'Trail Running Championship', 'Cross-country trail running championship', '2026-11-15 07:30:00', 'Rocky Mountains, Colorado', 'Open', 80, '2026-11-01 23:59:59'),
(@Organiser2ID, 'Charity Fun Run', '5K charity run for cancer awareness', '2026-10-20 09:00:00', 'City Center Park, London', 'Open', 200, '2026-10-10 23:59:59');

-- Get Event IDs
SELECT @Event1ID = EventID FROM Events WHERE EventName = 'Marathon 2026';
SELECT @Event2ID = EventID FROM Events WHERE EventName = 'Trail Running Championship';
SELECT @Event3ID = EventID FROM Events WHERE EventName = 'Charity Fun Run';

-- Insert Categories for Event 1
INSERT INTO Categories (EventID, CategoryName, [Description], EntryFee)
VALUES 
(@Event1ID, 'Full Marathon', '42.195 km full marathon', 75.00),
(@Event1ID, 'Half Marathon', '21.0975 km half marathon', 45.00),
(@Event1ID, 'Relay', 'Team relay category (4 members)', 120.00);

-- Insert Categories for Event 2
INSERT INTO Categories (EventID, CategoryName, [Description], EntryFee)
VALUES 
(@Event2ID, 'Elite', 'Competitive category for professional runners', 60.00),
(@Event2ID, 'Amateur', 'For amateur trail runners', 35.00);

-- Insert Categories for Event 3
INSERT INTO Categories (EventID, CategoryName, [Description], EntryFee)
VALUES 
(@Event3ID, 'Adult', 'For participants 18 and over', 15.00),
(@Event3ID, 'Youth', 'For participants under 18', 10.00);

-- Get Category IDs
SELECT @Category1ID = CategoryID FROM Categories WHERE CategoryName = 'Full Marathon' AND EventID = @Event1ID;
SELECT @Category2ID = CategoryID FROM Categories WHERE CategoryName = 'Half Marathon' AND EventID = @Event1ID;
SELECT @Category4ID = CategoryID FROM Categories WHERE CategoryName = 'Elite' AND EventID = @Event2ID;
SELECT @Category6ID = CategoryID FROM Categories WHERE CategoryName = 'Adult' AND EventID = @Event3ID;

-- Insert Event Enrolments
INSERT INTO EventEnrolments (UserID, EventID, CategoryID, EnrolmentDate, [Status], AmountPaid, PaymentStatus)
VALUES 
(@Participant1ID, @Event1ID, @Category1ID, DATEADD(day, -5, GETDATE()), 'Confirmed', 75.00, 'Paid'),
(@Participant2ID, @Event1ID, @Category2ID, DATEADD(day, -3, GETDATE()), 'Pending', 45.00, 'Unpaid'),
(@Participant1ID, @Event2ID, @Category4ID, DATEADD(day, -7, GETDATE()), 'Confirmed', 60.00, 'Paid'),
(@Participant2ID, @Event3ID, @Category6ID, DATEADD(day, -2, GETDATE()), 'Pending', 15.00, 'Unpaid');

-- Get Enrolment IDs
SELECT @Enrolment1ID = EnrolmentID FROM EventEnrolments 
WHERE UserID = @Participant1ID AND EventID = @Event1ID AND CategoryID = @Category1ID;

SELECT @Enrolment2ID = EnrolmentID FROM EventEnrolments 
WHERE UserID = @Participant2ID AND EventID = @Event1ID AND CategoryID = @Category2ID;

SELECT @Enrolment3ID = EnrolmentID FROM EventEnrolments 
WHERE UserID = @Participant1ID AND EventID = @Event2ID AND CategoryID = @Category4ID;

-- Insert Results
INSERT INTO Results (EnrolmentID, UserID, EventID, CategoryID, FinishTime, [Position], ResultStatus, [Notes])
VALUES 
(@Enrolment1ID, @Participant1ID, @Event1ID, @Category1ID, '03:45:30', 45, 'Completed', 'Personal best time'),
(@Enrolment2ID, @Participant2ID, @Event1ID, @Category2ID, '01:45:15', 12, 'Completed', 'Strong finish'),
(@Enrolment3ID, @Participant1ID, @Event2ID, @Category4ID, '02:30:45', 8, 'Completed', 'Placed in top 10');

-- Verification queries
SELECT 'Users Count:' AS Info, COUNT(*) AS Count FROM Users;
SELECT 'Events Count:' AS Info, COUNT(*) AS Count FROM Events;
SELECT 'Categories Count:' AS Info, COUNT(*) AS Count FROM Categories;
SELECT 'Enrolments Count:' AS Info, COUNT(*) AS Count FROM EventEnrolments;
SELECT 'Results Count:' AS Info, COUNT(*) AS Count FROM Results;

PRINT 'RaceDay database created and populated successfully!';
