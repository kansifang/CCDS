package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class AfterImportDuebillHandler{
	//�Ե������ݼӹ�����,���뵽�м��Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		//1���������� ��������ͳһ�޸�Ϊ ��������
		String sSql="update Batch_Import_Interim set ~s�����ϸ@��������e~='��˾����' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s�����ϸ@��������e~,'')='��������'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//�޸� ����÷������� ���������ʽ���� ���������� �޸�Ϊ ��˾���� ��
 		sSql="update Batch_Import_Interim set ~s�����ϸ@��������e~='��˾����',~s�����ϸ@���ҵ���e~='̫ԭ��' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s�����ϸ@�����ˮ��e~,'')='2740124368501101'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//2�� 
 		//b����Ӫ���ͣ��£��Դӵ�ǰ�·ݽ�ݵ� ��Ӫ���ͣ��£� Ϊ׼���µ�2013/12��֮ǰ�ģ���Ϊ֮ǰ�Ĳ�׼ȷ(������׼)
 		if(!StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0).equals(sKey)){
 			sSql="update Batch_Import_Interim BII set ~s�����ϸ@��Ӫ����(��)e~="+
 					"(select ~s�����ϸ@��Ӫ����(��)e~ from Batch_Import BI "+
 					"where BI.ConfigNo=BII.ConfigNo and BI.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BI.~s�����ϸ@�����ˮ��e~=BII.~s�����ϸ@�����ˮ��e~) "+
 			" where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+
 			" and exists(select 1 from Batch_Import BI1 where BI1.ConfigNo=BII.ConfigNo and BI1.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BI1.~s�����ϸ@�����ˮ��e~=BII.~s�����ϸ@�����ˮ��e~)";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 			Sqlca.executeSQL(sSql);
 		}
		//a����Ӫ���ͣ��£�����ֶ�Ϊ�գ����� ��Ӫ���� �ڵ�ֵ
 		sSql="update Batch_Import_Interim set ~s�����ϸ@��Ӫ����(��)e~=~s�����ϸ@��Ӫ����e~ where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s�����ϸ@��Ӫ����(��)e~,'')=''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
		//c���Ե���Ŀͻ���ϢΪ׼���¾�Ӫ����(��)----����������Զ�Խ���Ϊ׼������������໹��̫�󣬲��Ǻ�׼����ʱ���ΰɣ�
		/*
		sSql="update Batch_Import_Interim BII set ~s�����ϸ@��Ӫ����(��)e~="+
				"(select ~s�ͻ���ϸ@��Ӫ����(��)e~ from Batch_Import_Interim BII1 "+
				"where BII1.ConfigName='�ͻ���ϸ' and BII1.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BII1.~s�ͻ���ϸ@�ͻ�����e~=BII.~s�����ϸ@�ͻ�����e~) "+
		" where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+
		" and exists(select 1 from Batch_Import BII2 where BII2.ConfigName='�ͻ���ϸ' and BII2.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BII2.~s�ͻ���ϸ@�ͻ�����e~=BII.~s�����ϸ@�ͻ�����e~)";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		*/
 		//3��ֱ�������� ���ǡ����С�����ֱ�������ƣ����� �ܻ��� ���ֺ���������ڵı�־����
 		sSql="update Batch_Import_Interim set ~s�����ϸ@ֱ��������e~="+
 					"case when ~s�����ϸ@�ܻ���e~ like '%����%' or ~s�����ϸ@�ܻ���e~='���ֻ�' then '���Ƿ��гﱸ��' "+
 					"when ~s�����ϸ@�ܻ���e~ like '%����%' then '���з��гﱸ��' "+
 					"when ~s�����ϸ@�ܻ���e~ like '%����%' then '���η���' "+
 					"else ~s�����ϸ@ֱ��������e~ end "+
 					"where ConfigNo='"+sConfigNo+"' "+
 					"and OneKey='"+sKey+"' "+
 					"and nvl(~s�����ϸ@�ܻ���e~,'')<>''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//4��ֱ���������д��������е� ��� ���� �ܻ����� ������
 		sSql="update Batch_Import_Interim set ~s�����ϸ@ֱ��������e~=~s�����ϸ@�ܻ�����e~"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s�����ϸ@ֱ��������e~,'')='��������'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//5��ҵ��Ʒ�� ���� �����¼������������ǳ��ڴ��ҵ��Ʒ��ȴ�Ƕ��������ʽ�������������ڴ˸��³� �г��������ʽ����
 		sSql="update Batch_Import_Interim set ~s�����ϸ@ҵ��Ʒ��e~='�г��������ʽ����'"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s�����ϸ@ҵ��Ʒ��e~,'')='���������ʽ����'"+
 					" and (nvl(~s�����ϸ@������e~,0)>0 and nvl(~s�����ϸ@������e~,0)+1>12 or nvl(~s�����ϸ@������e~,0)>12)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//ҵ��Ʒ�� ���� �����¼������������Ƕ��ڴ��ҵ��Ʒ��ȴ���г��������ʽ�������������ڴ˸��³� ���������ʽ����
 		sSql="update Batch_Import_Interim set ~s�����ϸ@ҵ��Ʒ��e~='���������ʽ����'"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s�����ϸ@ҵ��Ʒ��e~,'')='�г��������ʽ����'"+
 					" and (nvl(~s�����ϸ@������e~,0)>0 and nvl(~s�����ϸ@������e~,0)+1<=12 or nvl(~s�����ϸ@������e~,0)<=12)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//6����ҵ��ģ Ϊ�յ�Ϊ ҽԺ��ѧУ����ҵ��λ��
 		sSql="update Batch_Import_Interim set ~s�����ϸ@��ҵ��ģe~='������ҵ��λ'"+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s�����ϸ@��ҵ��ģe~,'')=''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//7��ͳһ���±��ֵ�����ң���� �������Ӧת��
 		sSql="update Batch_Import_Interim set ~s�����ϸ@����e~='01',"+
			 		"~s�����ϸ@���(Ԫ)e~=~s�����ϸ@���(Ԫ)e~*nvl(getErate(~s�����ϸ@����e~,'01',''),1),"+
			 		"~s�����ϸ@���(Ԫ)e~=~s�����ϸ@���(Ԫ)e~*nvl(getErate(~s�����ϸ@����e~,'01',''),1) "+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s�����ϸ@����e~,'')<>'01'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
	}
	/**
	 * ������ά�Ȳ��뵽�������
	 * @throws Exception 
	 */
	public static void process(String sConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy) throws Exception{
		//��ǰ�����·ݵ�ǰ������
		boolean isSeason=false;
		String last2month="";
		String last1month="";
		if(StringFunction.isLike(sKey, "%03")||StringFunction.isLike(sKey, "%06")||StringFunction.isLike(sKey, "%09")||StringFunction.isLike(sKey, "%12")){
			last2month=StringFunction.getRelativeAccountMonth(sKey,"month", -2);
			last1month=StringFunction.getRelativeAccountMonth(sKey,"month", -1);
			isSeason=true;
		}
		String sSql="";
 		//1��������ά�Ȼ��ܵ��������
		String groupColumns=groupBy.replaceAll(",","||'@'||");
		groupColumns=("".equals(groupColumns)?"":groupColumns+",");
 		sSql="select "+
 				"ConfigNo,OneKey,'"+Dimension+"',"+groupColumns+
				"round(sum(case when ~s�����ϸ@�����ʼ��e~ like '"+sKey+"%' then ~s�����ϸ@���(Ԫ)e~ end)/10000,2) as BusinessSum,"+//����Ͷ�Ž��
				(isSeason==true?"round(sum(case when ~s�����ϸ@�����ʼ��e~ like '"+last2month+"%' or ~s�����ϸ@�����ʼ��e~ like '"+last1month+"%' or ~s�����ϸ@�����ʼ��e~ like '"+sKey+"%' then ~s�����ϸ@���(Ԫ)e~ end)/10000,2)":"0")+","+//����Ǽ���ĩ�����㰴��Ͷ�Ž��
				"round(case when sum(~s�����ϸ@���(Ԫ)e~)<>0 then sum(~s�����ϸ@���(Ԫ)e~*~s�����ϸ@ִ��������(%)e~)/sum(~s�����ϸ@���(Ԫ)e~) else 0 end,2) as Balance, "+//��Ȩ����
				"round(sum(~s�����ϸ@���(Ԫ)e~)/10000,2) as Balance, "+
				"count(distinct ~s�����ϸ@�ͻ�����e~) "+
				"from Batch_Import_Interim "+
				"where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s�����ϸ@���(Ԫ)e~,0)>0 "+
				"group by ConfigNo,OneKey"+("".equals(groupBy)?"":","+groupBy);
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,BusinessRate,Balance,TotalTransaction)"+
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
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2),sum(TotalTransaction) "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			"group by ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
		//2���������ά�ȵ��ܼ�
 		sSql="select "+
 				"ConfigNo,OneKey,Dimension,'�ܼ�',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2) as Balance,sum(TotalTransaction) "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('С��',DimensionValue)=0 "+
			"group by ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
 		//3�����ǰһ�������ֵ�ͷ��ȸ���
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+	
			"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
			")tab2"+
			" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY)="+
 				"(select BalanceTLY,BusinessRateTLY,BalanceRangeTLY from "+
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
 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
 	 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+
 					"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 				")tab1,"+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+	
 				"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
 				")tab2"+
 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 	 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 	 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY)="+
 	 				"(select BalanceTLY,BusinessRateTLY,BalanceRangeTLY from "+
 	 				"("+sSql+") tab2 where tab1.OneKey=tab2.OneKey and tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
 	 				")"+
 	 				" where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 from ("+sSql+") tab22 where tab1.OneKey=tab22.OneKey and tab1.Dimension=tab22.Dimension and tab1.DimensionValue=tab22.DimensionValue)"
 	 				);
 		}
 		//4��ռ�ȸ���
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
 				"case when nvl(tab2.BusinessSumSeason,0)<>0 then round(tab1.BusinessSumSeason/tab2.BusinessSumSeason*100,2) else 0 end as BusinessSeasonRatio,"+
 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
					"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+
						"from Batch_Import_Process "+
						"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+	
						"from Batch_Import_Process "+
						"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and DimensionValue='�ܼ�'"+
					")tab2"+
				" where tab1.Dimension=tab2.Dimension";
 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 				"set(BusinessSumRatio,BusinessSumSeasonRatio,BalanceRatio)="+
 				"( select BusinessSumRatio,BusinessSumSeasonRatio,BalanceRatio from "+
 				"("+sSql+") tab2 where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
 				")"+
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 from ("+sSql+") tab22 where tab1.Dimension=tab22.Dimension and tab1.DimensionValue=tab22.DimensionValue)"
 				);
	}
}