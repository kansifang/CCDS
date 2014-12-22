package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class BDOperationReportHandler{
	/**
	 * �¶Ⱦ�Ӫ���洦��
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public static void operationReportHandle(String HandlerFlag,String sReportConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		BDOperationReportHandler.interimProcess(sReportConfigNo, sOneKey, Sqlca);
		//
		BDOperationReportHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
	 	//4���ӹ��󣬽��кϼƣ������������
		BDOperationReportHandler.afterProcess(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
	}
	//�Ե������ݼӹ�����,���뵽�м��Batch_Import_Interim
	public static void interimProcess(String sReportConfigNo,String sKey,Transaction Sqlca) throws Exception{
	}
	/**
	 * ������ά�Ȳ��뵽�������---//4�� ��S6301_�弶���ൣ��_��ҵ��ģ ������н��д���
	 * @throws Exception 
	 */
	public static void processS63(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca) throws Exception{
 		//����� S63���������ݻ�������һ��һ����������
		//�Դ���С΢��������һ��������� ��ʽ�� ������ҵ@�������..
		String groupby="case when BII1.DimensionValue like '������ҵ%' then 'A-������ҵ'" +
						" when BII1.DimensionValue like '������ҵ%' then 'B-������ҵ'"+
						" when BII1.DimensionValue like 'С����ҵ%' then 'C-С����ҵ'"+
						" when BII1.DimensionValue like '΢����ҵ%' then 'D-΢����ҵ'"+
						" when BII1.DimensionValue like '���������ܶ�500��Ԫ���µ�С΢����ҵ%' then 'E-���������ܶ�500��Ԫ���µ�С΢����ҵ'"+
						" else 'Z-'||BII1.DimensionValue end";
 		String sSql="select "+
 				"'"+HandlerFlag+"','"+sReportConfigNo+"',BII1.OneKey,'��ҵ��ģ����'," +
 				groupby+","+
 				"sum(Balance)"+
				" from Batch_Import_Process BII1"+
				" where BII1.ConfigNo='b20140603000003' and BII1.OneKey='"+sKey+"' and BII1.Dimension='��ҵ��ģ��ϸ'"+//S63_��ģ��������ú�
				" and (BII1.DimensionValue like '%1.1.3%' or BII1.DimensionValue like '%1.1.4%' or BII1.DimensionValue like '%1.1.5%' ) " +
				" group by HandlerFlag,ConfigNo,OneKey,'��ҵ��ģ��ϸ',"+groupby;
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,Balance)"+
 				"( "+
 				sSql+
 				")");
 		//������ͨ�������ϸ����
 		//ͨ�������ϸ�����´���С΢��������
 		sSql="from Batch_Import_Interim BII1"+
 						" where BII1.ConfigName='�����ϸ' and BII1.OneKey='"+sKey+"' "+
 						" and BII1.~s�����ϸ@��ҵ��ģe~=substr(BIP.DimensionValue,3)"+//��ʽ�磺A-������ҵ
 						" and nvl(BII1.~s�����ϸ@���(Ԫ)e~,0)>0"+
 						" and (BII1.~s�����ϸ@�弶����e~ like '�μ�%' or BII1.~s�����ϸ@�弶����e~ like '����%' or BII1.~s�����ϸ@�弶����e~ like '��ʧ%')";
 		String updateSql="update Batch_Import_Process BIP set(TotalTransaction)="+
 	 				"(select count(distinct BII1.~s�����ϸ@�ͻ�����e~) "+sSql+")"+
 	 				" where BIP.HandlerFlag='"+HandlerFlag+"' and BIP.ConfigNo='"+sReportConfigNo+"' and BIP.OneKey='"+sKey+"' and BIP.Dimension = '��ҵ��ģ����'"+
 	 				" and exists"+
 	 				"	(select 1 "+sSql+")";
 		updateSql=StringUtils.replaceWithConfig(updateSql, Sqlca);
 		Sqlca.executeSQL(updateSql);
 		//ͨ�������ϸ���������� ���� �����ܶ�500��Ԫ���µ�С΢����ҵ �������� ---��Ϊ��ݱ��п�û�������ģ����ֻ��С�ͺ�΢����ҵ�� ����500�����²���
 		sSql="from Batch_Import_Interim BII1"+
 						" where BII1.ConfigName='�����ϸ' and BII1.OneKey='"+sKey+"' "+
 						" and BII1.~s�����ϸ@��ҵ��ģe~ in('С����ҵ','΢С����ҵ') "+
 						" and (select sum(BII2.~s�����ϸ@���(Ԫ)e~) from Batch_Import_Interim BII2 " +
 						"		where BII2.ConfigName=BII1.ConfigName " +
 						"			and BII2.OneKey=BII1.OneKey " +
 						"           and nvl(BII2.~s�����ϸ@���(Ԫ)e~,0)>0"+
 						"			and BII2.~s�����ϸ@�ͻ�����e~=BII1.~s�����ϸ@�ͻ�����e~)<=5000000"+
 						" and nvl(BII1.~s�����ϸ@���(Ԫ)e~,0)>0"+
 						" and (BII1.~s�����ϸ@�弶����e~ like '�μ�%' or BII1.~s�����ϸ@�弶����e~ like '����%' or BII1.~s�����ϸ@�弶����e~ like '��ʧ%')";
 		updateSql="update Batch_Import_Process set(TotalTransaction)="+
 	 				"(select count(distinct BII1.~s�����ϸ@�ͻ�����e~) "+sSql+")"+
 	 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"' and Dimension = '��ҵ��ģ����'"+
 	 				" and DimensionValue='E-���������ܶ�500��Ԫ���µ�С΢����ҵ'";
 		updateSql=StringUtils.replaceWithConfig(updateSql, Sqlca);
 		Sqlca.executeSQL(updateSql);
	}
	/**
	 * ������ά�Ȳ��뵽�������
	 * @throws Exception 
	 */
	public static void process(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca) throws Exception{
 		BDOperationReportHandler.processS63(HandlerFlag, sReportConfigNo, sKey, Sqlca);
 		//���S63�еĴ���С��ģ��ϸ�����ɵ�����ʽά�Ȼ���
 		String sSql="select "+
 				"'"+HandlerFlag+"','"+sReportConfigNo+"','"+sKey+"','���һ������ʽ',substr(BIP.DimensionValue,locate('@',BIP.DimensionValue)+1),sum(Balance)"+
				" from Batch_Import_Process BIP"+
				" where BIP.ConfigNo='b20140603000003' and BIP.OneKey='"+sKey+"' and BIP.Dimension='��ҵ��ģ��ϸ'"+//S63_��ģ��������ú�
				" and BIP.DimensionValue not like '���������ܶ�500��Ԫ���µ�С΢����ҵ%'" +
				" and (BIP.DimensionValue like '%1.2.1%' or BIP.DimensionValue like '%1.2.2%' or BIP.DimensionValue like '%1.2.3%' or BIP.DimensionValue = '�ܼ�@����������')" +
				" group by substr(BIP.DimensionValue,locate('@',BIP.DimensionValue)+1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,Balance)"+
 				"( "+
 				sSql+
 				")");
	}
	//����С�� �ϼ� ��������Ƚ�ֵ
	public static void afterProcess(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		String sLastMonthEnd=StringFunction.getRelativeAccountMonth(sKey,"month",-1);
		//2���������С΢�����ܶ���ܼ�
 		//�˴����㲻���ܶ��Ҫ����������������Ҫ����ֶΣ�ҲҪ���㲻����
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,'����С΢�ܼ�',"+
 				"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2) as Balance,sum(TotalTransaction) "+
 				" from Batch_Import_Process "+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"' and Dimension='��ҵ��ģ����'" +
 				" and DimensionValue <> 'E-���������ܶ�500��Ԫ���µ�С΢����ҵ'"+
 				" group by HandlerFlag,ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
		//3�����㲻���ʣ�ռ�ܶ�ıȣ�
 		sSql="select "+
 				" case when nvl(BIP2.Balance,0)<>0 then round(BIP1.Balance/BIP2.Balance*100,2) else 0 end"+
				" from Batch_Import_Process BIP2"+
				" where BIP2.HandlerFlag='"+HandlerFlag+"' " +
				" and BIP2.ConfigNo='b20140603000003'" +//S63�������ú�
				" and BIP2.OneKey ='"+sKey+"'" +
				" and BIP2.Dimension='��ҵ��ģ��ϸ'" +
				" and BIP2.DimensionValue='�ܼ�@����������'";
 		Sqlca.executeSQL("update Batch_Import_Process BIP1 "+
 				"set(BalanceRatio)="+
 				"("+sSql+")"+
 				" where HandlerFlag='"+HandlerFlag+"'" +
 				" and ConfigNo='"+sReportConfigNo+"'" +
 				" and OneKey='"+sKey+"'" +
 				" and Dimension='��ҵ��ģ����'" +
 				" and DimensionValue='����С΢�ܼ�'"
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
				"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1"+
			" left join (select Dimension,DimensionValue,BalanceRatio,Balance,TotalTransaction "+	
			"			from Batch_Import_Process "+
			"			where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
			")tab2 on tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
			" left join (select Dimension,DimensionValue,BalanceRatio,Balance,TotalTransaction "+	
			"			from Batch_Import_Process "+
			"			where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sLastMonthEnd+"'"+
			")tab3 on tab1.Dimension=tab3.Dimension and tab1.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab11 "+
 				"set(BalanceTLY,BalanceRatioTLY,BalanceRangeTLY,TotalTransactionTLY,TotalTransactionRangeTLY,BalanceTLM,BalanceRatioTLM,BalanceRangeTLM,TotalTransactionTLM,TotalTransactionRangeTLM)="+
 				"(select BalanceTLY,BalanceRatioTLY,BalanceRangeTLY,TotalTransactionTLY,TotalTransactionRangeTLY,BalanceTLM,BalanceRatioTLM,BalanceRangeTLM,TotalTransactionTLM,TotalTransactionRangeTLM from "+
 				"("+sSql+") tab12 where tab11.Dimension=tab12.Dimension and tab11.DimensionValue=tab12.DimensionValue"+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 from ("+sSql+") tab13 where tab11.Dimension=tab13.Dimension and tab11.DimensionValue=tab13.DimensionValue)"
 				);
	}
}