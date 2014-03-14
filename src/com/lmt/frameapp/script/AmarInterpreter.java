package com.lmt.frameapp.script;

import java.util.StringTokenizer;
import java.util.Vector;

import com.lmt.app.cms.javainvoke.BizletExecutor;
import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.sql.Transaction;

public class AmarInterpreter
{
  private ASValuePool memory = new ASValuePool();

  public String getScenarioID()
    throws Exception
  {
    IScriptObject sessionProperties = (IScriptObject)this.memory.getAttribute("SESSION_PROPERTIES");
    if (sessionProperties == null) return null;
    String sScenarioID = (String)sessionProperties.getAttribute("SCENARIO_ID");
    return sScenarioID;
  }

  public void setScenarioID(String scenarioID) throws Exception {
    IScriptObject sessionProperties = (IScriptObject)this.memory.getAttribute("SESSION_PROPERTIES");
    if (sessionProperties == null) {
      throw new Exception("没有初始化SESSION_PROPERTIES。");
    }
    sessionProperties.setAttribute("SCENARIO_ID", scenarioID);
  }
  public AmarInterpreter() throws Exception {
    this.memory.setAttribute("USER_STORAGE", new ScriptObject());
    this.memory.setAttribute("SESSION_PROPERTIES", new ScriptObject());
    this.memory.setAttribute("BINDING_TODOLIST", new Vector());

    this.memory.setAttribute("RUNNING_DECISION_TREES", new ASValuePool());
    this.memory.setAttribute("RUNNING_RULE_SETS", new ASValuePool());
    this.memory.setAttribute("RUNNING_SCORE_CARDS", new ASValuePool());
  }

  public Vector bindingToDoList() throws Exception {
    Vector bindingToDoList = (Vector)this.memory.getAttribute("BINDING_TODOLIST");
    return bindingToDoList;
  }

  public void addDictionaries(ASValuePool dictionaries)
    throws Exception
  {
    this.memory.uniteFromValuePool(dictionaries);
  }

  public void addDictionary(String sKey, IScriptObject oDictionary)
    throws Exception
  {
    this.memory.setAttribute(sKey, oDictionary);
  }

  public ASValuePool getMemory()
  {
    return this.memory;
  }

  public void removeDictionary(String sKey)
    throws Exception
  {
    this.memory.delAttribute(sKey);
  }

  public void clearMemory()
    throws Exception
  {
    this.memory.resetPool();
  }

  public Anything explain(Transaction Sqlca, String sScript)
    throws Exception
  {
    AmarScript script = new AmarScript(this.memory);
    return script.getExpressionValue(sScript, Sqlca);
  }

  public void initMemory(Transaction Sqlca, String sScenarioID, String sParaString)
    throws Exception
  {
    setScenarioID(sScenarioID);

    String sClassName = Sqlca.getString("select InitiateClass from SCRIPT_SCENARIO where ScenarioID='" + sScenarioID + "'");
    if ((sClassName == null) || (sClassName.equals(""))) return;
    ASValuePool parameters = getValuePoolFromProfileString(sParaString, ";");

    ASValuePool tmpMemory = null;

    BizletExecutor executor = new BizletExecutor();
    try
    {
      tmpMemory = (ASValuePool)executor.execute(Sqlca, sClassName, parameters);
    } catch (Exception ex) {
      ARE.getLog().error("============initMemory出错。Bizlet：" + sClassName, ex);
      throw ex;
    }

    addDictionaries(tmpMemory);
  }

  public void addBinding(Transaction Sqlca, String sBindedAttributeID, ASValuePool variables) throws Exception {
    String sSql = "select OBJECTATTRID,SCENARIOID,OBJECTATTRNAME,EXECUTESCRIPT,SCRIPTOBJECT,SCRIPTOBJATTR from SCRIPT_BINDING where ScenarioID='" + getScenarioID() + "' and ObjectAttrID='" + sBindedAttributeID + "'";
    String[][] sBindings = Sqlca.getStringMatrix(sSql);
    if (sBindings.length < 1) throw new Exception("没有在场景定义中找到指定的绑定定义！");

    String sBindingScript = sBindings[0][3];
    String sBindingObject = sBindings[0][4];
    String sBindingAttribute = sBindings[0][5];
    String sOutCome = (String)variables.getAttribute("OutCome");

    sBindingScript = StringFunction.macroReplace(variables, sBindingScript, "#{", "}");

    if ((sBindingScript != null) && (!sBindingScript.equals("")))
    {
      bindingToDoList().add(sBindingScript);
    }

    if ((sBindingObject != null) && (sBindingAttribute != null) && (sOutCome != null)) {
      IScriptObject bindedObj = (IScriptObject)getMemory().getAttribute(sBindingObject);
      if (bindedObj == null) {
        bindedObj = new ScriptObject();
        getMemory().setAttribute(sBindingObject, bindedObj);
      }
      bindedObj.setAttribute(sBindingAttribute, sOutCome);
    }
  }

  public void commitBinding(Transaction Sqlca) throws Exception {
    for (int i = 0; i < bindingToDoList().size(); ) {
      String sBindingScript = (String)bindingToDoList().get(i);
      try {
        explain(Sqlca, sBindingScript);
        bindingToDoList().remove(i);
      } catch (Exception ex) {
        ARE.getLog().error("=============更新绑定的业务属性时发生错误:", ex);
        throw ex;
      }
    }
  }

  public static ASValuePool getValuePoolFromProfileString(String data, String delim)
    throws Exception
  {
    StringTokenizer st = new StringTokenizer(data, delim);
    ASValuePool vpReturn = new ASValuePool();
    while (st.hasMoreElements()) {
      String sTempString = st.nextToken();
      if ((sTempString != null) && (!sTempString.equals(""))) {
        String sKey = StringFunction.getSeparate(sTempString, "=", 1);
        String sValue = StringFunction.getSeparate(sTempString, "=", 2);
        vpReturn.setAttribute(sKey, sValue);
      }
    }
    return vpReturn;
  }
}