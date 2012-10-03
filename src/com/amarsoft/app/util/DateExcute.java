package com.amarsoft.app.util;

import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;



/**
 * @author lpzhang 2010-5-8 
 * ʱ�任��
 *
 *����ʱע���·�Ҫ��ʵ���·� -1
 */
public class DateExcute extends Bizlet {
		
	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sCurDate = (String)this.getAttribute("CurDate");
		int iMonth = Integer.parseInt((String)this.getAttribute("Month"));
		int iDate = Integer.parseInt((String)this.getAttribute("Date"));
		
		//����ֵת���ɿ��ַ���
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
