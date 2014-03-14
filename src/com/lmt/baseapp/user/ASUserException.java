package com.lmt.baseapp.user;

import com.lmt.frameapp.ASException;


class ASUserException extends ASException
{
  private static final long serialVersionUID = 1L;

  public ASUserException(String paramString)
  {
    super(paramString);
  }

  public ASUserException(String paramString, int paramInt)
  {
    super(paramString, paramInt);
  }
}