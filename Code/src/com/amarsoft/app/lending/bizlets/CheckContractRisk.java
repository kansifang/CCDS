/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --探测合同风险
		Input Param:
				ObjectType: 对象类型
				ObjectNo: 对象编号
		Output Param:
				Message：风险提示信息
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
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
				
		
		//定义变量：提示信息、SQL语句、业务金额、产品类型
		String sMessage = "",sSql = "",sBusinessSum = "",sBusinessType = "",sCustomerID="",MFCustomerID="",sMaturity="";
		//定义变量：主要担保方式、主体表名、关联表名
		String sVouchType = "",sMainTable = "",sRelativeTable = "",sCustomerType="",sTableName="",sOccurType="",sChangType="";
		//定义变量：暂存标志,继续检查标志
		String sTempSaveFlag = "",sContinueCheckFlag = "TRUE";		
		//定义变量：票据张数
		int iBillNum = 0,iNum = 0;
		
		double dBalance2=0,dBalance =0;
		//定义变量：查询结果集
		ASResultSet rs = null,rs1 = null;			
		
		//根据对象类型获取主体表名
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) { 
			sMainTable = rs.getString("ObjectTable");
			sRelativeTable = rs.getString("RelativeTable");
			//将空值转化成空字符串
			if (sMainTable == null) sMainTable = "";
			if (sRelativeTable == null) sRelativeTable = "";
		}
		rs.getStatement().close();
		
		if (!sMainTable.equals("")) {
			//--------------第一步：检查合同信息是否全部输入---------------
			//从相应的对象主体表中获取金额、产品类型、票据张数、担保类型
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
				//将空值转化成空字符串
				if (sTempSaveFlag == null) sTempSaveFlag = "";
				if (sBusinessSum == null) sBusinessSum = ""; 
				if (sBusinessType == null) sBusinessType = "";
				if (sVouchType == null) sVouchType = "";
				if (sCustomerType == null) sCustomerType = "";
				if (sOccurType == null) sOccurType = "";
				if (sCustomerID == null) sCustomerID = "";
				if (sMaturity == null) sMaturity = "";
								
				if (sTempSaveFlag.equals("1")) {			
					sMessage = "合同基本信息为暂存状态，请先填写完合同基本信息并点击保存按钮！"+"@";
					sContinueCheckFlag = "FALSE";							
				}			
			}
			rs.getStatement().close(); 
		}
		
		if(sContinueCheckFlag.equals("TRUE"))
		{					
			//--------------第二步：检查担保合同是否全部输入---------------
			//假如业务基本信息中的主要担保方式为信用，则判断是否输入担保信息，如果输入了担保信息给出提示
			if (sVouchType.equals("005")) {
				/*
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType='GuarantyContract') having count(SerialNo) > 0";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum > 0)
					sMessage  += "在业务中选择的主要担保方式为信用，不应该输入担保信息！请调整主要担保方式或删除担保信息！"+"@";
				*/
			}
			//假如业务基本信息中的主要担保方式为保证、或抵押、或质押，则判断是否输入担保信息,短期出口信用保险融资，
			//出口票据贴现，出口信用证押汇,福费廷取消该控制
			else if(!"1080030".equals(sBusinessType)&&!"1080035".equals(sBusinessType)
					&&!"1080055".equals(sBusinessType)&&!"1080060".equals(sBusinessType)) 
			{
				//判断该笔申请是否是1、业务品种为“公积金组合贷款”&&2、发生类型为“变更”&&3、变更类型为“借款人变更”
				//如果符合上述条件不校验担保信息-----------------------------------------add by wangdw
				if(ChangTypeCheckOut.getInstance().changtypecheckout_gjj(Sqlca, sMainTable, sObjectNo))
				{
				//判断判断该笔申请是否是1、业务品种为“非公积金组合贷款”&&2、发生类型为“变更”&&3、变更类型为“非担保变更”
				//如果符合上述条件不校验担保信息-----------------------------------------add by wangdw 2012-06-01
				if(ChangTypeCheckOut.getInstance().changtypecheckout_isnotgjj(Sqlca, sMainTable, sObjectNo))
				{	
				if(sVouchType.length()>=3) {
					//假如业务基本信息中的主要担保方式为保证,必须输入保证担保信息
					if(sVouchType.substring(0,3).equals("010") && !sVouchType.equals("0105080"))
					{
						//检查担保合同信息中是否存在保证担保
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '010%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						
						if(iNum == 0)
							sMessage  += "在业务中选择的主要担保方式为保证，可没有输入与保证有关的担保信息！请调整主要担保方式或输入保证担保信息！"+"@";
					}
					
					//假如业务基本信息中的主要担保方式为抵押,必须输入抵押担保信息，并且还需要有相应的抵押物信息
					if(sVouchType.substring(0,3).equals("020"))	{
						//检查担保合同信息中是否存在抵押担保
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '050%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						
						if(iNum == 0)
							sMessage  += "在业务中选择的主要担保方式为抵押，可没有输入与抵押有关的担保信息！请调整主要担保方式或输入抵押担保信息！"+"@";
						else {							
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from CONTRACT_RELATIVE where "+
						       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and GuarantyType in ('050')";
							rs = Sqlca.getASResultSet(sSql);
							while(rs.next()) //循环判断每个抵押合同
							{
								String sGCNo =  rs.getString("SerialNo");  //获得担保合同流水号
								String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
								       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType='"+sObjectType+"'"+
								       " and ObjectNo ='"+sObjectNo+"' and ContractNo = '"+sGCNo+"') "; 
								rs1 = Sqlca.getASResultSet(sSql1);
								if(rs1.next())
								{
									iNum = rs1.getInt(1); 
								}
								rs1.getStatement().close();
								//判断担保合同项下是否有对应的
								if (iNum <= 0)
								{
								    sMessage +="担保合同编号为:"+sGCNo+"的担保合同项下无对应的抵押信息！@";
								}
						     }
						     rs.getStatement().close();
						}										
					}
					
					//假如业务基本信息中的主要担保方式为质押,必须输入质押担保信息，并且还需要有相应的质物信息
					if(sVouchType.substring(0,3).equals("040"))	{
						//检查担保合同信息中是否存在质押担保
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '060%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						System.out.println("iNum=" + iNum);
						if(iNum == 0)								
							sMessage  += "在业务中选择的主要担保方式为质押，可没有输入与质押有关的担保信息！请调整主要担保方式或输入质押担保信息！"+"@";
						else {							
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from CONTRACT_RELATIVE where "+
						       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and GuarantyType in ('060')";
							rs = Sqlca.getASResultSet(sSql);
							while(rs.next()) //循环判断每个质押合同
							{
								String sGCNo =  rs.getString("SerialNo");  //获得担保合同流水号
								String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
								       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType='"+sObjectType+"'"+
								       " and ObjectNo ='"+sObjectNo+"' and ContractNo = '"+sGCNo+"') "; 
								rs1 = Sqlca.getASResultSet(sSql1);
								if(rs1.next())
								{
									iNum = rs1.getInt(1); 
								}
								rs1.getStatement().close();
								//判断担保合同项下是否有对应的
								if (iNum <= 0)
								{
								    sMessage +="担保合同编号为:"+sGCNo+"的担保合同项下无对应的质押信息！@";
								}
						     }
						     rs.getStatement().close();
						}												
					}	
				}else{
					sMessage  += "代码表中定义的主要担保方式编号小于3位（CODE_LIBRARY.VouchType:"+sVouchType+"），申请的某些风险要素不能探测出来，请核对后再重新探测！"+"@";
				}
				}
			}
			}
			//--------------第三步：检查贴现业务和其票据业务信息一致---------------
			if(sBusinessType.length()>=4) {
				//如果产品类型为贴现业务
				if(sBusinessType.substring(0,4).equals("1020"))	{
					sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' "+
							" having sum(BillSum) = "+sBusinessSum+" ";
					rs = Sqlca.getASResultSet(sSql);
					if(rs.next()) 
						iNum = rs.getInt(1);
					rs.getStatement().close();
					
					if(iNum == 0)
						sMessage  += "业务金额和票据金额总和不符！"+"@";
										
					sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' "+
							" having count(SerialNo) = "+iBillNum+" ";
					rs = Sqlca.getASResultSet(sSql);
					if(rs.next()) 
						iNum = rs.getInt(1);
					rs.getStatement().close();
					
					if(iNum == 0)
						sMessage += "业务中输入的票据张数和输入的票据张数不符！"+"@";
				}					
			}else{
				sMessage  += "产品表中定义的产品编号小于4位（BUSINESS_TYPE.TypeNo:"+sBusinessType+"），申请的某些风险要素不能探测出来，请核对后再重新探测！"+"@";
			}
			
			
			 //--------------第四步：检查该客户是否有核心系统客户号---------------	
			/*sSql = "select MFCustomerID from Customer_Info where CustomerID ='"+sCustomerID+"'";
			MFCustomerID = Sqlca.getString(sSql);
			if(MFCustomerID == null) MFCustomerID="";
			if("".equals(MFCustomerID))
			{
				sMessage += "该客户的核心客户号为空，不能进行放贷申请！"+"@";
			}*/
			
			
			 //--------------第五步：检查该客户抵质押物是否都入库---------------	
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
				sMessage += "存在抵质押物未入库，不能进行放贷！"+"@";
			*/
			
			
			//--------------第六步：借新还旧业务是否与当前申请关联---------------		
			if(sOccurType.equals("060"))
			{
				//按照借据借新还旧
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
			    	sMessage  += "该业务申请没有关联还旧借新的原借据！"+"@";
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
			    		sMessage  += "还旧借新原业务余额、欠息不全为0！"+"@";
			    	}
			    }
				
			}
			//--------------新增(续作)是否与当前申请关联---------------		
			if(sOccurType.equals("065"))
			{
				//按照借据新增(续作)
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
			    	sMessage  += "该业务申请没有关联新增(续作)的原借据！"+"@";
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
			    		sMessage  += "新增(续作)原业务余额、欠息不全为0！"+"@";
			    	}
			    }
			}
			//--------------第六步：检查是否所有的担保合同都签署了起始日到期日---------------
			sSql = " select count(*) from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from CONTRACT_RELATIVE where "+
		       	   " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and (SignDate is null or SignDate='') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				iNum = rs.getInt(1);
			}
			rs.getStatement().close();
			if(iNum > 0)
				sMessage += "存在担保合同未签订生效日和到期日，不能进行放贷！"+"@";
			
			sSql= " select GuarantyRightID from guaranty_info where guarantyid in "+
				  " (select GuarantyID from GUARANTY_RELATIVE where ObjectType = 'BusinessContract' and ObjectNo = '"+sObjectNo+"')"+
				  " and GuarantyType like '010%'"; 
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next()){
				String sGuarantyRightID = rs.getString("GuarantyRightID");
				if(sGuarantyRightID == null) {
					sMessage += "抵押合同项下有抵押物信息未填写完整，不能进行放贷！"+"@";
					break;
				}
			}
			rs.getStatement().close();
			
			
			//--------------第七步：检查是否所有的房地产开发贷款的保险到期日应至少长于合同到期日后延3个月-1天---------------
			if("1050010".equals(sBusinessType)){
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =interpreter.explain(Sqlca,"!WorkFlowEngine.DateExcute("+sMaturity+","+2+","+-1+")"); //进3个月 减去一天
				String sReturn = aReturn.stringValue();
				String sInsuranceEndDate="",sGISerialNo="";
				//查询各抵押物信息
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
						sMessage += "抵押物编号【"+sGISerialNo+"】的保险到期日应至少长于合同到期日后延3个月-1天！"+"@";
						break;
					}
				}
				rs.getStatement().close();
								
				System.out.println("sReturn:"+sReturn);			    
			}
			/*
			//--------------第二十四步：集团成员办理业务，集团授信总量+本次申请金额不能大于资本金15％---------------
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
				Anything aReturn =  interpreter.explain(Sqlca,"!审批流程.是否超资本金("+sObjectNo+","+sObjectType+",4)");
				String sReturn = aReturn.stringValue();
				if(sReturn.equals("TRUE"))
				{
					sMessage  += "该笔贷款申请金额+集团授信总量不能大于本行资本金额15％！"+"@";
				}
			}
			*/
		}	
		
		return sMessage;
	 }
	 

}
