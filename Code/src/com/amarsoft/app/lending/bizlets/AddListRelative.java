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
		//自动获得传入的参数值	 
		int iCount = 0;
		//关联集团客户ID
		String sCustomerID = "";
		String sMessage = "";
		//sql
		String sSql = "";
		//当前用户ID
		String sUserID="";
		String sCustomerName = "";
		//证件编号
		String sCertID = "";
		//证件类型
		String sCertType = "";
		//sql游标
		ASResultSet rs2 = null;
		//登记日期
		String sInputDate = StringFunction.getToday();
		//更新日期
		String sUpdateDate = StringFunction.getToday();	
		//选择需添加集团成员的客户ID拼成字符串
		String sCustomerRelative= (String)this.getAttribute("CustomerRelative");
		sCustomerID = (String)this.getAttribute("CustomerID");
		sUserID = (String)this.getAttribute("UserID");
		//将空值转化为空字符串
		if(sCustomerRelative == null) sCustomerRelative = "";
		//实例化用户对象
		ASUser CurUser = new ASUser(sUserID,Sqlca);	
		//登记机构
		String sInputOrgID = CurUser.OrgID;
		//默认关联关系为‘04’==关联集团
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
					//建立集团成员关系
					Sqlca.executeSQL("update ENT_INFO set ECGroupFlag = '1' where CustomerID = '"+CustomerRelativeID[i]+"'");
					sMessage = "集团成员添加完成,请完善成员类型为“关联集团”的成员信息";					
				}	
			}
		}				
		return sMessage;
	}		
}
