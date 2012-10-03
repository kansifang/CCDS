/*
		Author: --bqliu 2011-05-27
		Tester:
		Describe: --����Ѻ��Ϣ�Ƿ���������
		Input Param:
				ObjectType: ��������
				ObjectNo: ������
		Output Param:
				Message����ʾ��Ϣ
		HistoryLog:lpzhang 2009-9-1 FOR TJ
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.ChangTypeCheckOut;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;


public class CheckVouchInfo extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
				
		
		//�����������ʾ��Ϣ��SQL���
		String sMessage = "",sSql = "";
		//�����������Ҫ������ʽ�������������������
		String sVouchType = "",sMainTable = "",sRelativeTable = "";
		//�����������������־
		String sContinueCheckFlag = "TRUE";		
		//�������: �����ж��ڹ�������ϴ��������ұ������Ϊ�������˵�ʱ���ж��Ƿ��е��� ҵ��Ʒ�֡��������͡��������---add by wangdw
		String sBusinessType = "",sOccurType = "",sChangType = "";
		int iNum = 0;
		//
		//�����������ѯ�����
		ASResultSet rs = null,rs1 = null;			
		
		//���ݶ������ͻ�ȡ�������
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) { 
			sMainTable = rs.getString("ObjectTable");
			sRelativeTable = rs.getString("RelativeTable");
			//����ֵת���ɿ��ַ���
			if (sMainTable == null) sMainTable = "";
			if (sRelativeTable == null) sRelativeTable = "";
		}
		rs.getStatement().close();
		
		if (!sMainTable.equals("")) {
			//--------------��һ��������Ӧ�Ķ���������л�ȡ��������---------------
			sSql = 	" select TempSaveFlag,VouchType,getCustomerType(CustomerID) as CustomerType "+
					" from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next()) { 			
				sVouchType = rs.getString("VouchType");
				//����ֵת���ɿ��ַ���
				if (sVouchType == null) sVouchType = "";
			}
			rs.getStatement().close(); 
		}
		//�жϸñ������Ƿ���1��ҵ��Ʒ��Ϊ����������ϴ��&&2����������Ϊ�������&&3���������Ϊ������˱����
		//�����������������У�鵣����Ϣ-----------------------------------------add by wangdw
		if(ChangTypeCheckOut.getInstance().changtypecheckout_gjj(Sqlca, sMainTable, sObjectNo))
		{
			//�ж��жϸñ������Ƿ���1��ҵ��Ʒ��Ϊ���ǹ�������ϴ��&&2����������Ϊ�������&&3���������Ϊ���ǵ��������
			//�����������������У�鵣����Ϣ-----------------------------------------add by wangdw 2012-06-01
			if(ChangTypeCheckOut.getInstance().changtypecheckout_isnotgjj(Sqlca, sMainTable, sObjectNo))
			{	
			if(sContinueCheckFlag.equals("TRUE"))
			{					
				//--------------�ڶ�������鵣����ͬ�Ƿ�ȫ������---------------
				if (!sVouchType.equals("005")) {//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤�����Ѻ������Ѻ�����ж��Ƿ����뵣����Ϣ
					if(sVouchType.length()>=3) {
						//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤,�������뱣֤������Ϣ
						if(sVouchType.substring(0,3).equals("010") && !sVouchType.equals("0105080"))
						{
							//��鵣����ͬ��Ϣ���Ƿ���ڱ�֤����
							sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
									" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
									" and GuarantyType like '010%' having count(SerialNo) > 0 ";
							rs = Sqlca.getASResultSet(sSql);
							if(rs.next()) 
								iNum = rs.getInt(1);
							rs.getStatement().close();
							
							if(iNum == 0)
								sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��֤����û�������뱣֤�йصĵ�����Ϣ���������Ҫ������ʽ�����뱣֤������Ϣ��"+"";
						}
						
						//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,���������Ѻ������Ϣ
						if(sVouchType.substring(0,3).equals("020"))	{
							//��鵣����ͬ��Ϣ���Ƿ���ڵ�Ѻ����
							sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
									" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
									" and GuarantyType like '050%' having count(SerialNo) > 0 ";
							rs = Sqlca.getASResultSet(sSql);
							if(rs.next()) 
								iNum = rs.getInt(1);
							rs.getStatement().close();
							
							if(iNum == 0){
								sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��Ѻ����û���������Ѻ�йصĵ�����Ϣ���������Ҫ������ʽ�������Ѻ������Ϣ��"+"";
							}
						}
						
						//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,����������Ѻ������Ϣ
						if(sVouchType.substring(0,3).equals("040"))	{
							//��鵣����ͬ��Ϣ���Ƿ������Ѻ����
							sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
									" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
									" and GuarantyType like '060%' having count(SerialNo) > 0 ";
							rs = Sqlca.getASResultSet(sSql);
							if(rs.next()) 
								iNum = rs.getInt(1);
							rs.getStatement().close();
							System.out.println("iNum=" + iNum);
							if(iNum == 0)								
								sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��Ѻ����û����������Ѻ�йصĵ�����Ϣ���������Ҫ������ʽ��������Ѻ������Ϣ��"+"";
						}
						
						sSql = " select SerialNo,GuarantyType from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from APPLY_RELATIVE where "+
					       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and ContractStatus = '010' and GuarantyType like '050%' ";
						rs = Sqlca.getASResultSet(sSql);
						
						while(rs.next()) //ѭ���ж�ÿ����Ѻ��ͬ
						{
							String sGCNo =  rs.getString("SerialNo");  //��õ�����ͬ��ˮ��
							String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
							       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType='"+sObjectType+"'"+
							       " and ObjectNo ='"+sObjectNo+"' and ContractNo = '"+sGCNo+"') "; 
							rs1 = Sqlca.getASResultSet(sSql1);
							if(rs1.next())
							{
								iNum = rs1.getInt(1); 
							}
							rs1.getStatement().close();
							//�жϵ�����ͬ�����Ƿ��ж�Ӧ��
							if (iNum <= 0)
							{
							    sMessage +="������ͬ���Ϊ:"+sGCNo+"�ĵ�����ͬ�����޶�Ӧ�ĵ���Ѻ��Ϣ��";
							}
					     }
					     rs.getStatement().close();
					     
					     sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from APPLY_RELATIVE where "+
					       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and ContractStatus = '010' and GuarantyType like '060%'";
						rs = Sqlca.getASResultSet(sSql);
						while(rs.next()) //ѭ���ж�ÿ����Ѻ��ͬ
						{
							String sGCNo =  rs.getString("SerialNo");  //��õ�����ͬ��ˮ��
							String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
							       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType='"+sObjectType+"'"+
							       " and ObjectNo ='"+sObjectNo+"' and ContractNo = '"+sGCNo+"') "; 
							rs1 = Sqlca.getASResultSet(sSql1);
							if(rs1.next())
							{
								iNum = rs1.getInt(1); 
							}
							rs1.getStatement().close();
							//�жϵ�����ͬ�����Ƿ��ж�Ӧ��
							if (iNum <= 0)
							{
							    sMessage +="������ͬ���Ϊ:"+sGCNo+"�ĵ�����ͬ�����޶�Ӧ�ĵ���Ѻ��Ϣ��";
							}
					     }
					     rs.getStatement().close();
					}else{
						sMessage  += "������ж������Ҫ������ʽ���С��3λ��CODE_LIBRARY.VouchType:"+sVouchType+"���������ĳЩ����Ҫ�ز���̽���������˶Ժ�������̽�⣡"+"";
					}
				}
				
			}
		}
		}
		return sMessage;
	 }
	 

}
