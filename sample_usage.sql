--
-- example database creation
--
DROP TABLE IF EXISTS test_data CASCADE;
CREATE TABLE test_data (
  test_id SERIAL PRIMARY KEY
--  test_id UUID PRIMARY KEY DEFAULT gen_random_uuid()
  , aaa text
  , bbb int
  , ccc jsonb
  , col_to_always_ignore int
  , last_action_by varchar
);

--
-- history schema reset
--
DROP SCHEMA IF EXISTS history CASCADE;

--
-- create trigger on previous table
--
-- customize:
-- trigger name (suggested {table_name}_history_trigger)
-- params to pass to changelog_insert_update_delete_trigger (see install sql)
DROP function if exists test_data_history_trigger;
CREATE TRIGGER test_data_history_trigger
  AFTER INSERT OR UPDATE OR DELETE 
  ON test_data
  FOR EACH ROW EXECUTE PROCEDURE changelog_insert_update_delete_trigger(
    '{"test_id", "aaa"}'            -- primary key IDs (always logged)
    , '{"col_to_always_ignore"}'    -- always ignore these columns
    , 'last_action_by'    -- who made the last action
  )
;

--
-- some testing data
--

INSERT INTO test_data (aaa, bbb, ccc, col_to_always_ignore, last_action_by)
   VALUES
    ('xxx', 123, '{"esto": {"con":"diez", "cañones":"por banda" }}'::jsonb , 888, 'alvaro@whatever.com')
  ;

INSERT INTO test_data (bbb)
   VALUES
    (456)
  ;
 
INSERT INTO test_data (aaa)
   VALUES
    ('xxx')
  ;

-- if using uuID 
update test_data set aaa='rrr' where test_id=1;
update test_data set aaa='yyy', col_to_always_ignore=654 where test_id=1;
update test_data set aaa='xyz' , ccc='{"alvaro rules":"vamos","viento": {"a": {"por banda": "toda vela"},"en":"popa" }}'::jsonb where test_id=1;
update test_data set aaa='xyz' , ccc='{"viento": {"en":"popa","a": {"por banda": "toda vela"} },"alvaro rules":"vamos"}'::jsonb where test_id=1;

update test_data set aaa='rrr' where test_id=2;
update test_data set aaa='yyy', col_to_always_ignore=654 where test_id=2;
update test_data set aaa='xyz' , ccc='{"alvaro rules":"vamos","viento": {"a": {"por banda": "toda vela"},"en":"popa" }}'::jsonb where test_id=2;
update test_data set aaa='xyz' , ccc='{"viento": {"en":"popa","a": {"por banda": "toda vela"} },"alvaro rules":"vamos"}'::jsonb where test_id=2;

update test_data set aaa='rrr' where test_id=3;
update test_data set aaa='yyy', col_to_always_ignore=654 where test_id=3;
update test_data set aaa='xyz' , ccc='{"alvaro rules":"vamos","viento": {"a": {"por banda": "toda vela"},"en":"popa" }}'::jsonb where test_id=3;
update test_data set aaa='xyz' , ccc='{"viento": {"en":"popa","a": {"por banda": "toda vela"} },"alvaro rules":"vamos"}'::jsonb where test_id=3;

delete from test_data where test_id in (1,2,3);
