<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2011/05/26
		Tester:
		Describe: 审查报告类型选择框
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<% 	
	//获得页面参数	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")); 		//业务流水号
	if(sCustomerID==null) sCustomerID="";
	
	ASResultSet rs = null;//-- 存放结果集
	String sCertID="";
	String sCustomerName="";
	
	//该成员的证件号码和成员名称
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
<title>关联客户选择框</title>

<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
  <table align="center" width="400" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
   <tr>
      <td nowarp  align="center" colspan=4 bgcolor="#D8D8AF" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:selectCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
<% 
	int iTotalCustomerCount=1;//总客户个数
	String sRelativeCustomerID="";//关联客户
 	String sRelativeCustomerName="";//关联客户名称
	String sRelativeCertID="";//关联客户证件号码
	String temp = "";//
	//Hash相同的客户号，已显示同一客户在关联数上的多次出现
	Hashtable myHashtable = new Hashtable();
	//保存每次搜索关联关系的正方CustomerId集合，第一次搜索只有本客户一条记录
	Vector lastCustomer=new Vector();
	//保存每次要搜索关系关系的客户条件，每次由集合lastCustomer生成
	String whereClause="";
	//搜索层次，搜索到该层次就结束
	int iLayerNum=2;
	
	myHashtable.put(sCustomerID,"0");
	lastCustomer.add(sCustomerID);
	for(int i=0;i<iLayerNum;i++)
	{
		//生成本次搜索的客户条件
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
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" ><font color=red>以下为关联企业相关搜索:</font></td>
	  	</tr>
	  	<%
			}
	  	%>
	  <tr> 
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" >1.<%=(i==1?"关联企业":"")%>同一法人代表</td>
	  </tr>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 选择</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 客户编号</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 证件号码</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 客户名称</td>
	  </tr>
	  <%
	  /****************************取同一法人代表信息*****************************/
	  
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
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" >2.<%=(i==1?"关联企业":"")%>同一实际控制人</td>
	  </tr>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 选择</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 客户编号</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 证件号码</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 客户名称</td>
	  </tr>
	  <%
	  /****************************取同一实际控制人*****************************/
	  
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
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" >3.<%=(i==1?"关联企业":"")%>控制其他企事业法人50% 以上股份的，或为第一大股东的:</td>
	  </tr>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 选择</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 客户编号</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 证件号码</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 客户名称</td>
	  </tr>
	  <%
	  /****************************控制其他企事业法人50% 以上股份的，或为第一大股东的:*****************************/
	  
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
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" >4.<%=(i==1?"关联企业":"")%>被其他企事业法人控股50% 以上股份的，或为第一大股东的:</td>
	  </tr>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 选择</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 客户编号</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 证件号码</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 客户名称</td>
	  </tr>
	  <%
	  /****************************被其他企事业法人控股50% 以上股份的，或为第一大股东的:*****************************/
	  
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
	      <td nowarp align="left"  colspan=4 class="black9pt" bgcolor="#D8D8AF" >5.<%=(i==1?"关联企业":"")%>共同被第三方企事业法人控制50% 以上、个人控股20% 以上股权的,或第一大股东为同一企事业法人的:</td>
	  </tr>
	  <tr> 
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 选择</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 客户编号</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 证件号码</td>
	      <td nowarp colspan=1 bgcolor="#D8D8AF" > 客户名称</td>
	  </tr>
	  <%
	  /****************************被其他企事业法人控股50% 以上股份的，或为第一大股东的:*****************************/
	  
	   //检查：其他企业出资50%以上的企业或个人出资20%以上的个人
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
        <input type="button" name="next" value="确认" onClick="javascript:selectCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
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