--Изначальный скрипт, показывает все данные
WITH set_config_precode AS (
  SELECT set_config('synchronize_seqscans', 'off', true)
)

select 
  user_id,
  p.device_type_canonical,
  p.order_id,
  p.created_dt_msk AS order_dt,
  p.created_ts_msk AS order_ts,
  p.currency_code,
  p.revenue,
  p.tickets_count,
	cast(p.created_dt_msk as date)- cast(LAG(p.created_dt_msk ) over (partition by p.user_id  order by p.created_dt_msk) as date) as days_since_prev,
  p.event_id,
  e.event_name_code as event_name,
  e.event_type_main,
  p.service_name,
  r.region_name,
  c.city_name
from afisha.purchases p
left join afisha.events as e ON p.event_id=e.event_id
left join afisha.city as c ON e.city_id=c.city_id
left join afisha.regions as r ON c.region_id=r.region_id
where 
  (p.device_type_canonical = 'mobile' 
  OR p.device_type_canonical = 'desktop')
  AND e.event_type_main != 'фильм'
order BY p.user_id 

















