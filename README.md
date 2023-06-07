# postgres-history-trigger

Trigger to store history changes on specific tables

## Getting started

You should run install.sql once to create the function used in each trigger.

Then, for each table you want to keep history, you must run the create trigger as shown in sample_usage.sql

Ej: 
``` sql
-- if your table goes like, for example
CREATE TABLE test_data (
  test_id SERIAL PRIMARY KEY
--  test_id UUID PRIMARY KEY DEFAULT gen_random_uuid()
  , aaa text
  , bbb int
  , ccc jsonb
  , col_to_always_ignore int
  , last_action_by varchar
);

-- you have to create the trigger like this, customizing as needed
CREATE TRIGGER test_data_history_trigger
  AFTER INSERT OR UPDATE OR DELETE 
  ON test_data
  FOR EACH ROW EXECUTE PROCEDURE changelog_insert_update_delete_trigger(
    '{"test_id", "aaa"}'            -- primary key IDs (always logged)
    , '{"col_to_always_ignore"}'    -- always ignore these columns
    , 'last_action_by'    -- who made the last action
  )
;


``` 

