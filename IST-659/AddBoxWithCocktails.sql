CREATE PROCEDURE AddBoxWithCocktails (
	@name char(50)
	, @description char(5000)
	, @theme char(100)
	, @cocktailone char(50)
	, @cocktailtwo char(50)
	, @cocktailthree char(50)
	, @servings decimal(1,0)
	, @instructionone char(5000)
	, @instructiontwo char(5000)
	, @instructionthree char(5000)
) AS
BEGIN
	INSERT INTO Box (BoxName, BoxDescription)
	VALUES (@name, @description)

	DECLARE @NewBox int
	SELECT @NewBox = SCOPE_IDENTITY()

	--Inserts Themes into BoxTheme, uses @NewBox as FK

	INSERT INTO BoxTheme (Theme, BoxID)
	VALUES (@theme, @NewBox)

	--Inserts Cocktails into Box using @NewBox as FK

	INSERT INTO Cocktail (CocktailName, NumberServing, Instruction, BoxID)
	VALUES (@cocktailone, @servings, @instructionone, @NewBox)

	INSERT INTO Cocktail (CocktailName, NumberServing, Instruction, BoxID)
	VALUES (@cocktailtwo, @servings, @instructiontwo, @NewBox)

	INSERT INTO Cocktail (CocktailName, NumberServing, Instruction, BoxID)
	Values (@cocktailthree, @servings, @instructionthree, @NewBox)
END