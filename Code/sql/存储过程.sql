CREATE PROCEDURE sales_status()	 ---存储过程可以设定输入参数和输出参数
LANGUAGE SQL                   ----DB2可以用多种语言编写存储过程，这里用的是纯SQL
BEGIN                          ---开始
DECLARE vID   smallint;        ---定义变量 和Oracle一样 DECLARE   变量名 变量的数据类型;
FOR V AS SELECT userid FROM user_ifo where userid='system'   ---for循环 tmp_brnd_cd预先创建好
DO                                         ---循环体开始
SET vID=BRND_CD;                       ---对vID赋值，db2可以用set赋值，也可以用values赋值，这里可以写成values(BRND_CD) into vID
INSERT INTO WWM_FORINSERT_TEST VALUES(vID); ---往wwm_forinsert_test 插入数据
END FOR;                              -----循环体结束
END                              -----存储过程结束
