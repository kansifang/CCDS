package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class AIContractHandler{
	//�Ե������ݼӹ�����,���뵽�м��Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		String sSql="";
		//1����Ҫ������ʽΪ���õ��Դ�2014/05�·ݺ�ͬ�� ����������ʽ Ϊ׼���µ�2014/03����Ϊ03�·ݲ�׼ȷ(������׼)
		String AdjustDate="2014/05";//StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0);
 		if(1==1&&sKey.compareTo(AdjustDate)<0){
			sSql="update Batch_Import_Interim BII set ~s��ͬ��ϸ@����������ʽe~="+
					"(select ~s��ͬ��ϸ@����������ʽe~ from Batch_Import BI "+
					"where BI.ConfigNo=BII.ConfigNo and BI.OneKey='2014/05' and BI.~s��ͬ��ϸ@��ͬ��ˮ��e~=BII.~s��ͬ��ϸ@��ͬ��ˮ��e~) "+
			"where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+// and nvl(BII.~s��ͬ��ϸ@��Ҫ������ʽe~,'����')='����' "+//������Ϊ���ã�����2014/05������������ʽ���еģ����Դ�Ϊ׼���Ը���
			"and exists(select 1 from Batch_Import BI1 where BI1.ConfigNo=BII.ConfigNo and BI1.OneKey='2014/05' and BI1.~s��ͬ��ϸ@��ͬ��ˮ��e~=BII.~s��ͬ��ϸ@��ͬ��ˮ��e~)";
			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
			Sqlca.executeSQL(sSql);
		}
		//2���������������ʽΪ�գ��޸�Ϊ ��Ҫ������ʽ��һ��Ҳ�������ã� �����Ҫ������ʽҲ�ǿ� �� ��Ϊ����
		sSql="update Batch_Import_Interim set ~s��ͬ��ϸ@����������ʽe~="+
					"case when nvl(~s��ͬ��ϸ@��Ҫ������ʽe~,'X') like '��Ѻ%' then '��Ѻ' "+
					"when nvl(~s��ͬ��ϸ@��Ҫ������ʽe~,'X') like '��Ѻ%' then '��Ѻ' "+
					"when nvl(~s��ͬ��ϸ@��Ҫ������ʽe~,'X') like '��֤%' then '��֤' "+
					"else '����' end "+
					"where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s��ͬ��ϸ@����������ʽe~,'')=''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		
 		//3��̫ԭ�й���ʵҵ�������޹�˾(��ͬ20130412000007) ���Ŵ��� �Խ��(���00000167523�����Ϊ׼
		sSql="update Batch_Import_Interim set ~s��ͬ��ϸ@���e~=475000000"+//ֱ��д������ɣ����ܺͽ�ݽ�����һ��ÿ��ʹ�ú�ͬʱ��Ҫ��֤���ҵ��������Ƿ�仯
					//"(select ~s�����ϸ@���(Ԫ)e~ from Batch_Import_Interim "+
					//"where ConfigName='�����ϸ' and OneKey='"+sKey+"' and ~s�����ϸ@�����ˮ��e~='00000167523')"+
					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
					" and nvl(~s��ͬ��ϸ@��ͬ��ˮ��e~,'')='20130412000007'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//4��ͳһ���±��ֵ�����ң���� �������Ӧת��
 		sSql="update Batch_Import_Interim set ~s��ͬ��ϸ@����e~='01',"+
			 		"~s��ͬ��ϸ@���e~=~s��ͬ��ϸ@���e~*nvl(getErate(~s��ͬ��ϸ@����e~,'01',''),1),"+
			 		"~s��ͬ��ϸ@���e~=~s��ͬ��ϸ@���e~*nvl(getErate(~s��ͬ��ϸ@����e~,'01',''),1) "+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s��ͬ��ϸ@����e~,'')<>'01'";
 		//sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		//Sqlca.executeSQL(sSql);
 		//5������Ǳ��д浥��֤�𣬱�֤�������0����Ȼ���ڽ��Ҳ��0���ĳжһ�Ʊ�ı�֤��������100 ���ճ��ڱ�Ϊ0
 		sSql="update Batch_Import_Interim set ~s��ͬ��ϸ@��֤�����(%)e~=100"+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and (nvl(~s��ͬ��ϸ@��Ҫ������ʽe~,'') like '%��֤��%' or nvl(~s��ͬ��ϸ@��Ҫ������ʽe~,'') like '%���д浥%' or nvl(~s��ͬ��ϸ@��Ҫ������ʽe~,'') like '%��������Ҵ��%')"+
 					" and nvl(~s��ͬ��ϸ@��֤�����(%)e~,0)=0"+
 					" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//6������Ǳ�֤�������Ϊ100����Ȼ����>0������Ҫ������ʽΪ���д浥��֤��ĳжһ�Ʊ��,��Ϻ�ͬ��ϸ��������� ������������ʽ�� ������Ѻ������Ҫ������ʽ��Ϊ��Ѻ
 		sSql="update Batch_Import_Interim BII1 set ~s��ͬ��ϸ@��Ҫ������ʽe~=" +
 					" case when ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' then '��Ѻ-' " +
 					" else '��֤-' end " +
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and (nvl(~s��ͬ��ϸ@��Ҫ������ʽe~,'') like '%��֤��%' or nvl(~s��ͬ��ϸ@��Ҫ������ʽe~,'') like '%���д浥%' or nvl(~s��ͬ��ϸ@��Ҫ������ʽe~,'') like '%��������Ҵ��%')"+
 					" and nvl(~s��ͬ��ϸ@��֤�����(%)e~,0)<>100"+
 					" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'" +
 					" and (nvl(~s��ͬ��ϸ@����������ʽe~,'') like '%��Ѻ%' or nvl(~s��ͬ��ϸ@����������ʽe~,'') like '%��֤%')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//11����Ҫ������ʽΪ���гжһ�Ʊ��,�����֤�����Ϊ100����֤��������0
 		sSql="update Batch_Import_Interim set ~s��ͬ��ϸ@��֤�����(%)e~=0"+
					" where ConfigNo='"+sConfigNo+"'"+
					" and OneKey='"+sKey+"'"+
					" and nvl(~s��ͬ��ϸ@��Ҫ������ʽe~,'') like '%���гжһ�Ʊ%'"+
					" and nvl(~s��ͬ��ϸ@��֤�����(%)e~,0)=100"+
					" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		//11��ɽ��������ó���޹�˾(20110303000008)��ͬ��20140702000060����֤����Ϊ50% �����ݣ�434805-434811����֤�����ȴΪ0---��ȥϵͳ����ԭ�� �˴����³�0�����ڽ�ݱ���һ��
 		sSql="update Batch_Import_Interim set ~s��ͬ��ϸ@��֤�����(%)e~=0"+
					" where ConfigNo='"+sConfigNo+"'"+
					" and OneKey='"+sKey+"'"+
					" and nvl(~s��ͬ��ϸ@��ͬ��ˮ��e~,'') = '20140702000060'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
 		//12�����Ĵ���δ�⸶��215w���ڴ˵���ȫ�����
 		sSql="insert into Batch_Import_Interim" +
 					"(ConfigNo,OneKey,~s��ͬ��ϸ@ҵ��Ʒ��e~,~s��ͬ��ϸ@��Ҫ������ʽe~,~s��ͬ��ϸ@��֤�����(%)e~,~s��ͬ��ϸ@���e~,~s��ͬ��ϸ@��Ӫ����(��)e~)" +
 					"values('"+sConfigNo+"','"+sKey+"','���гжһ�Ʊ','��֤��',100,2150000,'ú̿����')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//4���ܻ����� Ϊӭ��֧�е�ֱ���������� ����Ӫҵ�� ��Ϊ ����ֱ��֧��
 		sSql="update Batch_Import_Interim set ~s��ͬ��ϸ@ֱ����e~='����ֱ��֧��'"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s��ͬ��ϸ@ֱ����e~,'')='����Ӫҵ��'"+
 					" and nvl(~s��ͬ��ϸ@�ܻ�����e~,'')='����Ӫҵ��'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
	}
	/**
	 * ��ͬ�������
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public static void contractHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		AIContractHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//�Թ������ϵ��������պ�ͬ������������ʽֱ�ӷ��飬�˴�����case when...��
	 	String groupBy="case when ~s��ͬ��ϸ@����������ʽe~ like '%��֤%' and ~s��ͬ��ϸ@����������ʽe~ like '%���Ѻ%' then '��֤+���Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%��֤%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' then '��֤+����Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��֤' then '��һ��֤' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%����%' and ~s��ͬ��ϸ@����������ʽe~ like '%���Ѻ%' then '����+���Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '����' then '��һ����' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��Ѻ' then '��һ��Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��Ѻ' then '��һ��Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' then '��Ѻ+��Ѻ' "+
	 			"else '��������' end";
	 	String sWhere=" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'X') not in('��������֤','��������֤','���гжһ�Ʊ','�����','��������֤����','ί�д���-����֤','ί�д���')";
	 	AIContractHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"�Թ������ϵ���","~s��ͬ��ϸ@����������ʽe~",sWhere);
	 	//���л�ϵ���
	 	groupBy="case when ~s��ͬ��ϸ@��Ҫ������ʽe~ like '%��Ѻ%' and not(~s��ͬ��ϸ@��Ҫ������ʽe~ like '%���д浥' or ~s��ͬ��ϸ@��Ҫ������ʽe~ like '%��֤��' or ~s��ͬ��ϸ@��Ҫ������ʽe~ like '%��������Ҵ��%') then ~s��ͬ��ϸ@����������ʽe~" +
	 			//" ~s��ͬ��ϸ@��Ҫ������ʽe~ like '%��֤%' and ~s��ͬ��ϸ@����������ʽe~ like '%��֤%' " +
	 			//		"  and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' " +
	 			//		"  and ~s��ͬ��ϸ@����������ʽe~ not like '%���Ѻ%' " +
	 			//		"  and ~s��ͬ��ϸ@����������ʽe~ not like '%��Ѻ%' then '��֤' "+
	 			//"when ~s��ͬ��ϸ@����������ʽe~ like '%��֤%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' then '��֤+����Ѻ' "+
	 			//"when ~s��ͬ��ϸ@����������ʽe~ = '��֤' then '��һ��֤' "+
	 			//"when ~s��ͬ��ϸ@����������ʽe~ like '%����%' and ~s��ͬ��ϸ@����������ʽe~ like '%���Ѻ%' then '����+���Ѻ' "+
	 			//"when ~s��ͬ��ϸ@����������ʽe~ = '����' then '��һ����' "+
	 			//"when ~s��ͬ��ϸ@����������ʽe~ = '��Ѻ' then '��һ��Ѻ' "+
	 			//"when ~s��ͬ��ϸ@����������ʽe~ = '��Ѻ' then '��һ��Ѻ' "+
	 			//"when ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' then '��Ѻ+��Ѻ' "+
	 			" else replace(~s��ͬ��ϸ@����������ʽe~,'��Ѻ','') end";
	 	sWhere="and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ' and not(nvl(~s��ͬ��ϸ@��֤�����(%)e~,0)=100 and (~s��ͬ��ϸ@��Ҫ������ʽe~ like '%���д浥' or ~s��ͬ��ϸ@��Ҫ������ʽe~ like '%��֤��' or ~s��ͬ��ϸ@��Ҫ������ʽe~ like '%��������Ҵ��%'))";
	 	AIContractHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"���гжһ�Ʊ��ϵ���",groupBy,sWhere);
	 	//4���ӹ��󣬽��кϼƣ������������
	 	AIContractHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * ������ά�Ȳ��뵽�������
	 * @throws Exception 
	 */
	public static void process(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy,String sWhere) throws Exception{
		String sSql="";
 		//1�������߼������Ӷ�ͱ�������Ϣ���봦�����
		String[] groupColumnClause=StringUtils.replaceWithRealSql(groupBy);
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,'"+Dimension+"',"+groupColumnClause[0]+
				" round(sum(case when ~s��ͬ��ϸ@��ͬ��ʼ��e~ like '"+sKey+"%' then ~s��ͬ��ϸ@���e~ else 0 end)/10000,2) as BusinessSum,"+//����Ͷ�Ž��
				" round(sum(~s��ͬ��ϸ@���e~)/10000,2) as Balance,"+ 
				" round(sum(~s��ͬ��ϸ@���e~*(100-nvl(~s��ͬ��ϸ@��֤�����(%)e~,0))/100)/10000,2) as CKBalance"+
				" from Batch_Import_Interim "+
				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s��ͬ��ϸ@���e~,0)>0 "+
				" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'') <> '' "+
				" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'X') not like '%����%' "+
				" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'X') not like '%���%' "+
				sWhere+
				//" and nvl(~s��ͬ��ϸ@ҵ��Ʒ��e~,'X') not like '%����%' "+
				"group by ConfigNo,OneKey"+groupColumnClause[1];
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance,CKBalance)"+
 				"( "+
 				sSql+
 				")");
	}
	//����С�� �ϼ� ��������Ƚ�ֵ
	public static void afterProcess(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//1���������ά�ȵ�С��
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'@С��',"+
			"round(sum(BusinessSum),2) as BusinessSum," +
			"round(sum(Balance),2) as Balance, "+
			" round(sum(CKBalance),2) as CKBalance"+
			" from Batch_Import_Process "+
			" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			" group by ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance,CKBalance)"+
 				"( "+
 				sSql+
 				")");
		//2���������ά�ȵ��ܼ�
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,Dimension,'�ܼ�@�ܼ�',"+
			"round(sum(BusinessSum),2) as BusinessSum," +
			"round(sum(Balance),2) as Balance,"+
			" round(sum(CKBalance),2) as CKBalance"+
			" from Batch_Import_Process "+
			"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('С��',DimensionValue)=0 "+
			"group by ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance,CKBalance)"+
 				"( "+
 				sSql+
 				")");
 		//3��ռ�ȸ���
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
	 					"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
	 					"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio, " +
	 					"case when nvl(tab2.CKBalance,0)<>0 then round(tab1.CKBalance/tab2.CKBalance*100,2) else 0 end as CKBalanceRatio " +
	 					"from "+
						"(select Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+
							"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
						")tab1,"+
						"(select Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+	
							"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('�ܼ�',DimensionValue)>0"+
						")tab2"+
						" where tab1.Dimension=tab2.Dimension)tab3 "+
			" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BusinessSumRatio,BalanceRatio,CKBalanceRatio)="+
 				"(select tab3.BusinessSumRatio,tab3.BalanceRatio,tab3.CKBalanceRatio "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 "+sSql+")"
 				);
 		//4�����ǰһ�������ֵ�ͷ��ȸ���
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
	 					"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceToLY,"+
	 					"(nvl(tab1.CKBalance,0)-nvl(tab2.CKBalance,0)) as CKBalanceToLY,"+
	 					"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeToLY, "+
	 					"case when nvl(tab2.CKBalance,0)<>0 then cast(round((nvl(tab1.CKBalance,0)/nvl(tab2.CKBalance,0)-1)*100,2) as numeric(24,6)) else 0 end as CKBalanceRangeToLY " +
	 				" from "+
						"(select Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+
							"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
						")tab1"+
						" left join " +
						"(select Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+	
						"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
						")tab2"+
						" on tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
				" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BalanceTLY,CKBalanceTLY,BalanceRangeTLY,CKBalanceRangeTLY)="+
 				"(select tab3.BalanceToLY,tab3.CKBalanceToLY,tab3.BalanceRangeToLY,tab3.CKBalanceRangeToLY  "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 "+sSql+")"
 				);
 			//�������ȵ��룬������һ��������·ݵ�����ֵ������ֵ�ͷ��ȸ���
 		if(StringFunction.isLike(sKey, "%/12")){
 			sSql="select distinct OneKey from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey>'"+sKey+"'";
 			String[] sOneKey=Sqlca.getStringArray(sSql);
 			String OneKeys=StringFunction.toArrayString(sOneKey, "','");
 			sSql="from (select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
		 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceToLY,"+
		 	 				"(nvl(tab1.CKBalance,0)-nvl(tab2.CKBalance,0)) as CKBalanceToLY,"+
		 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeToLY, " +
		 	 				"case when nvl(tab2.CKBalance,0)<>0 then cast(round((nvl(tab1.CKBalance,0)/nvl(tab2.CKBalance,0)-1)*100,2) as numeric(24,6)) else 0 end as CKBalanceRangeToLY " +
		 	 			" from "+
			 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+
			 					"from Batch_Import_Process "+
			 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
			 				")tab1,"+
			 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+	
			 				"from Batch_Import_Process "+
			 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			 				")tab2"+
			 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
		 		" where tab.OneKey=tab3.OneKey and tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 	 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 	 				"set(BalanceTLY,CKBalanceTLY,BalanceRangeTLY,CKBalanceRangeTLY)="+
 	 				"(select tab3.BalanceToLY,tab3.CKBalanceToLY,tab3.BalanceRangeToLY,tab3.CKBalanceRangeToLY "+
 	 				sSql+""+
 	 				")"+
 	 				" where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 "+sSql+")"
 	 				);
 		}
	}
}