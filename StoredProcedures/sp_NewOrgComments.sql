USE [StudentOrgs]
GO

/****** Object:  StoredProcedure [dbo].[sp_NewOrgComments]    Script Date: 02/08/2013 09:54:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_NewOrgComments]
	-- Add the parameters for the stored procedure here
	@Organization_ID int, 
	@Date datetime, 
	@Text text
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Insert INTO OrgComments (Date,Text,Organization_ID)
	VALUES (@Date,@Text,@Organization_ID)
	
	if @@ERROR<>0
		BEGIN 
		raiserror('102',16,1)
		return -102;
		END
		
	else return 0;
END 


GO

