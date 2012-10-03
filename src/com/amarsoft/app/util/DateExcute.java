package com.amarsoft.app.util;

import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;



/**
 * @author lpzhang 2010-5-8 
 * 时间换算
 *
 *调用时注意月份要比实际月份 -1
 */
public class DateExcute extends Bizlet {
		
	public Object  run(Transaction Sqlca) throws Exception
	{		
		//获取参数：对象类型和对象编号
		String sCurDate = (String)this.getAttribute("CurDate");
		int iMonth = Integer.parseInt((String)this.getAttribute("Month"));
		int iDate = Integer.parseInt((String)this.getAttribute("Date"));
		
		//将空值转化成空字符串
		if(sCurDate == null) sCurDate = "";
		String TarDate = "";
		
		GregorianCalendar gr=new GregorianCalendar(Integer.parseInt(sCurDate.substring(0,4)),Integer.parseInt(sCurDate.substring(5,7)),Integer.parseInt(sCurDate.substring(8, 10)));
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	    gr.add(GregorianCalendar.MONTH,iMonth); 
	    gr.add(GregorianCalendar.DATE,iDate); 
	    TarDate = sdf.format(gr.getTime());
	    
	    return  TarDate;
			
	}

}
