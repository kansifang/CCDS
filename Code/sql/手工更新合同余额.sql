update business_contract 
set balance=businesssum,
normalbalance=businesssum,
actualputoutsum=businesssum,
ORIGINALPUTOUTDATE=putoutdate
--,classifyresult='0301'
where serialno in 
('9602032409120001');

