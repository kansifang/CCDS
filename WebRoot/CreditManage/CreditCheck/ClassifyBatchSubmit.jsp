<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu
		Tester:
		Content: --批量提交风险分类
		Input Param:
                  
		Output param:
		       DoNo:--模板号码
		       EditRight: --编辑权限
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "批量提交风险分类"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";//--存放sql语句
	String sSortNo=""; //--排序编号
	//获得页面参数	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String[][] sHeaders = {
								{"MultiSelectionFlag","双击√选"},
								{"ObjectNo","申请流水号"},
								{"BCObjectNo","合同流水号"},
								{"CustomerName","客户名称"},
								{"BusinessTypeName","业务品种"},
								{"BusinessSum","合同金额"},
								{"Balance","合同余额"},	
								{"Result2Name","客户经理风险分类结果"},	
				             };
	sSql =  " select '' as MultiSelectionFlag,FT.ObjectNo as ObjectNo,CR.ObjectNo as BCObjectNo,"+
			" BC.CustomerName as CustomerName,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			" BC.BusinessSum as BusinessSum,BC.Balance as Balance,"+
			" getItemName('ClassifyResult',CR.ClassifyLevel) as Result2Name, "+
			" FT.ObjectType as ObjectType,FT.FlowNo as FlowNo,FT.PhaseNo as PhaseNo "+
			" from FLOW_TASK FT,CLASSIFY_RECORD CR,BUSINESS_CONTRACT BC "+
			" where BC.SerialNo = CR.ObjectNo and FT.ObjectType =  'ClassifyApply' "+
			" and  FT.ObjectNo = CR.SerialNo and FT.FlowNo='ClassifyFlow'  "+
			" and FT.PhaseNo='0040' and FT.UserID='"+CurUser.UserID+"'"+
			" and CR.ObjectType='BusinessContract' and (FT.EndTime is  null  or  FT.EndTime = '')"+
			" order by FT.SerialNo desc ";
			
	//产生ASDataObject对象doTemp		
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置修改表名
	doTemp.UpdateTable = "BUSINESS_TYPE";
	//设置主键
	doTemp.setKey("TypeNo",true);
	//设置不可视列
	doTemp.setVisible("PhaseNo,FlowNo,ObjectType",false);
	
	
	doTemp.setAlign("MultiSelectionFlag","2");
	doTemp.setHTMLStyle("MultiSelectionFlag","style={width:60px} ondblclick=\"javascript:parent.onClickStatus()\"");
	
	doTemp.setType("BusinessSum,Balance","Number");
	
	//过滤查询
 	doTemp.setFilter(Sqlca,"1","BCObjectNo","");
 	doTemp.setFilter(Sqlca,"2","BusinessTypeName","");
 	doTemp.setFilter(Sqlca,"3","Result2Name","");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//设置页面显示的列数
	dwTemp.setPageSize(100);
  	

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			{"true","","Button","全选","全选","selectAll()",sResourcesPath},
			{"true","","Button","全不选","全不选","cancelSelect()",sResourcesPath},
			{"true","","Button","反选","反选","inverseSelect()",sResourcesPath},
			{"true","","Button","批量提交","批量提交","batchSubmit()",sResourcesPath}				
		   };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    
	//---------------------定义按钮事件------------------------------------
	
	//-----全选相关begin
	aIndex="";

	//双击选择
	function onClickStatus()
	{
		sMultiSelectionFlag = getItemValue(0,getRow(),"MultiSelectionFlag");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(aIndex.indexOf(sObjectNo+"@")<0)
		{
			setItemValue(0,getRow(),"MultiSelectionFlag","√");
			aIndex=aIndex+sObjectNo+"@";
		}
		else
		{
			setItemValue(0,getRow(),"MultiSelectionFlag","");
			aIndex=aIndex.replace(sObjectNo+"@","");
		}
	}

	//反选
	function inverseSelect()
	{
		var b = getRowCount(0);
		for(var iMSR = 0 ; iMSR < b ; iMSR++)
		{
			sObjectNo = getItemValue(0,iMSR,"ObjectNo");
			if(aIndex.indexOf(sObjectNo+"@")<0){
				setItemValue(0,iMSR,"MultiSelectionFlag","√");
				aIndex=aIndex+sObjectNo+"@";
			}else{
				setItemValue(0,iMSR,"MultiSelectionFlag","");
				aIndex=aIndex.replace(sObjectNo+"@","");
			}
		}
	}

	function selectAll()
	{
		var totalRowcount = getRowCount(0);
		//alert(curpage+"@"+pagesize) ;
	    var iterator=curpage*pagesize;                        //翻页后的叠加步长
	    var currentRowCount = 0;                                //当前页的数据行数
	    if(curpage==(pagenum-1)){        //如果当前页为末页，则调整当页的数据条数
	            currentRowCount = parseInt(totalRowcount)-parseInt(iterator);
	    }else{
	            currentRowCount = pagesize;
	    }
	    //--------------叠加后的循环节点终点
	    var iteratorRowCount = parseInt(currentRowCount)+parseInt(iterator);
	    //alert("curpage="+curpage+" |pagenum"+pagenum+" |totalRowcount="+totalRowcount+" |iterator="+iterator+" |currentRowCount="+currentRowCount+" |iteratorRowCount="+(iteratorRowCount));
	    for(var i=iterator; i<iteratorRowCount; i++){
	    	sObjectNo = getItemValue(0,i,"ObjectNo");
            setItemValue(0,i,"MultiSelectionFlag","√");
            aIndex=aIndex+sObjectNo+"@";
	    }
	}
	
	//客户端分页
	function cancelSelect()
	{
		var totalRowcount = getRowCount(0);
        var iterator=curpage*pagesize;                        //翻页后的叠加步长
        var currentRowCount = 0;                                //当前页的数据行数
        if(curpage==(pagenum-1)){        //如果当前页为末页，则调整当页的数据条数
                currentRowCount = parseInt(totalRowcount)-parseInt(iterator);
        }else{
                currentRowCount = pagesize;
        }
        //--------------叠加后的循环节点终点
        var iteratorRowCount = parseInt(currentRowCount)+parseInt(iterator);
        for(var i=iterator; i<iteratorRowCount; i++){
        	sObjectNo = getItemValue(0,i,"ObjectNo");
            setItemValue(0,i,"MultiSelectionFlag","");
            aIndex=aIndex.replace(sObjectNo+"@","");
        }
	}
	
	function batchSubmit(){
		if(typeof(aIndex)=="undefined" || aIndex.length==0){
			alert("至少选择一条记录进行提交！");
			return;
		} 
		else{
			var sObjectType = getItemValue(0,getRow(),"ObjectType");
			var sSerialNo = aIndex.split("@")[0];
			var sFlowNo = getItemValue(0,getRow(),"FlowNo");
			var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
			var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
			var sPhaseInfo = PopPage("/Common/WorkFlow/BatchSubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo.length==0){
				return;
			}
			var sPhaseOpinion1 = sPhaseInfo.split("@")[0];
			var sPhaseAction = sPhaseInfo.split("@")[1];
			var sRetuern = RunMethod("WorkFlowEngine","ClassifyBatchSubmit",sPhaseOpinion1+","+sPhaseAction+","+aIndex+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
			alert(sRetuern);
			reloadSelf();
		}
	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
