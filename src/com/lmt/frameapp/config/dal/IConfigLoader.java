package com.lmt.frameapp.config.dal;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.frameapp.sql.Transaction;

public abstract interface IConfigLoader
{
  public abstract ASValuePool loadConfig(Transaction paramTransaction)
    throws Exception;
}