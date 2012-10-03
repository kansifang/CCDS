package com.amarsoft.app.creditline;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.web.config.ASConfigure;
import com.amarsoft.web.config.loader.IConfigLoader;

public class ErrorTypeDefinitionLoader implements IConfigLoader{

	/* (non-Javadoc)
	 * @see com.amarsoft.config.loader.IConfigLoader#loadConfig(com.amarsoft.are.sql.Transaction)
	 */
	public ASValuePool loadConfig(Transaction Sqlca) throws Exception {
        ASValuePool vpCLTypeDef = null;
        String sCLTypeKey = null;
        ErrorType tmpType= null;
        
        vpCLTypeDef = new ASValuePool();
        String[] sKeys = {"ErrorTypeID",
        		"ErrorTypeName",
        		"ErrorLevel"
        		};
        
        StringBuffer sbSelect = new StringBuffer("");
        sbSelect.append("select ");
        for(int i=0;i<sKeys.length;i++) sbSelect.append(sKeys[i]+",");
        sbSelect.deleteCharAt(sbSelect.length()-1);
        sbSelect.append(" from CL_ERROR_TYPE ");
        
        String[][] sValueMatrix = Sqlca.getStringMatrix(sbSelect.toString());
        for(int i=0;i<sValueMatrix.length;i++){
        	sCLTypeKey = sValueMatrix[i][0];
        	tmpType = new ErrorType();
        	for(int j=0;j<sValueMatrix[i].length;j++){
            	tmpType.setAttribute(sKeys[j],sValueMatrix[i][j]);
            }
            vpCLTypeDef.setAttribute(sCLTypeKey,tmpType,false);
        }

        ASConfigure.setSysConfig("SYSCONF_CL_ERROR_TYPE",vpCLTypeDef);
        return vpCLTypeDef;		

	}

}
