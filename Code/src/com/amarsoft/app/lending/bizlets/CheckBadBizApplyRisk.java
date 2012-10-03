/*
		Author: --xhyong 2009/01/20
		Tester:
		Describe: --̽�ⲻ��ҵ���������̽��
		Input Param:
				ObjectType: ��������
				ObjectNo: ������
		Output Param:
				Message��������ʾ��Ϣ
		HistoryLog: 
*/

package com.amarsoft.app.lending.bizlets;


import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;



public class CheckBadBizApplyRisk extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		 
		//�����������ʾ��Ϣ��SQL��䡢��Ʒ���͡��ͻ�����
		String sMessage = "",sSql = "";
		//�����������ѯ�����
		ASResultSet rs = null;	
		//�ݴ��־,��������
		String sTempSaveFlag = "",sApplyType = "";
		int iAssetCount = 0,iContractCount = 0,iFiContractCount = 0;
		int iLwContractCount = 0,iCount1 = 0, iCount2 = 0,iCount3 = 0;
		//���ݶ������ͻ�ȡ�������
			//--------------��һ�������������Ϣ�Ƿ�ȫ������---------------
		//����Ӧ�Ķ���������л�ȡ�ݴ��־,��������
		sSql = 	" select TempSaveFlag,ApplyType "+
				" from BADBIZ_APPLY where SerialNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		while (rs.next()) { 	
			sTempSaveFlag = rs.getString("TempSaveFlag");
			sApplyType = rs.getString("ApplyType");
			if(!"2".equals(sTempSaveFlag))
			sMessage = "δ��д���������Ϣ��������д�����������Ϣ��������水ť��"+"@";									
		}
		rs.getStatement().close();
		/*
			//--------------�ڶ���������ծ�ʲ���ȡ�����Ϣ�Ƿ�¼��---------------	
		if("010".equals(sApplyType))
		{			
			//�Ƿ���д��ծ�ʲ���Ϣ
			sSql = 	" select count(SerialNo) as iCount "+
						" from ASSET_INFO where  ObjectType='BadBizApply' and ObjectNo = '"+sObjectNo+"'  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iAssetCount=rs.getInt("iCount");							
			}
			if(iAssetCount < 1)
			sMessage += "δ��д��ծ�ʲ���Ϣ��������д���ծ�ʲ���Ϣ�����棡"+"@";		
			rs.getStatement().close();
			//�Ƿ���д������ͬ��Ϣ
			sSql = 	" select count(AB.SerialNo) as iCount "+
			" from ASSET_BIZ AB,BUSINESS_CONTRACT BC "+
			" where  AB.ContractSerialNo = BC.SerialNo and "+
			" AB.ObjectType='BadBizApply' and ObjectNo = '"+sObjectNo+"'  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iContractCount=rs.getInt("iCount");							
			}
			if(iContractCount < 1)
			sMessage += "δ��д������ͬ��Ϣ��������д������ͬ��Ϣ�����棡"+"@";		
			rs.getStatement().close();
		}
			//--------------������������ծ�ʲ����������Ϣ�Ƿ�¼��---------------	
			//--------------���Ĳ��������������Ϣ�Ƿ�¼��---------------	
		if("030".equals(sApplyType))
		{
			
		}
			//--------------���岽���������ս������Ϣ�Ƿ�¼��---------------
		if("040".equals(sApplyType))
		{
				//�Ƿ���д������ͬ��Ϣ
				sSql = 	" select count(BR.ObjectNo) as iCount "+
					" from BUSINESS_CONTRACT BC,BADBIZ_RELATIVE BR  "+
					" where BR.ObjectNo=BC.SerialNo and BR.ObjectType='FinishContract' "+
					" and BR.SerialNo='"+sObjectNo+"'  ";
				rs = Sqlca.getASResultSet(sSql);
				if (rs.next()) { 	
					iFiContractCount=rs.getInt("iCount");							
				}
				if(iFiContractCount < 1)
					sMessage += "δ��д��ͬ��Ϣ��������д��ͬ��Ϣ��"+"@";		
				rs.getStatement().close();
		}
			//--------------��������������ϰ��������Ϣ�Ƿ�¼��---------------	
		if("050".equals(sApplyType))
		{
			//�Ƿ���д������ͬ��Ϣ
			sSql = 	" select count(BR.ObjectNo) as iCount "+
				" from BUSINESS_CONTRACT BC,BADBIZ_RELATIVE BR  "+
				" where BR.ObjectNo=BC.SerialNo and BR.ObjectType='LawCaseContract' "+
				" and BR.SerialNo in (select SerialNo from LAWCASE_INFO "+
						"where  ObjectType = 'BadBizApply' and ObjectNo='"+sObjectNo+"')  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iLwContractCount=rs.getInt("iCount");							
			}
			if(iLwContractCount < 1)
				sMessage += "δ��д��غ�ͬ��Ϣ��������д��غ�ͬ��Ϣ��"+"@";		
			rs.getStatement().close();
			//������������Ϣ
			sSql = 	" select count(SerialNo) as iCount "+
				" from LAWCASE_PERSONS  "+
				" where PersonType = '01' "+
				" and ObjectNo in (select SerialNo from LAWCASE_INFO "+
						"where  ObjectType = 'BadBizApply' and ObjectNo='"+sObjectNo+"')  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iCount1=rs.getInt("iCount");							
			}
			if(iCount1 < 1)
				sMessage += "δ��д������������Ϣ��������д������������Ϣ��"+"@";		
			rs.getStatement().close();
			//������������Ϣ
			sSql = 	" select count(SerialNo) as iCount "+
				" from LAWCASE_PERSONS  "+
				" where PersonType = '02' "+
				" and ObjectNo in (select SerialNo from LAWCASE_INFO "+
						"where  ObjectType = 'BadBizApply' and ObjectNo='"+sObjectNo+"')  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iCount2=rs.getInt("iCount");							
			}
			if(iCount2 < 1)
				sMessage += "δ��д���������Ա��Ϣ��������д���������Ա��Ϣ��"+"@";		
			rs.getStatement().close();
			//������������Ϣ
			sSql = 	" select count(SerialNo) as iCount "+
				" from LAWCASE_PERSONS  "+
				" where PersonType = '03' "+
				" and ObjectNo in (select SerialNo from LAWCASE_INFO "+
						"where  ObjectType = 'BadBizApply' and ObjectNo='"+sObjectNo+"')  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iCount3=rs.getInt("iCount");							
			}
			if(iCount3 < 1)
				sMessage += "δ��д��������Ϣ��������д��������Ϣ��"+"@";		
			rs.getStatement().close();
		}
		
		*/
				
		return sMessage;
	 }
	

}
