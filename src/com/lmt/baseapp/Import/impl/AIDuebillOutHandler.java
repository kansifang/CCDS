package com.lmt.baseapp.Import.impl;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class AIDuebillOutHandler{
	//�Ե������ݼӹ�����,���뵽�м��Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
 		String sSql="";
		//2�� 
 		//b����Ӫ���ͣ��£�����һ����׼���ڣ������������������Ϊ׼�� ���µ�����ʱ���֮ǰ�ģ�����ҵ�񲻶ϱ仯�����ھ�Ӫ���ͻ᲻�ϱ仯����һ�����һ�λ��Ǿ�ĳ�����ڲ����أ����Ǹ�����
 		//��ȡ 2014/05��ǰ����2014/05Ϊ׼���˺�͵�ǰΪ׼���ֲ���
 		//ԭ���ϵ����ݶ���Ҫ�ٵ�����ֻ����������
 		String AdjustDate="2014/05";//StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0);
 		if(1==1&&sKey.compareTo(AdjustDate)<0){
 			sSql="update Batch_Import_Interim BII set ~s������ϸ@��Ӫ����(��)e~="+
 					"(select ~s������ϸ@��Ӫ����(��)e~ from Batch_Import BI "+
 					"where BI.ConfigNo=BII.ConfigNo and BI.OneKey='"+AdjustDate+"' and BI.~s������ϸ@�����ˮ��e~=BII.~s������ϸ@�����ˮ��e~) "+
 			" where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+
 			" and exists(select 1 from Batch_Import BI1 where BI1.ConfigNo=BII.ConfigNo and BI1.OneKey='"+AdjustDate+"' and BI1.~s������ϸ@�����ˮ��e~=BII.~s������ϸ@�����ˮ��e~)";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 			Sqlca.executeSQL(sSql);
 		}
		//a����Ӫ���ͣ��£�����ֶ�Ϊ�գ����� ��Ӫ���� �ڵ�ֵ
 		sSql="update Batch_Import_Interim set ~s������ϸ@��Ӫ����(��)e~=~s������ϸ@��Ӫ����e~ where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and (nvl(~s������ϸ@��Ӫ����(��)e~,'')='' or ~s������ϸ@��Ӫ����(��)e~='����' and nvl(~s������ϸ@��Ӫ����e~,'')<>'' and ~s������ϸ@��Ӫ����(��)e~<>~s������ϸ@��Ӫ����e~)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
		//c���Ե���Ŀͻ���ϢΪ׼���¾�Ӫ����(��)----����������Զ�Խ���Ϊ׼������������໹��̫�󣬲��Ǻ�׼����ʱ���ΰɣ�
		/*
		sSql="update Batch_Import_Interim BII set ~s������ϸ@��Ӫ����(��)e~="+
				"(select ~s�ͻ���ϸ@��Ӫ����(��)e~ from Batch_Import_Interim BII1 "+
				"where BII1.ConfigName='�ͻ���ϸ' and BII1.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BII1.~s�ͻ���ϸ@�ͻ�����e~=BII.~s������ϸ@�ͻ�����e~) "+
		" where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+
		" and exists(select 1 from Batch_Import BII2 where BII2.ConfigName='�ͻ���ϸ' and BII2.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BII2.~s�ͻ���ϸ@�ͻ�����e~=BII.~s������ϸ@�ͻ�����e~)";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		*/
 		//3��ֱ�������� ���ǡ����С�����ֱ�������ƣ����� �ܻ��� ���ֺ���������ڵı�־����
 		sSql="update Batch_Import_Interim set ~s������ϸ@ֱ��������e~="+
 					"case when ~s������ϸ@�ܻ���e~ like '%����%' or ~s������ϸ@�ܻ���e~='���ֻ�' then '���Ƿ��гﱸ��' "+
 					"when ~s������ϸ@�ܻ���e~ like '%����%' then '���з��гﱸ��' "+
 					"when ~s������ϸ@�ܻ���e~ like '%����%' then '���η���' "+
 					"else ~s������ϸ@ֱ��������e~ end "+
 					"where ConfigNo='"+sConfigNo+"' "+
 					"and OneKey='"+sKey+"' "+
 					"and nvl(~s������ϸ@�ܻ���e~,'')<>''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//4��ֱ���������д��������е� ��� ���� �ܻ����� ������
 		sSql="update Batch_Import_Interim set ~s������ϸ@ֱ��������e~=~s������ϸ@�ܻ�����e~"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s������ϸ@ֱ��������e~,'')='��������'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		sSql="update Batch_Import_Interim set ~s������ϸ@��ҵ��ģe~='������ҵ��λ'"+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s������ϸ@��ҵ��ģe~,'')=''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//7��ͳһ���±��ֵ�����ң���� �������Ӧת��
 		sSql="update Batch_Import_Interim set ~s������ϸ@����e~='01',"+
			 		"~s������ϸ@���(Ԫ)e~=~s������ϸ@���(Ԫ)e~*nvl(getErate(~s������ϸ@����e~,'01',''),1),"+
			 		"~s������ϸ@���(Ԫ)e~=~s������ϸ@���(Ԫ)e~*nvl(getErate(~s������ϸ@����e~,'01',''),1) "+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s������ϸ@����e~,'')<>'01'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//8������Ǳ��д浥��֤�𣬱�֤�������0����Ȼ���ڽ��Ҳ��0���ĳжһ�Ʊ�ı�֤��������100
 		sSql="update Batch_Import_Interim set ~s������ϸ@��֤�����(%)e~=100"+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and (nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��֤��%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%���д浥%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��������Ҵ��%')"+
 					" and nvl(~s������ϸ@��֤�����(%)e~,0)=0"+
 					" and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//9������Ǳ�֤�������Ϊ100����Ȼ���ڽ��Ҳ��0������Ҫ������ʽΪ���д浥��֤��ĳжһ�Ʊ��,��Ϻ�ͬ��ϸ��������� ������������ʽ�� ������֤������Ҫ������ʽ��Ϊ��֤
 		sSql="update Batch_Import_Interim BII1 set " +
					"~s������ϸ@��Ҫ������ʽe~='��֤-' " +
					" where ConfigNo='"+sConfigNo+"'"+
					" and OneKey='"+sKey+"'"+
					" and (nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��֤��%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%���д浥%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��������Ҵ��%')"+
					" and nvl(~s������ϸ@��֤�����(%)e~,0)<>100"+
					" and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'" +
					" and exists(select 1 from Batch_Import_Interim BII2 " +
					"			where BII2.ConfigName='��ͬ��ϸ'" +
					"				and BII2.OneKey=BII1.OneKey" +
					"				and BII2.~s��ͬ��ϸ@�ͻ����e~=BII1.~s������ϸ@�ͻ����e~" +
					"				and BII2.~s��ͬ��ϸ@ҵ��Ʒ��e~=BII1.~s������ϸ@ҵ��Ʒ��e~" +
					"				and BII2.~s��ͬ��ϸ@��Ҫ������ʽe~=BII1.~s������ϸ@��Ҫ������ʽe~" +
					"				and locate('��֤',BII2.~s��ͬ��ϸ@����������ʽe~)>0)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//10������Ǳ�֤�������Ϊ100����Ȼ���ڽ��Ҳ��0������Ҫ������ʽΪ���д浥��֤��ĳжһ�Ʊ��,��Ϻ�ͬ��ϸ��������� ������������ʽ�� ������Ѻ������Ҫ������ʽ��Ϊ��Ѻ
 		sSql="update Batch_Import_Interim BII1 set " +
 					"~s������ϸ@��Ҫ������ʽe~='��Ѻ-' " +
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and (nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��֤��%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%���д浥%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��������Ҵ��%')"+
 					" and nvl(~s������ϸ@��֤�����(%)e~,0)<>100"+
 					" and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'" +
 					" and exists(select 1 from Batch_Import_Interim BII2 " +
 					"			where BII2.ConfigName='��ͬ��ϸ'" +
 					"				and BII2.OneKey=BII1.OneKey" +
 					"				and BII2.~s��ͬ��ϸ@�ͻ����e~=BII1.~s������ϸ@�ͻ����e~" +
 					"				and BII2.~s��ͬ��ϸ@ҵ��Ʒ��e~=BII1.~s������ϸ@ҵ��Ʒ��e~" +
 					"				and BII2.~s��ͬ��ϸ@��Ҫ������ʽe~=BII1.~s������ϸ@��Ҫ������ʽe~" +
 					"				and locate('��Ѻ',BII2.~s��ͬ��ϸ@����������ʽe~)>0)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//11�����Ĵ���δ�⸶��215w���ڴ˵���ȫ�����
 		sSql="insert into Batch_Import_Interim" +
 					"(ConfigNo,OneKey,~s������ϸ@ҵ��Ʒ��e~,~s������ϸ@��Ҫ������ʽe~,~s������ϸ@��֤�����(%)e~,~s������ϸ@���(Ԫ)e~,~s������ϸ@��Ӫ����(��)e~)" +
 					"values('"+sConfigNo+"','"+sKey+"','���гжһ�Ʊ','��֤��',100,2150000,'ú̿����')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
	}
	/**
	 * ������ά�Ȳ��뵽�������
	 * @throws Exception 
	 * 
	 * groupBy ��ʽ��QZ��ʾ��ѯֵ��ǰ׺ ��QZXXQZ��ʽ����������� д��QZNumberQZȻ������ֶ�֮ǰ����׺������Ҫ�Ժ��ټ�
	 */
	public static void process(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy,String sWhere) throws Exception{
		//�Ƿ񼾱������걨���걨�·ݣ�ԭ��ֻ���Ǽ����������ֶ��õ�Season��������չ�ˣ��˴����������ݿ��ֶβ��ٱ仯
		//��ǰ�·�Ϊ03,09�ͱ�ʾ������06�ͱ�ʾ���걨 12�ͱ�ʾ�걨
		boolean isSeason=false;
		String startsmonth="";
		if(StringFunction.isLike(sKey, "%03")||StringFunction.isLike(sKey, "%09")){
			startsmonth=StringFunction.getRelativeAccountMonth(sKey,"month", -2);
			isSeason=true;
		}
		if(StringFunction.isLike(sKey, "%06")){
			startsmonth=StringFunction.getRelativeAccountMonth(sKey,"month", -5);
			isSeason=true;
		}
		if(StringFunction.isLike(sKey, "%12")){
			startsmonth=StringFunction.getRelativeAccountMonth(sKey,"month", -11);
			isSeason=true;
		}
		String sSql="";
 		//1��������ά�Ȼ��ܵ��������
		String groupbyClause="",groupbyColumn="";
		//����group by �еķ����ֶ�
		groupbyClause=groupBy.replaceAll("LJF",",");
		groupbyClause=groupbyClause.replaceAll("QZ(.+?)QZ","");
		//����select�еķ����ֶ�
		groupbyColumn=groupBy;
		StringBuffer sb=new StringBuffer("");
		Pattern pattern=Pattern.compile("QZ(.+?)QZ",Pattern.CASE_INSENSITIVE);
		Matcher matcher=pattern.matcher(groupBy);
		while(matcher.find()){
			String gs=matcher.group(1);
			if(gs.startsWith("Number")){
				String []gsa=gs.split(":");
				String groupBypart=groupBy.substring(0,matcher.start(1));//��ȡ���� XXXLJFQZNumberQZXXXXX �� QZNumberQZ֮ǰ��String
				groupBypart=groupBypart.substring(0,groupBypart.lastIndexOf("LJF"));//��ȡ���� XXXLJFQZNumberQZXXXXX �� LJF֮ǰ��String
				String partitionby="partition by "+groupBypart.replaceAll("LJF",",").replaceAll("QZ(.+?)QZ","");
				gs="complementstring(trim(char(row_number()over("+partitionby+"))),'"+gsa[1]+"',"+gsa[2]+",'"+gsa[3]+"')";
			}
			matcher.appendReplacement(sb, gs+"||");
		}
		matcher.appendTail(sb);
		if(!"".equals(sb.toString())){
			groupbyColumn=sb.toString();
		}
		groupbyColumn=groupbyColumn.replaceAll("LJF","||'@'||");//�����ֶ�֮������ӷ�����ѯֵ������һ����@
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,'"+Dimension+"',"+("".equals(groupbyColumn)?"":groupbyColumn+",")+
				"round(sum(case when ~s������ϸ@�����ʼ��e~ like '"+sKey+"%' then ~s������ϸ@���(Ԫ)e~ end)/10000,2) as BusinessSum,"+//����Ͷ�Ž��
				(isSeason==true?"round(sum(case when ~s������ϸ@�����ʼ��e~ >= '"+startsmonth+"/01' and ~s������ϸ@�����ʼ��e~ <= '"+sKey+"/31' then ~s������ϸ@���(Ԫ)e~ end)/10000,2)":"0")+","+//����Ǽ���ĩ�����㰴��Ͷ�Ž��,����ǰ���ĩ�������Ͷ�ţ�����....
				"round(case when sum(~s������ϸ@���(Ԫ)e~)<>0 then sum(~s������ϸ@���(Ԫ)e~*~s������ϸ@ִ��������(%)e~)/sum(~s������ϸ@���(Ԫ)e~) else 0 end,2) as BusinessRate, "+//��Ȩ����
				"round(sum(~s������ϸ@���(Ԫ)e~)/10000,2) as Balance, "+
				"count(distinct ~s������ϸ@�ͻ�����e~) "+
				"from Batch_Import_Interim "+
				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s������ϸ@���(Ԫ)e~,0)>0 "+sWhere+
				" group by ConfigNo,OneKey"+("".equals(groupbyClause)?"":","+groupbyClause);
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,BusinessRate,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
	}
	//��ΪSQL��临�� process�޷�ͨ����ɣ���Ҫ�˴��������
	public static void afterProcess1(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		
	}
	//����С�� �ϼ� ��������Ƚ�ֵ С������ DimensionValue ����@�ָ�Ϊ��־
	public static void afterProcess(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//1���������ά�ȵ�С��
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'@С��',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2),sum(TotalTransaction) "+
			" from Batch_Import_Process "+
			" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			" group by HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
		//2���������ά�ȵ��ܼ�
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,'Z-�ܼ�@�ܼ�',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2) as Balance,sum(TotalTransaction) "+
			" from Batch_Import_Process "+
			" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('С��',DimensionValue)=0"+
			" group by HandlerFlag,ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
 		//3��ռ�ȣ��ܼƣ�С�ƵȻ��ܵ�ֵҪ������������ֵһ�����ӵõ�����Ҫ��ԭʼֵ��ӣ���Ϊ�����������ɲ�׼������
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
		 				"case when nvl(tab2.BusinessSumSeason,0)<>0 then round(tab1.BusinessSumSeason/tab2.BusinessSumSeason*100,2) else 0 end as BusinessSumSeasonRatio,"+
		 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
					"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+	
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('�ܼ�',DimensionValue)>0"+
					")tab2"+
					" where tab1.Dimension=tab2.Dimension)tab3"+
				" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BusinessSumRatio,BusinessSumSeasonRatio,BalanceRatio)="+
 				"(select tab3.BusinessSumRatio,tab3.BusinessSumSeasonRatio,tab3.BalanceRatio "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 "+sSql+")"
 				);
 		//4�����ǰһ�������ֵ�ͷ��ȸ���
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY,"+
		 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY"+
		 				" from "+
					"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio "+
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio "+	
					"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
					")tab2"+
					" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
			" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";	
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY,BalanceRatioTLY)="+
 				"(select tab3.BalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY,BalanceRatioTLY "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 "+sSql+")"
 				);
 		//�������ȵ��룬������һ��������·ݵ�����ֵ������ֵ�ͷ��ȸ���
 		if(StringFunction.isLike(sKey, "%/12")){
 			sSql="select distinct OneKey from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey>'"+sKey+"'";
 			String[] sOneKey=Sqlca.getStringArray(sSql);
 			String OneKeys=StringFunction.toArrayString(sOneKey, "','");
 			sSql="from (select tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
		 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 	 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY," +
		 	 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY"+
		 	 				" from "+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio "+
		 					"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
		 				")tab1,"+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio "+	
		 				"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
		 				")tab2"+
		 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
 				" where tab.OneKey=tab3.OneKey and tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";	
 	 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 	 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY,BalanceRatioTLY)="+
 	 				"(select tab3.BalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY,tab3.BalanceRatioTLY "+
 	 				sSql+
 	 				")"+
 	 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 "+sSql+")"
 	 				);
 		}
	}
}