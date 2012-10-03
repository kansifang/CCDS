package com.amarsoft.app.creditline;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.web.config.ASConfigure;
import com.amarsoft.web.config.loader.IConfigLoader;

public class CreditLineTypeDefinitionLoader implements IConfigLoader{

	/* (non-Javadoc)
	 * @see com.amarsoft.config.loader.IConfigLoader#loadConfig(com.amarsoft.are.sql.Transaction)
	 */
	public ASValuePool loadConfig(Transaction Sqlca) throws Exception {
        ASValuePool vpCLTypeDef = null;
        String sCLTypeKey = null;
        CreditLineType tmpType= null;
        
        vpCLTypeDef = new ASValuePool();
        String[] sKeys = {"CLTypeID",
        		"CLTypeName",
        		"CLKeeperClass",
        		"Line1BalExpr",
        		"Line2BalExpr",
        		"Line3BalExpr",
        		"CheckExpr",
        		"EffStatus",
        		"Circulatable",
        		"BeneficialType",
        		"CreationWizard",
        		"DONo",
        		"OverviewComp",
        		"CurrencyMode",
        		"ApprovalPolicy",
        		"ContractFlag",
        		"SubContractFlag",
        		"DefaultLimitation"
        		};
        
        StringBuffer sbSelect = new StringBuffer("");
        sbSelect.append("select ");
        for(int i=0;i<sKeys.length;i++) sbSelect.append(sKeys[i]+",");
        sbSelect.deleteCharAt(sbSelect.length()-1);
        sbSelect.append(" from CL_TYPE where EffStatus='1'");
        
        String[][] sValueMatrix = Sqlca.getStringMatrix(sbSelect.toString());
        for(int i=0;i<sValueMatrix.length;i++){
        	sCLTypeKey = sValueMatrix[i][0];
        	tmpType = new CreditLineType();
        	for(int j=0;j<sValueMatrix[i].length;j++){
            	tmpType.setAttribute(sKeys[j],sValueMatrix[i][j]);
            }
            //添加3个参数
        	tmpType.setAttribute("LineSum1",tmpType.getAttribute("Line1BalExpr"));
        	tmpType.setAttribute("LineSum2",tmpType.getAttribute("Line2BalExpr"));
        	tmpType.setAttribute("LineSum3",tmpType.getAttribute("Line3BalExpr"));
        	
            vpCLTypeDef.setAttribute(sCLTypeKey,tmpType,false);
        }

        
        
        ASConfigure.setSysConfig("SYSCONF_CLTYPE",vpCLTypeDef);
        return vpCLTypeDef;		

	}

}
