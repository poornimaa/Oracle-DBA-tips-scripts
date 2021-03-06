-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2015 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : erp_conc_manager_job_status.sql                                 |
-- | CLASS    : Oracle Applications                                             |
-- | PURPOSE  : Reports on concurrent manager job status.                       |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Concurrent Manager Job Status                               |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+

SET ECHO        OFF
SET FEEDBACK    6
SET HEADING     ON
SET LINESIZE    180
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN request_id        FORMAT  9999999999 HEADING 'Request|ID';
COLUMN Req_Date          FORMAT         a20 HEADING 'Req|Date';
COLUMN oracle_process_id FORMAT     9999999 HEADING 'PID';
COLUMN session_id        FORMAT     9999999 HEADING 'Session ID';
COLUMN oracle_id         FORMAT     9999999 HEADING 'Oracle ID';
COLUMN os_process_id     FORMAT         a10 HEADING 'OS PID';
COLUMN requested_by      FORMAT     9999999 HEADING 'Requested By';
COLUMN phase_code        FORMAT          a6 HEADING "Phase|Code"
COLUMN status_code       FORMAT          a6 HEADING "Status|Code"
COLUMN completion_text   FORMAT         a35 HEADING 'Text';
COLUMN user_id           FORMAT     9999999 HEADING 'User ID';
COLUMN user_name         FORMAT         a18 HEADING 'User|Name';
COLUMN Req_Date          FORMAT         a20 HEADING 'Req|Date';

SELECT
    a.request_id
  , to_char(a.REQUEST_DATE,'DD-MON-YYYY HH24:MI:SS') Req_Date
  , b.user_name
  , a.phase_code
  , a.status_code
  , c.os_process_id
  , a.oracle_id
  , a.requested_by
  , a.completion_text
FROM
    applsys.fnd_concurrent_requests a
  , applsys.fnd_user b
  , applsys.fnd_concurrent_processes c
WHERE
      a.requested_by = b.user_id
  AND c.concurrent_process_id = a.controlling_manager
  AND a.phase_code in ('R', 'T')
ORDER BY
  a.request_id, c.os_process_id
/

