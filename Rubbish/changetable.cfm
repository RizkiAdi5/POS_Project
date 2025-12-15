<html>
<head></head>
<body>

    <cftry>
<cfquery name="altertable1" datasource="#dts#">
CREATE TABLE `main`.`useraccountlimit` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
`companyid` varchar(45) DEFAULT '',
`usercount` int(10) unsigned DEFAULT '3',
PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=379 DEFAULT CHARSET=utf8;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable2" datasource="#dts#">
insert into useraccountlimit (companyid,usercount) values ('gramas_i','10')
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable3" datasource="#dts#">
ALTER TABLE `gsetup` ADD COLUMN `comboard` VARCHAR(45) DEFAULT 'Y' AFTER `lcs`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable4" datasource="#dts#">
ALTER TABLE `gsetup` ADD COLUMN `additemdelay` VARCHAR(45) DEFAULT '150' AFTER `lcs`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable5" datasource="#dts#">
ALTER TABLE `artran` ADD COLUMN `cashierid` VARCHAR(100) DEFAULT '' AFTER `dono`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable6" datasource="#dts#">
ALTER TABLE `icitem` ADD COLUMN `barcode` VARCHAR(100) DEFAULT '' AFTER `itemtype`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable7" datasource="#dts#">
CREATE TABLE `cashier` (
`cashierid` VARCHAR(100) NOT NULL DEFAULT '',
`password` VARCHAR(100) NOT NULL DEFAULT '',
`name` VARCHAR(100) NOT NULL DEFAULT '',
PRIMARY KEY (`cashierid`)
)
ENGINE = MyISAM;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable8" datasource="#dts#">
ALTER TABLE `artran` MODIFY COLUMN `VAN` VARCHAR(10) CHARACTER SET utf8 COLLATE
utf8_general_ci NOT NULL DEFAULT '';
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable8" datasource="#dts#">
ALTER TABLE `driver` MODIFY COLUMN `DRIVERNO` VARCHAR(10) CHARACTER SET utf8 COLLATE
utf8_general_ci NOT NULL DEFAULT '';
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable8" datasource="#dts#">
ALTER TABLE `gsetup` ADD COLUMN `memdisc` VARCHAR(45) DEFAULT '' AFTER `drawerport`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable9" datasource="#dts#">
ALTER TABLE `dailycounter` ADD COLUMN `type` VARCHAR(45) DEFAULT '' AFTER `updated_by`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable10" datasource="#dts#">
CREATE TABLE `deposit` (
`depositno` varchar(45) NOT NULL DEFAULT '',
`desp` varchar(200) DEFAULT NULL,
`CS_PM_CASH` double(17,7) NOT NULL DEFAULT '0.0000000',
`CS_PM_CHEQ` double(17,7) NOT NULL DEFAULT '0.0000000',
`CS_PM_CRCD` double(17,7) NOT NULL DEFAULT '0.0000000',
`CS_PM_CRC2` double(17,7) NOT NULL DEFAULT '0.0000000',
`CS_PM_DBCD` double(17,7) NOT NULL DEFAULT '0.0000000',
`CS_PM_VOUC` double(17,7) NOT NULL DEFAULT '0.0000000',
`CS_PM_CASHCD` double(17,7) NOT NULL DEFAULT '0.0000000',
`rem1` varchar(200) NOT NULL DEFAULT '',
`rem2` varchar(200) NOT NULL DEFAULT '',
`rem3` varchar(200) NOT NULL DEFAULT '',
`rem4` varchar(200) NOT NULL DEFAULT '',
`rem5` varchar(200) NOT NULL DEFAULT '',
`rem6` varchar(200) NOT NULL DEFAULT '',
`rem7` varchar(200) NOT NULL DEFAULT '',
`rem8` varchar(200) NOT NULL DEFAULT '',
`rem9` varchar(200) NOT NULL DEFAULT '',
`rem10` varchar(200) NOT NULL DEFAULT '',
`Billno` varchar(200) DEFAULT NULL,
`chequeno` varchar(200) DEFAULT '',
`cctype1` varchar(200) NOT NULL DEFAULT '',
`cctype2` varchar(200) NOT NULL DEFAULT '',
`sono` varchar(200) DEFAULT '',
`wos_date` date NOT NULL DEFAULT '0000-00-00',
PRIMARY KEY (`depositno`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable11" datasource="#dts#">
ALTER TABLE `gsetup` ADD COLUMN `disablecounter` VARCHAR(45) DEFAULT 'N' AFTER `voucherbal`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable12" datasource="#dts#">
CREATE TABLE `discount` (
`discount` DOUBLE(17,7) NOT NULL DEFAULT '0.0000000',
`desp` VARCHAR(100) NOT NULL DEFAULT '',
PRIMARY KEY (`discount`)
)
ENGINE = MyISAM;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable13" datasource="#dts#">
ALTER TABLE `gsetup` ADD COLUMN `comboardport` VARCHAR(150) DEFAULT '' AFTER `lcs`,
ADD COLUMN `drawerport` VARCHAR(150) DEFAULT '' AFTER `comboardport`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable14" datasource="#dts#">
ALTER TABLE `gsetup` ADD COLUMN `hidetotaldiscount` VARCHAR(45) DEFAULT 'N' AFTER `dfpos`,
ADD COLUMN `setitemdiscount` VARCHAR(45) DEFAULT 'N' AFTER `hidetotaldiscount`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable15" datasource="#dts#">
ALTER TABLE `gsetup` ADD COLUMN `hideqty` VARCHAR(45) DEFAULT 'N' AFTER `setitemdiscount`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable16" datasource="#dts#">
CREATE TABLE `posftp` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
`ftphost` varchar(100) DEFAULT '',
`ftpuser` varchar(100) DEFAULT '',
`ftppass` varchar(100) DEFAULT '',
`ftpport` varchar(45) DEFAULT '',
`tenantno` varchar(100) DEFAULT '',
PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable17" datasource="#dts#">
ALTER TABLE `artran` ADD COLUMN `roundadj` DOUBLE(15,5) NOT NULL DEFAULT '0.00000' AFTER
`GRAND_BIL`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable18" datasource="#dts#">
CREATE TABLE `ictermandcondition` (
`No` int(10) unsigned NOT NULL AUTO_INCREMENT,
`lRC` text,
`lPR` text,
`lDO` text,
`lINV` text,
`lCS` text,
`lCN` text,
`lDN` text,
`lPO` text,
`lQUO` text,
`lSO` text,
`lSAM` text,
PRIMARY KEY (`No`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable19" datasource="#dts#">
ALTER TABLE `userpin2` ADD COLUMN `H1Z60` CHAR(1) NOT NULL DEFAULT 'F' AFTER `H1Z40`,
ADD COLUMN `H1Z70` CHAR(1) NOT NULL DEFAULT 'F' AFTER `H1Z60`,
ADD COLUMN `H2I00` CHAR(1) NOT NULL DEFAULT 'F' AFTER `H1Z70`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable20" datasource="#dts#">
insert into userpin (code,desp,super,admin,standard,general,limited,mobile) values ('1Z60','Cashier
Profile','T','T','T','T','',''),('1Z70','Discount Profile','T','T','T','T','',''),('2I00','Cash Recording maintenance','T','T','T','T','','')
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable21" datasource="#dts#">
insert into userpin (code,desp,super,admin,standard,general,limited,mobile) values ('1Z70','Voucher Type
Profile','T','T','T','T','','')
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable22" datasource="#dts#">
ALTER TABLE `userpin2` ADD COLUMN `H1Z80` CHAR(1) NOT NULL DEFAULT 'F' AFTER `H1Z70`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable23" datasource="#dts#">
insert into userpin (code,desp,super,admin,standard,general,limited,mobile) values ('1Z50','Counter
Profile','T','T','T','T','','')
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable24" datasource="#dts#">
ALTER TABLE `userpin2` ADD COLUMN `H1Z50` CHAR(1) NOT NULL DEFAULT 'T' AFTER `H1R10`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
<cfquery name="altertable25" datasource="#dts#">
ALTER TABLE `gsetup` ADD COLUMN `site` VARCHAR(150) DEFAULT '' AFTER `lcs`;
</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
	</cftry>
    
    <cftry>
    <cfquery name="altertable26" datasource="#dts#">
CREATE TABLE  `poslog` (
  `u_Id` int(10) NOT NULL AUTO_INCREMENT,
  `userLogID` varchar(50) NOT NULL DEFAULT '',
  `userLogTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `udatabase` varchar(50) NOT NULL DEFAULT '',
  `uipaddress` varchar(15) NOT NULL DEFAULT '',
  `status` varchar(7) NOT NULL DEFAULT '',
  `logout` varchar(50) NOT NULL DEFAULT '',
  `location` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`u_Id`),
  KEY `USERLOG` (`u_Id`,`userLogID`,`userLogTime`,`udatabase`,`uipaddress`,`status`)
) ENGINE=MyISAM AUTO_INCREMENT=126556 DEFAULT CHARSET=utf8;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
   
   
   
   <cftry>
    <cfquery name="altertable27" datasource="#dts#">
	ALTER TABLE `posftp` ADD COLUMN `posdirectory` VARCHAR(200) DEFAULT '' AFTER `tenantno`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
   
   <cftry>
    <cfquery name="altertable28" datasource="#dts#">
	ALTER TABLE `posftp` ADD COLUMN `mall` VARCHAR(200) DEFAULT 'jurong' AFTER `posdirectory`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable28" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `INTERFACE` VARCHAR(45) DEFAULT 'new' AFTER `COMPRO7`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>


<cftry>
    <cfquery name="altertable28" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `DFLANGUAGE` VARCHAR(45) DEFAULT 'english' AFTER `COMPRO7`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>

	<cftry>
    <cfquery name="altertable28" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `LITEMNO` VARCHAR(45) DEFAULT 'Product code' AFTER `COMPRO7`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable28" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `LBRAND` VARCHAR(45) DEFAULT 'Brand' AFTER `COMPRO7`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable28" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `HOMEPAGEMENU` VARCHAR(45) DEFAULT 'dashboard' AFTER `COMPRO7`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>


	<cftry>
    <cfquery name="altertable29" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `displayset1` VARCHAR(20) DEFAULT '' AFTER `DFLANGUAGE`,
 ADD COLUMN `displayset2` VARCHAR(10) DEFAULT '' AFTER `displayset1`,
 ADD COLUMN `displayset3` VARCHAR(10) DEFAULT '' AFTER `displayset2`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable30" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `displaylogo` VARCHAR(20) DEFAULT '' AFTER `DFLANGUAGE`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable31" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `compulsarycounter` VARCHAR(1) DEFAULT '' AFTER `comboardport`,
 ADD COLUMN `compulsaryagent` VARCHAR(1) DEFAULT '' AFTER `compulsarycounter`,
 ADD COLUMN `hideagent` VARCHAR(1) DEFAULT '' AFTER `compulsaryagent`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
	
    <cftry>
    <cfquery name="altertable32" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `positemgrouping` VARCHAR(1) DEFAULT 'Y' AFTER `DFLANGUAGE`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable33" datasource="#dts#">
	ALTER TABLE `icitem` ADD COLUMN `PRICE5` DOUBLE(17,7) NOT NULL DEFAULT '0.0000000' AFTER `PRICE4`,
 ADD COLUMN `PRICE6` DOUBLE(17,7) NOT NULL DEFAULT '0.0000000' AFTER `PRICE5`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable34" datasource="#dts#">
CREATE TABLE  `displaysetup2` (
  `companyid` varchar(45) NOT NULL DEFAULT 'IMS',
  `billdate` varchar(45) DEFAULT NULL,
  `customerno` varchar(45) DEFAULT NULL,
  `descp` varchar(45) DEFAULT NULL,
  `refno2` varchar(45) DEFAULT NULL,
  `currency` varchar(45) DEFAULT NULL,
  `enduser` varchar(45) DEFAULT NULL,
  `agent` varchar(45) DEFAULT NULL,
  `terms` varchar(45) DEFAULT NULL,
  `project` varchar(45) DEFAULT NULL,
  `so` varchar(45) DEFAULT NULL,
  `quo` varchar(2) DEFAULT '',
  `quo_pur` varchar(2) DEFAULT '',
  `po` varchar(45) DEFAULT NULL,
  `do` varchar(45) DEFAULT NULL,
  `billtoadd_code` varchar(45) DEFAULT NULL,
  `deladd_code` varchar(45) DEFAULT NULL,
  `billattn` varchar(45) DEFAULT NULL,
  `delattn` varchar(45) DEFAULT NULL,
  `deltel` varchar(45) DEFAULT NULL,
  `permitno` varchar(45) DEFAULT NULL,
  `hremark5` varchar(45) DEFAULT NULL,
  `hremark6` varchar(45) DEFAULT NULL,
  `hremark7` varchar(45) DEFAULT NULL,
  `hremark8` varchar(45) DEFAULT NULL,
  `hremark9` varchar(45) DEFAULT NULL,
  `hremark10` varchar(45) DEFAULT NULL,
  `hremark11` varchar(45) DEFAULT NULL,
  `remark30` varchar(45) DEFAULT NULL,
  `remark31` varchar(45) DEFAULT NULL,
  `remark32` varchar(45) DEFAULT NULL,
  `remark33` varchar(45) DEFAULT NULL,
  `remark34` varchar(45) DEFAULT NULL,
  `remark35` varchar(45) DEFAULT NULL,
  `remark36` varchar(45) DEFAULT NULL,
  `remark37` varchar(45) DEFAULT NULL,
  `remark38` varchar(45) DEFAULT NULL,
  `remark39` varchar(45) DEFAULT NULL,
  `remark40` varchar(45) DEFAULT NULL,
  `remark41` varchar(45) DEFAULT NULL,
  `remark42` varchar(45) DEFAULT NULL,
  `remark43` varchar(45) DEFAULT NULL,
  `remark44` varchar(45) DEFAULT NULL,
  `remark45` varchar(45) DEFAULT NULL,
  `remark46` varchar(45) DEFAULT NULL,
  `remark47` varchar(45) DEFAULT NULL,
  `remark48` varchar(45) DEFAULT NULL,
  `remark49` varchar(45) DEFAULT NULL,
  `f_misc_charg1` varchar(45) DEFAULT NULL,
  `f_misc_charg2` varchar(45) DEFAULT NULL,
  `f_misc_charg3` varchar(45) DEFAULT NULL,
  `f_misc_charg4` varchar(45) DEFAULT NULL,
  `f_misc_charg5` varchar(45) DEFAULT NULL,
  `f_misc_charg6` varchar(45) DEFAULT NULL,
  `f_misc_charg7` varchar(45) DEFAULT NULL,
  `f_acc_code` varchar(45) DEFAULT NULL,
  `f_pay_cash` varchar(45) DEFAULT NULL,
  `f_pay_cheque` varchar(45) DEFAULT NULL,
  `f_pay_cc1` varchar(45) DEFAULT NULL,
  `f_pay_cc2` varchar(45) DEFAULT NULL,
  `f_pay_gvoucher` varchar(45) DEFAULT NULL,
  `f_pay_dc` varchar(45) DEFAULT NULL,
  `f_subtotal` varchar(45) DEFAULT NULL,
  `f_discount` varchar(45) DEFAULT NULL,
  `f_tax` varchar(45) DEFAULT NULL,
  `f_grand` varchar(45) DEFAULT NULL,
  `f_net` varchar(45) DEFAULT NULL,
  `f_terms_cond` varchar(45) DEFAULT NULL,
  `body_bal_on_hand` varchar(45) DEFAULT NULL,
  `body_uom` varchar(45) DEFAULT NULL,
  `body_location` varchar(45) DEFAULT NULL,
  `body_gl_ac` varchar(45) DEFAULT NULL,
  `body_serialno` varchar(45) DEFAULT NULL,
  `body_remark2` varchar(45) DEFAULT NULL,
  `body_remark3` varchar(45) DEFAULT NULL,
  `body_remark4` varchar(45) DEFAULT NULL,
  `body_as_voucher` varchar(45) DEFAULT NULL,
  `body_cost_code` varchar(45) DEFAULT NULL,
  `body_project` varchar(45) DEFAULT NULL,
  `body_title` varchar(45) DEFAULT NULL,
  `body_job` varchar(45) DEFAULT NULL,
  `job` varchar(45) DEFAULT NULL,
  `f_pay_as_debt` varchar(45) DEFAULT NULL,
  `f_pay_deposit` varchar(45) DEFAULT NULL,
  `item_no` varchar(45) DEFAULT NULL,
  `item_descp` varchar(45) DEFAULT NULL,
  `item_comment` varchar(45) DEFAULT NULL,
  `item_productcode` varchar(45) DEFAULT NULL,
  `item_barcode` varchar(45) DEFAULT NULL,
  `item_brand` varchar(45) DEFAULT NULL,
  `item_supplier` varchar(45) DEFAULT NULL,
  `item_category` varchar(45) DEFAULT NULL,
  `item_size` varchar(45) DEFAULT NULL,
  `item_packing` varchar(45) DEFAULT NULL,
  `item_shelfno` varchar(45) DEFAULT NULL,
  `item_material` varchar(45) DEFAULT NULL,
  `item_minimum` varchar(45) DEFAULT NULL,
  `item_maximum` varchar(45) DEFAULT NULL,
  `item_group` varchar(45) DEFAULT NULL,
  `item_reorder` varchar(45) DEFAULT NULL,
  `item_rating` varchar(45) DEFAULT NULL,
  `item_defalutedtax` varchar(45) DEFAULT NULL,
  `item_changepic` varchar(45) DEFAULT NULL,
  `item_itemtype` varchar(45) DEFAULT NULL,
  `item_costcode` varchar(45) DEFAULT NULL,
  `item_uom` varchar(45) DEFAULT NULL,
  `item_ucp` varchar(45) DEFAULT NULL,
  `item_usp1` varchar(45) DEFAULT NULL,
  `item_usp2` varchar(45) DEFAULT NULL,
  `item_mur` varchar(45) DEFAULT NULL,
  `item_usp4` varchar(45) DEFAULT NULL,
  `item_usp5` varchar(2) DEFAULT 'Y',
  `item_usp6` varchar(2) DEFAULT 'Y',
  `item_msp` varchar(45) DEFAULT NULL,
  `item_discontinue` varchar(45) DEFAULT NULL,
  `item_cp` varchar(45) DEFAULT NULL,
  `item_qtyformula` varchar(45) DEFAULT NULL,
  `item_serialno` varchar(45) DEFAULT NULL,
  `item_grade` varchar(45) DEFAULT NULL,
  `item_length` varchar(45) DEFAULT NULL,
  `item_width` varchar(45) DEFAULT NULL,
  `item_thickness` varchar(45) DEFAULT NULL,
  `item_w_l` varchar(45) DEFAULT NULL,
  `item_p_w` varchar(45) DEFAULT NULL,
  `item_upformula` varchar(45) DEFAULT NULL,
  `item_relateditem` varchar(45) DEFAULT NULL,
  `item_qtybf` varchar(45) DEFAULT NULL,
  `item_commissionlevel` varchar(45) DEFAULT NULL,
  `item_creditsales` varchar(45) DEFAULT NULL,
  `item_cashsales` varchar(45) DEFAULT NULL,
  `item_salesreturn` varchar(45) DEFAULT NULL,
  `item_purchase` varchar(45) DEFAULT NULL,
  `item_purchasereturn` varchar(45) DEFAULT NULL,
  `b_add_baddresscode` varchar(45) DEFAULT NULL,
  `b_add_bname` varchar(45) DEFAULT NULL,
  `b_add_baddress` varchar(45) DEFAULT NULL,
  `b_add_battn` varchar(45) DEFAULT NULL,
  `b_add_btel` varchar(45) DEFAULT NULL,
  `b_add_btel2` varchar(45) DEFAULT NULL,
  `b_add_bfax` varchar(45) DEFAULT NULL,
  `b_add_bemail` varchar(45) DEFAULT NULL,
  `b_add_daddresscode` varchar(45) DEFAULT NULL,
  `b_add_dname` varchar(45) DEFAULT NULL,
  `b_add_daddress` varchar(45) DEFAULT NULL,
  `b_add_dattn` varchar(45) DEFAULT NULL,
  `b_add_dtel` varchar(45) DEFAULT NULL,
  `b_add_dfax` varchar(45) DEFAULT NULL,
  `b_add_dcontact` varchar(45) DEFAULT NULL,
  `cust_profile_companyuen` varchar(45) DEFAULT 'Y',
  `cust_profile_gstno` varchar(45) DEFAULT 'Y',
  `cust_profile_nongstcustomer` varchar(45) DEFAULT 'Y',
  `cust_profile_taxincluded` varchar(45) DEFAULT 'Y',
  `cust_profile_groupto` varchar(45) DEFAULT 'Y',
  `cust_profile_address` varchar(45) DEFAULT 'Y',
  `cust_profile_country` varchar(45) DEFAULT 'Y',
  `cust_profile_postalcode` varchar(45) DEFAULT 'Y',
  `cust_profile_attention` varchar(45) DEFAULT 'Y',
  `cust_profile_phone` varchar(45) DEFAULT 'Y',
  `cust_profile_phone2` varchar(45) DEFAULT 'Y',
  `cust_profile_fax` varchar(45) DEFAULT 'Y',
  `cust_profile_deliveryaddress` varchar(45) DEFAULT 'Y',
  `cust_profile_deliverycountry` varchar(45) DEFAULT 'Y',
  `cust_profile_deliverypostalcode` varchar(45) DEFAULT 'Y',
  `cust_profile_deliveryattention` varchar(45) DEFAULT 'Y',
  `cust_profile_deliveryphone` varchar(45) DEFAULT 'Y',
  `cust_profile_deliveryfax` varchar(45) DEFAULT 'Y',
  `cust_profile_contact` varchar(45) DEFAULT 'Y',
  `cust_profile_email` varchar(45) DEFAULT 'Y',
  `cust_profile_website` varchar(45) DEFAULT 'Y',
  `cust_profile_EndUser` varchar(45) DEFAULT 'Y',
  `cust_profile_Sales` varchar(45) DEFAULT 'Y',
  `cust_profile_Terms` varchar(45) DEFAULT 'Y',
  `compulsory_cust_Terms` char(1) DEFAULT '',
  `cust_profile_Area` varchar(45) DEFAULT 'Y',
  `cust_profile_Business` varchar(45) DEFAULT 'Y',
  `cust_profile_CreditLimit` varchar(45) DEFAULT 'Y',
  `cust_profile_CurrencyCode` varchar(45) DEFAULT 'Y',
  `cust_profile_Currency` varchar(45) DEFAULT 'Y',
  `cust_profile_CurrencyDollar` varchar(45) DEFAULT 'Y',
  `cust_profile_CurrencyDollar2` varchar(45) DEFAULT 'Y',
  `cust_profile_BadStatus` varchar(45) DEFAULT 'Y',
  `cust_profile_Date` varchar(45) DEFAULT 'Y',
  `cust_profile_InvoiceLimit` varchar(45) DEFAULT 'Y',
  `cust_profile_DiscountPercentageCategory` varchar(45) DEFAULT 'Y',
  `cust_profile_DiscountPercentageLevel1` varchar(45) DEFAULT 'Y',
  `cust_profile_DiscountPercentageLevel2` varchar(45) DEFAULT 'Y',
  `cust_profile_DiscountPercentageLevel3` varchar(45) DEFAULT 'Y',
  `cust_profile_CreditSalesCode` varchar(45) DEFAULT 'Y',
  `cust_profile_SalesReturnCode` varchar(45) DEFAULT 'Y',
  `cust_profile_NormalRate` varchar(45) DEFAULT 'Y',
  `cust_profile_OfferRate` varchar(45) DEFAULT 'Y',
  `cust_profile_Remark1` varchar(45) DEFAULT 'Y',
  `cust_profile_Remark2` varchar(45) DEFAULT 'Y',
  `cust_profile_Remark3` varchar(45) DEFAULT 'Y',
  `cust_profile_Remark4` varchar(45) DEFAULT 'Y',
  `supp_profile_companyuen` varchar(45) DEFAULT 'Y',
  `supp_profile_gstno` varchar(45) DEFAULT 'Y',
  `supp_profile_nongstsuppomer` varchar(45) DEFAULT 'Y',
  `supp_profile_taxincluded` varchar(45) DEFAULT 'Y',
  `supp_profile_groupto` varchar(45) DEFAULT 'Y',
  `supp_profile_address` varchar(45) DEFAULT 'Y',
  `supp_profile_country` varchar(45) DEFAULT 'Y',
  `supp_profile_postalcode` varchar(45) DEFAULT 'Y',
  `supp_profile_attention` varchar(45) DEFAULT 'Y',
  `supp_profile_phone` varchar(45) DEFAULT 'Y',
  `supp_profile_phone2` varchar(45) DEFAULT 'Y',
  `supp_profile_fax` varchar(45) DEFAULT 'Y',
  `supp_profile_deliveryaddress` varchar(45) DEFAULT 'Y',
  `supp_profile_deliverycountry` varchar(45) DEFAULT 'Y',
  `supp_profile_deliverypostalcode` varchar(45) DEFAULT 'Y',
  `supp_profile_deliveryattention` varchar(45) DEFAULT 'Y',
  `supp_profile_deliveryphone` varchar(45) DEFAULT 'Y',
  `supp_profile_deliveryfax` varchar(45) DEFAULT 'Y',
  `supp_profile_contact` varchar(45) DEFAULT 'Y',
  `supp_profile_email` varchar(45) DEFAULT 'Y',
  `supp_profile_website` varchar(45) DEFAULT 'Y',
  `supp_profile_EndUser` varchar(45) DEFAULT 'Y',
  `supp_profile_agent` varchar(45) DEFAULT 'Y',
  `supp_profile_Terms` varchar(45) DEFAULT 'Y',
  `supp_profile_Area` varchar(45) DEFAULT 'Y',
  `supp_profile_Business` varchar(45) DEFAULT 'Y',
  `supp_profile_CreditLimit` varchar(45) DEFAULT 'Y',
  `supp_profile_CurrencyCode` varchar(45) DEFAULT 'Y',
  `supp_profile_Currency` varchar(45) DEFAULT 'Y',
  `supp_profile_CurrencyDollar` varchar(45) DEFAULT 'Y',
  `supp_profile_CurrencyDollar2` varchar(45) DEFAULT 'Y',
  `supp_profile_Status` varchar(45) DEFAULT 'Y',
  `supp_profile_Date` varchar(45) DEFAULT 'Y',
  `supp_profile_InvoiceLimit` varchar(45) DEFAULT 'Y',
  `supp_profile_DiscountPercentageCategory` varchar(45) DEFAULT 'Y',
  `supp_profile_DiscountPercentageLevel1` varchar(45) DEFAULT 'Y',
  `supp_profile_DiscountPercentageLevel2` varchar(45) DEFAULT 'Y',
  `supp_profile_DiscountPercentageLevel3` varchar(45) DEFAULT 'Y',
  `supp_profile_PurchaseCode` varchar(45) DEFAULT 'Y',
  `supp_profile_PurchaseReturnCode` varchar(45) DEFAULT 'Y',
  `supp_profile_Remark1` varchar(45) DEFAULT 'Y',
  `supp_profile_Remark2` varchar(45) DEFAULT 'Y',
  `supp_profile_Remark3` varchar(45) DEFAULT 'Y',
  `supp_profile_Remark4` varchar(45) DEFAULT 'Y',
  `cust_profile_otherrate` varchar(45) DEFAULT 'Y',
  `billtel` varchar(45) DEFAULT 'Y',
  `f_pay_cashc` varchar(45) DEFAULT 'Y',
  `body_service` varchar(45) DEFAULT 'Y',
  `body_titledesp` varchar(45) DEFAULT 'Y',
  `body_nodisplay` varchar(45) DEFAULT 'Y',
  `body_replydate` varchar(45) DEFAULT 'Y',
  `body_deliverydate` varchar(45) DEFAULT 'Y',
  `body_requiredate` varchar(45) DEFAULT 'Y',
  `body_initial` varchar(45) DEFAULT 'Y',
  `f_service` varchar(45) DEFAULT 'Y',
  `cust_profile_Headquaters` varchar(45) DEFAULT 'Y',
  `f_crlimit` varchar(45) DEFAULT '',
  `invnoindo` varchar(45) DEFAULT '',
  `compulsory_cust_postalcode` varchar(10) DEFAULT '',
  `compulsory_item_desp` varchar(10) DEFAULT '',
  `compulsory_cust_companyuen` varchar(10) DEFAULT '',
  `compulsory_item_comment` varchar(10) DEFAULT '',
  `compulsory_item_productcode` varchar(10) DEFAULT '',
  `compulsory_item_barcode` varchar(10) DEFAULT '',
  `compulsory_item_brand` varchar(10) DEFAULT '',
  `compulsory_item_supplier` varchar(10) DEFAULT '',
  `compulsory_item_cate` varchar(10) DEFAULT '',
  `compulsory_item_size` varchar(10) DEFAULT '',
  `compulsory_item_shelfno` varchar(10) DEFAULT '',
  `compulsory_item_material` varchar(10) DEFAULT '',
  `compulsory_item_group` varchar(10) DEFAULT '',
  `compulsory_item_rating` varchar(10) DEFAULT '',
  `compulsory_item_uom` varchar(10) DEFAULT '',
  `compulsory_cust_billadd` varchar(10) DEFAULT '',
  `compulsory_cust_billattn` varchar(10) DEFAULT '',
  `compulsory_cust_phone` varchar(10) DEFAULT '',
  `compulsory_cust_phone2` varchar(10) DEFAULT '',
  `compulsory_cust_fax` varchar(10) DEFAULT '',
  `compulsory_cust_deladd` varchar(10) DEFAULT '',
  `compulsory_cust_delattn` varchar(10) DEFAULT '',
  `compulsory_cust_delphone` varchar(10) DEFAULT '',
  `compulsory_cust_delfax` varchar(10) DEFAULT '',
  `compulsory_cust_delphone2` varchar(10) DEFAULT '',
  `billdate_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `customerno_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `descp_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `refno2_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `currency_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `enduser_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `agent_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `terms_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `project_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `job_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `invnoindo_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `so_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `po_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `do_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `billtoadd_code_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `deladd_code_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `billtel_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `billattn_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `delattn_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `deltel_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `permitno_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `hremark5_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `hremark6_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `hremark7_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `hremark8_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `hremark9_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `hremark10_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `hremark11_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark30_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark31_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark32_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark33_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark34_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark35_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark36_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark37_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark38_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark39_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark40_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark41_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark42_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark43_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark44_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark45_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark46_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark47_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark48_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `remark49_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_service_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_crlimit_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_misc_charg1_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_misc_charg2_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_misc_charg3_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_misc_charg4_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_misc_charg5_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_misc_charg6_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_misc_charg7_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_acc_code_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_pay_cash_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_pay_cheque_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_pay_cc1_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_pay_cc2_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_pay_cashc_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_pay_gvoucher_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_pay_dc_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_pay_deposit_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_pay_as_debt_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_subtotal_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_discount_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_net_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_tax_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_grand_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `f_terms_cond_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_bal_on_hand_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_service_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_uom_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_location_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_gl_ac_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_serialno_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_remark2_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_remark3_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_remark4_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_nodisplay_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_as_voucher_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_cost_code_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_initial_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_project_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_title_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_titledesp_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_requiredate_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_replydate_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_deliverydate_pur` varchar(45) NOT NULL DEFAULT 'Y',
  `body_note1` varchar(45) NOT NULL DEFAULT '',
  `body_note1_pur` varchar(45) NOT NULL DEFAULT '',
  `item_stock` varchar(45) DEFAULT 'Y',
  `body_deductable_item` varchar(45) DEFAULT '',
  `body_deductable_item_pur` varchar(45) DEFAULT '',
  `body_pricelist_pur` varchar(2) DEFAULT '',
  `body_pricelist` varchar(2) DEFAULT '',
  `body_searchcomment` varchar(45) DEFAULT 'Y',
  `body_extendcomment` varchar(45) NOT NULL DEFAULT 'Y',
  `body_createnewcomment` varchar(45) NOT NULL DEFAULT 'Y',
  `body_searchmaterial` varchar(45) NOT NULL DEFAULT 'Y',
  `body_uploadimage` varchar(45) NOT NULL DEFAULT 'Y',
  `body_copyitemremark` varchar(45) NOT NULL DEFAULT 'Y',
  `body_discountbody` varchar(45) NOT NULL DEFAULT 'Y',
  `cust_profile_rating` varchar(45) DEFAULT 'N',
  `item_release` char(1) DEFAULT 'Y',
  `compulsory_item_release` char(1) DEFAULT 'Y',
  `cust_profile_remark5` varchar(45) DEFAULT '',
  `cust_profile_remark6` varchar(45) DEFAULT '',
  `cust_profile_remark7` varchar(45) DEFAULT '',
  `cust_profile_remark8` varchar(45) DEFAULT '',
  `cust_profile_remark9` varchar(45) DEFAULT '',
  `cust_profile_remark10` varchar(45) DEFAULT '',
  `cust_profile_remark11` varchar(45) DEFAULT '',
  `cust_profile_remark12` varchar(45) DEFAULT '',
  `cust_profile_remark13` varchar(45) DEFAULT '',
  `cust_profile_remark14` varchar(45) DEFAULT '',
  `cust_profile_remark15` varchar(45) DEFAULT '',
  `cust_profile_remark16` varchar(45) DEFAULT '',
  `cust_profile_remark17` varchar(45) DEFAULT '',
  `cust_profile_remark18` varchar(45) DEFAULT '',
  `cust_profile_remark19` varchar(45) DEFAULT '',
  `cust_profile_remark20` varchar(45) DEFAULT '',
  PRIMARY KEY (`companyid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable34" datasource="#dts#">
	ALTER TABLE `displaysetup2` ADD COLUMN `item_usp5` VARCHAR(2) DEFAULT 'Y' AFTER `item_usp4`,
 ADD COLUMN `item_usp6` VARCHAR(2) DEFAULT 'Y' AFTER `item_usp5`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable35" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `branchpricelvl` VARCHAR(2) NOT NULL DEFAULT '1' AFTER `DFLANGUAGE`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable36" datasource="#dts#">
	ALTER TABLE `driver` ADD COLUMN `points` DOUBLE(17,7) NOT NULL DEFAULT '0.00000' AFTER `created_on`,
 ADD COLUMN `pointsbf` DOUBLE(17,7) NOT NULL DEFAULT '0.00000' AFTER `points`,
 ADD COLUMN `pointsredeem` DOUBLE(17,7) NOT NULL DEFAULT '0.00000' AFTER `pointsbf`;

	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable37" datasource="#dts#">
	ALTER TABLE `driver` ADD COLUMN `remarks` VARCHAR(200) NOT NULL DEFAULT '' AFTER `created_on`;

	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `memberpoint` VARCHAR(1) DEFAULT '' AFTER `lcs`,
 ADD COLUMN `memberpointamt` VARCHAR(10) DEFAULT '1' AFTER `memberpoint`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `icitem` MODIFY COLUMN `COLORID` VARCHAR(40) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
 MODIFY COLUMN `SIZEID` VARCHAR(40) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
 DROP INDEX `ITEMINFO`,
 ADD INDEX `ITEMINFO` USING BTREE(`ITEMNO`, `DESP`, `SHELF`, `COSTCODE`, `UNIT`, `GRADED`, `WSERIALNO`, `NONSTKITEM`, `COLOR`, `SIZE`);

	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `artran` MODIFY COLUMN `VAN` VARCHAR(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '';
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `ictran` MODIFY COLUMN `VAN` VARCHAR(15) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '';
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `ictrantemp` MODIFY COLUMN `VAN` VARCHAR(15) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '';

	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `mysqlpass` VARCHAR(20) DEFAULT '12345' AFTER `memdisc`
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
     <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	CREATE TABLE  `pospayment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `creditcard` varchar(45) DEFAULT 'Y',
  `NETS` varchar(45) DEFAULT 'Y',
  `cashcard` varchar(45) DEFAULT 'Y',
  `voucher` varchar(45) DEFAULT 'Y',
  `cheque` varchar(45) DEFAULT 'Y',
  `deposit` varchar(45) DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `batchdate` DATE NOT NULL DEFAULT '2011-01-01' AFTER `memdisc`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	update displaysetup set itemsearch_ucost=''
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `voidtransfer` VARCHAR(1) DEFAULT 'N' AFTER `lcs`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `ictran` ADD COLUMN `originalqty` DOUBLE(17,7) NOT NULL DEFAULT '0.0000000' AFTER `qty`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `posftp` ADD COLUMN `tranno` VARCHAR(45) DEFAULT '0' AFTER `mall`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `gsetup` ADD COLUMN `fontsize` VARCHAR(2) DEFAULT '16' AFTER `lcs`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	CREATE TABLE  `expresspickitem` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `itemno` text,
      `desp` text,
      `created_on` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
      `uuid` varchar(100) DEFAULT '',
      PRIMARY KEY (`id`)
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	ALTER TABLE `ictrantemp` MODIFY COLUMN `ITEMNO` VARCHAR(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '';

	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
	CREATE TABLE  `reserve` (
      `reserveno` varchar(100) NOT NULL DEFAULT '',
      `name` varchar(150) DEFAULT '',
      `grossamt` double(17,7) NOT NULL DEFAULT '0.0000000',
      `phone` varchar(150) DEFAULT '',
      `email` varchar(150) DEFAULT '',
      `note` text,
      `status` varchar(45) DEFAULT '',
      PRIMARY KEY (`reserveno`) USING BTREE
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
    CREATE TABLE  `reservedet` (
      `reserveno` varchar(100) NOT NULL DEFAULT '',
      `trancode` int(4) unsigned NOT NULL DEFAULT '0',
      `itemno` varchar(100) NOT NULL DEFAULT '',
      `desp` varchar(100) NOT NULL DEFAULT '',
      `qty_bil` double(17,5) NOT NULL DEFAULT '0.00000',
      `price_bil` double(17,5) NOT NULL DEFAULT '0.00000',
      `dispec1` varchar(10) NOT NULL DEFAULT '0',
      `dispec2` varchar(10) NOT NULL DEFAULT '0',
      `dispec3` varchar(10) NOT NULL DEFAULT '0',
      `disamt_bil` varchar(45) NOT NULL DEFAULT '0',
      `amt_bil` double(17,5) NOT NULL DEFAULT '0.00000',
      `taxpec1` varchar(10) NOT NULL DEFAULT '0',
      `taxpec2` varchar(10) NOT NULL DEFAULT '0',
      `taxpec3` varchar(10) NOT NULL DEFAULT '0',
      `taxamt_bil` double(17,5) NOT NULL DEFAULT '0.00000',
      `despa` varchar(100) DEFAULT '',
      `note_a` varchar(100) DEFAULT '',
      `status` varchar(45) DEFAULT '',
      PRIMARY KEY (`reserveno`,`trancode`) USING BTREE
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
    CREATE TABLE  `reservestock` (
      `itemno` varchar(150) NOT NULL,
      `pp` double(17,7) NOT NULL,
      `gwc` double(17,7) NOT NULL,
      `mbs` double(17,7) NOT NULL,
      `rf` double(17,7) NOT NULL,
      PRIMARY KEY (`itemno`)
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
    ALTER TABLE `reserve` ADD COLUMN `location` VARCHAR(150) DEFAULT '' AFTER `status`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
    ALTER TABLE `reserve` ADD COLUMN `depositno` VARCHAR(150) AFTER `location`,
 ADD COLUMN `depositamt` DOUBLE(17,7) NOT NULL DEFAULT '0.0000000' AFTER `depositno`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
    ALTER TABLE `reserve` ADD COLUMN `depositno` VARCHAR(150) AFTER `location`,
 ADD COLUMN `depositamt` DOUBLE(17,7) NOT NULL DEFAULT '0.0000000' AFTER `depositno`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
    ALTER TABLE `reservedet` ADD COLUMN `location` VARCHAR(100) DEFAULT '' AFTER `status`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
    CREATE TABLE  `staffattendance` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `wos_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
      `Cashier` varchar(200) DEFAULT '',
      `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
      `created_by` varchar(200) DEFAULT '',
      `logintype` varchar(45) DEFAULT '',
      PRIMARY KEY (`id`)
    ) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
    ALTER TABLE `dailycounter` ADD COLUMN `desp` VARCHAR(450) DEFAULT '' AFTER `type`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
   ALTER TABLE `pospayment` ADD COLUMN `sccancel` VARCHAR(45) DEFAULT 'Ctrl+1' AFTER `deposit`,
 ADD COLUMN `scdeposit` VARCHAR(45) DEFAULT 'Ctrl+2' AFTER `sccancel`,
 ADD COLUMN `sccash` VARCHAR(45) DEFAULT 'Ctrl+3' AFTER `scdeposit`,
 ADD COLUMN `scnet` VARCHAR(45) DEFAULT 'Ctrl+4' AFTER `sccash`,
 ADD COLUMN `sccreditcard` VARCHAR(45) DEFAULT 'Ctrl+5' AFTER `scnet`,
 ADD COLUMN `sccheque` VARCHAR(45) DEFAULT 'Ctrl+6' AFTER `sccreditcard`,
 ADD COLUMN `sccashcard` VARCHAR(45) DEFAULT 'Ctrl+7' AFTER `sccheque`,
 ADD COLUMN `scmulti` VARCHAR(45) DEFAULT 'Ctrl+8' AFTER `sccashcard`,
 ADD COLUMN `scclose` VARCHAR(45) DEFAULT 'Ctrl+9' AFTER `scmulti`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
        CREATE TABLE  `print_barcode_setting` (
          `no_copies` varchar(45) DEFAULT NULL,
          `id` int(11) NOT NULL DEFAULT '1',
          `wide_version` varchar(45) DEFAULT NULL,
          `bar_code` varchar(45) DEFAULT NULL,
          `format_2` varchar(45) DEFAULT NULL,
          `format_3` varchar(45) DEFAULT NULL,
          `spacing` varchar(45) DEFAULT NULL,
          `top_spacing` varchar(45) DEFAULT NULL,
          `left_spacing` varchar(45) DEFAULT NULL,
          `font_size` varchar(45) DEFAULT NULL,
          `format_4` varchar(45) DEFAULT NULL,
          `barcodewidth` varchar(45) DEFAULT '',
          `format_5` varchar(45) DEFAULT '',
          `format_6` varchar(45) DEFAULT '',
          PRIMARY KEY (`id`)
        ) ENGINE=MyISAM DEFAULT CHARSET=latin1;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>

    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		ALTER TABLE `pospayment` ADD COLUMN `scsearch` VARCHAR(45) DEFAULT 'Ctrl+0' AFTER `scclose`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		ALTER TABLE `driver` ADD COLUMN `pricelevel` VARCHAR(10) DEFAULT '' AFTER `pointsredeem`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		ALTER TABLE `gsetup` ADD COLUMN `df_mem_price` VARCHAR(1) DEFAULT '1' AFTER `mysqlpass`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		ALTER TABLE `gsetup` ADD COLUMN `editbillpassword` VARCHAR(45) DEFAULT '' AFTER `lcs`,
 ADD COLUMN `editbillpassword1` VARCHAR(45) DEFAULT '' AFTER `editbillpassword`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		ALTER TABLE `vouchertype` ADD COLUMN `voucheramt` DOUBLE(17,7) NOT NULL DEFAULT '0.000000' AFTER `updated_on`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		ALTER TABLE `driver` ADD COLUMN `icno` VARCHAR(45) DEFAULT '' AFTER `created_on`,
        ADD COLUMN `dob` VARCHAR(45) DEFAULT '' AFTER `icno`,
        ADD COLUMN `gender` VARCHAR(45) DEFAULT '' AFTER `dob`
        ADD COLUMN `discontinuedriver` VARCHAR(45) DEFAULT '' AFTER `gender`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		ALTER TABLE `driver` ADD COLUMN `phone` VARCHAR(100) DEFAULT '' AFTER `discontinuedriver`,
 ADD COLUMN `phonea` VARCHAR(100) DEFAULT '' AFTER `phone`,
 ADD COLUMN `e_mail` VARCHAR(100) DEFAULT '' AFTER `phonea`;
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		update driver set dob='0000-00-00' where dob is null or dob=''
	</cfquery>
    <cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
	<cftry>
    <cfquery name="altertable38" datasource="#dts#">
		ALTER TABLE `driver` MODIFY COLUMN `dob` DATE DEFAULT '0000-00-00';
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		ALTER TABLE `driver` ADD COLUMN `expiredate` DATE NOT NULL DEFAULT '0000-00-00' AFTER `dob`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		ALTER TABLE `promotion` ADD COLUMN `location` VARCHAR(100) DEFAULT '' AFTER `description`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		insert into refnoset (type,lastusedno,counter) values ('BARC','00000001',1);
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `gsetup` ADD COLUMN `possyncprice` VARCHAR(1) DEFAULT 'Y' AFTER `lcs`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `gsetup` ADD COLUMN `possyncbarcode` VARCHAR(1) DEFAULT 'Y' AFTER `possyncprice`;
 			
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    CREATE TABLE  `supervisor` (
              `supervisorid` varchar(100) NOT NULL DEFAULT '',
              `password` varchar(100) NOT NULL DEFAULT '',
              `name` varchar(100) NOT NULL DEFAULT '',
              PRIMARY KEY (`supervisorid`)
            ) ENGINE=MyISAM DEFAULT CHARSET=utf8;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `pospayment` ADD COLUMN `possync` VARCHAR(45) DEFAULT '1' AFTER `scsearch`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `ictermandcondition` ADD COLUMN `lVOUC` TEXT AFTER `lSAM`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    CREATE TABLE `posvoucherno` (
              `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
              `voucherno` VARCHAR(100) NOT NULL DEFAULT '',
              `amt` DOUBLE(17,7) NOT NULL DEFAULT '0.00',
              `created_on` VARCHAR(100) NOT NULL DEFAULT '',
              `uuid` VARCHAR(100) NOT NULL DEFAULT '',
              PRIMARY KEY (`id`)
            )
            ENGINE = MyISAM;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `pospayment` ADD COLUMN `vouchertype` VARCHAR(45) DEFAULT '' AFTER `voucher`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `locadjtran` ADD COLUMN `trancode` VARCHAR(45) NOT NULL DEFAULT '' AFTER `oairefno`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `pospayment` ADD COLUMN `scfocus` VARCHAR(45) DEFAULT 'Alt+1' AFTER `vouchertype`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `gsetup` ADD COLUMN `laitemno` VARCHAR(45) DEFAULT 'Product code' AFTER `lcs`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `gsetup` ADD COLUMN `ldescription` VARCHAR(45) DEFAULT 'Description' AFTER `lcs`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `modulecontrol` ADD COLUMN `auto` VARCHAR(45) DEFAULT '' AFTER `matrixtran`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `gsetup` ADD COLUMN `disablelocation` VARCHAR(1) DEFAULT '' AFTER `lcs`;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    ALTER TABLE `modulecontrol` ADD COLUMN `project` VARCHAR(45) DEFAULT '' AFTER `auto`,
 ADD COLUMN `job` VARCHAR(45) DEFAULT '' AFTER `project`,
 ADD COLUMN `package` VARCHAR(45) DEFAULT '' AFTER `job`,
 ;
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable38" datasource="#dts#">
		    CREATE TABLE `fifoitemstatus` (
              `itemno` varchar(100) NOT NULL DEFAULT '',
              `aitemno` varchar(100) DEFAULT '',
              `desp` varchar(450) DEFAULT '',
              `despa` varchar(450) DEFAULT '',
              `unit` varchar(100) DEFAULT '',
              `qtybf` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin11` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin12` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin13` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin14` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin15` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin16` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin17` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin18` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin19` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin20` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin21` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin22` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin23` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin24` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin25` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin26` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin27` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qin28` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout11` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout12` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout13` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout14` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout15` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout16` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout17` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout18` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout19` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout20` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout21` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout22` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout23` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout24` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout25` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout26` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout27` double(17,7) NOT NULL DEFAULT '0.0000000',
              `qout28` double(17,7) NOT NULL DEFAULT '0.0000000',
              `supp` varchar(100) DEFAULT '',
              `brand` varchar(100) DEFAULT '',
              `category` varchar(100) DEFAULT '',
              `wos_group` varchar(100) DEFAULT '',
              `itemtype` varchar(45) DEFAULT '',
              `uuid` varchar(100) NOT NULL DEFAULT '',
              PRIMARY KEY (`itemno`,`uuid`) USING BTREE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC; 
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
    
    <cftry>
    <cfquery name="altertable39" datasource="#dts#">
		    insert into userpin (code,desp,super,admin,standard,general,limited,mobile) values ('1312','View Only','T','T','T','','',''),('41H0','Consignment Out','T','T','T','','','')

	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>
    
     <cftry>
    <cfquery name="altertable40" datasource="#dts#">
		    ALTER TABLE `userpin2` ADD COLUMN `H1312` CHAR(1) NOT NULL DEFAULT 'T';
	</cfquery>
	<cfcatch type="any">
		<!---<cfoutput>#dts#-#cfcatch.Message#:#cfcatch.Detail#</cfoutput>---><br>	
	</cfcatch>
    </cftry>


    
    
<script type="text/javascript">
alert('Update Complete!');
window.location.href="/index.cfm";
</script>

    

Finish.

</body>
</html>