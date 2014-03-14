package com.lmt.baseapp.flow;

import com.lmt.frameapp.ASException;


class FlowException extends ASException
{
  private static final long serialVersionUID = 1L;

  public FlowException(String paramString)
  {
    super(paramString);
  }

  public FlowException(String paramString, int paramInt)
  {
    super(paramString, paramInt);
  }
}