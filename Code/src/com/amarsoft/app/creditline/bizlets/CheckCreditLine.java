/*
		Author: jgao1 2008-09-26
		Tester:
		Describe: 检查授信限额总额是否大于授信总额，检查敞口限额是否高于授信限额
		Input Param:
				LineSum1: 授信限额
				LineSum2: 敞口限额
				ParentLineID:授信总额LineID；
		Output Param:
				1."00":表示正常；
				2."01":表示当前敞口限额大于授信限额；
				3."10"：表示授信限额之和大于授信总额；
				4."11"：表示敞口限额大于授信限额和授信限额之和大于授信总额
		HistoryLog:
*/

package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;



public class CheckCreditLine extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
	 	//获得授信总额的LineID
	 	String sParentLineID = (String)this.getAttribute("ParentLineID");
	 	if(sParentLineID == null) sParentLineID = "";
	 	//获得详情时的LineID号，把他的LineSum1剔除掉
	 	String sSubLineID = (String)this.getAttribute("SubLineID");
		//获得当然输入的授信限额
		String sLineSum1 = (String)this.getAttribute("LineSum1");
		String sCurrency = (String)this.getAttribute("Currency");//当前币种
		String sObjectNo = (String)this.getAttribute("ObjectNo");//合同号
		if(sLineSum1==null||sLineSum1.equals("")) sLineSum1 = "0";
		if(sCurrency == null) sCurrency="";
		if(sObjectNo == null) sObjectNo="";
		//并把当然授信限额从String型转化为double型，当前授信限额变量为sLineSuminput1
		double sLineSuminput1 = Double.parseDouble(sLineSum1);
		//获得当然输入的敞口限额
		String sLineSum2 = (String)this.getAttribute("LineSum2");
		if(sLineSum2==null||sLineSum2.equals("")) sLineSum2 = "0";
		//并把当然敞口限额从String型转化为double型，当前敞口限额变量为sLineSuminput2
		double sLineSuminput2 = Double.parseDouble(sLineSum2);
		
		int dTermMonth = Integer.parseInt((String)this.getAttribute("TermMonth"));
		
		//授信限额之和超过授信总额的标志：1.false表示正常;2.true表示超额.
		boolean flag1 = false;
		//当前输入的敞口限额大于授信限额的标志：1.false表示正常；2.true表示超过.
		boolean flag2 = false;
		//返回值标志：1."00":表示正常；2."01":表示当前敞口限额大于授信限额；3."10"：表示授信限额之和大于授信总额；3."11"：表示敞口限额大于授信限额和授信限额之和大于授信总额。
		String flag3 = "00";
		
		String sSql = "";
		ASResultSet rs = null;
		int dParentTermMonth=0;
		double dBCBusinessSum=0.0,dBCTermMonth = 0.0;//合同信息
		//区合同信息
		sSql = "select LineSum1*getERate(Currency,'01',ERateDate) as BusinessSum, TermMonth from CL_INFO where LineID='"+sParentLineID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dBCBusinessSum = rs.getDouble("BusinessSum");
				dBCTermMonth = rs.getDouble("TermMonth");
			}
			rs.getStatement().close();
		
		
		double sLineSum = 0;
		//在CL_INFO表中取到授信总额
		sSql = "select "+sLineSuminput1+"*getERate('"+sCurrency+"','01','') as LineSum1  from (values 1)  as a ";
	    rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sLineSum = rs.getDouble("LineSum1");//页面录入金额
		}
		rs.getStatement().close();
		
		//所有已经子授信限额总和LineSum
		double LineSum = 0;
		sSql = "select sum(nvl(LineSum1,0)*getERate(Currency,'01',ERateDate))  from CL_INFO where ParentLineID='"+sParentLineID+"' and LineID <> '"+sSubLineID+"'";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			LineSum = rs.getDouble(1);
			
		}
		rs.getStatement().close();
		
		//求所有已经分配的授信限额和当前输入的授信限额之和
		LineSum = LineSum + sLineSum;
		
		//如果所有子授信限额的总和大于授信总额，则超额
		if(LineSum > dBCBusinessSum) 
		{
			flag3 = "01";
		}else if(dTermMonth >dBCTermMonth){
			flag3 = "12";
		}
		
		
		return flag3;
	    
	}

}
