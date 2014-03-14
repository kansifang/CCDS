package com.lmt.app.object;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ASException;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.script.AmarInterpreter;
import com.lmt.frameapp.script.Any;
import com.lmt.frameapp.script.Anything;
import com.lmt.frameapp.script.Expression;
import com.lmt.frameapp.script.IScriptObject;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
import com.lmt.frameapp.web.ui.HTMLTab;

public class BizObject implements IBizObject, IScriptObject
{
  private ASValuePool attributes = new ASValuePool();
  private BizObjectType type;
  private String id;
  private String name;
  private String view;
  private String[][] constants = (String[][])null;
  private AmarInterpreter interpreter = null;

  public String id() {
    return this.id;
  }

  public String name() {
    return this.name;
  }

  public Object getAttribute(String sKey)
    throws Exception
  {
    return this.attributes.getAttribute(sKey);
  }

  public void setAttribute(String sKey, Object oValue) throws Exception {
    this.attributes.setAttribute(sKey, oValue);
  }

  public ASValuePool getAttributes() {
    return this.attributes;
  }

  public void init(Transaction Sqlca, BizObjectType bot, String sObjectNo) throws Exception {
    init(Sqlca, bot, sObjectNo, "001");
  }

  public void setInterpreter(AmarInterpreter argInterpreter)
  {
    this.interpreter = argInterpreter;
  }

  public void init(Transaction Sqlca, BizObjectType bot, String sObjectNo, String sViewID) throws Exception
  {
    this.type = bot;
    this.view = sViewID;
    String sTable = (String)getType().getAttribute("ObjectTable");
    String sKeyCol = (String)getType().getAttribute("KeyCol");
    String sNameCol = (String)getType().getAttribute("KeyColName");
    String sSql = "select AttributeID,AttributeName from OBJECT_ATTRIBUTE where ObjectType='" + bot.id + "' and IsInUse='1' ";
    String[][] sAttrs = Sqlca.getStringMatrix(sSql);
    ASResultSet rs = null;

    sSql = "select * from " + sTable + " where " + sKeyCol + "='" + sObjectNo + "' ";
    try {
      rs = Sqlca.getASResultSet(sSql);
    } catch (Exception ex) {
      throw new ASException("对象类型[" + bot.id + "]的主数据表或者关键字段定义错误。请检查OBJECTTYPE_CATALOG表。（" + sSql + "）" + ex.getMessage());
    }
    if (rs.next()) {
      try {
        this.id = rs.getString(sKeyCol);
        this.name = rs.getString(sNameCol);
      } catch (Exception ex) {
        throw new ASException("对象类型[" + bot.id + "]的名称字段(KeyColName)定义错误(" + sNameCol + ")。请检查OBJECTTYPE_CATALOG表。");
      }
      for (int i = 0; i < sAttrs.length; i++)
        try {
          setAttribute(sAttrs[i][0], rs.getString(sAttrs[i][0]));
        } catch (Exception ex) {
          throw new Exception("取对象属性[" + sAttrs[i][0] + "]时发生错误:" + ex.getMessage());
        }
    }
    else {
      for (int i = 0; i < sAttrs.length; i++) {
        this.id = "";
        this.name = "";
        setAttribute(sAttrs[i][0], "");
      }

    }

    rs.getStatement().close();
  }

  public BizObjectType getType()
  {
    return this.type;
  }

  public Object getTypeAttribute(String sKey)
    throws Exception
  {
    return getType().getAttribute(sKey);
  }

  public String[][] getConstants() throws Exception {
    if (this.constants != null) return this.constants;

    Object[] sKeys = this.attributes.getKeys();
    this.constants = new String[sKeys.length][2];
    for (int i = 0; i < this.constants.length; i++)
      if (sKeys[i] != null) {
        this.constants[i][0] = ("#" + (String)sKeys[i]);
        this.constants[i][1] = ((String)getAttribute((String)sKeys[i]));
      }
    return this.constants;
  }

  public String getRightType(Transaction Sqlca, String sUserID, String sViewID) throws Exception {
    String sRightType = null;
    String sExpression = (String)getType().getAttribute("RightType");
    if (sExpression == null) return "All";
    try
    {
      sExpression = StringFunction.replace(sExpression, "#CurObjectType", getType().id);
      sExpression = StringFunction.replace(sExpression, "#CurObjectNo", this.id);
      sExpression = StringFunction.replace(sExpression, "#CurUserID", sUserID);
      sExpression = StringFunction.replace(sExpression, "#ViewID", sViewID);
      sExpression = Expression.pretreatConstant(sExpression, getConstants());

      if (this.interpreter == null) {
        Any aReturn = null;
        aReturn = Expression.getExpressionValue(sExpression, Sqlca);
        sRightType = aReturn.toStringValue();
      } else {
        Anything aReturn = null;
        aReturn = this.interpreter.explain(Sqlca, sExpression);
        sRightType = aReturn.toStringValue();
      }
    }
    catch (Exception ex) {
      ARE.getLog().error("对象权限计算公式解析错误。公式：" + sExpression, ex);
      throw ex;
    }

    return sRightType;
  }

  public IBizObject getRelativeObject(Transaction Sqlca, String sRelationship) throws Exception
  {
    String sSql = "select ObjectType,RelationShip,RelaObjectType,ShowOnTabExpr,RelaExpr from OBJECTTYPE_RELA where ObjectType='" + getTypeAttribute("ObjectType") + "' and RelationShip='" + sRelationship + "' order by SortNo";
    String[][] sRelativeDef = Sqlca.getStringMatrix(sSql);
    for (int i = 0; i < sRelativeDef.length; i++)
    {
      String sShowOnTabExpr = sRelativeDef[i][3];
      sShowOnTabExpr = StringFunction.replace(sShowOnTabExpr, "#ObjectType", (String)this.type.getAttribute("ObjectType"));
      sShowOnTabExpr = StringFunction.replace(sShowOnTabExpr, "#ObjectNo", this.id);
      sShowOnTabExpr = Expression.pretreatConstant(sShowOnTabExpr, getConstants());

      if (this.interpreter == null) {
        Any aShowOnTabExpr = Expression.getExpressionValue(sShowOnTabExpr, Sqlca);
        if (aShowOnTabExpr != null) sShowOnTabExpr = aShowOnTabExpr.toStringValue(); 
      }
      else {
        Anything aShowOnTabExpr = this.interpreter.explain(Sqlca, sShowOnTabExpr);
        if (aShowOnTabExpr != null) sShowOnTabExpr = aShowOnTabExpr.toStringValue();
      }

      if ((sShowOnTabExpr == null) || (sShowOnTabExpr.equalsIgnoreCase("false")))
      {
        continue;
      }
      String sRelaExpr = sRelativeDef[i][4];
      String sRelaObjectNo = null;
      sRelaExpr = StringFunction.replace(sRelaExpr, "#ObjectType", (String)this.type.getAttribute("ObjectType"));
      sRelaExpr = StringFunction.replace(sRelaExpr, "#ObjectNo", this.id);

      sRelaExpr = Expression.pretreatConstant(sRelaExpr, getConstants());

      if (this.interpreter == null) {
        Any aRelaExpr = Expression.getExpressionValue(sRelaExpr, Sqlca);
        if (aRelaExpr != null) sRelaObjectNo = aRelaExpr.toStringValue(); 
      }
      else {
        Anything aRelaExpr = this.interpreter.explain(Sqlca, sRelaExpr);
        if (aRelaExpr != null) sRelaObjectNo = aRelaExpr.toStringValue();
      }
      return BizObjectFactory.getInstance().createBizObject(Sqlca, sRelativeDef[i][2], sRelaObjectNo);
    }
    return null;
  }

  public String[][] getTabArray(Transaction Sqlca) throws Exception {
    String sSql = "select ObjectType,RelationShip,RelaObjectType,ShowOnTabExpr,RelaExpr,ViewExpr,DisplayName from OBJECTTYPE_RELA where ObjectType='" + getTypeAttribute("ObjectType") + "' order by SortNo";
    String[][] sRelativeDef = Sqlca.getStringMatrix(sSql);

    String[] sAddStringArray = null;
    String[][] sTabStrip = new String[20][3];

    for (int i = 0; i < sRelativeDef.length; i++)
    {
      String sShowOnTabExpr = sRelativeDef[i][3];
      sShowOnTabExpr = StringFunction.replace(sShowOnTabExpr, "#ObjectType", (String)this.type.getAttribute("ObjectType"));
      sShowOnTabExpr = StringFunction.replace(sShowOnTabExpr, "#ObjectNo", this.id);
      sShowOnTabExpr = Expression.pretreatConstant(sShowOnTabExpr, getConstants());
      if (this.interpreter == null) {
        Any aShowOnTabExpr = Expression.getExpressionValue(sShowOnTabExpr, Sqlca);
        if (aShowOnTabExpr != null) sShowOnTabExpr = aShowOnTabExpr.toStringValue(); 
      }
      else {
        Anything aShowOnTabExpr = this.interpreter.explain(Sqlca, sShowOnTabExpr);
        if (aShowOnTabExpr != null) sShowOnTabExpr = aShowOnTabExpr.toStringValue();
      }

      if ((sShowOnTabExpr == null) || (sShowOnTabExpr.equalsIgnoreCase("false")))
      {
        continue;
      }
      String sRelaExpr = sRelativeDef[i][4];
      String sRelaObjectNo = null;
      if (sRelaExpr == null) {
        sRelaObjectNo = "";
      } else {
        sRelaExpr = StringFunction.replace(sRelaExpr, "#ObjectType", DataConvert.toString((String)this.type.getAttribute("ObjectType")));
        sRelaExpr = StringFunction.replace(sRelaExpr, "#ObjectNo", this.id);
        sRelaExpr = Expression.pretreatConstant(sRelaExpr, getConstants());

        if (this.interpreter == null) {
          Any aRelaExpr = Expression.getExpressionValue(sRelaExpr, Sqlca);
          if (aRelaExpr != null) sRelaObjectNo = aRelaExpr.toStringValue(); 
        }
        else {
          Anything aRelaExpr = this.interpreter.explain(Sqlca, sRelaExpr);
          if (aRelaExpr != null) sRelaObjectNo = aRelaExpr.toStringValue();
        }

      }

      String sViewExpr = sRelativeDef[i][5];
      String sViewScript = null;
      if (sViewExpr == null) {
        sViewScript = "";
      } else {
        sViewExpr = StringFunction.replace(sViewExpr, "#ObjectType", (String)this.type.getAttribute("ObjectType"));
        sViewExpr = StringFunction.replace(sViewExpr, "#ObjectNo", this.id);
        sViewExpr = StringFunction.replace(sViewExpr, "#ViewID", this.view);
        sViewExpr = StringFunction.replace(sViewExpr, "#RelaObjectType", sRelativeDef[i][2]);
        sViewExpr = StringFunction.replace(sViewExpr, "#RelaObjectNo", sRelaObjectNo);
        sViewExpr = Expression.pretreatConstant(sViewExpr, getConstants());

        if (this.interpreter == null) {
          Any aViewExpr = Expression.getExpressionValue(sViewExpr, Sqlca);
          if (aViewExpr != null) sViewScript = aViewExpr.toStringValue(); 
        }
        else {
          Anything aViewExpr = this.interpreter.explain(Sqlca, sViewExpr);
          if (aViewExpr != null) sViewScript = aViewExpr.toStringValue();
        }
      }
      sAddStringArray = new String[] { "", sRelativeDef[i][6], sViewScript };
      sTabStrip = HTMLTab.addTabArray(sTabStrip, sAddStringArray);
    }
    return sTabStrip;
  }

  public Object[] getKeys() {
    return this.attributes.getKeys();
  }

  public void setAttributes(ASValuePool attributes) throws Exception {
    this.attributes = attributes;
  }
}