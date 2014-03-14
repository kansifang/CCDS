package com.lmt.baseapp.user;

import com.lmt.frameapp.ASException;

class ASOrgException extends ASException
{
  private static final long serialVersionUID = 1L;

  public ASOrgException(String paramString)
  {
    super(paramString);
  }

  public ASOrgException(String paramString, int paramInt)
  {
    super(paramString, paramInt);
  }
}