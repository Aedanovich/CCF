package com.ccfsg.connect.utils;

import java.util.Calendar;

public class DateUtils {

	public static long getFirstDateOfCurrentMonth() 
	{
		Calendar cal=Calendar.getInstance();
		cal.set(Calendar.DAY_OF_MONTH,Calendar.getInstance().getActualMinimum(Calendar.DAY_OF_MONTH));
		cal.set( Calendar.SECOND, 0 );
		cal.set( Calendar.MINUTE, 0 );
		cal.set( Calendar.HOUR_OF_DAY, 0 );
		cal.set( Calendar.MILLISECOND, 0 );
		return cal.getTimeInMillis();
	}
	
	public static long getLastDateOfCurrentMonth() 
	{
		Calendar cal=Calendar.getInstance();
		cal.set(Calendar.DAY_OF_MONTH,Calendar.getInstance().getActualMaximum(Calendar.DAY_OF_MONTH) + 1);
		return cal.getTimeInMillis();
	}
}
