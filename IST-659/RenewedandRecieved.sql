CREATE PROCEDURE IsRenewed (@SubscriberID int, @BoxID int) AS
BEGIN
	UPDATE Subscription
	SET Renewed = 1
	WHERE SubscriberID = @SubscriberID AND BoxID = @BoxID
END
GO

CREATE PROCEDURE NotRenewed (@SubscriberID int, @BoxID int) AS
BEGIN
	UPDATE Subscription
	SET Renewed = 0
	WHERE SubscriberID = @SubscriberID AND BoxID = @BoxID
END
GO

CREATE PROCEDURE IsRecieved (@SubscriberID int, @BoxID int) AS
BEGIN
	UPDATE Shipping
	SET PackageRecieved = 1
	WHERE SubscriberID = @SubscriberID AND BoxID = @BoxID
END
GO

CREATE PROCEDURE NotRecieved (@SubscriberID int, @BoxID int) AS
BEGIN
	UPDATE Shipping
	SET PackageRecieved = 0
	WHERE SubscriberID = @SubscriberID AND BoxID = @BoxID
END
GO