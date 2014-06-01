package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class AfterImportCustomerHandler{
	//�Ե������ݼӹ�����,���뵽�м��Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		
		String sSql="";
		
		//1������ظ��ͻ�-----��ͬsheetͬһ�ͻ��ظ�ʱ��importNo��ͬ  ��һ��sheet���ظ�ͬһ�ͻ�ʱ��importNo��ͬ��importIndex��ͬ ��
		sSql="delete from Batch_Import BI1 where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
					" and ~s�ͻ���ϸ@�ͻ�����e~  in "+
						"(select BI2.~s�ͻ���ϸ@�ͻ�����e~ from Batch_Import BI2"+
						" where BI2.ConfigNo='"+sConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)"+
					" and ImportNo||ImportIndex not in "+
						"(select max(ImportNo||ImportIndex) from Batch_Import BI2 "+
						" where BI2.ConfigNo='"+sConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		
 		sSql="delete from Batch_Import_Interim BI1 where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
				" and ~s�ͻ���ϸ@�ͻ�����e~  in "+
					"(select BI2.~s�ͻ���ϸ@�ͻ�����e~ from Batch_Import_Interim BI2"+
					" where BI2.ConfigNo='"+sConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)"+
				" and ImportNo||ImportIndex not in "+
					"(select max(ImportNo||ImportIndex) from Batch_Import_Interim BI2 "+
					" where BI2.ConfigNo='"+sConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
	}
	/**
	 * ������ά�Ȳ��뵽�������
	 * @throws Exception 
	 */
	public static void process(String sConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy) throws Exception{
		String sSql="";
 		//1�������߼������Ӷ�ͱ�������Ϣ���봦�����
		String groupColumns=groupBy.replaceAll(",","||'@'||");
		groupColumns=("".equals(groupColumns)?"":groupColumns+",");
 		sSql="select "+
 				"ConfigNo,OneKey,'"+Dimension+"',"+groupColumns+
				"round(sum(case when ~s��ͬ��ϸ@��ͬ��ʼ��e~ like '"+sKey+"%' then ~s��ͬ��ϸ@���e~*nvl(getErate(~s��ͬ��ϸ@����e~,'01',''),0) end)/10000,2) as BusinessSum,"+//����Ͷ�Ž��
				"round(sum(~s��ͬ��ϸ@���e~*nvl(getErate(~s��ͬ��ϸ@����e~,'01',''),0))/10000,2) as Balance "+ 
				"from Batch_Import_Interim "+
				"where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s��ͬ��ϸ@���e~,0)>0 "+
				" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'')<>''"+
				" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'X') not in('��������֤','��������֤','���гжһ�Ʊ','�����','��������֤����','ί�д���-����֤','ί�д���') "+
				" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'X') not like '%����%' "+
				" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'X') not like '%���%' "+
				//" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'X') not like '%����%' "+
				"group by ConfigNo,OneKey"+("".equals(groupBy)?"":","+groupBy);
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance)"+
 				"( "+
 				sSql+
 				")");
	}
	//����С�� �ϼ� ��������Ƚ�ֵ
	public static void afterProcess(String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//1���������ά�ȵ�С��
 		sSql="select "+
 				"ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'С��',"+
			"round(sum(BusinessSum),2) as BusinessSum,round(sum(Balance),2) as Balance "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			"group by ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance)"+
 				"( "+
 				sSql+
 				")");
		//2���������ά�ȵ��ܼ�
 		sSql="select "+
 				"ConfigNo,OneKey,Dimension,'�ܼ�',"+
			"round(sum(BusinessSum),2) as BusinessSum,round(sum(Balance),2) as Balance "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('С��',DimensionValue)=0 "+
			"group by ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance)"+
 				"( "+
 				sSql+
 				")");
 		//3�����ǰһ�������ֵ�ͷ��ȸ���
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceToLY,"+
 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeToLY from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+	
			"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
			")tab2"+
			" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 				"set(BalanceTLY,BalanceRangeTLY)="+
 				"(select BalanceToLY,BalanceRangeToLY from "+
 				"("+sSql+") tab2 where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
 				")"+
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 from ("+sSql+") tab22 where tab1.Dimension=tab22.Dimension and tab1.DimensionValue=tab22.DimensionValue)"
 				);
 			//�������ȵ��룬������һ��������·ݵ�����ֵ������ֵ�ͷ��ȸ���
 		if(StringFunction.isLike(sKey, "%/12")){
 			sSql="select distinct OneKey from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey>'"+sKey+"'";
 			String[] sOneKey=Sqlca.getStringArray(sSql);
 			String OneKeys=StringFunction.toArrayString(sOneKey, "','");
 			sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceToLY,"+
 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeToLY from "+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+
 					"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 				")tab1,"+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+	
 				"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
 				")tab2"+
 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 	 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 	 				"set(BalanceTLY,BalanceRangeTLY)="+
 	 				"(select BalanceToLY,BalanceRangeToLY from "+
 	 				"("+sSql+") tab2 where tab1.OneKey=tab2.OneKey and tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
 	 				")"+
 	 				" where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 from ("+sSql+") tab22 where tab1.OneKey=tab22.OneKey and tab1.Dimension=tab22.Dimension and tab1.DimensionValue=tab22.DimensionValue)"
 	 				);
 		}
 		//4��ռ�ȸ���
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+	
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and DimensionValue='�ܼ�'"+
			")tab2"+
			" where tab1.Dimension=tab2.Dimension";
 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 				"set(BusinessSumRatio,BalanceRatio)="+
 				"( select BusinessSumRatio,BalanceRatio from "+
 				"("+sSql+") tab2 where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
 				")"+
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 from ("+sSql+") tab22 where tab1.Dimension=tab22.Dimension and tab1.DimensionValue=tab22.DimensionValue)"
 				);
	}
}