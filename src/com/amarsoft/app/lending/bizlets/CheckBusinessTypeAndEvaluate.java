package com.amarsoft.app.lending.bizlets;




import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.web.dw.ASDataWindow;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;

public class CheckBusinessTypeAndEvaluate extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//申请流水号
		String sObjectNo = "";
		//申请类型
		String sObjectType = "";	
		//客户编号
		String sCustomerID = "";
		//申请业务批准
		String sBusinessType = "";
		//信用评级模型编号
		String sModelNo = "";
		//是否停用并行信用评级
		String sIsInuse = "";
		//sql
		String sSql = "";
		//返回信息
		String sMessage = "";
		//sql游标
		ASResultSet rs2 = null;
		//获取参数
		sObjectNo= (String)this.getAttribute("OjectNo");
		sObjectType= (String)this.getAttribute("ObjectType");
		sCustomerID= (String)this.getAttribute("CustomerID");
		sBusinessType= (String)this.getAttribute("BusinessType");
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		//取是否停用并行客户信用评级
		sIsInuse = Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
		if (sIsInuse== null) sIsInuse="" ;
        if(sIsInuse.equals("2"))
        {
	        sSql = " select ModelNo from Evaluate_Record where ObjectType ='NewEvaluate' "+
		           " and ObjectNo ='"+sCustomerID+"' and EvaluateResult <>'' and EvaluateResult is not null order by AccountMonth desc,SerialNo desc fetch first 1 rows only ";
	        sModelNo = Sqlca.getString(sSql);
	        if (sModelNo == null) sModelNo = "";
	        // 1110010-个人一手住房贷款,1110020-个人二手住房贷款,1110025-直客式住房贷款,1110027-住房公积金组合贷款(商业按揭部分),1140010-个人一手商业用房贷款,1140020-个人二手商业用房贷款
	        // 1140025-直客式商用房贷款,sModelNo.equals("511")-房贷专家打分卡
	        if((("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) > -1) && !sModelNo.equals("511"))
	        {	        	
	        	sMessage = "需要使用“房贷类评分卡”对申请人进行信用等级评估(新模型)!";
	        }else if(sBusinessType.startsWith("1110") && !sModelNo.equals("512") && ("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) == -1)
	        {
	        	sMessage = "需要使用“消费类评分卡”对申请人进行信用等级评估(新模型)!";
	        }else if(sBusinessType.startsWith("1150") && !sModelNo.equals("513"))
	        {	
	        	sMessage = "需要使用“经营性涉农贷款评分卡”对申请人进行信用等级评估(新模型)!";
	        }else if(sBusinessType.startsWith("1140") && !sModelNo.equals("513")&& !sModelNo.equals("514")&& ("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) == -1)
	        {
	        	sMessage = "需要使用“经营性涉农贷款评分卡”或“经营性非涉农贷款评分卡”对申请人进行信用等级评估(新模型)!";
	        }
        }
        else
        {
	        sSql = " select ModelNo from Evaluate_Record where ObjectType ='Customer' "+
		           " and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth desc,SerialNo desc  fetch first 1 rows only ";
	        sModelNo = Sqlca.getString(sSql);
	        if (sModelNo == null) sModelNo = "";
	        // 1110010-个人一手住房贷款,1110020-个人二手住房贷款,1110025-直客式住房贷款,1110027-住房公积金组合贷款(商业按揭部分),1140010-个人一手商业用房贷款,1140020-个人二手商业用房贷款
	        // 1140025-直客式商用房贷款,sModelNo.equals("511")-房贷专家打分卡
	        if((("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) > -1) && !sModelNo.equals("511"))
	        {	   
	        	sMessage = "需要使用“房贷类评分卡”对申请人进行信用等级评估!";
	        }else if(sBusinessType.startsWith("1110") && !sModelNo.equals("512")&& ("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) == -1)
	        {
	        	sMessage = "需要使用“消费类评分卡”对申请人进行信用等级评估!";
	        }else if(sBusinessType.startsWith("1150") && !sModelNo.equals("513"))
	        {	
	        	sMessage = "需要使用“经营性涉农贷款评分卡”对申请人进行信用等级评估!";
	        }else if(sBusinessType.startsWith("1140") && !sModelNo.equals("513")&& !sModelNo.equals("514") && ("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) == -1)
	        {
	        	sMessage = "需要使用“经营性涉农贷款评分卡”或“经营性非涉农贷款评分卡”对申请人进行信用等级评估!";
	        }
        }				
		return sMessage;
	}		
}
