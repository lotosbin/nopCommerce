﻿--upgrade scripts from nopCommerce 3.50 to 3.60

--new locale resources
declare @resources xml
--a resource will be deleted if its value is empty
set @resources='
<Language>
  <LocaleResource Name="Admin.Configuration.Settings.Shipping.NotifyCustomerAboutShippingFromMultipleLocations">
    <Value>Notify customer about shipping from multiple locations</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Shipping.NotifyCustomerAboutShippingFromMultipleLocations.Hint">
    <Value>Check if you want customers to be notified when shipping from multiple locations.</Value>
  </LocaleResource>
  <LocaleResource Name="Checkout.ShippingMethod.ShippingFromMultipleLocations">
    <Value>Please note that your order will be shipped from multiple locations</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.SeNames.Details">
    <Value>Edit page</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Feed.Froogle.PricesConsiderPromotions">
    <Value>Prices consider promotions</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Feed.Froogle.PricesConsiderPromotions.Hint">
    <Value>Check if you want prices to be calculated with promotions (tier prices, discounts, special prices, tax, etc). But please note that it can significantly reduce time required to generate the feed file.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.IsTelecommunicationsOrBroadcastingOrElectronicServices.Hint">
    <Value>Check if it''s telecommunications, broadcasting and electronic services. It''s used for tax calculation in Europe Union.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Vendor.AllowCustomersToContactVendors">
    <Value>Allow customers to contact vendors</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Vendor.AllowCustomersToContactVendors.Hint">
    <Value>Check to allow customers to contact vendors.</Value>
  </LocaleResource>
  <LocaleResource Name="PageTitle.ContactVendor">
    <Value>Contact Vendor - {0}</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor">
    <Value>Contact vendor</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.Button">
    <Value>Submit</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.Email">
    <Value>Your email</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.Email.Hint">
    <Value>Enter your email address</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.Email.Required">
    <Value>Enter email</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.EmailSubject">
    <Value>{0}. Contact us</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.Enquiry">
    <Value>Enquiry</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.Enquiry.Hint">
    <Value>Enter your enquiry</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.Enquiry.Required">
    <Value>Enter enquiry</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.FullName">
    <Value>Your name</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.FullName.Hint">
    <Value>Enter your name</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.FullName.Required">
    <Value>Enter your name</Value>
  </LocaleResource>
  <LocaleResource Name="ContactVendor.YourEnquiryHasBeenSent">
    <Value>Your enquiry has been successfully sent to the vendor.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.Templates.Topic">
    <Value>Topic templates</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.Templates.Topic.DisplayOrder">
    <Value>Display order</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.Templates.Topic.Name">
    <Value>Name</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.Templates.Topic.Name.Required">
    <Value>Name is required</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.Templates.Topic.ViewPath">
    <Value>View path</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.Templates.Topic.ViewPath.Required">
    <Value>View path is required</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.Topics.Fields.TopicTemplate">
    <Value>Topic template</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.Topics.Fields.TopicTemplate.Hint">
    <Value>Choose a topic template. This template defines how this topic will be displayed.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Address.AddressAttributes.Fields.IsRequired.Hint">
	<Value>When an attribute is required, the customer must choose an appropriate attribute value before they can continue.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.MessageTemplates.Test">
	<Value>Test template</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.MessageTemplates.Test.BackToTemplate">
	<Value>back to template</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.MessageTemplates.Test.Send">
	<Value>Send</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.MessageTemplates.Test.SendTo">
	<Value>Send email to</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.MessageTemplates.Test.SendTo.Hint">
	<Value>Send test email to ensure that everything is properly configured.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.MessageTemplates.Test.Success">
	<Value>Email has been successfully queued.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.MessageTemplates.Test.Tokens">
	<Value>Tokens</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.MessageTemplates.Test.Tokens.Description">
	<Value>Please enter tokens you want to be replaced below</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.MessageTemplates.Test.Tokens.Hint">
	<Value>Enter tokens.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.MessageTemplates.TestDetails">
	<Value>Send test email</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.SearchPagePageSizeOptions">
    <Value>Search page. Page size options (comma separated)</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Common.ExportToExcel.All">
    <Value>Export to Excel (all found)</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Common.ExportToXml.All">
    <Value>Export to XML (all found)</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Shipments.PrintPackagingSlip.All">
    <Value>Print packaging slips (all found)</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.Warehouse">
    <Value>Warehouse</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.Warehouse.Hint">
    <Value>If an asterisk is selected, then this shipping rate will apply to all warehouses.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Feed.Froogle.Products.CustomGoods">
    <Value>Custom goods (no identifier exists)</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.TopCategoryMenuSubcategoryLevelsToDisplay">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.TopCategoryMenuSubcategoryLevelsToDisplay.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.QueuedEmails.Fields.Priority.Range">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Enums.Nop.Core.Domain.Messages.QueuedEmailPriority.Low">
    <Value>Low</Value>
  </LocaleResource>
  <LocaleResource Name="Enums.Nop.Core.Domain.Messages.QueuedEmailPriority.High">
    <Value>High</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Promotions.Discounts.Fields.MaximumDiscountAmount">
    <Value>Maximum discount amount</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Promotions.Discounts.Fields.MaximumDiscountAmount.Hint">
    <Value>Maximum allowed discount amount. Leave empty to allow any discount amount. If you''re using "Assigned to products" discount type, then it''s applied to each product separately.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Media.DefaultImageQuality">
    <Value>Default image quality (0 - 100)</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Media.DefaultImageQuality.Hint">
    <Value>The image quality to be used for uploaded images. Once changed you have to manually delete already generated thumbs.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.PdfSettings">
    <Value>PDF settings</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.EnableXSRFProtectionForAdminArea">
    <Value>Enable XSRF protection for admin area</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.EnableXSRFProtectionForAdminArea.Hint">
    <Value>Check to enable XSRF protection for admin area.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Fields.Profit">
    <Value>Profit</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Fields.Profit.Hint">
    <Value>Profit of this order.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Widgets.GoogleAnalytics.IncludingTax">
    <Value>Include tax</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Widgets.GoogleAnalytics.IncludingTax.Hint">
    <Value>Check to include tax when generating tracking code for {ECOMMERCE} part.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Feed.Froogle.PassShippingInfoWeight">
    <Value>Pass shipping info (weight)</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Feed.Froogle.PassShippingInfoWeight.Hint">
    <Value>Check if you want to include shipping information (weight) in generated XML file.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Feed.Froogle.PassShippingInfo">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Feed.Froogle.PassShippingInfo.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Feed.Froogle.PassShippingInfoDimensions">
    <Value>Pass shipping info (dimensions)</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Feed.Froogle.PassShippingInfoDimensions.Hint">
    <Value>Check if you want to include shipping information (dimensions) in generated XML file.</Value>
  </LocaleResource>
  <LocaleResource Name="Newsletter.Button">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Newsletter.Options.Subscribe">
    <Value>Subscribe</Value>
  </LocaleResource>
  <LocaleResource Name="Newsletter.Options.Unsubscribe">
    <Value>Unsubscribe</Value>
  </LocaleResource>
  <LocaleResource Name="Newsletter.UnsubscribeEmailSent">
    <Value>A verification email has been sent. Thank you!</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.CustomerUser.NewsletterBlockAllowToUnsubscribe">
    <Value>Newsletter box. Allow to unsubscribe</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.CustomerUser.NewsletterBlockAllowToUnsubscribe.Hint">
    <Value>Check if you want to allow customers to display "unsubscribe" option in the newsletter block.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.General">
    <Value>General</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.Performance">
    <Value>Performance</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ProductReviews">
    <Value>Product reviews</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.Search">
    <Value>Search</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.CompareProducts">
    <Value>Compare products</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.Sharing">
    <Value>Sharing</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.EnableXSRFProtectionForPublicStore">
    <Value>Enable XSRF protection for public store</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.EnableXSRFProtectionForPublicStore.Hint">
    <Value>Check to enable XSRF protection for public store.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ProductSearchTermMinimumLength">
    <Value>Search term minimum length</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ProductSearchTermMinimumLength.Hint">
    <Value>Specify minimum length of search term.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.ResponsiveDesignSupported">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.ResponsiveDesignSupported.Hint">
    <Value></Value>
  </LocaleResource>
</Language>
'

CREATE TABLE #LocaleStringResourceTmp
	(
		[ResourceName] [nvarchar](200) NOT NULL,
		[ResourceValue] [nvarchar](max) NOT NULL
	)

INSERT INTO #LocaleStringResourceTmp (ResourceName, ResourceValue)
SELECT	nref.value('@Name', 'nvarchar(200)'), nref.value('Value[1]', 'nvarchar(MAX)')
FROM	@resources.nodes('//Language/LocaleResource') AS R(nref)

--do it for each existing language
DECLARE @ExistingLanguageID int
DECLARE cur_existinglanguage CURSOR FOR
SELECT [ID]
FROM [Language]
OPEN cur_existinglanguage
FETCH NEXT FROM cur_existinglanguage INTO @ExistingLanguageID
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @ResourceName nvarchar(200)
	DECLARE @ResourceValue nvarchar(MAX)
	DECLARE cur_localeresource CURSOR FOR
	SELECT ResourceName, ResourceValue
	FROM #LocaleStringResourceTmp
	OPEN cur_localeresource
	FETCH NEXT FROM cur_localeresource INTO @ResourceName, @ResourceValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (EXISTS (SELECT 1 FROM [LocaleStringResource] WHERE LanguageID=@ExistingLanguageID AND ResourceName=@ResourceName))
		BEGIN
			UPDATE [LocaleStringResource]
			SET [ResourceValue]=@ResourceValue
			WHERE LanguageID=@ExistingLanguageID AND ResourceName=@ResourceName
		END
		ELSE 
		BEGIN
			INSERT INTO [LocaleStringResource]
			(
				[LanguageId],
				[ResourceName],
				[ResourceValue]
			)
			VALUES
			(
				@ExistingLanguageID,
				@ResourceName,
				@ResourceValue
			)
		END
		
		IF (@ResourceValue is null or @ResourceValue = '')
		BEGIN
			DELETE [LocaleStringResource]
			WHERE LanguageID=@ExistingLanguageID AND ResourceName=@ResourceName
		END
		
		FETCH NEXT FROM cur_localeresource INTO @ResourceName, @ResourceValue
	END
	CLOSE cur_localeresource
	DEALLOCATE cur_localeresource


	--fetch next language identifier
	FETCH NEXT FROM cur_existinglanguage INTO @ExistingLanguageID
END
CLOSE cur_existinglanguage
DEALLOCATE cur_existinglanguage

DROP TABLE #LocaleStringResourceTmp
GO



--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'shippingsettings.notifycustomeraboutshippingfrommultiplelocations')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'shippingsettings.notifycustomeraboutshippingfrommultiplelocations', N'false', 0)
END
GO


--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'frooglesettings.pricesconsiderpromotions')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'frooglesettings.pricesconsiderpromotions', N'false', 0)
END
GO


--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'vendorsettings.allowcustomerstocontactvendors')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'vendorsettings.allowcustomerstocontactvendors', N'true', 0)
END
GO


--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'externalauthenticationsettings.requireemailvalidation')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'externalauthenticationsettings.requireemailvalidation', N'false', 0)
END
GO




--Topic templates
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TopicTemplate]') and OBJECTPROPERTY(object_id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[TopicTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ViewPath] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO

IF NOT EXISTS (
		SELECT 1
		FROM [dbo].[TopicTemplate]
		WHERE [Name] = N'Default template')
BEGIN
	INSERT [dbo].[TopicTemplate] ([Name], [ViewPath], [DisplayOrder])
	VALUES (N'Default template', N'TopicDetails', 1)
END
GO



--new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[Topic]') and NAME='TopicTemplateId')
BEGIN
	ALTER TABLE [Topic]
	ADD [TopicTemplateId] int NULL
END
GO

UPDATE [Topic]
SET [TopicTemplateId] = 1
WHERE [TopicTemplateId] IS NULL
GO

ALTER TABLE [Topic] ALTER COLUMN [TopicTemplateId] int NOT NULL
GO



--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'frooglesettings.expirationnumberofdays')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'frooglesettings.expirationnumberofdays', N'28', 0)
END
GO


--shipping by weight plugin
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[ShippingByWeight]') and OBJECTPROPERTY(object_id, N'IsUserTable') = 1)
BEGIN
	--new [StoreId] column
	EXEC ('IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id(''[ShippingByWeight]'') and NAME=''WarehouseId'')
	BEGIN
		ALTER TABLE [ShippingByWeight]
		ADD [WarehouseId] int NULL

		exec(''UPDATE [ShippingByWeight] SET [WarehouseId] = 0'')
		
		EXEC (''ALTER TABLE [ShippingByWeight] ALTER COLUMN [WarehouseId] int NOT NULL'')
	END')
END
GO


--froogle plugin
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[GoogleProduct]') and OBJECTPROPERTY(object_id, N'IsUserTable') = 1)
BEGIN
	--new [StoreId] column
	EXEC ('IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id(''[GoogleProduct]'') and NAME=''CustomGoods'')
	BEGIN
		ALTER TABLE [GoogleProduct]
		ADD [CustomGoods] bit NULL

		exec(''UPDATE [GoogleProduct] SET [CustomGoods] = 0'')
		
		EXEC (''ALTER TABLE [GoogleProduct] ALTER COLUMN [CustomGoods] bit NOT NULL'')
	END')
END
GO

--delete setting
DELETE FROM [Setting] 
WHERE [name] = N'catalogsettings.topcategorymenusubcategorylevelstodisplay'
GO


--queued email priority
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[QueuedEmail]') and NAME='Priority')
BEGIN
	EXEC sp_rename 'QueuedEmail.Priority', 'PriorityId', 'COLUMN';
	
	EXEC ('UPDATE [QueuedEmail] SET [PriorityId] = 0 WHERE [PriorityId] <> 5')
END
GO



--new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[Discount]') and NAME='MaximumDiscountAmount')
BEGIN
	ALTER TABLE [Discount]
	ADD [MaximumDiscountAmount] decimal(18,4) NULL
END
GO


--more indexes
IF NOT EXISTS (SELECT 1 from sys.indexes WHERE [NAME]=N'IX_Product_ProductAttribute_Mapping_ProductId_DisplayOrder' and object_id=object_id(N'[Product_ProductAttribute_Mapping]'))
BEGIN
	CREATE NONCLUSTERED INDEX [IX_Product_ProductAttribute_Mapping_ProductId_DisplayOrder] ON [Product_ProductAttribute_Mapping] ([ProductId] ASC, [DisplayOrder] ASC)
END
GO

IF EXISTS (SELECT 1 from sys.indexes WHERE [NAME]=N'IX_Product_ProductAttribute_Mapping_ProductId' and object_id=object_id(N'[Product_ProductAttribute_Mapping]'))
BEGIN
	DROP INDEX [IX_Product_ProductAttribute_Mapping_ProductId] ON [Product_ProductAttribute_Mapping]
END
GO


--more indexes
IF NOT EXISTS (SELECT 1 from sys.indexes WHERE [NAME]=N'IX_ProductAttributeValue_ProductAttributeMappingId_DisplayOrder' and object_id=object_id(N'[ProductAttributeValue]'))
BEGIN
	CREATE NONCLUSTERED INDEX [IX_ProductAttributeValue_ProductAttributeMappingId_DisplayOrder] ON [ProductAttributeValue] ([ProductAttributeMappingId] ASC, [DisplayOrder] ASC)
END
GO

IF EXISTS (SELECT 1 from sys.indexes WHERE [NAME]=N'IX_ProductAttributeValue_ProductAttributeMappingId' and object_id=object_id(N'[ProductAttributeValue]'))
BEGIN
	DROP INDEX [IX_ProductAttributeValue_ProductAttributeMappingId] ON [ProductAttributeValue]
END
GO


--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'securitysettings.enablexsrfprotectionforadminarea')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'securitysettings.enablexsrfprotectionforadminarea', N'true', 0)
END
GO


--rename setting
UPDATE [Setting] 
SET [Name] = N'frooglesettings.passshippinginfoweight'
WHERE [Name] = N'frooglesettings.passshippinginfo'
GO


--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'frooglesettings.passshippinginfodimensions')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'frooglesettings.passshippinginfodimensions', N'false', 0)
END
GO


--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'customersettings.newsletterblockallowtounsubscribe')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'customersettings.newsletterblockallowtounsubscribe', N'false', 0)
END
GO


--'Newsletter unsubscribe' message template
IF NOT EXISTS (
		SELECT 1
		FROM [MessageTemplate]
		WHERE [Name] = N'NewsLetterSubscription.DeactivationMessage')
BEGIN
	INSERT [MessageTemplate] ([Name], [BccEmailAddresses], [Subject], [Body], [IsActive], [EmailAccountId], [LimitedToStores], [AttachedDownloadId])
	VALUES (N'NewsLetterSubscription.DeactivationMessage', null, N'%Store.Name%. Subscription deactivation message.', N'<p><a href="%NewsLetterSubscription.DeactivationUrl%">Click here to unsubscribe from our newsletter.</a></p><p>If you received this email by mistake, simply delete it.</p>', 1, 0, 0, 0)
END
GO

--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'securitysettings.enablexsrfprotectionforpublicstore')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'securitysettings.enablexsrfprotectionforpublicstore', N'true', 0)
END
GO

--Delete setting
DELETE FROM [Setting]
WHERE Name = N'storeinformationsettings.responsivedesignsupported'
GO