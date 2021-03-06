USE [StudentOrgs]
GO
/****** Object:  Trigger [dbo].[tIUD_Incident]    Script Date: 02/08/2013 14:43:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Trigger [dbo].[tIUD_Incident]
   On [dbo].[Incident]
   for Insert, Update, Delete
   Not for Replication
As
Begin
/**********************************************************
*Trigger Name: tIUD_Incident

select * from tIUD_Incident
Incident_ID Date DateReported Location Incident Result Notes Organization_ID ReportedBy FollowUp Time
------------ -------------------------------------------------- --------------------- ----------- --------------- ----------- -------------------------------------------------- -------------- ------------- ------------ ----------- ------------------- -------------- -------------- -------------------- --------- -------------
***********************************************************/
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @errno int,
           @errmsg varchar(255)

SELECT @numrows = @@ROWCOUNT
/* ------------------------- */

INSERT INTO dbo.AuditTrail 
	(UserID, Date, type, OldValue, NewValue,TableName)
SELECT SUSER_SNAME(), getdate(), 'IN', '<NONE>', 
	convert(varchar(6),inserted.Incident_ID) + ': ' + convert(varchar(20),inserted.Date) + ': '+
		convert(varchar(20),inserted.DateReported) + ': '+ inserted.Location  + inserted.Incident + ': '+
		inserted.Result + ': '+ inserted.Notes  +': ' +convert(varchar(6),inserted.Organization_ID) + ': ' + inserted.ReportedBy + ': '+
		inserted.FollowUp + ': '+ inserted.Time ,'Incident' 
FROM inserted 
WHERE NOT EXISTS(select * from deleted where inserted.Incident_ID = deleted.Incident_ID)

SELECT @errno = @@ERROR
IF @errno <> 0
BEGIN
     SELECT @errmsg = 'Cannot audit adding Incident.'
     GOTO error
END

INSERT INTO dbo.AuditTrail 
	(UserID, Date, type, OldValue, NewValue,TableName)
SELECT SUSER_SNAME(),getdate(), 'DL', 
convert(varchar(6),deleted.Incident_ID) + ': ' + convert(varchar(20),deleted.Date) + ': '+
		convert(varchar(20),deleted.DateReported) + ': '+ deleted.Location  + deleted.Incident + ': '+
		deleted.Result + ': '+ deleted.Notes  +': ' + convert(varchar(6),deleted.Organization_ID) + ': ' + deleted.ReportedBy + ': '+
		deleted.FollowUp + ': '+ deleted.Time , 
	'<NONE>','Incident'
FROM deleted 
WHERE NOT EXISTS(select * from inserted where inserted.Incident_ID = deleted.Incident_ID)

SELECT @errno = @@ERROR
IF @errno <> 0
BEGIN
     SELECT @errmsg = 'Cannot audit deleting Incident.'
     GOTO error
END

IF UPDATE(Date)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:Date',  
		convert(varchar(6),deleted.Incident_ID) + ': ' + convert(varchar(20),deleted.Date),
		convert(varchar(6),inserted.Incident_ID) + ': ' + convert(varchar(20),inserted.Date),'Incident'
	FROM deleted
	INNER JOIN inserted ON inserted.Incident_ID = deleted.Incident_ID
	WHERE deleted.Date <> inserted.Date

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating Date.'
		 GOTO error
	END
END

IF UPDATE(DateReported)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:DateReported',  
		convert(varchar(6),deleted.Incident_ID) + ': ' + convert(varchar(20),deleted.DateReported),
		convert(varchar(6),inserted.Incident_ID) + ': ' + convert(varchar(20),inserted.DateReported),'Incident'
	FROM deleted
	INNER JOIN inserted ON inserted.Incident_ID = deleted.Incident_ID
	WHERE deleted.DateReported <> inserted.DateReported

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating Date Reported.'
		 GOTO error
	END
END

IF UPDATE(Location)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:Location',  
		convert(varchar(6),deleted.Incident_ID) + ': ' + deleted.Location,
		convert(varchar(6),inserted.Incident_ID) + ': ' + inserted.Location,'Incident'
	FROM deleted
	INNER JOIN inserted ON inserted.Incident_ID = deleted.Incident_ID
	WHERE deleted.Location <> inserted.Location

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating Location.'
		 GOTO error
	END
END

IF UPDATE(Incident)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:Incident',  
		convert(varchar(6),deleted.Incident_ID) + ': ' + deleted.Incident,
		convert(varchar(6),inserted.Incident_ID) + ': ' + inserted.Incident,'Incident'
	FROM deleted
	INNER JOIN inserted ON inserted.Incident_ID = deleted.Incident_ID
	WHERE deleted.Incident <> inserted.Incident

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating Incident.'
		 GOTO error
	END
END

IF UPDATE(Result)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:Result',  
		convert(varchar(6),deleted.Incident_ID) + ': ' + deleted.Result,
		convert(varchar(6),inserted.Incident_ID) + ': ' + inserted.Result,'Incident'
	FROM deleted
	INNER JOIN inserted ON inserted.Incident_ID = deleted.Incident_ID
	WHERE deleted.Result <> inserted.Result

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating Result.'
		 GOTO error
	END
END

IF UPDATE(Notes)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:Notes',  
		convert(varchar(6),deleted.Incident_ID) + ': ' + deleted.Notes,
		convert(varchar(6),inserted.Incident_ID) + ': ' + inserted.Notes,'Incident'
	FROM deleted
	INNER JOIN inserted ON inserted.Incident_ID = deleted.Incident_ID
	WHERE deleted.Notes <> inserted.Notes

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating Notes.'
		 GOTO error
	END
END

IF UPDATE(Organization_ID)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:Organization_ID',  
		convert(varchar(6),deleted.Incident_ID) + ': ' + deleted.Organization_ID,
		convert(varchar(6),inserted.Incident_ID) + ': ' + inserted.Organization_ID,'Incident'
	FROM deleted
	INNER JOIN inserted ON inserted.Incident_ID = deleted.Incident_ID
	WHERE deleted.Organization_ID <> inserted.Organization_ID

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating Organization_ID.'
		 GOTO error
	END
END

IF UPDATE(ReportedBy)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:ReportedBy',  
		convert(varchar(6),deleted.Incident_ID) + ': ' + deleted.ReportedBy,
		convert(varchar(6),inserted.Incident_ID) + ': ' + inserted.ReportedBy,'Incident'
	FROM deleted
	INNER JOIN inserted ON inserted.Incident_ID = deleted.Incident_ID
	WHERE deleted.ReportedBy <> inserted.ReportedBy

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating ReportedBy.'
		 GOTO error
	END
END

IF UPDATE(FollowUp)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:FollowUp',  
		convert(varchar(6),deleted.Incident_ID) + ': ' + deleted.FollowUp,
		convert(varchar(6),inserted.Incident_ID) + ': ' + inserted.FollowUp,'Incident'
	FROM deleted
	INNER JOIN inserted ON inserted.Incident_ID = deleted.Incident_ID
	WHERE deleted.FollowUp <> inserted.FollowUp

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating FollowUp.'
		 GOTO error
	END
END

IF UPDATE(Time)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:Time',  
		convert(varchar(6),deleted.Incident_ID) + ': ' + deleted.Time,
		convert(varchar(6),inserted.Incident_ID) + ': ' + inserted.Time,'Incident'
	FROM deleted
	INNER JOIN inserted ON inserted.Incident_ID = deleted.Incident_ID
	WHERE deleted.Time <> inserted.Time

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating Time.'
		 GOTO error
	END
END
/* -------------------------- */
  RETURN
error:
  RAISERROR @errno @errmsg
  ROLLBACK TRANSACTION
END

