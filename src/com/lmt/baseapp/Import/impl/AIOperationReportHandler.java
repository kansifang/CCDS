package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class AIOperationReportHandler{
	//�Ե������ݼӹ�����,���뵽�м��Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		String sSql="";
 		//1���������Ŀ��Ϊ�գ����ơ��汾��:1410 ��ɫ��Ϊ����ʽ����  ��ɫ��Ϊ���������֡������� 
		sSql="delete from Batch_Import_Interim "+
					"where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
					"and (nvl(~s"+sConfigNo+"@��Ŀe~,'')='' or ~s"+sConfigNo+"@��Ŀe~ like '�汾��:%' or ~s"+sConfigNo+"@��Ŀe~ like '%ɫ��Ϊ%')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
		
	}
	/**
	 * ������ά�Ȳ��뵽�������
	 * @throws Exception 
	 */
	public static void process(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		String sSql="";
		String sConfigName=Sqlca.getString("select CodeName from Code_Catalog where CodeNo='"+sConfigNo+"'");
 		//1�� ��G0103_����� ������н��д���
 		if("G0103_�����".equals(sConfigName)){
 			sSql="select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'������ϸ',~s"+sConfigName+"@��Ŀe~"+
 					",~s"+sConfigName+"@����Һϼ�e~"+//����Ͷ�Ž��
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
 					" and ~s"+sConfigName+"@��Ŀe~ like '1%' ";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 	 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 	 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue"+
 	 				",Balance)"+
 	 				"( "+
 	 				sSql+
 	 				")");
 		}else if("G0107_��ҵ����".equals(sConfigName)){
 			//2�� ��G0107_��ҵ���� ������н��д���
 	 		sSql="select "+
 	 				"'"+HandlerFlag+"',ConfigNo,OneKey,'��ҵ��ϸ',~s"+sConfigName+"@��Ŀe~"+
 					",~s"+sConfigName+"@����Һϼ�e~"+//����Ͷ�Ž��
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' ";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 	 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 	 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue"+
 	 				",Balance)"+
 	 				"( "+
 	 				sSql+
 	 				")");
 		}else if("S6301_�弶���ൣ��_��ҵ��ģ".equals(sConfigName)){
 			//3�� ��S6301_�弶���ൣ��_��ҵ��ģ ������н��д���
 	 		sSql="select "+
 	 				"'"+HandlerFlag+"',ConfigNo,OneKey,'��ҵ��ģ��ϸ','������ҵ@'||~s"+sConfigName+"@��Ŀe~"+
 					",~s"+sConfigName+"@������ҵe~"+
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
 					" union all "+
 					"select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'��ҵ��ģ��ϸ','������ҵ@'||~s"+sConfigName+"@��Ŀe~"+
 					",~s"+sConfigName+"@������ҵe~"+
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
 					" union all "+
 					" select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'��ҵ��ģ��ϸ','С����ҵ@'||~s"+sConfigName+"@��Ŀe~"+
 					",~s"+sConfigName+"@С����ҵe~"+
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
 					" union all "+
 					" select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'��ҵ��ģ��ϸ','΢����ҵ@'||~s"+sConfigName+"@��Ŀe~"+
 					",~s"+sConfigName+"@΢����ҵe~"+
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
 					" union all "+
 					" select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'��ҵ��ģ��ϸ','���������ܶ�500��Ԫ���µ�С΢����ҵ@'||~s"+sConfigName+"@��Ŀe~"+
 					",~s"+sConfigName+"@���������ܶ�500��Ԫ���µ�С΢����ҵe~"+//����Ͷ�Ž��
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' ";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 	 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 	 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue"+
 	 				",Balance)"+
 	 				"( "+
 	 				sSql+
 	 				")");
 		}
	}
	//����С�� �ϼ� ��������Ƚ�ֵ
	public static void afterProcess(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//1���������ά�ȵ�С��
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'С��',"+
			"round(sum(BusinessSum),2) as BusinessSum,round(sum(Balance),2) as Balance "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			"group by ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance)"+
 				"( "+
 				sSql+
 				")");
		//2���������ά�ȵ��ܼ�
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,Dimension,'�ܼ�',"+
			"round(sum(BusinessSum),2) as BusinessSum,round(sum(Balance),2) as Balance "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('С��',DimensionValue)=0 "+
			"group by ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance)"+
 				"( "+
 				sSql+
 				")");
 		//3������ռ��
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,Balance "+
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,Balance "+	
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and DimensionValue='�ܼ�'"+
			")tab2"+
			" where tab1.Dimension=tab2.Dimension";
 		Sqlca.executeSQL("update Batch_Import_Process tab3 "+
 				"set(BalanceRatio)="+
 				"( select BalanceRatio from "+
 				"("+sSql+") tab4 where tab3.Dimension=tab4.Dimension and tab3.DimensionValue=tab4.DimensionValue"+
 				")"+
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 from ("+sSql+") tab22 where tab3.Dimension=tab22.Dimension and tab3.DimensionValue=tab22.DimensionValue)"
 				);
 		//4�����ǰһ�������ֵ�ͷ��ȸ���
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY,"+
 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BalanceRatio,Balance "+
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BalanceRatio,Balance "+	
			"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
			")tab2"+
			" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab3 "+
 				"set(BalanceTLY,BalanceRatioTLY,BalanceRangeTLY)="+
 				"(select BalanceTLY,BalanceRatioTLY,BalanceRangeTLY from "+
 				"("+sSql+") tab4 where tab3.Dimension=tab4.Dimension and tab3.DimensionValue=tab4.DimensionValue"+
 				")"+
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 from ("+sSql+") tab22 where tab3.Dimension=tab22.Dimension and tab3.DimensionValue=tab22.DimensionValue)"
 				);
 			//�������ȵ��룬������һ��������·ݵ�����ֵ������ֵ�ͷ��ȸ���
 		if(StringFunction.isLike(sKey, "%/12")){
 			sSql="select distinct OneKey from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey>'"+sKey+"'";
 			String[] sOneKey=Sqlca.getStringArray(sSql);
 			String OneKeys=StringFunction.toArrayString(sOneKey, "','");
 			sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
 	 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY,"+
 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+
 					"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 				")tab1,"+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+	
 				"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
 				")tab2"+
 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 	 		Sqlca.executeSQL("update Batch_Import_Process tab3 "+
 	 				"set(BalanceTLY,BalanceRatioTLY,BalanceRangeTLY)="+
 	 				"(select BalanceTLY,BalanceRatioTLY,BalanceRangeTLY from "+
 	 				"("+sSql+") tab4 where tab3.OneKey=tab4.OneKey and tab3.Dimension=tab4.Dimension and tab3.DimensionValue=tab4.DimensionValue"+
 	 				")"+
 	 				" where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 from ("+sSql+") tab22 where tab3.OneKey=tab22.OneKey and tab3.Dimension=tab22.Dimension and tab3.DimensionValue=tab22.DimensionValue)"
 	 				);
 		}
	}
}