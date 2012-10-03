package com.amarsoft.app.lending.bizlets;




import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.web.dw.ASDataWindow;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;

public class AddListRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	 
		int iCount = 0;
		//�������ſͻ�ID
		String sCustomerID = "";
		String sMessage = "";
		//sql
		String sSql = "";
		//��ǰ�û�ID
		String sUserID="";
		String sCustomerName = "";
		//֤�����
		String sCertID = "";
		//֤������
		String sCertType = "";
		//sql�α�
		ASResultSet rs2 = null;
		//�Ǽ�����
		String sInputDate = StringFunction.getToday();
		//��������
		String sUpdateDate = StringFunction.getToday();	
		//ѡ������Ӽ��ų�Ա�Ŀͻ�IDƴ���ַ���
		String sCustomerRelative= (String)this.getAttribute("CustomerRelative");
		sCustomerID = (String)this.getAttribute("CustomerID");
		sUserID = (String)this.getAttribute("UserID");
		//����ֵת��Ϊ���ַ���
		if(sCustomerRelative == null) sCustomerRelative = "";
		//ʵ�����û�����
		ASUser CurUser = new ASUser(sUserID,Sqlca);	
		//�Ǽǻ���
		String sInputOrgID = CurUser.OrgID;
		//Ĭ�Ϲ�����ϵΪ��04��==��������
		String sRelationShip = "04";

		if(!sCustomerRelative.equals(""))
		{           
			String[] CustomerRelativeID = sCustomerRelative.split("@");
			for(int i=1;i<CustomerRelativeID.length;i++)
			{
				iCount = Integer.parseInt(Sqlca.getString(" select Count(CustomerID) from Customer_Relative where CustomerID = '"+sCustomerID+"' and RelativeID = '"+CustomerRelativeID[i]+"' and RelationShip like '04%' "));
				if(iCount < 1)
				{   
					sSql = " select CustomerID,CustomerName,CertID,CertType from CUSTOMER_INFO where CustomerID = '"+CustomerRelativeID[i]+"'";
					rs2 = Sqlca.getResultSet(sSql);
					if(rs2.next())
					{
					    sCustomerName = rs2.getString("CustomerName");
					    sCertID = rs2.getString("CertID");
					    sCertType = rs2.getString("CertType");
					}
					rs2.getStatement().close();
				    String	sSql2 = " insert into CUSTOMER_RELATIVE(CustomerID,RelativeID,CustomerName,RelationShip,CertType,CertID,InputOrgId,InputUserId,InputDate,UpdateDate) values ('"+sCustomerID+"','"+CustomerRelativeID[i]+"','"+sCustomerName+"','"+sRelationShip+"','"+sCertType+"','"+sCertID+"','"+sInputOrgID+"','"+sUserID+"','"+sInputDate+"','"+sUpdateDate+"')";
					Sqlca.executeSQL(sSql2);
					//�������ų�Ա��ϵ
					Sqlca.executeSQL("update ENT_INFO set ECGroupFlag = '1' where CustomerID = '"+CustomerRelativeID[i]+"'");
					sMessage = "���ų�Ա������,�����Ƴ�Ա����Ϊ���������š��ĳ�Ա��Ϣ";					
				}	
			}
		}				
		return sMessage;
	}		
}
