/*
		Author: --wangdw  2012-9-4
		Tester:
		Describe: --�����ж�
		Input Param:
				ObjectNo:������ˮ��
				BusinessType����������
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import java.text.DecimalFormat;

import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;

 
public class UpdateContractChange extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{

		//��ö�����ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//��ö�������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//��������
		//����ֵת���ɿ��ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		//���������Sql���
		String sSql = "";
		String sSql1 = "";
		String sChangType = "";			//�������
		String sPurpose = "";			//��;
		String sOldContractNo = "";		//�Ϻ�ͬ��
		String sChangeObject = "";		//�������
		String sOccurType = "";			//��������
		String sFieldValue = "";
		int iFieldType = 0;
		int iColumnCount = 0;
		String sRelativeSerialNo1 = ""; //�µĵ�����ͬ��
		ASResultSet rs = null;
		ASResultSet rs1 = null;
		//��ȡ��������
		sSql = "select nvl(OccurType,'') as OccurType from business_apply where serialno ='"+sObjectNo+"'";
		sOccurType = Sqlca.getString(sSql);
		//��ȡ�������
		sSql = "select nvl(ChangeObject,'') as ChangeObject from business_apply where serialno ='"+sObjectNo+"'";
		sChangeObject = Sqlca.getString(sSql);
		//������������Ǳ�������ұ�������ǡ���ͬ��
		if(sOccurType.equals("120") && sChangeObject.equals("02"))
		{
			sSql = "select nvl(changtype,'') as changtype from business_apply where serialno ='"+sObjectNo+"'";
			sChangType = Sqlca.getString(sSql);//�������
			sSql = "select nvl(BCH.serialno,'') as serialno from APPLY_RELATIVE AR,BUSINESS_CONTRACT_HISTORY BCH  " +
					"where AR.objecttype = 'ContractChange' and AR.serialno = '"+sObjectNo+"' and AR.objectno = BCH.order";
			sOldContractNo = Sqlca.getString(sSql);
			//������������04 ���������Ϣ
			if(sChangType.equals("04"))
			{
				//1�������µ�������APPLY_RELATIVE��ͨ��objecttype=GuarantyContract���ҵ��µ������Ӧ�ĵ�����ͬ�š�
				//2�������µ�������ͨ��APPLY_RELATIVE��objecttype=ContractChange���ҵ���ʷ��ͬ���id
				//3��������ʷ��ͬ��id�ҵ�ԭ��ͬ��
				//4����ԭ��ͬ�����µĵ�����ͬ�ŵĶ�Ӧ��ϵ����contract_RELATIVE
				//5�����֮ǰ�ĵ�����ͬ��Ϣ���û��ֹ�ȥ��ΪʧЧ��ϵͳ�Դ˲�������
				//�����µĴ����ͬ����ǩ����ͬ����Ϣ���ϵĺ�ͬ��
				//(��ͬ״̬��ContractStatus��010��δǩ��ͬ��020����ǩ��ͬ��030����ʧЧ)	
				sSql =  " select GC.SerialNo from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPLY_RELATIVE AR "+
				" where AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and ContractStatus = '020' ";
				rs = Sqlca.getASResultSet(sSql);
				while(rs.next())
				{
					sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
							" values('"+sOldContractNo+"','GuarantyContract','"+rs.getString("SerialNo")+"') ";
					Sqlca.executeSQL(sSql);
					
					//���������׶ε�����Ϣ����ˮ�Ų��ҵ���Ӧ�ĵ�������Ϣ
					sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
							" where ObjectType = '"+sObjectType+"' "+
							" and ObjectNo = '"+sObjectNo+"' "+
							" and ContractNo = '" +rs.getString("SerialNo")+"' ";
					rs1 = Sqlca.getASResultSet(sSql);				
					while(rs1.next())
					{
						sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
								" values('GuarantyContract','"+sOldContractNo+"','"+rs.getString("SerialNo")+"', "+
								" '"+rs1.getString("GuarantyID")+"','Copy','"+rs1.getString("Status")+"','"+rs1.getString("Type")+"') ";
						Sqlca.executeSQL(sSql);	
					}
					rs1.getStatement().close();
				}
				rs.getStatement().close();
				//�����µĴ����ͬ��δǩ���ĵ�����ͬ��Ϣ�������µĵ�����ͬ��Ϣ���ϵĴ����ͬ��
				sSql =  " select GC.* from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPLY_RELATIVE AR "+
						" where AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
						" and GC.ContractStatus = '010' ";
				System.out.println("sSql::::::::::::::::::WWQQ "+sSql); 
				rs = Sqlca.getASResultSet(sSql);
				//��õ�����Ϣ������
				iColumnCount = rs.getColumnCount(); 
				double index = 0;//������ 
				String sGCType = "";
				DecimalFormat decimalformat = new DecimalFormat("00");
				while(rs.next())
				{
					//��õ�����Ϣ���
					sRelativeSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo","GC",Sqlca);
					String sGuarantyType = rs.getString("GuarantyType");
					if(sGuarantyType == null) sGuarantyType = "";
					if(sGuarantyType.equals("050"))//��Ѻ
						sGCType ="2";
					else if(sGuarantyType.equals("060"))//��Ѻ
						sGCType ="3";
					else
						sGCType ="1";
					
					index++;
					
					//sRelativeSerialNo1 = sOldContractNo+sGCType+decimalformat.format(index);
					System.out.println("sRelativeSerialNo1:"+sRelativeSerialNo1);
					//���뵣����Ϣ
					sSql = " insert into GUARANTY_CONTRACT values('"+sRelativeSerialNo1+"'";
					for(int i=2;i<= iColumnCount;i++)
					{
						sFieldValue = rs.getString(i);
						iFieldType = rs.getColumnType(i);
						if (isNumeric(iFieldType))					
						{
							if (sFieldValue == null) sFieldValue = "0"; 
							sSql=sSql +","+sFieldValue;
						}else {
							if (sFieldValue == null) sFieldValue = "";
							sSql=sSql +",'"+sFieldValue +"'";
						}
					}
					sSql= sSql + ")";
					Sqlca.executeSQL(sSql);
					
					//���ĵ�����ͬ״̬
					//sSql =	" update GUARANTY_CONTRACT set ContractStatus='020' where SerialNo = '"+sRelativeSerialNo1+"' ";
					//Sqlca.executeSQL(sSql);
					
					//���¿����ĵ�����Ϣ���ͬ��������
					sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
							" values('"+sOldContractNo+"','GuarantyContract','"+sRelativeSerialNo1+"')";
					Sqlca.executeSQL(sSql);
								
					//���������׶ε�����Ϣ����ˮ�Ų��ҵ���Ӧ�ĵ�������Ϣ
					sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
							" where ObjectType = '"+sObjectType+"' "+
							" and ObjectNo = '"+sObjectNo+"' "+
							" and ContractNo = '" +rs.getString("SerialNo")+"' ";
					rs1 = Sqlca.getASResultSet(sSql);				
					while(rs1.next())
					{
						sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
								" values('BusinessContract','"+sOldContractNo+"','"+sRelativeSerialNo1+"', "+
								" '"+rs1.getString("GuarantyID")+"','Copy','"+rs1.getString("Status")+"','"+rs1.getString("Type")+"') ";
						Sqlca.executeSQL(sSql);	
					}
					rs1.getStatement().close();
				}
				rs.getStatement().close();
				
				
			}
			//������������05 �����;
			if(sChangType.equals("05"))
			{
				//1�������µ��������ҵ���������;��
				//2�������µ�������ͨ��APPLY_RELATIVE��objecttype=ContractChange���ҵ���ʷ��ͬ���id
				//3��������ʷ��ͬ��id�ҵ�ԭ��ͬ��
				//4������ԭ��ͬ����;�ֶΡ�
				sSql ="select nvl(PURPOSE,'') as PURPOSE from business_apply where serialno ='"+sObjectNo+"'";
				sPurpose = Sqlca.getString(sSql);
				sSql = "update BUSINESS_CONTRACT set PURPOSE = '"+sPurpose+"' where serialno = '"+sOldContractNo+"'";
				Sqlca.executeSQL(sSql);
				
			}
		}
		return "123";
	}
	//�ж��ֶ������Ƿ�Ϊ��������
	private boolean isNumeric(int iType) 
	{
		if (iType==java.sql.Types.BIGINT ||iType==java.sql.Types.INTEGER || iType==java.sql.Types.SMALLINT || iType==java.sql.Types.DECIMAL || iType==java.sql.Types.NUMERIC || iType==java.sql.Types.DOUBLE || iType==java.sql.Types.FLOAT ||iType==java.sql.Types.REAL)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}
