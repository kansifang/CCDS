package com.amarsoft.ReserveManage;

import java.util.Date;
import java.text.*;

public class StringDeal
{			
	/**
	 * ��ȡ��������֮������� <p>
	 * 
	 * ʾ����<p>
	 * ------------------------------------------<br>
	 * String a=StringFunction.getQuot("1998/02/15","1998/02/10");<br>
	 * System.out.print(a);<br>
	 * ------------------------------------------<br>   
	 * ���õ���5��<br>
	 * 
	 * @param sDate1  �����ַ���
	 * @param sDate2  �����ַ���
	 * @return  ��������֮�������
	 */
	public static long getQuot(String sDate1, String sDate2){ 
		long quot = 0; 
		SimpleDateFormat ft = new SimpleDateFormat("yyyy/MM/dd"); 
		try { 
			Date date1 = ft.parse( sDate1 ); 
			Date date2 = ft.parse( sDate2 ); 
			quot = date1.getTime() - date2.getTime(); 
			quot = quot / 1000 / 60 / 60 / 24; 
		} catch (ParseException e) { 
		e.printStackTrace(); 
		} 
		return quot; 
	} 

	
	
		
	public static void main(String[] args) {
		
	}	
}
