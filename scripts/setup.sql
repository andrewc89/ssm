use [master]
go

create login [ssmonitor]
with password = 'ssmonitor',
check_policy = off,
check_expiration = off,
default_database = msdb
go

use [msdb]
go

create proc [get_job_history]
as
begin
select name, run_date as [date], run_time as [time],
run_duration as duration, run_status as status
from msdb.dbo.sysjobs j
join msdb.dbo.sysjobhistory jh on j.job_id = jh.job_id
where step_id = 0
order by name, [date] desc, [time] desc
end
go

create user [ssmonitor] for login [ssmonitor]
go

grant execute on dbo.[get_job_history] to [ssmonitor]
go
