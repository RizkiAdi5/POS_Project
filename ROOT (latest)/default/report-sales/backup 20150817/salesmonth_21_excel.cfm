<!---
 WARNING:  File extension were not heavily tested
--->
<cfscript>
	pathToOutFile = "#HRootPath#\Excel_Report\#dts#_SR4_#huserid#.xls";
	
	//headerList = "ITEM CODE,ITEM DESCRIPTION,TOTAL";
	//headerlist=javacast("string",form.periodfrom)&"ITEM CODE,ITEM DESCRIPTION,TOTAL";
	periodfr = javacast("int",form.periodfrom);
	periodto = javacast("int",form.periodto);
	
	if(form.label eq "salesqty" or form.label eq "salesqtyvalue"){
		headerlist="ITEM CODE,ITEM DESCRIPTION,UNIT,TOTAL";
	}
	else{
		headerlist="ITEM CODE,ITEM DESCRIPTION,TOTAL";
	}
	
	for (i=periodfr;i LTE periodto;i=i+1){		
		headerlist=headerlist&","&javacast("string",dateformat(dateadd('m',i,getgeneral.lastaccyear),"mmm yy"));
	}
	
	//create a new workbook and worksheet
	book = createObject("java", "org.apache.poi.hssf.usermodel.HSSFWorkbook").init();
	HSSFPrintSetup = createObject("java","org.apache.poi.hssf.usermodel.HSSFPrintSetup");
	HSSFCellStyle = createObject("java","org.apache.poi.hssf.usermodel.HSSFCellStyle");
	HSSFFont = createObject("java","org.apache.poi.hssf.usermodel.HSSFFont");
	HSSFDataFormat = createObject("java","org.apache.poi.hssf.usermodel.HSSFDataFormat");
	HSSFRegion=createObject("java","org.apache.poi.hssf.util.Region");
	//RegionUtil = createObject("java","org.apache.poi.hssf.usermodel.contrib.HSSFRegionUtil").init();
	
	sheet = book.createSheet("SalesReportByProduct");
	sheet.setColumnWidth(0,4000);  //ITEM CODE
	sheet.setColumnWidth(1,9000);  //ITEM DESCRIPTION
	
	columncount = 2;
	if(form.label eq "salesqty" or form.label eq "salesqtyvalue"){
		sheet.setColumnWidth(javacast("int",columncount),3000);  //UNIT
		columncount=columncount+1;
	}
	sheet.setColumnWidth(javacast("int",columncount),3000);  //TOTAL
	columncount=columncount+1;
	if(form.label eq "salesqtyvalue"){
		sheet.setColumnWidth(javacast("int",columncount),3000);  //TOTAL 2
		columncount=columncount+1;
	}
	//columncount = 3;
	for (i=periodfr;i LTE periodto;i=i+1){
		sheet.setColumnWidth(javacast("int",columncount),3000);  //MONTH YEAR
		columncount=columncount+1;
		if(form.label eq "salesqtyvalue"){
			sheet.setColumnWidth(javacast("int",columncount),3000);  //MONTH YEAR
			columncount=columncount+1;
		}
	}
	
	//RowOffset = -1;
	sheet.setMargin(sheet.LeftMargin,0.6);
	sheet.setMargin(sheet.RightMargin,0.75);
	sheet.setMargin(sheet.TopMargin,0.75);
	sheet.setMargin(sheet.BottomMargin,0.99);
	
	ps = sheet.getPrintSetup();
	ps.setPaperSize(HSSFPrintSetup.A4_PAPERSIZE);
	ps.setLandscape(JavaCast("boolean",true));
	ps.setFitWidth(0);
	
	//Font Style
	font = book.createFont();
	font.setFontName("Arial");
	font.setBoldWeight(HSSFFont.BOLDWEIGHT_BOLD);
	
	font2 = book.createFont();
	font2.setFontName("Arial");
	
	font3 = book.createFont();
	font3.setFontName("Times New Roman");	
	font3.setBoldWeight(HSSFFont.BOLDWEIGHT_BOLD);
	font3.setColor(HSSFFont.COLOR_RED);
	font3.setFontHeightInPoints(12);
	
	sTitle = book.createCellStyle();  
	sTitle.setFont(font3);
	sTitle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
	
	sHeader = book.createCellStyle();
	sHeader.setFont(font);
	sHeader.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	sHeader.setBorderTop(HSSFCellStyle.BORDER_THIN);
	sHeader.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	sHeader.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	sHeader.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
	
	sHeader2 = book.createCellStyle();
	sHeader2.setFont(font);
	sHeader2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	sHeader2.setBorderTop(HSSFCellStyle.BORDER_THIN);
	sHeader2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	sHeader2.setBorderRight(HSSFCellStyle.BORDER_THIN);
	sHeader2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	sHeader2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
	
	sBodyNumber = book.createCellStyle();
	sBodyNumber.setFont(font2);
	sBodyNumber.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	
	sBodyPrice = book.createCellStyle();
	sBodyPrice.setFont(font2);
	sBodyPrice.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
	sBodyPrice.setDataFormat("4");
	
	sBodyString = book.createCellStyle();
	sBodyString.setFont(font2);
	sBodyString.setAlignment(HSSFCellStyle.ALIGN_LEFT);
	sBodyString.SetWrapText(JavaCast( "boolean", true ));
	
	sTotal = book.createCellStyle();
	sTotal.setFont(font);
	sTotal.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
	
	sTotalAmt = book.createCellStyle();
	sTotalAmt.setFont(font2);
	sTotalAmt.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
	sTotalAmt.setDataFormat("7");
	sTotalAmt.setBorderTop(HSSFCellStyle.BORDER_THIN);
	sTotalAmt.setBorderBottom(HSSFCellStyle.BORDER_DOUBLE);
	
	sTotalNumber = book.createCellStyle();
	sTotalNumber.setFont(font2);
	sTotalNumber.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	sTotalNumber.setBorderTop(HSSFCellStyle.BORDER_THIN);
	sTotalNumber.setBorderBottom(HSSFCellStyle.BORDER_DOUBLE);
	
	if(form.label eq "salesqtyvalue"){
		//if(form.datefrom neq "" and form.dateto neq ""){
			//z=5;
		//}
		//else{
			z=4;
		//}
		//create a region(rowFrom,cellFrom,rowTo,cellTo)
		sheet.addMergedRegion(HSSFRegion.init(javacast("int",z),0,javacast("int",z+1),0));	//ITEM CODE
		
		sheet.addMergedRegion(HSSFRegion.init(javacast("int",z),1,javacast("int",z+1),1));	//ITEM DESP
		sheet.addMergedRegion(HSSFRegion.init(javacast("int",z),2,javacast("int",z+1),2));	//UNIT
		sheet.addMergedRegion(HSSFRegion.init(javacast("int",z),3,javacast("int",z),4));	//TOTAL
		
		x=5;
		y=6;
		for (i=periodfr;i LTE periodto;i=i+1){
			sheet.addMergedRegion(HSSFRegion.init(javacast("int",z),javacast("int",x),javacast("int",z),javacast("int",y)));	//MONTH YEAR
			x=x+2;
			y=y+2;
		}
	}
		
	// Create a row and put some cells in it. Rows are 0 based.    
	count = 0;
	row = sheet.createRow(javacast("int",count));
	cell = row.createCell(0);
	cell.setCellValue(javacast("string",getgeneral["compro"][1]));
	cell.setCellStyle(sTitle);
	   
	count = count + 1;
	row = sheet.createRow(javacast("int",count));
	cell = row.createCell(0);
	cell.setCellValue("SALES  REPORT BY PRODUCT");
	cell.setCellStyle(sTitle);
	
	count = count + 1;
	row = sheet.createRow(javacast("int",count));
	cell = row.createCell(0);
	cell.setCellValue("FROM "&javacast("string",dateformat(dateadd('m',javacast("int",form.periodfrom),getgeneral.lastaccyear),"mmm yy"))&" TO "&javacast("string",dateformat(dateadd('m',javacast("int",form.periodto),getgeneral.lastaccyear),"mmm yy")));
	cell.setCellStyle(sTitle);
	
	//if(form.datefrom neq "" and form.dateto neq ""){
		//count = count + 1;
		//row = sheet.createRow(javacast("int",count));
		//cell = row.createCell(0);
		//cell.setCellValue("FROM "&javacast("string",dateformat(date1,"dd-mm-yyyy"))&" TO "&javacast("string",dateformat(date2,"dd-mm-yyyy")));
		//cell.setCellStyle(sTitle);
	//}
	
	count = count + 2;
	row = sheet.createRow(javacast("int",count));
	row.setHeightInPoints(20.0);
	
	x=0;
	for (i = 1; i lte listlen(headerList); i=i+1){
		//cell = row.createCell(javacast("int",i-1));
		if(form.label eq "salesqtyvalue"){
			if(i gte 4){
				cell = row.createCell(javacast("int",i-1+x));
				
			}else{
				cell = row.createCell(javacast("int",i-1));
			}
			
			cell.setCellValue(listgetat(headerList, i));
			cell.setCellStyle(sHeader);
			
		}else{
			cell = row.createCell(javacast("int",i-1));
			
			cell.setCellValue(listgetat(headerList, i));
			if(i eq listlen(headerList)){
				cell.setCellStyle(sHeader2);
			}else{
				cell.setCellStyle(sHeader);
			}
			//cell.setCellStyle(sHeader);
		}
				
		if(form.label eq "salesqtyvalue"){
			if(i gte 4){
				cell = row.createCell(javacast("int",i+x));
				if(i eq listlen(headerList)){
					cell.setCellStyle(sHeader2);
				}else{
					cell.setCellStyle(sHeader);
				}
				
				x=x+1;
			}
		}
	}
	
	
	if(form.label eq "salesqtyvalue"){
		count = count + 1;
		row = sheet.createRow(javacast("int",count));
		
		cell = row.createCell(0);	//ITEM CODE
		cell.setCellStyle(sHeader);
		
		cell = row.createCell(1);	//ITEM DESP
		cell.setCellStyle(sHeader);
		
		cell = row.createCell(2);	//UNIT
		cell.setCellStyle(sHeader);
		
		//row.setHeightInPoints(20.0);
		cell = row.createCell(3);
		cell.setCellValue(javacast("string","QTY"));
		cell.setCellStyle(sHeader);
		
		cell = row.createCell(4);
		cell.setCellValue(javacast("string","AMT"));
		cell.setCellStyle(sHeader);
		
		x=5;
		y=6;
		for (i=periodfr;i LTE periodto;i=i+1){
			cell = row.createCell(javacast("int",x));
			cell.setCellValue(javacast("string","QTY"));
			cell.setCellStyle(sHeader);
			
			cell = row.createCell(javacast("int",y));
			cell.setCellValue(javacast("string","AMT"));
			//cell.setCellStyle(sHeader);
			if(i eq periodto){
				cell.setCellStyle(sHeader2);
			}else{
				cell.setCellStyle(sHeader);
			}
			x=x+2;
			y=y+2;
		}
	}
	
	// StructKeyArray()
	keys = StructKeyArray(FinalResult);
	arraySort(keys,'numeric');
	size = ArrayLen(keys);
	for (i=1; i LTE size; i=i+1)
	{  
		key = keys[i];  
		value = FinalResult[key]; 
		 
		// do stuff...
		count = count + 1;
		row = sheet.createRow(javacast("int",count));
		
		cell = row.createCell(0);
		cell.setCellValue(javacast("string",value.itemno));
		cell.setCellStyle(sBodyString);
		
		cell = row.createCell(1);
		cell.setCellValue(javacast("string",value.itemdesp));
		cell.setCellStyle(sBodyString);
		
		columncount = 2;
		if(form.label eq "salesqty" or form.label eq "salesqtyvalue"){
			cell = row.createCell(javacast("int",columncount));
			cell.setCellValue(javacast("string",value.unit));
			cell.setCellStyle(sBodyString);
			columncount=columncount+1;
		}
		
		cell = row.createCell(javacast("int",columncount));
		cell.setCellValue(javacast("double",value.total));
		if(form.label eq "salesqty" or form.label eq "salesqtyvalue"){
			cell.setCellStyle(sBodyNumber);
		}
		else{
			cell.setCellStyle(sBodyPrice);
		}
		columncount=columncount+1;
		
		if(form.label eq "salesqtyvalue"){
			cell = row.createCell(javacast("int",columncount));
			cell.setCellValue(javacast("double",value.total2));
			cell.setCellStyle(sBodyPrice);
			
			columncount=columncount+1;
		}
		
		//columncount = 3;
		for (j=periodfr;j LTE periodto;j=j+1){
			
			cell = row.createCell(javacast("int",columncount));
			
			
			if(not structkeyexists(value,"month_"&j))
        	{
            	cell.setCellValue(javacast("double","0"));
        	}
    		else
        	{
            	//amonth="value.month_"&i;
            	cell.setCellValue(javacast("double",value["month_"&j])); 
        	}
						
			if(form.label eq "salesqty" or form.label eq "salesqtyvalue"){
				cell.setCellStyle(sBodyNumber);
			}
			else{
				cell.setCellStyle(sBodyPrice);
			}
					
			columncount=columncount+1;
			
			if(form.label eq "salesqtyvalue"){
				cell = row.createCell(javacast("int",columncount));
			
				if(not structkeyexists(value,"month2_"&j))
	        	{
	            	cell.setCellValue(javacast("double","0"));
	        	}
	    		else
	        	{
	            	cell.setCellValue(javacast("double",value["month2_"&j])); 
	        	}
	        	cell.setCellStyle(sBodyPrice);
				columncount=columncount+1;
			}
		}
	}
	
	count = count + 1;
	row = sheet.createRow(javacast("int",count));
	row.setHeight(330);
	if(form.label eq "salesqty" or form.label eq "salesqtyvalue"){
		counter2=2;
	}
	else{
		counter2=1;
	}
	cell = row.createCell(javacast("int",counter2));
	cell.setCellValue("TOTAL");
	cell.setCellStyle(sBodyString);
	cell.setCellStyle(sTotal);
	counter2=counter2+1;
	
	cell = row.createCell(javacast("int",counter2));
	if(form.label eq "salesqty" or form.label eq "salesqtyvalue"){
		cell.setCellFormula("SUM(D5:D#count#)");
	}
	else{
		cell.setCellFormula("SUM(C5:C#count#)");
	}
	
	//cell.setCellStyle(sTotalAmt);
	if(form.label eq "salesqty" or form.label eq "salesqtyvalue"){
		cell.setCellStyle(sTotalNumber);
	}
	else{
		cell.setCellStyle(sTotalAmt);
	}
	
	if(form.label eq "salesqtyvalue"){
		counter2=counter2+1;
		cell = row.createCell(javacast("int",counter2));
		cell.setCellFormula("SUM(E5:E#count#)");
		cell.setCellStyle(sTotalAmt);	
		
	}
	
	if(form.label eq "salesqty"){
		keycodelist="E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL";
	}
	else if(form.label eq "salesqtyvalue"){
		keycodelist="F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL";
	}
	else{
		keycodelist="D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL";
	}
		
	columncount = counter2+1;
	keycode=1;
	for (j=periodfr;j LTE periodto;j=j+1){
		
		cell = row.createCell(javacast("int",columncount));
		xFormula1="SUM("&listgetat(keycodelist,javacast("int",keycode),",")&"5:"&listgetat(keycodelist,javacast("int",keycode),",")&count&")";
		cell.setCellFormula(xFormula1);
		if(form.label eq "salesqty" or form.label eq "salesqtyvalue"){
			cell.setCellStyle(sTotalNumber);
		}
		else{
			cell.setCellStyle(sTotalAmt);
		}
			
		columncount=columncount+1;
		keycode=keycode+1;
		
		if(form.label eq "salesqtyvalue"){
			cell = row.createCell(javacast("int",columncount));
			xFormula1="SUM("&listgetat(keycodelist,javacast("int",keycode),",")&"5:"&listgetat(keycodelist,javacast("int",keycode),",")&count&")";
			cell.setCellFormula(xFormula1);
			cell.setCellStyle(sTotalAmt);
			
			columncount=columncount+1;
			keycode=keycode+1;
		}
	}
	
	outFile = createObject("java", "java.io.FileOutputStream").init( pathToOutFile );
	book.write( outFile );
	outFile.close();

	WriteOutput("Done!");
</cfscript>

<cfheader name="Content-Disposition" value="inline; filename=SalesReportByProduct.xls">
<cfcontent type="application/vnd.ms-excel" file="#pathToOutFile#">