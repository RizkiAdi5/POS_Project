<cftry>
<cfquery name="updatetable" datasource="#dts#">
ALTER TABLE `counter` ADD COLUMN `add1` VARCHAR(45) DEFAULT '' AFTER `updated_on`,
 ADD COLUMN `add2` VARCHAR(45) DEFAULT '' AFTER `add1`,
 ADD COLUMN `add3` VARCHAR(45) DEFAULT '' AFTER `add2`,
 ADD COLUMN `add4` VARCHAR(45) DEFAULT '' AFTER `add3`;
</cfquery>
<cfcatch type="any">
</cfcatch>
</cftry>
<cfoutput>
<h1>Update Done!</h1>
</cfoutput>