​IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CocktailType')
BEGIN
DROP TABLE CocktailType
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Ingredient')
BEGIN
DROP TABLE Ingredient
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Cocktail')
BEGIN
DROP TABLE Cocktail
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BoxTheme')
BEGIN
DROP TABLE BoxTheme
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Shipping')
BEGIN
DROP TABLE Shipping
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Subscription')
BEGIN
DROP TABLE Subscription
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Box')
BEGIN
DROP TABLE Box
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Payment')
BEGIN
DROP TABLE Payment
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Subscriber')
BEGIN
DROP TABLE Subscriber
END

CREATE TABLE Subscriber (
	SubscriberID int IDENTITY PRIMARY KEY
	, SubscriberFirstName char(20) NOT NULL
	, SubscriberMiddleInitial char(1)
	, SubscriberLastName char(20) NOT NULL
	, Email char(100) NOT NULL
	, PhoneNumber char(10) NOT NULL
	, ShippingAddress char(100) NOT NULL
	, ShippingAddress2 char(100)
	, ShippingCity char(50) NOT NULL
	, ShippingState char(2) NOT NULL
	, ShippingZipCode char(5) NOT NULL
	, PlanType char(7) NOT NULL
)
GO

CREATE TABLE Payment (
	PaymentID int IDENTITY PRIMARY KEY
	,BillingFirstName char(20) NOT NULL
	, BillingMiddleInital char(1)
	, BillingLastName char(20) NOT NULL
	, CardNumber char(12) NOT NULL
	, SecurityCode char(4) NOT NULL
	, BillingAddress char(100) NOT NULL
	, BillingAddress2 char(100)
	, BillingCity char(50) NOT NULL
	, BillingState char(20) NOT NULL
	, BillingZipCode char(5) NOT NULL
	, SubscriberID int NOT NULL FOREIGN KEY REFERENCES Subscriber(SubscriberID)
)
GO

CREATE TABLE Box (
	BoxID int IDENTITY PRIMARY KEY
	, BoxName char(50) NOT NULL
	, BoxDescription char(5000) NOT NULL
)
GO

CREATE TABLE Subscription(
	SubscriptionID int IDENTITY PRIMARY KEY
	, SubscriptionStartDate datetime NOT NULL
	, SubscriptionEndDate datetime NOT NULL
	, Renewed bit NOT NULL
	, SubscriberID int NOT NULL FOREIGN KEY REFERENCES Subscriber(SubscriberID)
	, BoxID int NOT NULL FOREIGN KEY REFERENCES Box(BoxID)
)
GO

CREATE TABLE Shipping(
	ShippingID int IDENTITY PRIMARY KEY
	, ShippingDate datetime NOT NULL
	, TrackingNumber char(15) NOT NULL
	, PackageRecieved bit NOT NULL
	, SubscriberID int NOT NULL FOREIGN KEY REFERENCES Subscriber(SubscriberID)
	, BoxID int NOT NULL FOREIGN KEY REFERENCES Box(BoxID)
)
GO

CREATE TABLE BoxTheme (
	BoxThemeID int IDENTITY PRIMARY KEY
	, Theme char(100) NOT NULL
	, BoxID int NOT NULL FOREIGN KEY REFERENCES Box(BoxID)
)
GO

CREATE TABLE Cocktail (
	CocktailID int IDENTITY PRIMARY KEY
	, CocktailName char(50) NOT NULL
	, NumberServing decimal(1,0) NOT NULL
	, Instruction char(5000) NOT NULL
	, BoxID int NOT NULL FOREIGN KEY REFERENCES Box(BoxID)
)
GO

CREATE TABLE Ingredient (
	IngredientID int IDENTITY PRIMARY KEY
	, IngredientName char(50) NOT NULL
	, IngredientType char(20) NOT NULL
	, IngredientAmount decimal(12,3) NOT NULL
	, IngredientUnit char(5) NOT NULL
	, CocktailID int NOT NULL FOREIGN KEY REFERENCES Cocktail(CocktailID)
)
GO

CREATE TABLE CocktailType (
	CocktailTypeID int IDENTITY PRIMARY KEY
	, CocktailType char(50) NOT NULL
	, CocktailID int NOT NULL FOREIGN KEY REFERENCES Cocktail(CocktailID)
)
GO