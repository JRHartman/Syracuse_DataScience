ALTER PROCEDURE AddSubscriberWithPayment (
	@FirstName char(20)
	, @MiddleInitial char(1) = NULL
	, @LastName char(20)
	, @Email char(100)
	, @Phone char(10)
	, @ShippingAddress char(100)
	, @ShippingAddress2 char(100) = NULL
	, @ShippingCity char(50)
	, @ShippingState char(2)
	, @ShippingZipCode char(5)
	, @Plan char(7)
	, @CardNumber char(12)
	, @SecurityCode char(4)

) AS
BEGIN
	INSERT INTO Subscriber (
		SubscriberFirstName, SubscriberMiddleInitial, SubscriberLastName,
		Email, PhoneNumber, ShippingAddress, ShippingAddress2,
		 ShippingCity, ShippingState, ShippingZipCode, PlanType
	) VALUES (
		@FirstName, @MiddleInitial, @LastName, @Email, @Phone,
		@ShippingAddress, @ShippingAddress2, @ShippingCity,
		@ShippingState, @ShippingZipCode, @Plan
	)
	
	-- Finds the PK of the newly inserted data to use as FK for 'Payment'

	DECLARE @NewSubscriber int
	SELECT @NewSubscriber = SCOPE_IDENTITY()
	
	--Uses 'Subscriber' data to fill 'Payment' 

	BEGIN
		INSERT INTO Payment (
			BillingFirstName, BillingMiddleInital, BillingLastName,
			BillingAddress, BillingAddress2, BillingCity, BillingState, 
			BillingZipCode, CardNumber, SecurityCode, SubscriberID
		) VALUES (
			@FirstName, @MiddleInitial, @LastName, @ShippingAddress,
			@ShippingAddress2, @ShippingCity, @ShippingZipCode,
			@ShippingState, @CardNumber, @SecurityCode, @NewSubscriber
		)
	END
END