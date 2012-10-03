/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --̽���ͬ����
		Input Param:
				ObjectType: ��������
				ObjectNo: ������
		Output Param:
				Message��������ʾ��Ϣ
		HistoryLog:lpzhang 2009-9-1 FOR TJ
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;
import com.amarsoft.app.util.ChangTypeCheckOut;

public class CheckContractRisk extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
				
		
		//�����������ʾ��Ϣ��SQL��䡢ҵ�����Ʒ����
		String sMessage = "",sSql = "",sBusinessSum = "",sBusinessType = "",sCustomerID="",MFCustomerID="",sMaturity="";
		//�����������Ҫ������ʽ�������������������
		String sVouchType = "",sMainTable = "",sRelativeTable = "",sCustomerType="",sTableName="",sOccurType="",sChangType="";
		//����������ݴ��־,��������־
		String sTempSaveFlag = "",sContinueCheckFlag = "TRUE";		
		//���������Ʊ������
		int iBillNum = 0,iNum = 0;
		
		double dBalance2=0,dBalance =0;
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
			//--------------��һ��������ͬ��Ϣ�Ƿ�ȫ������---------------
			//����Ӧ�Ķ���������л�ȡ����Ʒ���͡�Ʊ����������������
			sSql = 	" select TempSaveFlag,BusinessSum,BusinessType,BillNum,VouchType,getCustomerType(CustomerID) as CustomerType ,CustomerID,OccurType,Maturity "+
					" from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	 
				sBusinessSum = rs.getString("BusinessSum");				
				sBusinessType = rs.getString("BusinessType");
				iBillNum = rs.getInt("BillNum");
				sVouchType = rs.getString("VouchType");
				sCustomerType = rs.getString("CustomerType"); 
				sOccurType = rs.getString("OccurType"); 
				sCustomerID = rs.getString("CustomerID"); 
				sMaturity = rs.getString("Maturity"); 
				//����ֵת���ɿ��ַ���
				if (sTempSaveFlag == null) sTempSaveFlag = "";
				if (sBusinessSum == null) sBusinessSum = ""; 
				if (sBusinessType == null) sBusinessType = "";
				if (sVouchType == null) sVouchType = "";
				if (sCustomerType == null) sCustomerType = "";
				if (sOccurType == null) sOccurType = "";
				if (sCustomerID == null) sCustomerID = "";
				if (sMaturity == null) sMaturity = "";
								
				if (sTempSaveFlag.equals("1")) {			
					sMessage = "��ͬ������ϢΪ�ݴ�״̬��������д���ͬ������Ϣ��������水ť��"+"@";
					sContinueCheckFlag = "FALSE";							
				}			
			}
			rs.getStatement().close(); 
		}
		
		if(sContinueCheckFlag.equals("TRUE"))
		{					
			//--------------�ڶ�������鵣����ͬ�Ƿ�ȫ������---------------
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ���ã����ж��Ƿ����뵣����Ϣ����������˵�����Ϣ������ʾ
			if (sVouchType.equals("005")) {
				/*
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType='GuarantyContract') having count(SerialNo) > 0";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum > 0)
					sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ���ã���Ӧ�����뵣����Ϣ���������Ҫ������ʽ��ɾ��������Ϣ��"+"@";
				*/
			}
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤�����Ѻ������Ѻ�����ж��Ƿ����뵣����Ϣ,���ڳ������ñ������ʣ�
			//����Ʊ�����֣���������֤Ѻ��,����͢ȡ���ÿ���
			else if(!"1080030".equals(sBusinessType)&&!"1080035".equals(sBusinessType)
					&&!"1080055".equals(sBusinessType)&&!"1080060".equals(sBusinessType)) 
			{
				//�жϸñ������Ƿ���1��ҵ��Ʒ��Ϊ����������ϴ��&&2����������Ϊ�������&&3���������Ϊ������˱����
				//�����������������У�鵣����Ϣ-----------------------------------------add by wangdw
				if(ChangTypeCheckOut.getInstance().changtypecheckout_gjj(Sqlca, sMainTable, sObjectNo))
				{
				//�ж��жϸñ������Ƿ���1��ҵ��Ʒ��Ϊ���ǹ�������ϴ��&&2����������Ϊ�������&&3���������Ϊ���ǵ��������
				//�����������������У�鵣����Ϣ-----------------------------------------add by wangdw 2012-06-01
				if(ChangTypeCheckOut.getInstance().changtypecheckout_isnotgjj(Sqlca, sMainTable, sObjectNo))
				{	
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
							sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��֤����û�������뱣֤�йصĵ�����Ϣ���������Ҫ������ʽ�����뱣֤������Ϣ��"+"@";
					}
					
					//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,���������Ѻ������Ϣ�����һ���Ҫ����Ӧ�ĵ�Ѻ����Ϣ
					if(sVouchType.substring(0,3).equals("020"))	{
						//��鵣����ͬ��Ϣ���Ƿ���ڵ�Ѻ����
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '050%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						
						if(iNum == 0)
							sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��Ѻ����û���������Ѻ�йصĵ�����Ϣ���������Ҫ������ʽ�������Ѻ������Ϣ��"+"@";
						else {							
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from CONTRACT_RELATIVE where "+
						       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and GuarantyType in ('050')";
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
								    sMessage +="������ͬ���Ϊ:"+sGCNo+"�ĵ�����ͬ�����޶�Ӧ�ĵ�Ѻ��Ϣ��@";
								}
						     }
						     rs.getStatement().close();
						}										
					}
					
					//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,����������Ѻ������Ϣ�����һ���Ҫ����Ӧ��������Ϣ
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
							sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��Ѻ����û����������Ѻ�йصĵ�����Ϣ���������Ҫ������ʽ��������Ѻ������Ϣ��"+"@";
						else {							
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from CONTRACT_RELATIVE where "+
						       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and GuarantyType in ('060')";
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
								    sMessage +="������ͬ���Ϊ:"+sGCNo+"�ĵ�����ͬ�����޶�Ӧ����Ѻ��Ϣ��@";
								}
						     }
						     rs.getStatement().close();
						}												
					}	
				}else{
					sMessage  += "������ж������Ҫ������ʽ���С��3λ��CODE_LIBRARY.VouchType:"+sVouchType+"���������ĳЩ����Ҫ�ز���̽���������˶Ժ�������̽�⣡"+"@";
				}
				}
			}
			}
			//--------------���������������ҵ�����Ʊ��ҵ����Ϣһ��---------------
			if(sBusinessType.length()>=4) {
				//�����Ʒ����Ϊ����ҵ��
				if(sBusinessType.substring(0,4).equals("1020"))	{
					sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' "+
							" having sum(BillSum) = "+sBusinessSum+" ";
					rs = Sqlca.getASResultSet(sSql);
					if(rs.next()) 
						iNum = rs.getInt(1);
					rs.getStatement().close();
					
					if(iNum == 0)
						sMessage  += "ҵ�����Ʊ�ݽ���ܺͲ�����"+"@";
										
					sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' "+
							" having count(SerialNo) = "+iBillNum+" ";
					rs = Sqlca.getASResultSet(sSql);
					if(rs.next()) 
						iNum = rs.getInt(1);
					rs.getStatement().close();
					
					if(iNum == 0)
						sMessage += "ҵ���������Ʊ�������������Ʊ������������"+"@";
				}					
			}else{
				sMessage  += "��Ʒ���ж���Ĳ�Ʒ���С��4λ��BUSINESS_TYPE.TypeNo:"+sBusinessType+"���������ĳЩ����Ҫ�ز���̽���������˶Ժ�������̽�⣡"+"@";
			}
			
			
			 //--------------���Ĳ������ÿͻ��Ƿ��к���ϵͳ�ͻ���---------------	
			/*sSql = "select MFCustomerID from Customer_Info where CustomerID ='"+sCustomerID+"'";
			MFCustomerID = Sqlca.getString(sSql);
			if(MFCustomerID == null) MFCustomerID="";
			if("".equals(MFCustomerID))
			{
				sMessage += "�ÿͻ��ĺ��Ŀͻ���Ϊ�գ����ܽ��зŴ����룡"+"@";
			}*/
			
			
			 //--------------���岽�����ÿͻ�����Ѻ���Ƿ����---------------	
			/*
			sSql = " select Count(GuarantyID)  from GUARANTY_INFO "+
					       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType='BusinessContract' "+
					       " and ObjectNo ='"+sObjectNo+"' ) and   GuarantyStatus <> '02'"; 
			
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				iNum = rs.getInt(1);
			}
			rs.getStatement().close();
			if(iNum > 0)
				sMessage += "���ڵ���Ѻ��δ��⣬���ܽ��зŴ���"+"@";
			*/
			
			
			//--------------�����������»���ҵ���Ƿ��뵱ǰ�������---------------		
			if(sOccurType.equals("060"))
			{
				//���ս�ݽ��»���
				String BDSerialNo ="";
				sSql = 	" select ObjectNo from Contract_RELATIVE "+
						" where SerialNo = '"+sObjectNo+"' " +
						" and ObjectType = 'BusinessDueBill' ";
				rs = Sqlca.getASResultSet(sSql);
			    if(rs.next())
			    {
			    	BDSerialNo = rs.getString("ObjectNo");
			    	if(BDSerialNo == null) BDSerialNo ="";
			    }
			    else
			    {
			    	sMessage  += "��ҵ������û�й������ɽ��µ�ԭ��ݣ�"+"@";
			    }
			    rs.getStatement().close();
			    
			    if(!BDSerialNo.equals(""))
			    {
			    	sSql = "select Balance,(INTERESTBALANCE1+INTERESTBALANCE2) as Balance2  from Business_Duebill where SerialNo='"+BDSerialNo+"'";
			    	rs = Sqlca.getASResultSet(sSql);
			    	if(rs.next())
			    	{
			    		dBalance = rs.getDouble("Balance");
			    		dBalance2= rs.getDouble("Balance2");
			    	}
			    	rs.getStatement().close();
			    	if(dBalance>0 || dBalance2>0 )
			    	{
			    		sMessage  += "���ɽ���ԭҵ����ǷϢ��ȫΪ0��"+"@";
			    	}
			    }
				
			}
			//--------------����(����)�Ƿ��뵱ǰ�������---------------		
			if(sOccurType.equals("065"))
			{
				//���ս������(����)
				String BDSerialNo ="";
				sSql = 	" select ObjectNo from Contract_RELATIVE "+
						" where SerialNo = '"+sObjectNo+"' " +
						" and ObjectType = 'BusinessDueBill' ";
				rs = Sqlca.getASResultSet(sSql);
			    if(rs.next())
			    {
			    	BDSerialNo = rs.getString("ObjectNo");
			    	if(BDSerialNo == null) BDSerialNo ="";
			    }
			    else
			    {
			    	sMessage  += "��ҵ������û�й�������(����)��ԭ��ݣ�"+"@";
			    }
			    rs.getStatement().close();
			    
			    if(!BDSerialNo.equals(""))
			    {
			    	sSql = "select Balance,(INTERESTBALANCE1+INTERESTBALANCE2) as Balance2  from Business_Duebill where SerialNo='"+BDSerialNo+"'";
			    	rs = Sqlca.getASResultSet(sSql);
			    	if(rs.next())
			    	{
			    		dBalance = rs.getDouble("Balance");
			    		dBalance2= rs.getDouble("Balance2");
			    	}
			    	rs.getStatement().close();
			    	if(dBalance>0 || dBalance2>0 )
			    	{
			    		sMessage  += "����(����)ԭҵ����ǷϢ��ȫΪ0��"+"@";
			    	}
			    }
			}
			//--------------������������Ƿ����еĵ�����ͬ��ǩ������ʼ�յ�����---------------
			sSql = " select count(*) from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from CONTRACT_RELATIVE where "+
		       	   " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and (SignDate is null or SignDate='') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				iNum = rs.getInt(1);
			}
			rs.getStatement().close();
			if(iNum > 0)
				sMessage += "���ڵ�����ͬδǩ����Ч�պ͵����գ����ܽ��зŴ���"+"@";
			
			sSql= " select GuarantyRightID from guaranty_info where guarantyid in "+
				  " (select GuarantyID from GUARANTY_RELATIVE where ObjectType = 'BusinessContract' and ObjectNo = '"+sObjectNo+"')"+
				  " and GuarantyType like '010%'"; 
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next()){
				String sGuarantyRightID = rs.getString("GuarantyRightID");
				if(sGuarantyRightID == null) {
					sMessage += "��Ѻ��ͬ�����е�Ѻ����Ϣδ��д���������ܽ��зŴ���"+"@";
					break;
				}
			}
			rs.getStatement().close();
			
			
			//--------------���߲�������Ƿ����еķ��ز���������ı��յ�����Ӧ���ٳ��ں�ͬ�����պ���3����-1��---------------
			if("1050010".equals(sBusinessType)){
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =interpreter.explain(Sqlca,"!WorkFlowEngine.DateExcute("+sMaturity+","+2+","+-1+")"); //��3���� ��ȥһ��
				String sReturn = aReturn.stringValue();
				String sInsuranceEndDate="",sGISerialNo="";
				//��ѯ����Ѻ����Ϣ
				sSql = " select InsuranceEndDate,GuarantyID from Guaranty_Info where  GuarantyType like '010%' and InsuranceEndDate is not null  and InsuranceEndDate <>''  "+
					   " and GuarantyID in (select GuarantyID from  Guaranty_Relative where ObjectNo ='"+sObjectNo+"' and ObjectType ='BusinessContract' ) ";
				rs = Sqlca.getASResultSet(sSql);
				while(rs.next())
				{
					sInsuranceEndDate = rs.getString("InsuranceEndDate");
					sGISerialNo = rs.getString("GuarantyID");
					if(sInsuranceEndDate==null) sInsuranceEndDate="";
					if(sGISerialNo==null) sGISerialNo="";

					if(sInsuranceEndDate.compareTo(sReturn)<1)
					{
						sMessage += "��Ѻ���š�"+sGISerialNo+"���ı��յ�����Ӧ���ٳ��ں�ͬ�����պ���3����-1�죡"+"@";
						break;
					}
				}
				rs.getStatement().close();
								
				System.out.println("sReturn:"+sReturn);			    
			}
			/*
			//--------------�ڶ�ʮ�Ĳ������ų�Ա����ҵ�񣬼�����������+����������ܴ����ʱ���15��---------------
			String JTCustomerID ="";
			sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
				   " and RelationShip like '04%' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				JTCustomerID = rs.getString("CustomerID");
				if(JTCustomerID == null) JTCustomerID ="";
			}
			rs.getStatement().close();
			if(!JTCustomerID.equals(""))
			{
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =  interpreter.explain(Sqlca,"!��������.�Ƿ��ʱ���("+sObjectNo+","+sObjectType+",4)");
				String sReturn = aReturn.stringValue();
				if(sReturn.equals("TRUE"))
				{
					sMessage  += "�ñʴ���������+���������������ܴ��ڱ����ʱ����15����"+"@";
				}
			}
			*/
		}	
		
		return sMessage;
	 }
	 

}
