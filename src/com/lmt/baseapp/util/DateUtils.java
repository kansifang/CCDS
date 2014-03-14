package com.lmt.baseapp.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class DateUtils {
	protected static Date parseString2Date(String datestring, String format)
			throws Exception {
		try {
			String sDate = "";
			if (datestring.length() == 7)
				sDate = datestring + "/01";
			else if (datestring.length() == 4)
				sDate = datestring + "/01/01";
			else {
				sDate = datestring;
			}
			Date date = new SimpleDateFormat(format).parse(sDate);
			return date;
		} catch (Exception e) {
			throw new Exception("字符'" + datestring + "'转换异常" + e);
		}
	}

	public static Date parseString2Date(String datestring) throws Exception {
		return parseString2Date(datestring, "yyyy/MM/dd");
	}

	public static String parseDateFormat(Date date, String sFormat) {
		SimpleDateFormat sdf = new SimpleDateFormat(sFormat);
		GregorianCalendar gc = new GregorianCalendar();
		gc.setTime(date);
		return sdf.format(gc.getTime());
	}

	public static String getRelativeDate(Date date, int iYear, int iMonth,
			int iDate, String sFormat) {
		SimpleDateFormat sdf = new SimpleDateFormat(sFormat);
		GregorianCalendar gc = new GregorianCalendar();

		gc.setTime(date);

		gc.add(1, iYear);
		gc.add(2, iMonth);
		gc.add(5, iDate);

		return sdf.format(gc.getTime());
	}

	public static String getRelativeDate(String sDate, int iYear, int iMonth,
			int iDate, String sFormat) throws Exception {
		Date date = parseString2Date(sDate, "yyyy/MM/dd");
		return getRelativeDate(date, iYear, iMonth, iDate, sFormat);
	}

	public static String getRelativeDate(Date date, int iYear, int iMonth,
			int iDate) {
		return getRelativeDate(date, iYear, iMonth, iDate, "yyyy/MM/dd");
	}

	public static String getRelativeDate(String sDate, int iYear, int iMonth,
			int iDate) throws Exception {
		return getRelativeDate(sDate, iYear, iMonth, iDate, "yyyy/MM/dd");
	}
	public static String getRelativeMonth(Date date, int iYear, int iMonth,
			String s) {
		return getRelativeDate(date, iYear, iMonth, 0, s);
	}
	public static String getQuaterInfo(String datetime, int offset)
			throws Exception {
		String[] sDateInfo = getQuarterTime(datetime);
		String sMonthRange = sDateInfo[0] + "/" + sDateInfo[1];
		int iStep = offset * 3;
		String sQuaterValue = getRelativeMonth(sMonthRange + "/01", 0, iStep);

		return sQuaterValue;
	}
	public static String getRelativeMonth(String sDate, int iYear, int iMonth,
			String s) throws Exception {
		return getRelativeDate(sDate, iYear, iMonth, 0, s);
	}

	public static String getRelativeMonth(Date date, int iYear, int iMonth) {
		return getRelativeDate(date, iYear, iMonth, 0, "yyyy/MM");
	}

	public static String getRelativeMonth(String sDate, int iYear, int iMonth)
			throws Exception {
		return getRelativeDate(sDate, iYear, iMonth, 0, "yyyy/MM");
	}

	public static boolean isMonthEnd(String sEndDate) throws Exception {
		return getRelativeDate(sEndDate, 0, 0, 1).substring(8, 10).equals("01");
	}

	public static String formatDate(String sDate, String format)
			throws Exception {
		if (sDate.length() == 8) {
			sDate = parseDateFormat(parseString2Date(sDate, "yyyyMMdd"), format);
		}
		return sDate;
	}

	public static String formatDate(String sDate) throws Exception {
		return formatDate(sDate, "yyyy/MM/dd");
	}

	public static String getNowTime(String format) {
		return parseDateFormat(new Date(), format);
	}

	public static String getNowTime() {
		return getNowTime("yyyy/MM/dd HH:mm:ss:SS");
	}

	public static String getToday(String sFormat) {
		return getNowTime(sFormat);
	}

	public static String getToday() {
		return getToday("yyyy/MM/dd");
	}

	public static String getFillInDate(String sdate) throws Exception {
		Date date = parseString2Date(sdate);
		String sFillinDate = "";
		switch (sdate.length()) {
		case 7:
			sFillinDate = parseDateFormat(date, "yyyy 年 MM 月");
			break;
		case 10:
			sFillinDate = parseDateFormat(date, "yyyy 年 MM 月 dd 日");
			break;
		}

		return sFillinDate;
	}

	public static String getFillinParam(String sDate, int iScal) {
		if (iScal <= 0) {
			return sDate;
		}
		String[] sDateInfo = StringUtils.toStringArray(sDate, "/");
		if (sDateInfo.length >= iScal) {
			return sDateInfo[(iScal - 1)];
		}
		return sDate;
	}

	public static String[] getQuaterTime(String datetime, String seperator) {
		String[] sOriginTime = StringUtils.toStringArray(datetime, seperator);
		int iMonth = Integer.parseInt(sOriginTime[1]);
		int iQuarter = (iMonth + 2) / 3;
		String[] sQuarterTime = new String[2];
		System.arraycopy(sOriginTime, 0, sQuarterTime, 0, 2);

		switch (iQuarter) {
		case 1:
			sQuarterTime[1] = "03";
			break;
		case 2:
			sQuarterTime[1] = "06";
			break;
		case 3:
			sQuarterTime[1] = "09";
			break;
		case 4:
			sQuarterTime[1] = "12";
		}

		return sQuarterTime;
	}

	public static String[] getQuarterTime(String datetime) {
		return getQuaterTime(datetime, "/");
	}

	public static String getQuaterName(String datetime) {
		String[] sDateInfo = getQuarterTime(datetime);
		String sQuarter = "";
		switch (Integer.parseInt(sDateInfo[1]) / 3) {
		case 1:
			sQuarter = "第 一 季度";
			break;
		case 2:
			sQuarter = "第 二 季度";
			break;
		case 3:
			sQuarter = "第 三 季度";
			break;
		case 4:
			sQuarter = "第 四 季度";
		}

		return sDateInfo[0] + " 年 " + sQuarter;
	}



	public static String getYearInfo(String datetime, int offset)
			throws Exception {
		String[] sDateInfo = getQuarterTime(datetime);
		if (sDateInfo[1].compareTo("06") > 0)
			sDateInfo[1] = "12";
		else {
			sDateInfo[1] = "06";
		}
		int iStep = offset * 6;
		return getRelativeMonth(sDateInfo[0] + "/" + sDateInfo[1] + "/01", 0,
				iStep);
	}

	public static boolean isDateString(String date) {
		int[] iaMonthDays = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

		String[] iaDate = new String[3];

		if (!date
				.matches("[0-9]{4}[/|-]?[0-1]{1}[0-9]{1}[/|-]?[0-3]{1}[0-9]{1}")) {
			return false;
		}
		if (date.length() == 8) {
			iaDate[0] = date.substring(0, 4);
			iaDate[1] = date.substring(4, 6);
			iaDate[2] = date.substring(6, 8);
		} else {
			iaDate[0] = date.substring(0, 4);
			iaDate[1] = date.substring(5, 7);
			iaDate[2] = date.substring(8, 10);
		}
		int year = Integer.parseInt(iaDate[0]);
		int month = Integer.parseInt(iaDate[1]);
		int day = Integer.parseInt(iaDate[2]);

		if ((year < 1900) || (year > 2100)) {
			return false;
		}
		if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
			iaMonthDays[1] = 29;
		}
		if ((month < 1) || (month > 12)) {
			return false;
		}

		return (day >= 1) && (day <= iaMonthDays[(month - 1)]);
	}
}