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
					"and (nvl(~s"+sConfigNo+"@��Ŀe~,'')='' or ~s"+sConfigNo+"@��Ŀe~ like '�汾��:%' or ~s"+sConfigNo+"@��Ŀe~ like '%ɫ��Ϊ%' or ~s"+sConfigNo+"@��Ŀe~ like '����%')";
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
 		
		if("G0101_����".equals(sConfigName)){
 			//1�� ��G0103_����� ������н��д���
 			sSql="select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'������ϸ',~s"+sConfigName+"@��Ŀe~"+
 					",round(~s"+sConfigName+"@����Һϼ�e~/10000,2)"+
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
 					" and (~s"+sConfigName+"@��Ŀe~ like '3.%' or ~s"+sConfigName+"@��Ŀe~ like '4.%' or ~s"+sConfigName+"@��Ŀe~ like '5.%' or ~s"+sConfigName+"@��Ŀe~ like '6.%') ";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 	 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 	 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue"+
 	 				",Balance)"+
 	 				"( "+
 	 				sSql+
 	 				")");
 	 		//�жҰ�������ʽ
 	 		String groupBy="case when ~s������ϸ@��Ҫ������ʽe~ like '��֤-%' then '��֤' "+
 		 			"when ~s������ϸ@��Ҫ������ʽe~ like '��Ѻ-%' then '��Ѻ' "+
 		 			"when ~s������ϸ@��Ҫ������ʽe~ = '����' then '����' "+
 		 			"when ~s������ϸ@��Ҫ������ʽe~ like '%��Ѻ-%' or ~s������ϸ@��Ҫ������ʽe~='��֤��' then '��Ѻ' "+
 		 			"else '����' end";
 	 		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='b20140606000001' and OneKey='"+sKey+"'");
 		 	AIDuebillHandler.process(HandlerFlag,"b20140606000001",sKey,Sqlca,"��һ������ʽ",groupBy,"and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'");
 		 	//�жҰ���Ӫ���ͣ��£�
 		 	groupBy="case "+
 	 				"when ~s������ϸ@��Ӫ����(��)e~ like '%ú̿����%' or ~s������ϸ@��Ӫ����(��)e~ like '%ú̿ϴѡ%' then 'ú̿' "+
 	 				"when ~s������ϸ@��Ӫ����(��)e~ like '%��̼%' then '��̼' "+//��̼��
 	 				"when ~s������ϸ@��Ӫ����(��)e~ like '%����ҵ%' or ~s������ϸ@��Ӫ����(��)e~ like '%һ��ӹ�%' then '����ҵ' "+//����ҵ��
 	 				"when ~s������ϸ@��Ӫ����(��)e~ like '%��������%' then '��������' "+//�������ۡ�
 	 				"when ~s������ϸ@��Ӫ����(��)e~ like '%����%' then '����' "+
 	 				"when ~s������ϸ@��Ӫ����(��)e~ like '%��������%' then '��������' "+
 		 			"when ~s������ϸ@��Ӫ����(��)e~ like '%���ز�%' then '���ز�' "+
 		 			"when ~s������ϸ@��Ӫ����(��)e~ like '%����ʩ��%' then '����ʩ��' "+
 		 			"when ~s������ϸ@��Ӫ����(��)e~ like '%���󿪲�%' then '���󿪲�' "+
 		 			"when ~s������ϸ@��Ӫ����(��)e~ like '%ũ��������%' then 'ũ��������' "+
 		 			"when ~s������ϸ@��Ӫ����(��)e~ like '%����ƽ̨%' then '����ƽ̨' "+
 					"when ~s������ϸ@��Ӫ����(��)e~ like '%��ó��%' or ~s������ϸ@��Ӫ����(��)e~ like '%�ֲ�����%' then '��ó��' "+
 					"when ~s������ϸ@��Ӫ����(��)e~ like '%ҽҩ����%' then 'ҽҩ����' "+
 					"when ~s������ϸ@��Ӫ����(��)e~ like '%ȼ�������͹�Ӧ%' then 'ȼ�������͹�Ӧ' "+
 					"when ~s������ϸ@��Ӫ����(��)e~ like '%����ά�޼�����%' then '����ά�޼�����' "+
 					"when ~s������ϸ@��Ӫ����(��)e~ like '%����%' then '����' "+
 					"when ~s������ϸ@��Ӫ����(��)e~ like '%ס�޲���%' then 'ס�޲���' "+
 		 			"when ~s������ϸ@��Ӫ����(��)e~ like '%��ͨ����%' then '��ͨ����' "+
 		 			"when ~s������ϸ@��Ӫ����(��)e~ like '%ҽԺѧУ%' then 'ҽԺѧУ' "+
 		 			"when ~s������ϸ@��Ӫ����(��)e~ like '%��Ϣ����%' then '��Ϣ����' "+
 		 			"when ~s������ϸ@��Ӫ����(��)e~ like '%�Ļ�����%' then '�Ļ�����' "+
 					"when ~s������ϸ@��Ӫ����(��)e~ like '%��ɫұ��%' then '��ɫұ��' "+
 		 			"else '����' end";
 		 	AIDuebillHandler.process(HandlerFlag,"b20140606000001",sKey,Sqlca,"��Ӫ����(��)",groupBy,"and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'");
 		 	AIDuebillHandler.afterProcess(HandlerFlag,"b20140606000001", sKey, Sqlca);
 		}else if("G0103_�����".equals(sConfigName)){
 			//1�� ��G0103_����� ������н��д���
 			sSql="select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'������ϸ',~s"+sConfigName+"@��Ŀe~"+
 					",round(~s"+sConfigName+"@����Һϼ�e~/10000,2)"+
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
 					",round(~s"+sConfigName+"@�������e~/10000,2)"+
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
 					" and (~s"+sConfigName+"@��Ŀe~ like '1%' or ~s"+sConfigName+"@��Ŀe~ like '2%' or ~s"+sConfigName+"@��Ŀe~ like '4%')";
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
 	 				"'"+HandlerFlag+"',BII1.ConfigNo,BII1.OneKey,'��ҵ��ģ��ϸ','������ҵ@'||BII1.~s"+sConfigName+"@��Ŀe~"+
 					",round(BII1.~s"+sConfigName+"@������ҵe~/10000,2),BII2.~s"+sConfigName+"@������ҵe~"+
 					" from Batch_Import_Interim BII1,Batch_Import_Interim BII2 "+
 					" where BII1.ConfigNo='"+sConfigNo+"' and BII1.OneKey='"+sKey+"' and BII2.ConfigNo='"+sConfigNo+"' and BII2.OneKey='"+sKey+"' "+
 					" and (BII1.~s"+sConfigName+"@��Ŀe~ = '1.���ڴ������ϼ�' or BII1.~s"+sConfigName+"@��Ŀe~ like '1.1.%' or BII1.~s"+sConfigName+"@��Ŀe~ like '1.2.%') "+
 					" and BII2.~s"+sConfigName+"@��Ŀe~ like '%���У������%'"+
 					" union all "+
 					"select "+
 					"'"+HandlerFlag+"',BII1.ConfigNo,BII1.OneKey,'��ҵ��ģ��ϸ','������ҵ@'||BII1.~s"+sConfigName+"@��Ŀe~"+
 					",round(BII1.~s"+sConfigName+"@������ҵe~/10000,2),BII2.~s"+sConfigName+"@������ҵe~"+
 					" from Batch_Import_Interim BII1,Batch_Import_Interim BII2 "+
 					" where BII1.ConfigNo='"+sConfigNo+"' and BII1.OneKey='"+sKey+"' and BII2.ConfigNo='"+sConfigNo+"' and BII2.OneKey='"+sKey+"' "+
 					" and (BII1.~s"+sConfigName+"@��Ŀe~ = '1.���ڴ������ϼ�' or BII1.~s"+sConfigName+"@��Ŀe~ like '1.1.%' or BII1.~s"+sConfigName+"@��Ŀe~ like '1.2.%') "+
 					" and BII2.~s"+sConfigName+"@��Ŀe~ like '%���У������%'"+
 					" union all "+
 					" select "+
 					"'"+HandlerFlag+"',BII1.ConfigNo,BII1.OneKey,'��ҵ��ģ��ϸ','С����ҵ@'||BII1.~s"+sConfigName+"@��Ŀe~"+
 					",round(BII1.~s"+sConfigName+"@С����ҵe~/10000,2),BII2.~s"+sConfigName+"@С����ҵe~"+
 					" from Batch_Import_Interim BII1,Batch_Import_Interim BII2 "+
 					" where BII1.ConfigNo='"+sConfigNo+"' and BII1.OneKey='"+sKey+"' and BII2.ConfigNo='"+sConfigNo+"' and BII2.OneKey='"+sKey+"' "+
 					" and (BII1.~s"+sConfigName+"@��Ŀe~ = '1.���ڴ������ϼ�' or BII1.~s"+sConfigName+"@��Ŀe~ like '1.1.%' or BII1.~s"+sConfigName+"@��Ŀe~ like '1.2.%') "+
 					" and BII2.~s"+sConfigName+"@��Ŀe~ like '%���У������%'"+
 					" union all "+
 					" select "+
 					"'"+HandlerFlag+"',BII1.ConfigNo,BII1.OneKey,'��ҵ��ģ��ϸ','΢����ҵ@'||BII1.~s"+sConfigName+"@��Ŀe~"+
 					",round(BII1.~s"+sConfigName+"@΢����ҵe~/10000,2),BII2.~s"+sConfigName+"@΢����ҵe~"+
 					" from Batch_Import_Interim BII1,Batch_Import_Interim BII2 "+
 					" where BII1.ConfigNo='"+sConfigNo+"' and BII1.OneKey='"+sKey+"' and BII2.ConfigNo='"+sConfigNo+"' and BII2.OneKey='"+sKey+"' "+
 					" and (BII1.~s"+sConfigName+"@��Ŀe~ = '1.���ڴ������ϼ�' or BII1.~s"+sConfigName+"@��Ŀe~ like '1.1.%' or BII1.~s"+sConfigName+"@��Ŀe~ like '1.2.%') "+
 					" and BII2.~s"+sConfigName+"@��Ŀe~ like '%���У������%'"+
 					" union all "+
 					" select "+
 					"'"+HandlerFlag+"',BII1.ConfigNo,BII1.OneKey,'��ҵ��ģ��ϸ','���������ܶ�500��Ԫ���µ�С΢����ҵ@'||BII1.~s"+sConfigName+"@��Ŀe~"+
 					",round(BII1.~s"+sConfigName+"@���������ܶ�500��Ԫ���µ�С΢����ҵe~/10000,2),BII2.~s"+sConfigName+"@���������ܶ�500��Ԫ���µ�С΢����ҵe~"+
 					" from Batch_Import_Interim BII1,Batch_Import_Interim BII2 "+
 					" where BII1.ConfigNo='"+sConfigNo+"' and BII1.OneKey='"+sKey+"' and BII2.ConfigNo='"+sConfigNo+"' and BII2.OneKey='"+sKey+"' "+
 					" and (BII1.~s"+sConfigName+"@��Ŀe~ = '1.���ڴ������ϼ�' or BII1.~s"+sConfigName+"@��Ŀe~ like '1.1.%' or BII1.~s"+sConfigName+"@��Ŀe~ like '1.2.%') "+
 					" and BII2.~s"+sConfigName+"@��Ŀe~ like '%���У������%'"+
 					" union all "+
 					" select "+
 					"'"+HandlerFlag+"','"+sConfigNo+"',OneKey,'��ҵ��ģ��ϸ','�ܼ�@����������'"+
 					",round(~sG0103_�����@����Һϼ�e~/10000,2),0"+
 					" from Batch_Import_Interim "+
 					" where ConfigName='G0103_�����' and OneKey='"+sKey+"' "+
 					" and ~sG0103_�����@��Ŀe~ = '1.�������'";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 	 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 	 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue"+
 	 				",Balance,TotalTransaction)"+
 	 				"( "+
 	 				sSql+
 	 				")");
 	 		//ͨ�������ϸ�����²�������
 	 		sSql="from Batch_Import_Interim BII1"+
 	 						" where BII1.ConfigName='�����ϸ' and BII1.OneKey='"+sKey+"' "+
 	 						" and BII1.~s�����ϸ@��ҵ��ģe~=substr(BIP.DimensionValue,1,locate('@',BIP.DimensionValue)-1) "+
 	 						" and (BII1.~s�����ϸ@�弶����e~ like '�μ�%' or BII1.~s�����ϸ@�弶����e~ like '����%' or BII1.~s�����ϸ@�弶����e~ like '��ʧ%')";
 	 		
 	 		String updateSql="update Batch_Import_Process BIP set(BadTT)="+
		 	 				"(select count(distinct BII1.~s�����ϸ@�ͻ�����e~) "+sSql+")"+
		 	 				" where HandlerFlag='"+HandlerFlag+"' and BIP.ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
		 	 				" and exists"+
		 	 				"	(select 1 "+sSql+")";
 	 		updateSql=StringUtils.replaceWithConfig(updateSql, Sqlca);
 	 		Sqlca.executeSQL(updateSql);
 		}
	}
	//����С�� �ϼ� ��������Ƚ�ֵ
	public static void afterProcess(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		String sLastMonthEnd=StringFunction.getRelativeAccountMonth(sKey,"month",-1);
		//3������ռ��
 		sSql="select tab1.Dimension,tab1.DimensionValue,"+
 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,Balance "+
				"from Batch_Import_Process "+
				"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,Balance "+	
				"from Batch_Import_Process "+
				"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and (DimensionValue='1.�������' or DimensionValue='�ܼ�@����������')"+
			")tab2"+
			" where tab1.Dimension=tab2.Dimension";
 		Sqlca.executeSQL("update Batch_Import_Process tab3 "+
 				"set(BalanceRatio)="+
 				"( select BalanceRatio from "+
 				"("+sSql+") tab4 where tab3.Dimension=tab4.Dimension and tab3.DimensionValue=tab4.DimensionValue"+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 from ("+sSql+") tab22 where tab3.Dimension=tab22.Dimension and tab3.DimensionValue=tab22.DimensionValue)"
 				);
 		//4�����ǰһ�������ֵ�ͷ��ȸ���
 		sSql="select tab1.Dimension,tab1.DimensionValue,"+
 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY,"+
 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY,"+
 				"(nvl(tab1.TotalTransaction,0)-nvl(tab2.TotalTransaction,0)) as TotalTransactionTLY,"+
 				"case when nvl(tab2.TotalTransaction,0)<>0 then cast(round((decimal(nvl(tab1.TotalTransaction,0))/decimal(nvl(tab2.TotalTransaction,0))-1)*100,2) as numeric(24,6)) else 0 end as TotalTransactionRangeTLY,"+
 				"(nvl(tab1.Balance,0)-nvl(tab3.Balance,0)) as BalanceTLM,"+
 				"(nvl(tab1.BalanceRatio,0)-nvl(tab3.BalanceRatio,0)) as BalanceRatioTLM,"+
 				"case when nvl(tab3.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab3.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLM,"+
 				"(nvl(tab1.TotalTransaction,0)-nvl(tab3.TotalTransaction,0)) as TotalTransactionTLM,"+
 				"case when nvl(tab3.TotalTransaction,0)<>0 then cast(round((decimal(nvl(tab1.TotalTransaction,0))/decimal(nvl(tab3.TotalTransaction,0))-1)*100,2) as numeric(24,6)) else 0 end as TotalTransactionRangeTLM"+//ע�⣺���ݿ�integer/integer �Զ���ȥС��������С�����Դ�����ԶΪ0������ҪתΪdouble�ٳ�,sum()/sum()������Ҳ�������ˣ��ù�
 			" from "+
			"(select Dimension,DimensionValue,BalanceRatio,Balance,TotalTransaction "+
				"from Batch_Import_Process "+
				"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select Dimension,DimensionValue,BalanceRatio,Balance,TotalTransaction "+	
			"from Batch_Import_Process "+
				"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
			")tab2,"+
			"(select Dimension,DimensionValue,BalanceRatio,Balance,TotalTransaction "+	
			"from Batch_Import_Process "+
				"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastMonthEnd+"'"+
			")tab3"+
			" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
			" and tab1.Dimension=tab3.Dimension and tab1.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab11 "+
 				"set(BalanceTLY,BalanceRatioTLY,BalanceRangeTLY,TotalTransactionTLY,TotalTransactionRangeTLY,BalanceTLM,BalanceRatioTLM,BalanceRangeTLM,TotalTransactionTLM,TotalTransactionRangeTLM)="+
 				"(select BalanceTLY,BalanceRatioTLY,BalanceRangeTLY,TotalTransactionTLY,TotalTransactionRangeTLY,BalanceTLM,BalanceRatioTLM,BalanceRangeTLM,TotalTransactionTLM,TotalTransactionRangeTLM from "+
 				"("+sSql+") tab12 where tab11.Dimension=tab12.Dimension and tab11.DimensionValue=tab12.DimensionValue"+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 from ("+sSql+") tab13 where tab11.Dimension=tab13.Dimension and tab11.DimensionValue=tab13.DimensionValue)"
 				);
	}
}