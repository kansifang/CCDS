<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2011/05/26
		Tester:
		Describe: ��鱨������ѡ���
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<% 	
	//���ҳ�����	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")); 		//ҵ����ˮ��
	if(sCustomerID==null) sCustomerID="";
	
	ASResultSet rs = null;//-- ��Ž����
	String sCertID="";
	String sCustomerName="";
	
	//�ó�Ա��֤������ͳ�Ա����
	String sSql = " select CertID,CustomerName from Customer_info where CustomerID = '"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerName = rs.getString("CustomerName");
		sCertID = rs.getString("CertID");
	}
	rs.getStatement().close();
%>

<html>
<head> 
<title>�����ͻ�ѡ���</title>

<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
  <table align="center" width="400" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
   <tr>
      <td nowarp  align="center" colspan=4 bgcolor="#D8D8AF" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:selectCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
<% 
	int iTotalCustomerCount=1;//�ܿͻ�����
	String sRelativeCustomerID="";//�����ͻ�
 	String sRelativeCustomerName="";//�����ͻ�����
	String sRelativeCertID="";//�����ͻ�֤������
	String temp = "";//
	//Hash��ͬ�Ŀͻ��ţ�����ʾͬһ�ͻ��ڹ������ϵĶ�γ���
	Hashtable myHashtable = new Hashtable();
	//����ÿ������������ϵ������CustomerId���ϣ���һ������ֻ�б��ͻ�һ����¼
	Vector lastCustomer=new Vector();
	//����ÿ��Ҫ������ϵ��ϵ�Ŀͻ�������ÿ���ɼ���lastCustomer����
	String whereClause="";
	//������Σ��������ò�ξͽ���
	int iLayerNum=2;
	
	myHashtable.put(sCustomerID,"0");
	lastCustomer.add(sCustomerID);
	for(int i=0;i<iLayerNum;i++)
	{
		//���ɱ��������Ŀͻ�����
		whereClause="'NULL'";
		System.out.println("lastCustomer.size():"+lastCustomer.size());
		for(int j=0;j<lastCustomer.size();j++)
		{
			whereClause=whereClause+",'"+lastCustomer.get(j)+"'";
		}
		lastCustomer.removeAllElements();
		if(!"''".equals(whereClause))
		{
			if(i==1)
			{
%>
		<tr> 
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" ><font color=red>����Ϊ������ҵ�������:</font></td>
	  	</tr>
	  	<%
			}
	  	%>
	  <tr> 
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" >1.<%=(i==1?"������ҵ":"")%>ͬһ���˴���</td>
	  </tr>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > ѡ��</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > �ͻ����</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > ֤������</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > �ͻ�����</td>
	  </tr>
	  <%
	  /****************************ȡͬһ���˴�����Ϣ*****************************/
	  
		sSql =" select distinct CustomerID,getCustomerName(CustomerID) as RelativeCustomerName,"+
				"(select CertID from CUSTOMER_INFO where CustomerID=CR.CustomerID) as CertID"+
				" from Customer_Relative CR "+
				" where CustomerID not in("+whereClause+") and RelationShip = '0100' and RelativeID in (select RelativeID from CUSTOMER_RELATIVE where RelationShip = '0100' and CustomerID in ("+whereClause+")) ";
		rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{           
			sRelativeCustomerID = rs.getString("CustomerID");
			sRelativeCustomerName = rs.getString("RelativeCustomerName");
			sRelativeCertID = rs.getString("CertID");
	  %>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><INPUT TYPE="CHECKBOX" NAME="<%="CustomerList"+iTotalCustomerCount%>" VALUE="<%=sRelativeCustomerID%>"></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCustomerID%></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCertID%></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCustomerName %></td>
	  </tr>
	   <%
	   		iTotalCustomerCount = iTotalCustomerCount+1;
	   if(!myHashtable.containsKey(sRelativeCustomerID))
		{
			lastCustomer.add(sRelativeCustomerID);
			myHashtable.put(sRelativeCustomerID,"0");
		}
		else
		{
			temp=(String)myHashtable.get(sRelativeCustomerID);
			myHashtable.put(sRelativeCustomerID,String.valueOf((Integer.parseInt(temp)+1)));
		}
		}
		rs.getStatement().close();
	   %>
	    
	  <tr> 
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" >2.<%=(i==1?"������ҵ":"")%>ͬһʵ�ʿ�����</td>
	  </tr>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > ѡ��</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > �ͻ����</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > ֤������</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > �ͻ�����</td>
	  </tr>
	  <%
	  /****************************ȡͬһʵ�ʿ�����*****************************/
	  
		sSql =" select distinct CustomerID,getCustomerName(CustomerID) as RelativeCustomerName,"+
				"(select CertID from CUSTOMER_INFO where CustomerID=CR.CustomerID) as CertID"+
				" from Customer_Relative CR "+
				" where  CustomerID not in("+whereClause+") and RelationShip = '0109' and RelativeID in (select RelativeID from CUSTOMER_RELATIVE where RelationShip = '0109' and CustomerID in ("+whereClause+")) ";
		rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{           
			sRelativeCustomerID = rs.getString("CustomerID");
			sRelativeCustomerName = rs.getString("RelativeCustomerName");
			sRelativeCertID = rs.getString("CertID");
	  %>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><INPUT TYPE="CHECKBOX" NAME="<%="CustomerList"+iTotalCustomerCount%>" VALUE="<%=sRelativeCustomerID%>"></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCustomerID%></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCertID%></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCustomerName %></td>
	  </tr>
	   <%
	   		iTotalCustomerCount = iTotalCustomerCount+1;
		   if(!myHashtable.containsKey(sRelativeCustomerID))
			{
				lastCustomer.add(sRelativeCustomerID);
				myHashtable.put(sRelativeCustomerID,"0");
			}
			else
			{
				temp=(String)myHashtable.get(sRelativeCustomerID);
				myHashtable.put(sRelativeCustomerID,String.valueOf((Integer.parseInt(temp)+1)));
			}
		}
		rs.getStatement().close();
	   %>
	   
	   
	    <tr> 
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" >3.<%=(i==1?"������ҵ":"")%>������������ҵ����50% ���Ϲɷݵģ���Ϊ��һ��ɶ���:</td>
	  </tr>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > ѡ��</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > �ͻ����</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > ֤������</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > �ͻ�����</td>
	  </tr>
	  <%
	  /****************************������������ҵ����50% ���Ϲɷݵģ���Ϊ��һ��ɶ���:*****************************/
	  
		sSql =" select distinct RelativeID,getCustomerName(RelativeID) as RelativeCustomerName,"+
				"(select CertID from CUSTOMER_INFO where CustomerID=CR.RelativeID) as CertID"+
				" from Customer_Relative CR "+
				" where CustomerID in("+whereClause+") and RelationShip like '02%'  and (InvestmentProp>=50 or InvestmentStatus='01' ) ";
		rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{           
			sRelativeCustomerID = rs.getString("RelativeID");
			sRelativeCustomerName = rs.getString("RelativeCustomerName");
			sRelativeCertID = rs.getString("CertID");
	  %>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><INPUT TYPE="CHECKBOX" NAME="<%="CustomerList"+iTotalCustomerCount%>" VALUE="<%=sRelativeCustomerID%>"></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCustomerID%></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCertID%></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCustomerName %></td>
	  </tr>
	   <%
	   		iTotalCustomerCount = iTotalCustomerCount+1;
		   if(!myHashtable.containsKey(sRelativeCustomerID))
			{
				lastCustomer.add(sRelativeCustomerID);
				myHashtable.put(sRelativeCustomerID,"0");
			}
			else
			{
				temp=(String)myHashtable.get(sRelativeCustomerID);
				myHashtable.put(sRelativeCustomerID,String.valueOf((Integer.parseInt(temp)+1)));
			}
		}
		rs.getStatement().close();
	   %>
	   
	  <tr> 
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" >4.<%=(i==1?"������ҵ":"")%>����������ҵ���˿ع�50% ���Ϲɷݵģ���Ϊ��һ��ɶ���:</td>
	  </tr>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > ѡ��</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > �ͻ����</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > ֤������</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > �ͻ�����</td>
	  </tr>
	  <%
	  /****************************����������ҵ���˿ع�50% ���Ϲɷݵģ���Ϊ��һ��ɶ���:*****************************/
	  
		sSql =" select distinct RelativeID,getCustomerName(RelativeID) as RelativeCustomerName,"+
				"(select CertID from CUSTOMER_INFO where CustomerID=CR.RelativeID) as CertID"+
				" from Customer_Relative CR "+
				" where  getCustomerType(RelativeID) like '01%' and CustomerID in ("+whereClause+") and RelationShip like '52%'  and (InvestmentProp>=50 or InvestmentStatus='01' ) ";
		rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{           
			sRelativeCustomerID = rs.getString("RelativeID");
			sRelativeCustomerName = rs.getString("RelativeCustomerName");
			sRelativeCertID = rs.getString("CertID");
	  %>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><INPUT TYPE="CHECKBOX" NAME="<%="CustomerList"+iTotalCustomerCount%>" VALUE="<%=sRelativeCustomerID%>"></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCustomerID%></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCertID%></td>
	      <td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCustomerName %></td>
	  </tr>
	   <%
	   		iTotalCustomerCount = iTotalCustomerCount+1;
		   if(!myHashtable.containsKey(sRelativeCustomerID))
			{
				lastCustomer.add(sRelativeCustomerID);
				myHashtable.put(sRelativeCustomerID,"0");
			}
			else
			{
				temp=(String)myHashtable.get(sRelativeCustomerID);
				myHashtable.put(sRelativeCustomerID,String.valueOf((Integer.parseInt(temp)+1)));
			}
		}
		rs.getStatement().close();
	   %>
	   
	   <tr> 
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" >5.<%=(i==1?"������ҵ":"")%>��ͬ������������ҵ���˿���50% ���ϡ����˿ع�20% ���Ϲ�Ȩ��,���һ��ɶ�Ϊͬһ����ҵ���˵�:</td>
	  </tr>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > ѡ��</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > �ͻ����</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > ֤������</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > �ͻ�����</td>
	  </tr>
	  <%
	  /****************************����������ҵ���˿ع�50% ���Ϲɷݵģ���Ϊ��һ��ɶ���:*****************************/
	  
	   //��飺������ҵ����50%���ϵ���ҵ����˳���20%���ϵĸ���
	   sSql = "select distinct CustomerID,getCustomerName(CustomerID) as RelativeCustomerName,"+
		   " (select CertID from CUSTOMER_INFO where CustomerID=CR.CustomerID) as CertID "+
		   " from Customer_Relative CR "+
		   "where RelativeID in(select RelativeID from CUSTOMER_RELATIVE  "+
				                    "where  (InvestmentStatus='01' or (getCustomerType(RelativeID) like '03%' and InvestmentProp >= 20) "+
				                    "or (getCustomerType(RelativeID) like '01%' and InvestmentProp >= 50))"+
				                    " and CustomerID in ("+whereClause+") and RelationShip like '52%' ) "+
		   	"and ( InvestmentStatus='01' or (getCustomerType(RelativeID) like '03%' and InvestmentProp >= 20)"+
		   	" or (getCustomerType(RelativeID) like '01%' and InvestmentProp >= 50)) and CustomerID not in("+whereClause+") and RelationShip like '52%'";
	   rs = Sqlca.getResultSet(sSql);
	   while(rs.next())
	   {
		  
			sRelativeCustomerID = rs.getString("CustomerID");
			sRelativeCustomerName = rs.getString("RelativeCustomerName");
			sRelativeCertID = rs.getString("CertID");
					
		 %>
			<tr> 
				<td nowarp colspan=1 bgcolor="#F0F1DE" ><INPUT TYPE="CHECKBOX" NAME="<%="CustomerList"+iTotalCustomerCount%>" VALUE="<%=sRelativeCustomerID%>"></td>
				<td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCustomerID%></td>
				<td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCertID%></td>
				<td nowarp colspan=1 bgcolor="#F0F1DE" ><%=sRelativeCustomerName %></td>
			</tr>
<%
			iTotalCustomerCount = iTotalCustomerCount+1; 
			if(!myHashtable.containsKey(sRelativeCustomerID))
			{
				lastCustomer.add(sRelativeCustomerID);
				myHashtable.put(sRelativeCustomerID,"0");
			}
			else
			{
				temp=(String)myHashtable.get(sRelativeCustomerID);
				myHashtable.put(sRelativeCustomerID,String.valueOf((Integer.parseInt(temp)+1)));
			}
	    }
	    rs.getStatement().close();
	 }
	}            
%>
   
 
    <tr>
      <td nowarp  align="center" colspan=4 bgcolor="#D8D8AF" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:selectCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
<script language=javascript>
function selectCustomer()
{
	//self.returnValue=document.all("SEX").value;
	for(i=1;i<<%=iTotalCustomerCount%>;i++)
	{
		if(document.all("CustomerList"+i).checked)
		{
			self.returnValue=self.returnValue+"@"+document.all("CustomerList"+i).value;
		}
		
	}
	self.close();
	
}

</script>
</html>
<%@ include file="/IncludeEnd.jsp"%>