--存放评级初始结果
alter table evaluate_record  add EvaluateFirstResult varchar(80);
--备份银行自身权重（内部权重）
alter table evaluate_model  add CoefficientBackup Decimal(24,6);