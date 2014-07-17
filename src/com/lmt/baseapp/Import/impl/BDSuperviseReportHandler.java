package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class BDSuperviseReportHandler{
	//�Ե������ݼӹ�����,���뵽�м��Batch_Import_Interim
	public static void interimProcess(String sReportConfigNo,String sKey,Transaction Sqlca) throws Exception{
		//String sSql="";
		/*
		//1������ظ��ͻ�-----��ͬsheetͬһ�ͻ��ظ�ʱ��importNo��ͬ  ��һ��sheet���ظ�ͬһ�ͻ�ʱ��importNo��ͬ��importIndex��ͬ ��
		sSql="delete from Batch_Import BI1 where ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
					" and ~s�ͻ���ϸ@�ͻ�����e~  in "+
						"(select BI2.~s�ͻ���ϸ@�ͻ�����e~ from Batch_Import BI2"+
						" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)"+
					" and ImportNo||ImportIndex not in "+
						"(select max(ImportNo||ImportIndex) from Batch_Import BI2 "+
						" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		
 		sSql="delete from Batch_Import_Interim BI1 where ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
				" and ~s�ͻ���ϸ@�ͻ�����e~  in "+
					"(select BI2.~s�ͻ���ϸ@�ͻ�����e~ from Batch_Import_Interim BI2"+
					" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)"+
				" and ImportNo||ImportIndex not in "+
					"(select max(ImportNo||ImportIndex) from Batch_Import_Interim BI2 "+
					" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		*/
	}
	/**
	 * ������ά�Ȳ��뵽�������
	 * @throws Exception 
	 */
	public static void process(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy,String sWhere) throws Exception{
		//1�����Թ���˽�����ֻ��ܵ��������
		//��λ����Ԫ
		String sCSql="select  '�Թ�����' as Type, "+
				"		round(sum(~s�����ϸ@���(Ԫ)e~)/100000000,2) as Balance"+
				"		from Batch_Import_Interim where ConfigName ='�����ϸ' and OneKey ='"+sKey+"'"+
				"	union all"+
				"	select '��˽����' as Type, "+
				"		round(sum(~s������ϸ@���e~)/100000000,2) as Balance"+
				"		from Batch_Import_Interim where ConfigName ='������ϸ' and OneKey ='"+sKey+"' and ~s������ϸ@ҵ��Ʒ��e~ not in('����ί�д���','����ס�����������')"+
				"	union all"+
				"	select '����' as Type, "+
				"		round(~sG0103_�����@����Һϼ�e~/10000,2) as Balance"+
				"		from Batch_Import_Interim where ConfigName ='G0103_�����' and OneKey ='"+sKey+"' and ~sG0103_�����@��Ŀe~='1.3���ּ����ʽת����'";
		String sSql="select "+
 				"'"+HandlerFlag+"','"+sReportConfigNo+"','"+sKey+"','"+Dimension+"',Type,Balance,"+
				"'"+StringFunction.getTodayNow()+"'"+
				" from ("+sCSql+")tab";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,Balance,InputTime)"+
 				"( "+
 				sSql+
 				")");
	}
	//����С�� �ϼ� ��������Ƚ�ֵ
	public static void afterProcess(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//2���������ά�ȵ��ܼ�
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,'�ܼ�',sum(Balance) "+
			"from Batch_Import_Process "+
			"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"'"+
			"group by HandlerFlag,ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,Balance)"+
 				"( "+
 				sSql+
 				")");
 		//4�����ǰһ�������ֵ�ͷ��ȸ���
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
			 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
			 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY " +
			 			"from "+
						"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+
							"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"'"+
						")tab1"+
						" left join (select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+	
						"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
						")tab2 on tab1.Dimension=tab2.Dimension and nvl(tab1.DimensionValue,'')=nvl(tab2.DimensionValue,'')" +
					")tab3"+
			" where tab.Dimension=tab3.Dimension and nvl(tab.DimensionValue,'')=nvl(tab3.DimensionValue,'')";	
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 							"set(BalanceTLY,BalanceRangeTLY)="+
 								"(select tab3.BalanceTLY,tab3.BalanceRangeTLY "+sSql+")"+
 						 " where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
 						 " and exists(select 1 "+sSql+")"
 				);
	}
}