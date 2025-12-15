<cfscript>
/**
 * Returns a date object representing the last day of the given month.
 * 
 * @param strMonth      Month you want to get the last day for, (Required)
 * @param strYear      Year for the specified month.  Useful for leap years.  The default is the current year. (Optional)
 * @return Returns a date object. 
 * @author Ryan Kime (ryan.kime@somnio.com) 
 * @version 1, May 7, 2002 
 */
function LastDayOfMonth(strMonth) {
  var strYear=Year(Now());
  if (ArrayLen(Arguments) gt 1)
    strYear=Arguments[2];
  return DateAdd("d", -1, DateAdd("m", 1, CreateDate(strYear, strMonth, 1)));
}
</cfscript>
