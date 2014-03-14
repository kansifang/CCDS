package com.lmt.frameapp.metadata;

public abstract interface ColumnUIMetaData extends MetaDataObject
{
  public static final int ALIGNMENT_CENTER = 0;
  public static final int ALIGNMENT_LEFT = 1;
  public static final int ALIGNMENT_RIGHT = 2;
  public static final int ALIGNMENT_TOP = 3;
  public static final int ALIGNMENT_BOTTOM = 4;
  public static final int VALUE_CHARACTER_UNLIMITED = 0;
  public static final int VALUE_CHARACTER_LIST = 1;
  public static final int VALUE_CHARACTER_CODETABLE = 2;
  public static final int VALUE_CHARACTER_RANGE = 3;

  public abstract int getHAlignment();

  public abstract int getVAlignment();

  public abstract int getValueCharacter();

  public abstract String getValueCodetable();

  public abstract String getValueList();

  public abstract String getValueRange();

  public abstract String getInputMask();

  public abstract boolean matchMask(String paramString);

  public abstract String getDisplayFormat();

  public abstract String getCSS();

  public abstract boolean isKey();

  public abstract boolean isReadOnly();

  public abstract boolean isVisible();

  public abstract boolean isRequired();

  public abstract boolean isSortable();
}