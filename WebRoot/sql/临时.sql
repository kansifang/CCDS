select
'#myvar_year##myvar_month#' as sjfsny,
trim(b.creditno)||trim(b.duebillno) as zhjlbs,
replace(b.settledate,'-','') as js_yhkrq,
cast((b.corpus+b.accrual) as int) as byyhkje,
cast((b.alreadycorpus+b.alreadyaccrual) as int) as rjhkje,
cast(a.corpus as int) as ye,
case when
(
   '#myvar_year##myvar_month#'>=substr(replace(a.enddate,'-',''),1,6)
)
then
(
   case b.status when 1 then '3' else
   (
      case b.liststatus when 1 then '2' when 4 then '4' when 5 then '4' end
   )
   end
)
else
(
   case b.status when 1 then '1' else
   (
      case b.liststatus when 1 then '2' when 4 then '4' when 5 then '4' end
   )
   end
)
end as zhzt
from loan_ref a,client_list b
where
(
   
   (
      case when
      (
         substr(replace(a.enddate,'-',''),1,6)>'#myvar_year##myvar_month#'
         and a.maxperiod!=1
      )
      then a.curperiod-1 else a.curperiod end
   )
   =b.period
)
and a.customerno=b.customerno
and a.duebillno=b.duebillno
and
(
   
   (
      case when
      (
         '#myvar_year##myvar_month#'>=substr(replace(a.enddate,'-',''),1,6)
      )
      then substr
      (
         replace(a.enddate,'-',''),1,6
      )
      else '#myvar_year##myvar_month#' end
   )
   =substr ( replace(b.settledate,'-',''),1,6 )
)
and
(
   a.endflag =0 or
   (
      a.endflag in(1,2,3)
      and substr(replace(a.lastdate,'-',''),1,6)='#myvar_year##myvar_month#'
   )
)
