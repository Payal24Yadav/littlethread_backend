--
-- PostgreSQL database dump
--

\restrict KvXnwJZ5caEqHs8j1AkEq0L4rcc9EKYdrH9cH5iOyhdb660Kjy8OCv20c5BYHcT

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: supabase_admin
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


ALTER FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) OWNER TO supabase_admin;

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL AND ppt.tablename NOT LIKE '% %'),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  -- Count raw slot entries before apply_rls/subscription filter
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  -- Apply RLS and filter as before
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  -- Real rows with slot count attached
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  -- Sentinel row: always returned when no real rows exist so Elixir can
  -- always read slot_changes_count. Identified by wal IS NULL.
  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- Name: Address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Address" (
    id text NOT NULL,
    "customerId" text NOT NULL,
    name text NOT NULL,
    phone text NOT NULL,
    "addressLine1" text NOT NULL,
    "addressLine2" text,
    city text NOT NULL,
    state text NOT NULL,
    pincode text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Address" OWNER TO postgres;

--
-- Name: Admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Admin" (
    id text NOT NULL,
    email text NOT NULL,
    password text,
    "is2FAEnabled" boolean DEFAULT false NOT NULL,
    otp text,
    "otpExpires" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Admin" OWNER TO postgres;

--
-- Name: Banner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Banner" (
    id text NOT NULL,
    "imageUrl" text NOT NULL,
    "altText" text,
    "linkUrl" text,
    type text DEFAULT 'DESKTOP'::text NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Banner" OWNER TO postgres;

--
-- Name: Category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Category" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Category" OWNER TO postgres;

--
-- Name: Collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Collection" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "imageUrl" text,
    "order" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Collection" OWNER TO postgres;

--
-- Name: ContactMessage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ContactMessage" (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    subject text,
    message text NOT NULL,
    "isRead" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."ContactMessage" OWNER TO postgres;

--
-- Name: Coupon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Coupon" (
    id text NOT NULL,
    code text NOT NULL,
    percentage double precision NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Coupon" OWNER TO postgres;

--
-- Name: Customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Customer" (
    id text NOT NULL,
    email text,
    mobile text,
    name text,
    gender text,
    password text,
    provider text DEFAULT 'local'::text NOT NULL,
    otp text,
    "otpExpires" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Customer" OWNER TO postgres;

--
-- Name: GlobalSetting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."GlobalSetting" (
    id text DEFAULT 'default'::text NOT NULL,
    "codEnabled" boolean DEFAULT false NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."GlobalSetting" OWNER TO postgres;

--
-- Name: MobileOtp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."MobileOtp" (
    id text NOT NULL,
    mobile text NOT NULL,
    "otpHash" text NOT NULL,
    "expiresAt" timestamp(3) without time zone NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."MobileOtp" OWNER TO postgres;

--
-- Name: Order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Order" (
    id text NOT NULL,
    "totalAmount" double precision NOT NULL,
    status text DEFAULT 'PENDING'::text NOT NULL,
    "customerId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "razorpayOrderId" text,
    "razorpayPaymentId" text,
    "razorpaySignature" text,
    "paymentMethod" text,
    "invoiceNumber" text,
    "shippingAddress" jsonb,
    "deliveryDate" timestamp(3) without time zone,
    "cancellationReason" text
);


ALTER TABLE public."Order" OWNER TO postgres;

--
-- Name: OrderActivity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."OrderActivity" (
    id text NOT NULL,
    "orderId" text NOT NULL,
    status text NOT NULL,
    message text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."OrderActivity" OWNER TO postgres;

--
-- Name: OrderItem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."OrderItem" (
    id text NOT NULL,
    quantity integer NOT NULL,
    price double precision NOT NULL,
    "productId" text NOT NULL,
    "variantTitle" text,
    "orderId" text NOT NULL
);


ALTER TABLE public."OrderItem" OWNER TO postgres;

--
-- Name: Product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Product" (
    id text NOT NULL,
    name text NOT NULL,
    subtitle text,
    handle text,
    description text,
    price double precision NOT NULL,
    "isDiscountable" boolean DEFAULT false NOT NULL,
    "discountPrice" double precision,
    images text[],
    "thumbnailUrl" text,
    "hoverThumbnailUrl" text,
    stock integer DEFAULT 0 NOT NULL,
    weight double precision,
    length double precision,
    breadth double precision,
    height double precision,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Product" OWNER TO postgres;

--
-- Name: ProductVariant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ProductVariant" (
    id text NOT NULL,
    title text NOT NULL,
    price double precision,
    stock integer DEFAULT 0 NOT NULL,
    images text[],
    "thumbnailUrl" text,
    "hoverThumbnailUrl" text,
    "productId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ProductVariant" OWNER TO postgres;

--
-- Name: Profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Profile" (
    id text NOT NULL,
    email text NOT NULL,
    role text DEFAULT 'user'::text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Profile" OWNER TO postgres;

--
-- Name: ReturnRequest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ReturnRequest" (
    id text NOT NULL,
    "orderId" text NOT NULL,
    reason text NOT NULL,
    description text,
    "returnDate" timestamp(3) without time zone NOT NULL,
    status text DEFAULT 'PENDING'::text NOT NULL,
    "adminResponse" text,
    "refundAmount" double precision,
    "returnShipmentId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ReturnRequest" OWNER TO postgres;

--
-- Name: Review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Review" (
    id text NOT NULL,
    rating integer NOT NULL,
    comment text,
    "userName" text NOT NULL,
    "userEmail" text,
    "userPhone" text,
    images text[],
    "productId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Review" OWNER TO postgres;

--
-- Name: Sale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sale" (
    id text NOT NULL,
    "productId" text NOT NULL,
    quantity integer NOT NULL,
    price double precision NOT NULL,
    source text DEFAULT 'Website'::text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Sale" OWNER TO postgres;

--
-- Name: Shipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Shipment" (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    "orderId" text NOT NULL,
    awb text NOT NULL,
    "shipmentId" text NOT NULL,
    courier text NOT NULL,
    status text DEFAULT 'SHIPMENT_CREATED'::text NOT NULL,
    "labelUrl" text,
    "createdAt" timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Shipment" OWNER TO postgres;

--
-- Name: _CategoryToProduct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_CategoryToProduct" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_CategoryToProduct" OWNER TO postgres;

--
-- Name: _CollectionToProduct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_CollectionToProduct" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_CollectionToProduct" OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    email text,
    role text
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
63ecc065-fdb6-445f-8df1-1f1201566803	63ecc065-fdb6-445f-8df1-1f1201566803	{"sub": "63ecc065-fdb6-445f-8df1-1f1201566803", "email": "swatigunjan1@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-03-25 09:56:51.453269+00	2026-03-25 09:56:51.45332+00	2026-03-25 09:56:51.45332+00	29ab380d-960e-4442-aea7-be17ce06c325
aaf564e2-7454-4035-8305-1704619072ef	aaf564e2-7454-4035-8305-1704619072ef	{"sub": "aaf564e2-7454-4035-8305-1704619072ef", "email": "admin@admin.com", "email_verified": false, "phone_verified": false}	email	2026-04-25 06:34:56.238965+00	2026-04-25 06:34:56.23934+00	2026-04-25 06:34:56.23934+00	88b38718-402e-48eb-a620-9fd45c6ae8dc
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
ee5a7c97-f31d-4ba0-a7b2-9d675c4a2c0c	2026-04-25 06:35:40.595136+00	2026-04-25 06:35:40.595136+00	password	7b56d976-8633-47e8-94a7-451bdf061450
45b7bbab-0f49-432a-8e53-00b968111e47	2026-04-25 06:36:21.909604+00	2026-04-25 06:36:21.909604+00	password	d7fd5a85-d943-45eb-9b43-60cb993768bf
3fd3b81f-2cee-43f3-a7a6-b291913ef44b	2026-04-25 06:40:53.76514+00	2026-04-25 06:40:53.76514+00	password	0d4603a2-b1b0-4895-92c9-82b2ae161534
b117293c-cd03-4ef1-b4ac-26a4f64e7195	2026-04-25 06:42:40.567036+00	2026-04-25 06:42:40.567036+00	password	81ce71e5-6e8e-4db2-93ed-78a1b53d3bc6
d1f4c285-73f5-4072-a2b6-9cbbfd3dd2b6	2026-04-25 07:06:48.165445+00	2026-04-25 07:06:48.165445+00	password	ac5878ac-03c3-4eae-aee1-02b9f840c922
cc69aff7-194d-468c-a975-a3ca7cdec30f	2026-04-25 07:08:48.011606+00	2026-04-25 07:08:48.011606+00	password	67fe6dab-2d69-4e0b-a6d5-d65263247aef
dc511197-5628-456b-a315-a7c135e948d5	2026-04-25 07:13:30.381223+00	2026-04-25 07:13:30.381223+00	password	76e7e507-5ac7-4233-a2f2-e203c9aa0613
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
b12a6f33-8dec-497a-802c-4e5af875eb4a	63ecc065-fdb6-445f-8df1-1f1201566803	recovery_token	7f2f30144b467bb04e976eba10a561d2cac1cf0bcc4172a03056ef16	swatigunjan1@gmail.com	2026-03-25 11:02:32.314713	2026-03-25 11:02:32.314713
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	145	ejqou2p3gnno	aaf564e2-7454-4035-8305-1704619072ef	f	2026-04-25 06:35:40.584458+00	2026-04-25 06:35:40.584458+00	\N	ee5a7c97-f31d-4ba0-a7b2-9d675c4a2c0c
00000000-0000-0000-0000-000000000000	146	bscz3jgjycnw	aaf564e2-7454-4035-8305-1704619072ef	f	2026-04-25 06:36:21.896163+00	2026-04-25 06:36:21.896163+00	\N	45b7bbab-0f49-432a-8e53-00b968111e47
00000000-0000-0000-0000-000000000000	147	vfeu7d6gwkig	aaf564e2-7454-4035-8305-1704619072ef	f	2026-04-25 06:40:53.741275+00	2026-04-25 06:40:53.741275+00	\N	3fd3b81f-2cee-43f3-a7a6-b291913ef44b
00000000-0000-0000-0000-000000000000	148	segbb2yxwwr6	aaf564e2-7454-4035-8305-1704619072ef	f	2026-04-25 06:42:40.555318+00	2026-04-25 06:42:40.555318+00	\N	b117293c-cd03-4ef1-b4ac-26a4f64e7195
00000000-0000-0000-0000-000000000000	149	ssp7ygyzbier	aaf564e2-7454-4035-8305-1704619072ef	f	2026-04-25 07:06:48.147493+00	2026-04-25 07:06:48.147493+00	\N	d1f4c285-73f5-4072-a2b6-9cbbfd3dd2b6
00000000-0000-0000-0000-000000000000	150	4uhpp554gkp3	aaf564e2-7454-4035-8305-1704619072ef	f	2026-04-25 07:08:47.992534+00	2026-04-25 07:08:47.992534+00	\N	cc69aff7-194d-468c-a975-a3ca7cdec30f
00000000-0000-0000-0000-000000000000	151	44tj4cncwd5q	aaf564e2-7454-4035-8305-1704619072ef	f	2026-04-25 07:13:30.3546+00	2026-04-25 07:13:30.3546+00	\N	dc511197-5628-456b-a315-a7c135e948d5
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
d1f4c285-73f5-4072-a2b6-9cbbfd3dd2b6	aaf564e2-7454-4035-8305-1704619072ef	2026-04-25 07:06:48.127635+00	2026-04-25 07:06:48.127635+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	49.43.4.206	\N	\N	\N	\N	\N
cc69aff7-194d-468c-a975-a3ca7cdec30f	aaf564e2-7454-4035-8305-1704619072ef	2026-04-25 07:08:47.970779+00	2026-04-25 07:08:47.970779+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	49.43.4.206	\N	\N	\N	\N	\N
dc511197-5628-456b-a315-a7c135e948d5	aaf564e2-7454-4035-8305-1704619072ef	2026-04-25 07:13:30.325011+00	2026-04-25 07:13:30.325011+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	49.43.4.206	\N	\N	\N	\N	\N
ee5a7c97-f31d-4ba0-a7b2-9d675c4a2c0c	aaf564e2-7454-4035-8305-1704619072ef	2026-04-25 06:35:40.575233+00	2026-04-25 06:35:40.575233+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	49.43.4.206	\N	\N	\N	\N	\N
45b7bbab-0f49-432a-8e53-00b968111e47	aaf564e2-7454-4035-8305-1704619072ef	2026-04-25 06:36:21.876402+00	2026-04-25 06:36:21.876402+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	49.43.4.206	\N	\N	\N	\N	\N
3fd3b81f-2cee-43f3-a7a6-b291913ef44b	aaf564e2-7454-4035-8305-1704619072ef	2026-04-25 06:40:53.711419+00	2026-04-25 06:40:53.711419+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	49.43.4.206	\N	\N	\N	\N	\N
b117293c-cd03-4ef1-b4ac-26a4f64e7195	aaf564e2-7454-4035-8305-1704619072ef	2026-04-25 06:42:40.532715+00	2026-04-25 06:42:40.532715+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	49.43.4.206	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	aaf564e2-7454-4035-8305-1704619072ef	authenticated	authenticated	admin@admin.com	$2a$10$WG5kBxKLUTNqqdgcWt3SvOe2IP1TqygaIz..iWRz9m0XUJABFMIki	2026-04-25 06:34:56.251313+00	\N		\N		\N			\N	2026-04-25 07:13:30.324906+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-04-25 06:34:56.217868+00	2026-04-25 07:13:30.376316+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	63ecc065-fdb6-445f-8df1-1f1201566803	authenticated	authenticated	swatigunjan1@gmail.com	$2a$10$voAPpDD9NsMQ9cajNRlOAuDebF9PYvjnRKcmgd1IeVPb32xLVSqDa	2026-03-25 09:56:51.46475+00	\N		\N	7f2f30144b467bb04e976eba10a561d2cac1cf0bcc4172a03056ef16	2026-03-25 11:02:30.899625+00			\N	\N	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-03-25 09:56:51.447532+00	2026-03-25 11:02:32.298595+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: Address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Address" (id, "customerId", name, phone, "addressLine1", "addressLine2", city, state, pincode, "createdAt", "updatedAt") FROM stdin;
4b6bfbf1-8dc5-475e-9a09-6fa3c8e6e133	b4c3a3d8-4c6b-4cb4-bdd9-930faf938ab7	Noopur Gupta	9868449673	506/Y1,5th floor, Yamuna Block,D6 , Vasant Kunj, Near Masoodpur Flyover, New Delhi	Apartment	New Delhi	New Delhi	110070	2026-04-28 16:54:25.584	2026-04-28 16:54:25.584
\.


--
-- Data for Name: Admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Admin" (id, email, password, "is2FAEnabled", otp, "otpExpires", "createdAt", "updatedAt") FROM stdin;
bc5fd466-17c2-4f79-b4b6-9a1a3bb651ec	admin@example.com	admin123	f	\N	\N	2026-04-25 05:43:57.574	2026-04-25 05:43:57.574
46f8a3c9-b27e-4c55-8d14-948f8635fd74	admin@admin.com	admin123	f	\N	\N	2026-04-25 05:49:25.972	2026-04-25 07:00:07.255
\.


--
-- Data for Name: Banner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Banner" (id, "imageUrl", "altText", "linkUrl", type, "order", "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Category" (id, name, description, "createdAt") FROM stdin;
d95bc219-c235-4e52-9593-d12b491f8abd	Ethnic Wear	Traditional and elegant ethnic wear	2026-04-25 06:12:25.382
ad97e691-78ce-4497-94bc-65025e7c4c23	kurta set	\N	2026-04-25 09:24:40.06
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	KURTA SET WITH DUPATTA	\N	2026-04-25 09:48:25.649
\.


--
-- Data for Name: Collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Collection" (id, name, description, "imageUrl", "order", "createdAt") FROM stdin;
92ebe55e-a7f7-4dcf-8666-921c38f4614a	bestseller		https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103351273.webp	1	2026-04-25 07:49:13.206
bd4b5c35-f627-4ab8-a217-fa3c509e5db9	The Everyday Muse		https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777105901383.webp	2	2026-04-25 08:31:44.083
a852100a-2a1e-416c-b5c8-206f44732279	Timeless Edit		https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777105928323.webp	3	2026-04-25 08:32:10.315
\.


--
-- Data for Name: ContactMessage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ContactMessage" (id, name, email, subject, message, "isRead", "createdAt") FROM stdin;
\.


--
-- Data for Name: Coupon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Coupon" (id, code, percentage, "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Customer" (id, email, mobile, name, gender, password, provider, otp, "otpExpires", "createdAt", "updatedAt") FROM stdin;
07942866-70be-4ab2-868c-c1681ddb614b	ansupal01@gmail.com	\N	test	\N	$2b$12$UkleLs8qGxw2Xzctmxl.yeZa.F/VoY3SYkyD2b.VdxXLqvItQyU0.	local	\N	\N	2026-04-25 09:02:39.647	2026-04-25 09:02:39.647
01f2e9b4-9c13-48d1-8527-858fa520f4c3	komitrajput63@gmail.com	\N	Komit Rajput	\N	$2b$12$nKHdMdft1ocD/EwORPMU6.ipZEuH8ojMioWN8GItiyLtObBrArYkS	local	\N	\N	2026-04-27 09:06:09.334	2026-04-27 09:06:09.334
e20c28fe-a060-4692-b7b6-6667e03b0834	rejilalohithakshan@gmail.com	\N	Rejila	\N	$2b$12$ZJQWlyca1B4Mx6X8FgUrPulayIyW4x5k6hWhLt1Vs6ZL0Qk8VPgIm	local	\N	\N	2026-04-28 04:22:31.165	2026-04-28 04:22:31.165
1d7e50c8-24e2-4f09-b8e3-730a040b77cf	noopurgupta@hotmail.com	\N	NOOPUR GUPTA	\N	$2b$12$lxlY9crUjKwZE11M9VbsMu8t3F7WvRGKBpjUnE76futDwjh24WmwS	local	\N	\N	2026-04-28 06:14:32.03	2026-04-28 06:14:32.03
db3a1eaa-c88b-4a5b-b471-fb9d803cff81	s.mahima123@gmail.com	\N	Mahima s	\N	$2b$12$1UiSOOEAoNWQBARSWIyzW.R/QHGJtYQqj0GUxtLtEsnZ0wV5rOQ4i	local	\N	\N	2026-04-28 07:50:39.483	2026-04-28 07:50:39.483
b4c3a3d8-4c6b-4cb4-bdd9-930faf938ab7	sugeesh1978@yahoo.com	\N	Noopur  Gupta	female	$2b$12$KBGTOSJP7JUSGXoQMFKxnOABuknYaVI6fosUbgA90FavAlxLUDB/S	local	\N	\N	2026-04-28 16:28:04.541	2026-04-28 16:50:55.047
98bf454e-0b0f-4261-a02a-7f8a37d1630d	mona.miracles@gmail.com	\N	Mona Choudhary	\N	$2b$12$STjUCmNyN5kBKNb.XG25f.bXkUdctmwILfvUMaeBCB9zOxqltb4ga	local	\N	\N	2026-04-29 04:22:49.001	2026-04-29 04:22:49.001
4e23e4b5-f675-4ed2-9ace-bf9f0dcd6d0f	ranjeer.p.clt@gmail.com	\N	Ranjeer P	\N	$2b$12$1FHHMOUcICkE0x0vXRdle.yE53PUl5RWmuJv/FITrXT5Qxizw.sMq	local	\N	\N	2026-04-29 13:22:52.993	2026-04-29 13:22:52.993
\.


--
-- Data for Name: GlobalSetting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."GlobalSetting" (id, "codEnabled", "updatedAt") FROM stdin;
default	f	2026-04-25 05:43:58.358
\.


--
-- Data for Name: MobileOtp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MobileOtp" (id, mobile, "otpHash", "expiresAt", attempts, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Order" (id, "totalAmount", status, "customerId", "createdAt", "updatedAt", "razorpayOrderId", "razorpayPaymentId", "razorpaySignature", "paymentMethod", "invoiceNumber", "shippingAddress", "deliveryDate", "cancellationReason") FROM stdin;
3dde893e-696f-4e93-bfa9-c29a77f46dab	1699	CANCELLED	07942866-70be-4ab2-868c-c1681ddb614b	2026-04-25 09:03:56.452	2026-04-25 09:05:42.209	order_ShfYteAmGkgYZo	pay_ShfYyBvAYiqMgm	257b065be717e6d4cfee8075061f6c50c38b3ded53318b275b4c28ebf01dd0bb	razorpay	Gof-INV-0001	{"city": "Mathura", "email": "chetan.novarsis@gmail.com", "phone": "7771824784", "state": "Uttar Pradesh", "address": "Adress-Vrindavan Road, Mant Raja, Tehsil-Mant, Dist. Mathura-281202 (U.P.)", "pinCode": "281202", "fullName": "test test", "lastName": "test", "apartment": "", "firstName": "test", "paymentMethod": "razorpay"}	\N	Cancelled by admin
31be2f69-6077-4f45-bd1f-3ec06e0a3d78	1699	CANCELLED	07942866-70be-4ab2-868c-c1681ddb614b	2026-04-25 10:02:03.775	2026-04-25 10:10:09.792	order_ShgYFth7YcMCZW	pay_ShgYJxXPpyApCk	503f72f07bd55261792adfc1c108d5aa781a856cdac3de1b34cb99410fec024e	razorpay	Gof-INV-0002	{"city": "Mathura", "email": "chetan.novarsis@gmail.com", "phone": "7771824784", "state": "Uttar Pradesh", "address": "Adress-Vrindavan Road, Mant Raja, Tehsil-Mant, Dist. Mathura-281202 (U.P.)", "pinCode": "281202", "fullName": "test test", "lastName": "test", "apartment": "", "firstName": "test", "paymentMethod": "razorpay"}	\N	Cancelled by admin
05a1cac7-2cb2-4a7d-9121-9ce7264ff027	2699	CANCELLED	07942866-70be-4ab2-868c-c1681ddb614b	2026-04-25 10:12:21.57	2026-04-25 10:17:47.502	order_Shgj4CMP45O3uD	pay_ShgjDfGGfUZpsC	3d53f08657ed91accc152973ce622bb8a513b3bc06a7848673b7b63b32fbedc8	razorpay	Gof-INV-0003	{"city": "Mathura", "email": "chetan.novarsis@gmail.com", "phone": "7771824784", "state": "Uttar Pradesh", "address": "Adress-Vrindavan Road, Mant Raja, Tehsil-Mant, Dist. Mathura-281202 (U.P.)", "pinCode": "281202", "fullName": "test test", "lastName": "test", "apartment": "", "firstName": "test", "paymentMethod": "razorpay"}	\N	Cancelled by admin
e0eb5e25-b0f2-4da8-bf49-b10788b2c4a3	1999	CANCELLED	07942866-70be-4ab2-868c-c1681ddb614b	2026-04-25 10:57:31.796	2026-04-25 11:14:49.755	order_ShhUqsLE9kfW2K	pay_ShhUx1aBvRFkeS	60ba85c67e9d356b52ada10ecaf4fdf135050eb2d362131176a3ed9123e6fe28	razorpay	Gof-INV-0004	{"city": "Mathura", "email": "chetan.novarsis@gmail.com", "phone": "7771824784", "state": "Uttar Pradesh", "address": "Adress-Vrindavan Road, Mant Raja, Tehsil-Mant, Dist. Mathura-281202 (U.P.)", "pinCode": "281202", "fullName": "test test", "lastName": "test", "apartment": "", "firstName": "test", "paymentMethod": "razorpay"}	\N	Cancelled by admin
68f3668a-15f5-4fe2-8f9a-06bc95068dc0	2399	CANCELLED	07942866-70be-4ab2-868c-c1681ddb614b	2026-04-25 11:11:11.254	2026-04-25 11:18:12.371	order_ShhjHWMGKH1weG	pay_ShhjMaD13mYfgG	4a902325554f9ef1e8213766af545795a2c9c5ee3462bc307a6feb71f351ac03	razorpay	GOE-INV-0001	{"city": "Mathura", "email": "ansupal01@gmail.com", "phone": "7771824784", "state": "Uttar Pradesh", "address": "Adress-Vrindavan Road, Mant Raja, Tehsil-Mant, Dist. Mathura-281202 (U.P.)", "pinCode": "281202", "fullName": "test test", "lastName": "test", "apartment": "", "firstName": "test", "paymentMethod": "razorpay"}	\N	Cancelled by admin
38b327bd-9d48-4284-b6cb-312dd62947e0	1699	CANCELLED	07942866-70be-4ab2-868c-c1681ddb614b	2026-04-25 11:41:08.76	2026-04-25 12:10:15.912	order_ShiEpydKyGiMiJ	pay_ShiEzIqyndMDu5	df6c86d9b39d00c0570ada68a6618a1817ad4162f3a64361889059a4ec633b68	razorpay	GOE-INV-0002	{"city": "Indore", "email": "ansupal01@gmail.com", "phone": "7771824784", "state": "Madhya Pradesh", "address": "Adress-Vrindavan Road, Mant Raja, Tehsil-Mant, Dist. Mathura-281202 (U.P.)", "pinCode": "452001", "fullName": "test test", "lastName": "test", "apartment": "", "firstName": "test", "paymentMethod": "razorpay"}	\N	Cancelled by admin
271740bc-a3d7-4e3a-889c-7c6ef3994815	1599	CANCELLED	07942866-70be-4ab2-868c-c1681ddb614b	2026-04-25 12:16:37.158	2026-04-25 12:30:41.482	order_Shiq7d1h6tPgR9	pay_ShiqO9fO7PXHxT	7d09e17b6da0040976d199f4a359a4c6b5a43055941fe44e85b536a1c10de5df	razorpay	GOE-INV-0003	{"city": "Mathura", "email": "chetan.novarsis@gmail.com", "phone": "7771824784", "state": "Uttar Pradesh", "address": "Adress-Vrindavan Road, Mant Raja, Tehsil-Mant, Dist. Mathura-281202 (U.P.)", "pinCode": "281202", "fullName": "test test", "lastName": "test", "apartment": "", "firstName": "test", "paymentMethod": "razorpay"}	\N	Cancelled by admin
7455f121-a59b-4c30-bbf0-17f83f78f67b	1299	unknown	98bf454e-0b0f-4261-a02a-7f8a37d1630d	2026-04-29 04:25:24.016	2026-04-29 04:33:09.031	order_SjAwYqTvBkGHMK	pay_SjAwhSHfYCsIZL	3851f9217afe254397336799916f0f38042b4cdc425003ace85ef20f609397e2	razorpay	GOE-INV-0006	{"awb": "14112362134240", "city": "East Delhi", "email": "mona.miracles@gmail.com", "phone": "9717283122", "state": "Delhi", "address": "309 Block 2 Kirti Apartments, Mayur Vihar Phase I Extension", "pinCode": "110091", "fullName": "Mona Choudhary", "lastName": "Choudhary", "apartment": "", "firstName": "Mona", "courierName": "Xpressbees Surface", "paymentMethod": "razorpay", "lastStatusUpdate": "2026-04-29T04:33:09.031Z"}	\N	\N
668f0e16-a959-4347-b413-029ad7c02104	2099	unknown	e20c28fe-a060-4692-b7b6-6667e03b0834	2026-04-28 04:30:09.508	2026-04-29 06:00:01.117	order_SimTuRLfY3gfey	pay_SimUX09s86xdVt	6a31eca188bc6a05d8a33674bf7cc29f69d64ac30d4799aaf28d63c65f91519f	razorpay	GOE-INV-0004	{"awb": "SF3158093783KR", "city": "Kozhikode", "email": "rejilalohithakshan@gmail.com", "phone": "9747000112", "state": "Kerala", "address": "Nirmala Bavan", "pinCode": "673001", "fullName": "Rejila Lohithakshan", "lastName": "Lohithakshan", "apartment": "65/1960, Kannur road, opp. Galaxy magnum opus", "firstName": "Rejila", "courierName": "Shadowfax Surface", "paymentMethod": "razorpay", "lastStatusUpdate": "2026-04-29T06:00:01.117Z"}	\N	\N
70ab56d1-dbff-45fc-aab1-f3dedac97bbb	2099	CANCELLED	07942866-70be-4ab2-868c-c1681ddb614b	2026-04-29 07:00:39.928	2026-04-29 07:01:56.531	order_SjDahmd0kD3onX	pay_SjDb9zllPPbY0b	dd019436b0c6c0c5d25c75382edda0c28437660f8a5d27a139655078f28d80a1	razorpay	GOE-INV-0007	{"city": "Mathura", "email": "ansupal01@gmail.com", "phone": "7771824784", "state": "Uttar Pradesh", "address": "Adress-Vrindavan Road, Mant Raja, Tehsil-Mant, Dist. Mathura-281202 (U.P.)", "pinCode": "281202", "fullName": "test test", "lastName": "test", "apartment": "", "firstName": "test", "paymentMethod": "razorpay"}	\N	Cancelled by admin
ebe14aec-920c-4048-965d-004bdd82fb66	2399	in_transit	b4c3a3d8-4c6b-4cb4-bdd9-930faf938ab7	2026-04-28 16:57:40.784	2026-04-29 11:22:37.508	order_SizDG8nfutHeTr	pay_SizEM8Gvtl1IQn	11082a3f763d194c2e17a1a2de53607903fa4984523d5119c912484b2217c394	razorpay	GOE-INV-0005	{"awb": "14112362133812", "city": "South West Delhi", "email": "sugeesh1978@yahoo.com", "phone": "9868449673", "state": "Delhi", "address": "506/Y1,5th floor, Yamuna Block,D6 , Vasant Kunj, Near Masoodpur Flyover, New Delhi", "pinCode": "110070", "fullName": "Noopur  Gupta", "lastName": " Gupta", "apartment": "Apartment", "firstName": "Noopur", "courierName": "Xpressbees Surface", "paymentMethod": "razorpay", "lastStatusUpdate": "2026-04-29T11:22:37.508Z"}	\N	\N
\.


--
-- Data for Name: OrderActivity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."OrderActivity" (id, "orderId", status, message, "createdAt") FROM stdin;
efbd2590-803f-4b66-9708-88280ccfbb3c	3dde893e-696f-4e93-bfa9-c29a77f46dab	ORDER_PLACED	Order placed and paid successfully.	2026-04-25 09:03:59.86
87703a43-c702-4b77-bed7-e034ab83c56c	3dde893e-696f-4e93-bfa9-c29a77f46dab	ORDER_CANCELLED	Order cancelled by admin. Reason: Cancelled by admin	2026-04-25 09:05:42.744
6ef74315-d5ff-4eb0-8307-843653aa23f3	31be2f69-6077-4f45-bd1f-3ec06e0a3d78	ORDER_PLACED	Order placed and paid successfully.	2026-04-25 10:02:05.585
ef165717-d7db-4e9b-9ec6-de5cb646945c	31be2f69-6077-4f45-bd1f-3ec06e0a3d78	ORDER_CANCELLED	Order cancelled by admin. Reason: Cancelled by admin	2026-04-25 10:10:10.408
185b4c48-1558-484a-9736-61a7de893e80	05a1cac7-2cb2-4a7d-9121-9ce7264ff027	ORDER_PLACED	Order placed and paid successfully.	2026-04-25 10:12:23.67
7164e9e4-a5f7-4b20-a720-1d8786af76a7	05a1cac7-2cb2-4a7d-9121-9ce7264ff027	ORDER_CANCELLED	Order cancelled by admin. Reason: Cancelled by admin	2026-04-25 10:17:48.041
814c7d68-a877-470d-a673-d2c74cad52bf	e0eb5e25-b0f2-4da8-bf49-b10788b2c4a3	ORDER_PLACED	Order placed and paid successfully.	2026-04-25 10:57:33.712
a912b6a7-deda-4191-ac07-bb220260acff	68f3668a-15f5-4fe2-8f9a-06bc95068dc0	ORDER_PLACED	Order placed and paid successfully.	2026-04-25 11:11:13.087
345d3cbf-e7ab-4010-bc20-c725397ce9ba	e0eb5e25-b0f2-4da8-bf49-b10788b2c4a3	ORDER_CANCELLED	Order cancelled by admin. Reason: Cancelled by admin	2026-04-25 11:14:50.301
3e6f13a2-eb49-4d94-98fb-f07d2f968ed7	68f3668a-15f5-4fe2-8f9a-06bc95068dc0	SHIPMENT_CREATED	Shipment manifested with Ekart Logistics Surface. AWB: SRSP3517066565	2026-04-25 11:15:26.791
33ceb5e3-6917-475d-bb3c-467b04cabcea	68f3668a-15f5-4fe2-8f9a-06bc95068dc0	LABEL_GENERATED	Shipping label generated successfully.	2026-04-25 11:15:40.749
81797fab-88bf-4b09-a68b-959f72318ee5	68f3668a-15f5-4fe2-8f9a-06bc95068dc0	SHIPMENT_CANCELLED	Shipment 1303643116 has been cancelled.	2026-04-25 11:16:02.337
b4e8eff1-048e-4fc8-a747-b4310a110efa	68f3668a-15f5-4fe2-8f9a-06bc95068dc0	ORDER_CANCELLED	Order cancelled by admin. Reason: Cancelled by admin	2026-04-25 11:18:12.913
94c2f176-171c-4e31-8193-3b106407b02a	38b327bd-9d48-4284-b6cb-312dd62947e0	ORDER_PLACED	Order placed and paid successfully.	2026-04-25 11:41:10.684
d96419cb-6978-4833-97a1-c9b2358e8113	38b327bd-9d48-4284-b6cb-312dd62947e0	ORDER_CANCELLED	Order cancelled by admin. Reason: Cancelled by admin	2026-04-25 12:10:16.526
50f404d4-2862-4f71-8366-05f45d34e003	271740bc-a3d7-4e3a-889c-7c6ef3994815	ORDER_PLACED	Order placed and paid successfully.	2026-04-25 12:16:39
6078010e-d8d4-4b3d-be97-0ba45fe2b8c1	271740bc-a3d7-4e3a-889c-7c6ef3994815	ORDER_CANCELLED	Order cancelled by admin. Reason: Cancelled by admin	2026-04-25 12:30:42.159
fac8ddc9-48dd-4b3f-9104-00aeeb0a5edb	668f0e16-a959-4347-b413-029ad7c02104	ORDER_PLACED	Order placed and paid successfully.	2026-04-28 04:30:10.9
7db703bd-95f9-4aa4-b515-fdf9e868e057	668f0e16-a959-4347-b413-029ad7c02104	SHIPMENT_CREATED	Shipment manifested with Amazon Prepaid Surface 500g. AWB: 368945883233	2026-04-28 04:37:21.55
7bce0747-8b6f-4770-96db-ef0fbd9783e6	668f0e16-a959-4347-b413-029ad7c02104	LABEL_GENERATED	Shipping label generated successfully.	2026-04-28 04:37:54.025
2769f781-0c5c-4ecf-9eb2-aeec7b26184e	ebe14aec-920c-4048-965d-004bdd82fb66	ORDER_PLACED	Order placed and paid successfully.	2026-04-28 16:57:42.158
48c3ed3e-a1c0-4559-98ea-3ce1c3ba8940	ebe14aec-920c-4048-965d-004bdd82fb66	SHIPMENT_CREATED	Shipment manifested with Xpressbees Surface. AWB: 14112362133812	2026-04-28 17:01:21.157
481e6ee1-ca5e-42e5-9ac9-179a6a438651	7455f121-a59b-4c30-bbf0-17f83f78f67b	ORDER_PLACED	Order placed and paid successfully.	2026-04-29 04:25:25.451
2ee1920f-7f1d-44f4-b010-0c9887edaa0e	7455f121-a59b-4c30-bbf0-17f83f78f67b	SHIPMENT_CREATED	Shipment manifested with Xpressbees Surface. AWB: 14112362134240	2026-04-29 04:30:34.178
ac0c7dee-6863-403a-a2ee-b9be502a411c	70ab56d1-dbff-45fc-aab1-f3dedac97bbb	ORDER_PLACED	Order placed and paid successfully.	2026-04-29 07:00:45.211
83c54990-aa61-4fcc-88a4-22cc1a3a5eeb	70ab56d1-dbff-45fc-aab1-f3dedac97bbb	SHIPMENT_CREATED	Shipment manifested with Shadowfax Surface. AWB: SF3158100416KR	2026-04-29 07:01:27.417
9a5d93dd-dcf0-4f08-adc9-802b7eacb580	70ab56d1-dbff-45fc-aab1-f3dedac97bbb	ORDER_CANCELLED	Order cancelled by admin. Reason: Cancelled by admin	2026-04-29 07:01:57.156
\.


--
-- Data for Name: OrderItem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."OrderItem" (id, quantity, price, "productId", "variantTitle", "orderId") FROM stdin;
1b519942-2963-4339-953c-3baffe967496	1	1699	478cec6d-1759-4ed4-88c2-326313a8d245	Color: Charcoal Blue, Size: M	3dde893e-696f-4e93-bfa9-c29a77f46dab
1e8a904b-147f-4c89-94bf-19d14adbcdb0	1	1699	478cec6d-1759-4ed4-88c2-326313a8d245	Color: Charcoal Blue, Size: M	31be2f69-6077-4f45-bd1f-3ec06e0a3d78
61ce4d6e-6d20-411a-9827-3a1623252023	1	2699	64932421-c97c-432a-9b89-f22c522763cc	Color: Golden Yellow, Size: M	05a1cac7-2cb2-4a7d-9121-9ce7264ff027
5a042133-35f0-4988-8f15-9f745216c2d4	1	1999	a9d1a05f-eb33-4ad3-bda2-fa611aaf5c7b	Color: Black, Size: M	e0eb5e25-b0f2-4da8-bf49-b10788b2c4a3
a6fc90c3-9709-4d25-aa3e-4b2df8686cf0	1	2399	e80ea23f-a3e4-460f-a540-c2fc805d3dd8	Color: Sun kissed Spring, Size: M	68f3668a-15f5-4fe2-8f9a-06bc95068dc0
c2c7bc6c-6ee0-4453-8a0c-71f86457d855	1	1699	478cec6d-1759-4ed4-88c2-326313a8d245	Color: Multi coloured, Size: M	38b327bd-9d48-4284-b6cb-312dd62947e0
21565584-3edb-4841-9ca1-501c1d0e0c19	1	1599	a94742a6-d946-4d41-bed1-effeb7bd3fb4	Color: indigo, Size: M	271740bc-a3d7-4e3a-889c-7c6ef3994815
3c4beee2-5a3c-487b-873b-1d828ea93ad8	1	2099	fe54a318-76b9-4577-81d5-1d767029149d	Color: Blushing Bloom, Size: XL	668f0e16-a959-4347-b413-029ad7c02104
a1a8bdb2-87ec-4ec9-b7f0-2cd809146567	1	2399	600a0a7f-ae4a-4414-8b06-7e55090b93aa	Color: Light Brown, Size: L	ebe14aec-920c-4048-965d-004bdd82fb66
8eece5fc-1709-4da3-877f-5bbc443f35bf	1	1299	d25bf760-b535-4755-91ec-aeca8b163832	Color: soft orange , Size: 2XL	7455f121-a59b-4c30-bbf0-17f83f78f67b
401d313f-b306-4011-b709-d5a77c008f00	1	2099	64932421-c97c-432a-9b89-f22c522763cc	Color: Multicolour, Size: M	70ab56d1-dbff-45fc-aab1-f3dedac97bbb
\.


--
-- Data for Name: Product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Product" (id, name, subtitle, handle, description, price, "isDiscountable", "discountPrice", images, "thumbnailUrl", "hoverThumbnailUrl", stock, weight, length, breadth, height, "createdAt", "updatedAt") FROM stdin;
64932421-c97c-432a-9b89-f22c522763cc	Citrus bloom	Multicolored printed kurta set	citrus-bloom	Vibrant Multicoloured Block Print Kurta Set with Coordinated Printed Bottoms & Dupatta.	2099	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097090.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103098234.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103098877.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103099577.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103099992.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103100487.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097090.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097511.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:45:01.611	2026-04-28 17:04:17.5
fe54a318-76b9-4577-81d5-1d767029149d	Blushing Bloom	Floral Printed Angrakha Kurta Set With Dupatta	blushing-bloom	Soft Pink Angrakha Kurta with Floral Prints, Plain Bottom & Printed Dupatta.	2099	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102377544.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102378213.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102378672.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102379174.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102379720.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102380309.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102380759.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102377544.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102378213.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:33:01.832	2026-04-28 17:09:08.993
0968b431-10d8-4922-bc0e-0b152fe8f937	Black Aura	Black Printed Cotton Kurta Set	black-aura	Elegant Black Printed Cotton Kurta Set with Plain Bottom & Printed Dupatta.	1499	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102285160.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102286006.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102286602.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287070.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287516.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287945.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102288276.webp}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102285160.webp	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102286006.webp	0	\N	\N	\N	\N	2026-04-25 07:31:29.214	2026-04-27 07:53:02.55
e80ea23f-a3e4-460f-a540-c2fc805d3dd8	Sun kissed Spring	Light Yellow Floral Embroidered Kurta Set	sun-kissed-spring	Pastel Yellow Kurta Set Featuring Floral Embroidery on the Yoke with Plain Pants & Lightly Embroidered Dupatta.	1899	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103050509.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103051366.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103052193.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103052658.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053044.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053891.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103050509.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103051366.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:44:14.913	2026-04-28 17:04:53.452
f71dfc3d-062b-4a48-8606-22ce34dabd4a	The Rust Relic	Rust-Coloured Kurta Set with Floral Embroidery	the-rust-relic	Rust Embroidered Kurta Set with Kashmiri-Inspired Thread Work, Plain Bottoms & Delicate Embroidered Dupatta.	1599	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102536646.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102537142.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102537583.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102538038.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102538470.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102539332.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102539758.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102536646.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102537142.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:35:41.192	2026-04-28 17:06:48.992
478cec6d-1759-4ed4-88c2-326313a8d245	Cubist curio	Multicoloured Cotton Printed Kurta Set	cubist-curio	Geometric Printed Kurta Set with Multicolour Detailing, Matching Pants & Statement Dupatta.	1699	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103227874.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229171.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229643.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103230145.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103230598.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103231046.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103231510.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103227874.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229171.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:47:12.467	2026-04-29 06:24:27.905
a9d1a05f-eb33-4ad3-bda2-fa611aaf5c7b	Midnight Hue	Black Cotton Kurta Set With Dupatta	midnight-hue	Modern Black Kurta Set Featuring Floral Embroidery with Coordinated Pants & Designer Dupatta.	1999	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103316246.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103317210.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103317697.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318116.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318519.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318933.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103319321.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103319766.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103316246.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103317210.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:48:40.801	2026-04-28 17:08:18.118
6004ffab-7236-44df-a1f6-c1145c40367e	Teracotta Whisper	V-Neck Cotton Printed Kurta Set With Dupatta	teracotta-whisper	Terracotta V-Neck Printed Cotton Kurta Set with Printed Bottom & Dupatta.	2099	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102887511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888159.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888563.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888962.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102889364.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102889811.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102890689.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102891106.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102887511.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888159.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:41:32.361	2026-04-28 17:05:44.131
5bc3412a-cf30-432d-9a87-0c4160de3bda	The Indigo Batik Story 	Indigo Batik Printed Kurta Set	the-indigo-batik-story	Indigo Batik Printed Kurta Set with Plain Bottom And Batik Printed Dupatta.	2099	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101972579.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101973492.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101974004.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101975038.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101975558.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101976357.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101976851.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101977271.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109340050.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109353778.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109369371.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109386093.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109401221.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109407747.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109416293.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109423073.webp}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101972579.webp	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101973492.webp	0	\N	\N	\N	\N	2026-04-25 07:26:18.435	2026-04-27 07:59:26.005
439b5c59-cf77-4653-9e67-dc5876426ea2	Kesariya Kalam	Orange Kurta Set With Printed Bottom And Dupatta	kesariya-kalam	Vibrant Orange  Coloured Kurta Set with Embroidered Yoke, Printed Bottom & Dupatta.	1899	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102428542.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102429279.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102429985.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102430434.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102430891.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102431294.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102431705.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102429985.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102431705.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:33:53.308	2026-04-28 17:07:51.773
d25bf760-b535-4755-91ec-aeca8b163832	The Peach Palette	 peach floral kurta set with coordinated bottom and dupatta	the-peach-palette	Peach Angrakha style Floral kurta set with cordinated bottom and printed dupatta\n	1299	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119275.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119926.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102120648.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121115.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121602.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102122161.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119275.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119926.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:28:43.792	2026-04-28 17:10:12.028
736fbb5e-87bd-4bf4-9209-ba5c6f700fca	Red Rajwada 	Red Coloured Block Printed Cotton Kurta Set	red-rajwada	Elegant Red Kurta Set with Heritage Block Prints, Tailored Pants & Dupatta.	1599	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141272.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141793.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103142300.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103142783.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103143732.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103144600.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103145052.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103145578.webp}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141272.webp	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141793.webp	0	\N	\N	\N	\N	2026-04-25 07:45:46.738	2026-04-25 11:55:53.587
a94742a6-d946-4d41-bed1-effeb7bd3fb4	The indigo edit	Indigo Block Printed Kurta Set 	the-indigo-edit	Indigo Kurta Set with Traditional Block Prints, Printed Bottom And Printed Dupatta.	1599	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118605629.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118606695.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118607828.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118608426.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118609493.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118610046.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118610773.webp}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118605629.webp	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118606695.webp	0	\N	\N	\N	\N	2026-04-25 12:03:31.876	2026-04-25 12:12:43.32
a59a0ce1-5f0a-4e94-b59e-76a403ca9ed0	The Indigo Odyssey	Angrakha Block Printed Kurta Set with Dupatta	the-indigo-odyssey	Angrakha Block Print Kurta Set with Chevron Patterned Pants & Printed Dupatta.	1899	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773105.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773802.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102774266.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102774687.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102775128.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102775564.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102776016.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773105.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773802.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:39:37.684	2026-04-28 17:06:10.859
42967ced-2bb4-4a1f-b13c-4b143b150452	Botanica Grace	Floral Batik Printed Cotton Kurta Set	botanica-grace	Floral Batik Printed Cotton Kurta Set with Printed Bottom And Statement Dupatta.	2399	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102117164.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102118391.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119264.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119785.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102120234.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121069.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121513.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102117164.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102118391.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:28:43.186	2026-04-28 17:10:43.02
600a0a7f-ae4a-4414-8b06-7e55090b93aa	Charkha Charm	Premium Khadi Kurta Set with Thread Work & Dupatta	charkha-charm	Premium Khadi Kurta Set Featuring Intricate Thread Work with Pants & Embroidered Dupatta.	2399	f	\N	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947150.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947903.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102948346.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102949078.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102949563.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102950044.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102950520.webp?v=2}	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947150.webp?v=2	https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947903.webp?v=2	0	\N	\N	\N	\N	2026-04-25 07:42:31.576	2026-04-28 17:02:24.884
\.


--
-- Data for Name: ProductVariant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ProductVariant" (id, title, price, stock, images, "thumbnailUrl", "hoverThumbnailUrl", "productId", "createdAt", "updatedAt") FROM stdin;
5adc3bbf-7fd5-4190-b0c3-f8d9f45b4570	Color: Green, Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109340050.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109353778.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109369371.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109401221.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109386093.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109407747.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109416293.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109423073.webp}	\N	\N	5bc3412a-cf30-432d-9a87-0c4160de3bda	2026-04-27 07:59:26.005	2026-04-27 07:59:26.005
66073812-6e52-499d-a6c3-d5e846e51f37	Color: Green, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109340050.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109353778.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109369371.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109401221.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109386093.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109407747.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109416293.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109423073.webp}	\N	\N	5bc3412a-cf30-432d-9a87-0c4160de3bda	2026-04-27 07:59:26.005	2026-04-27 07:59:26.005
60cb7ce4-f38b-47e8-8885-60d2038fa329	Color:  Indigo , Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101972579.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101973492.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101975038.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101974004.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101975558.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101976357.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101976851.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101977271.webp}	\N	\N	5bc3412a-cf30-432d-9a87-0c4160de3bda	2026-04-27 07:59:26.005	2026-04-27 07:59:26.005
8e0ad04f-0241-4fec-9338-171cd4fc435a	Color:  Indigo , Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101972579.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101973492.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101975038.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101974004.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101975558.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101976357.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101976851.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101977271.webp}	\N	\N	5bc3412a-cf30-432d-9a87-0c4160de3bda	2026-04-27 07:59:26.005	2026-04-27 07:59:26.005
7a867978-a28d-4a1a-8723-eafbd65c16e1	Color:  Indigo , Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101972579.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101973492.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101975038.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101974004.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101975558.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101976357.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101976851.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101977271.webp}	\N	\N	5bc3412a-cf30-432d-9a87-0c4160de3bda	2026-04-27 07:59:26.005	2026-04-27 07:59:26.005
4d1b9d02-7d5b-4d56-88b3-da4b5ee9fac9	Color:  Indigo , Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101972579.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101973492.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101975038.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101974004.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101975558.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101976357.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101976851.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777101977271.webp}	\N	\N	5bc3412a-cf30-432d-9a87-0c4160de3bda	2026-04-27 07:59:26.005	2026-04-27 07:59:26.005
1130be4f-e950-4aa8-babd-564047c87a77	Color: Green, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109340050.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109353778.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109369371.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109401221.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109386093.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109407747.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109416293.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109423073.webp}	\N	\N	5bc3412a-cf30-432d-9a87-0c4160de3bda	2026-04-27 07:59:26.005	2026-04-27 07:59:26.005
953f6b92-591a-4fbc-bbca-3b4b22c9ef01	Color: Green, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109340050.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109353778.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109369371.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109401221.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109386093.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109407747.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109416293.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/the-indigo-batik-story--1777109423073.webp}	\N	\N	5bc3412a-cf30-432d-9a87-0c4160de3bda	2026-04-27 07:59:26.005	2026-04-27 07:59:26.005
d964cf16-ca85-4dfd-a0a4-31f4f5fdf383	Color: Green, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119785.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102117164.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102118391.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119264.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121513.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121069.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102120234.webp?v=2}	\N	\N	42967ced-2bb4-4a1f-b13c-4b143b150452	2026-04-29 06:39:21.189	2026-04-29 06:39:21.189
0483e71e-db6a-4627-8892-61793d63e511	Color: indigo, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118605629.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118606695.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118607828.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118608426.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118609493.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118610046.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118610773.webp}	\N	\N	a94742a6-d946-4d41-bed1-effeb7bd3fb4	2026-04-25 12:12:43.32	2026-04-25 12:30:40.779
584e29a6-552e-43ae-8332-9c1ac38f21de	Color: Green, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119785.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102117164.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102118391.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119264.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121513.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121069.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102120234.webp?v=2}	\N	\N	42967ced-2bb4-4a1f-b13c-4b143b150452	2026-04-29 06:39:21.189	2026-04-29 06:39:21.189
4846d6c0-96d9-4919-80f8-24c5b58f99f1	Color: Green, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119785.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102117164.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102118391.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119264.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121513.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121069.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102120234.webp?v=2}	\N	\N	42967ced-2bb4-4a1f-b13c-4b143b150452	2026-04-29 06:39:21.189	2026-04-29 06:39:21.189
497713b2-14f9-47b2-a95b-51a0b7c9cd4c	Color: Green, Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119785.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102117164.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102118391.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119264.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121513.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121069.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102120234.webp?v=2}	\N	\N	42967ced-2bb4-4a1f-b13c-4b143b150452	2026-04-29 06:39:21.189	2026-04-29 06:39:21.189
c93f9ba5-c438-4008-b26d-b8ae9418d30c	Color: Multi colour, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229171.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103231046.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103227874.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103230598.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103231510.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229643.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103230145.webp?v=2}	\N	\N	478cec6d-1759-4ed4-88c2-326313a8d245	2026-04-29 06:24:57.616	2026-04-29 06:24:57.616
7924cc74-42aa-47b4-88c7-6cbcc36014e4	Color: Multi colour, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229171.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103231046.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103227874.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103230598.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103231510.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229643.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103230145.webp?v=2}	\N	\N	478cec6d-1759-4ed4-88c2-326313a8d245	2026-04-29 06:24:57.616	2026-04-29 06:24:57.616
7b3a7b07-e1bd-46ac-b3a0-4decba552462	Color: Black, Size: M	\N	0	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318933.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103316246.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103317697.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318116.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103317210.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103319766.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318519.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103319321.webp?v=2}	\N	\N	a9d1a05f-eb33-4ad3-bda2-fa611aaf5c7b	2026-04-29 06:40:31.286	2026-04-29 06:40:31.286
8678a479-fefb-419f-97da-9245dd92b307	Color: Multicolour, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103098877.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097090.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103098234.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103099992.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103100487.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103099577.webp?v=2}	\N	\N	64932421-c97c-432a-9b89-f22c522763cc	2026-04-29 06:17:12.532	2026-04-29 06:17:12.532
8ed2bfe6-df06-45ed-b35c-248f70ec5337	Color: Multicolour, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103098877.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097090.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103098234.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103099992.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103100487.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103099577.webp?v=2}	\N	\N	64932421-c97c-432a-9b89-f22c522763cc	2026-04-29 06:17:12.532	2026-04-29 06:17:12.532
9e2c2442-3695-445c-b95f-5e7f700ef500	Color: Multicolour, Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103098877.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097090.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103098234.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103099992.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103100487.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103099577.webp?v=2}	\N	\N	64932421-c97c-432a-9b89-f22c522763cc	2026-04-29 06:17:12.532	2026-04-29 06:17:12.532
72518fdc-588d-4076-9539-edd3adf1338b	Color: Pink, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102379720.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102378213.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102377544.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102378672.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102379174.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102380309.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102380759.webp?v=2}	\N	\N	fe54a318-76b9-4577-81d5-1d767029149d	2026-04-29 06:36:30.086	2026-04-29 06:36:30.086
b96f165b-a251-4da3-84b2-8763d5f681d6	Color: Pink, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102379720.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102378213.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102377544.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102378672.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102379174.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102380309.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102380759.webp?v=2}	\N	\N	fe54a318-76b9-4577-81d5-1d767029149d	2026-04-29 06:36:30.086	2026-04-29 06:36:30.086
981b39a0-daa3-420c-887c-0da7bc95fa4d	Color: Pink, Size: 2XL	\N	0	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102379720.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102378213.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102377544.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102378672.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102379174.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102380309.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102380759.webp?v=2}	\N	\N	fe54a318-76b9-4577-81d5-1d767029149d	2026-04-29 06:36:30.086	2026-04-29 06:36:30.086
09637528-73af-4b5b-993d-c0e85654d3ef	Color: Black, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318933.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103316246.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103317697.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318116.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103317210.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103319766.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318519.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103319321.webp?v=2}	\N	\N	a9d1a05f-eb33-4ad3-bda2-fa611aaf5c7b	2026-04-29 06:40:31.286	2026-04-29 06:40:31.286
f4174235-3836-413c-8b1f-6e37fcd4a534	Color: Black, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318933.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103316246.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103317697.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318116.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103317210.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103319766.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318519.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103319321.webp?v=2}	\N	\N	a9d1a05f-eb33-4ad3-bda2-fa611aaf5c7b	2026-04-29 06:40:31.286	2026-04-29 06:40:31.286
3e56a678-b664-4787-b5a7-7a60e751f95b	Color: Black, Size: 2XL	\N	2	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318933.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103316246.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103317697.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318116.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103317210.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103319766.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103318519.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103319321.webp?v=2}	\N	\N	a9d1a05f-eb33-4ad3-bda2-fa611aaf5c7b	2026-04-29 06:40:31.286	2026-04-29 06:40:31.286
7b4edb3c-765a-49a0-9e2c-54902fbf2ad1	Color: indigo, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118605629.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118606695.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118607828.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118608426.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118609493.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118610046.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118610773.webp}	\N	\N	a94742a6-d946-4d41-bed1-effeb7bd3fb4	2026-04-25 12:12:43.32	2026-04-25 12:12:43.32
66b99b6a-0892-4c75-a5a8-c378a80399b6	Color: indigo, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118605629.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118606695.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118607828.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118608426.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118609493.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118610046.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118610773.webp}	\N	\N	a94742a6-d946-4d41-bed1-effeb7bd3fb4	2026-04-25 12:12:43.32	2026-04-25 12:12:43.32
6adc8a0a-1482-4178-93e9-55a30327f171	Color: Multi colour, Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229171.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103231046.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103227874.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103230598.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103231510.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229643.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103230145.webp?v=2}	\N	\N	478cec6d-1759-4ed4-88c2-326313a8d245	2026-04-29 06:24:57.616	2026-04-29 06:24:57.616
1388f6a9-0a40-4f93-87a4-6a9977dd628d	Color: Multi colour, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229171.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103231046.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103227874.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103230598.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103231510.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103229643.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103230145.webp?v=2}	\N	\N	478cec6d-1759-4ed4-88c2-326313a8d245	2026-04-29 06:24:57.616	2026-04-29 06:24:57.616
3719817c-519b-475e-b844-9b32eb0de15c	Color: Multicolour, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103098877.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097090.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103098234.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103097511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103099992.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103100487.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103099577.webp?v=2}	\N	\N	64932421-c97c-432a-9b89-f22c522763cc	2026-04-29 06:17:12.532	2026-04-29 07:01:55.898
817285cd-cd12-4f5d-a572-40fd88da468d	Color: Light Yellow, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103052193.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053044.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103052658.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103051366.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103050509.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053891.webp?v=2}	\N	\N	e80ea23f-a3e4-460f-a540-c2fc805d3dd8	2026-04-29 06:27:21.666	2026-04-29 06:27:21.666
7988c7bb-5479-4a35-a5e5-1623e8b15710	Color: Light Yellow, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103052193.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053044.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103052658.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103051366.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103050509.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053891.webp?v=2}	\N	\N	e80ea23f-a3e4-460f-a540-c2fc805d3dd8	2026-04-29 06:27:21.666	2026-04-29 06:27:21.666
2b862691-a726-456e-a92f-92f2e2ece173	Color: Light Yellow, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103052193.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053044.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103052658.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103051366.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103050509.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053891.webp?v=2}	\N	\N	e80ea23f-a3e4-460f-a540-c2fc805d3dd8	2026-04-29 06:27:21.666	2026-04-29 06:27:21.666
60fb6cf8-2446-4af4-a046-4682f9286ab7	Color: Peach, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102120648.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119275.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121115.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119926.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121602.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102122161.webp?v=2}	\N	\N	d25bf760-b535-4755-91ec-aeca8b163832	2026-04-29 07:08:09.088	2026-04-29 07:08:09.088
7e13ffc7-11d7-4edd-a4fc-ae5235c27e90	Color: Peach, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102120648.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119275.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121115.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119926.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121602.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102122161.webp?v=2}	\N	\N	d25bf760-b535-4755-91ec-aeca8b163832	2026-04-29 07:08:09.088	2026-04-29 07:08:09.088
ce2c5021-c495-4305-a01f-a44208cbe378	Color: Light Yellow, Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103052193.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053044.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103052658.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103051366.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103050509.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103053891.webp?v=2}	\N	\N	e80ea23f-a3e4-460f-a540-c2fc805d3dd8	2026-04-29 06:27:21.666	2026-04-29 06:27:21.666
9be98c4e-f9c1-4028-8e51-4e70d391255a	Color: Peach, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102120648.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119275.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121115.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119926.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121602.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102122161.webp?v=2}	\N	\N	d25bf760-b535-4755-91ec-aeca8b163832	2026-04-29 07:08:09.088	2026-04-29 07:08:09.088
2abd176a-1522-45f9-b589-1719d9b50edc	Color: Peach, Size: 2XL	\N	0	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102120648.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119275.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121115.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102119926.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102121602.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102122161.webp?v=2}	\N	\N	d25bf760-b535-4755-91ec-aeca8b163832	2026-04-29 07:08:09.088	2026-04-29 07:08:09.088
a288d1f8-1d02-4830-b5e4-5b4a3cee0439	Color: Off White , Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102949078.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102948346.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947903.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947150.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102950520.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102950044.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102949563.webp?v=2}	\N	\N	600a0a7f-ae4a-4414-8b06-7e55090b93aa	2026-04-29 06:28:04.486	2026-04-29 06:28:04.486
ce6c5611-f87f-4f00-89c0-2bbd810e18b7	Color: Off White , Size: L	\N	0	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102949078.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102948346.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947903.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947150.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102950520.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102950044.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102949563.webp?v=2}	\N	\N	600a0a7f-ae4a-4414-8b06-7e55090b93aa	2026-04-29 06:28:04.486	2026-04-29 06:28:04.486
cf92c67b-bc9f-4a5a-9366-2685697f271f	Color: indigo, Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118605629.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118606695.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118607828.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118608426.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118609493.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118610046.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777118610773.webp}	\N	\N	a94742a6-d946-4d41-bed1-effeb7bd3fb4	2026-04-25 12:12:43.32	2026-04-25 12:12:43.32
53c857c2-ba2a-4672-93f5-b5cbb1b7b89d	Color: Off White , Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102949078.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102948346.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947903.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947150.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102950520.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102950044.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102949563.webp?v=2}	\N	\N	600a0a7f-ae4a-4414-8b06-7e55090b93aa	2026-04-29 06:28:04.486	2026-04-29 06:28:04.486
08b93623-5f23-47b2-9c19-925efcd9c858	Color: Off White , Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102949078.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102948346.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947903.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102947150.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102950520.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102950044.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102949563.webp?v=2}	\N	\N	600a0a7f-ae4a-4414-8b06-7e55090b93aa	2026-04-29 06:28:04.486	2026-04-29 06:28:04.486
66487b35-a438-42b4-bbb2-f4a6db8a6c52	Color: Teracotta, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102887511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888159.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888563.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888962.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102889364.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102891106.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102889811.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102890689.webp?v=2}	\N	\N	6004ffab-7236-44df-a1f6-c1145c40367e	2026-04-29 06:29:45.182	2026-04-29 06:29:45.182
39aa0d05-0895-4825-ad79-ac9b2924f464	Color: Teracotta, Size: L	\N	0	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102887511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888159.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888563.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888962.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102889364.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102891106.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102889811.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102890689.webp?v=2}	\N	\N	6004ffab-7236-44df-a1f6-c1145c40367e	2026-04-29 06:29:45.182	2026-04-29 06:29:45.182
77ba8171-d3e7-47af-acdc-ec477dc7acce	Color: Teracotta, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102887511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888159.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888563.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888962.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102889364.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102891106.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102889811.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102890689.webp?v=2}	\N	\N	6004ffab-7236-44df-a1f6-c1145c40367e	2026-04-29 06:29:45.182	2026-04-29 06:29:45.182
e216ce81-6697-4a18-9a60-f643e91e9181	Color: Teracotta, Size: 2XL	\N	0	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102887511.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888159.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888563.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102888962.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102889364.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102891106.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102889811.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102890689.webp?v=2}	\N	\N	6004ffab-7236-44df-a1f6-c1145c40367e	2026-04-29 06:29:45.182	2026-04-29 06:29:45.182
20235642-9c89-4293-a715-4b4ae31dda3a	Color: Indigo , Size: M	\N	0	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773105.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773802.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102774266.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102774687.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102775128.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102775564.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102776016.webp?v=2}	\N	\N	a59a0ce1-5f0a-4e94-b59e-76a403ca9ed0	2026-04-29 06:30:49.399	2026-04-29 06:30:49.399
1b8d7f9d-7c65-45a4-a10a-3351aa25c3e3	Color: Indigo , Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773105.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773802.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102774266.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102774687.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102775128.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102775564.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102776016.webp?v=2}	\N	\N	a59a0ce1-5f0a-4e94-b59e-76a403ca9ed0	2026-04-29 06:30:49.399	2026-04-29 06:30:49.399
f5933167-31cc-41df-89dc-5f3a3cbba379	Color: Indigo , Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773105.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773802.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102774266.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102774687.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102775128.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102775564.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102776016.webp?v=2}	\N	\N	a59a0ce1-5f0a-4e94-b59e-76a403ca9ed0	2026-04-29 06:30:49.399	2026-04-29 06:30:49.399
11e128ab-08c7-44c9-95e6-ac1ad1d95d91	Color: Indigo , Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773105.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102773802.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102774266.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102774687.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102775128.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102775564.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102776016.webp?v=2}	\N	\N	a59a0ce1-5f0a-4e94-b59e-76a403ca9ed0	2026-04-29 06:30:49.399	2026-04-29 06:30:49.399
7fe9f690-d949-4923-bb76-8c8741591693	Color: Black, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102285160.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102286006.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102286602.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102288276.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287070.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287945.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287516.webp}	\N	\N	0968b431-10d8-4922-bc0e-0b152fe8f937	2026-04-27 07:53:02.55	2026-04-27 07:53:02.55
d8ce2482-a0d3-43ec-bdbd-a0ae298fdca4	Color: Black, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102285160.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102286006.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102286602.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102288276.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287070.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287945.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287516.webp}	\N	\N	0968b431-10d8-4922-bc0e-0b152fe8f937	2026-04-27 07:53:02.55	2026-04-27 07:53:02.55
c509a629-4dd6-479e-baca-5f4f1881e5ea	Color: Black, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102285160.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102286006.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102286602.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102288276.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287070.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287945.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287516.webp}	\N	\N	0968b431-10d8-4922-bc0e-0b152fe8f937	2026-04-27 07:53:02.55	2026-04-27 07:53:02.55
91a62109-947b-432e-97eb-11d7ed67abbc	Color: Black, Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102285160.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102286006.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102286602.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102288276.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287070.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287945.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102287516.webp}	\N	\N	0968b431-10d8-4922-bc0e-0b152fe8f937	2026-04-27 07:53:02.55	2026-04-27 07:53:02.55
f80f1a34-cb47-4302-a73a-dab57da198b8	Color: Rustic Orange, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102536646.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102537142.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102537583.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102538470.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102538038.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102539332.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102539758.webp?v=2}	\N	\N	f71dfc3d-062b-4a48-8606-22ce34dabd4a	2026-04-29 06:33:18.055	2026-04-29 06:33:18.055
7e2da9a7-04b5-4311-85ef-c6c42627cdfa	Color: Rustic Orange, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102536646.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102537142.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102537583.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102538470.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102538038.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102539332.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102539758.webp?v=2}	\N	\N	f71dfc3d-062b-4a48-8606-22ce34dabd4a	2026-04-29 06:33:18.055	2026-04-29 06:33:18.055
29ec9b60-83f1-4125-8b08-83eb1817bf7c	Color: Rustic Orange, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102536646.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102537142.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102537583.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102538470.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102538038.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102539332.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102539758.webp?v=2}	\N	\N	f71dfc3d-062b-4a48-8606-22ce34dabd4a	2026-04-29 06:33:18.055	2026-04-29 06:33:18.055
20db74fe-20ea-4798-bf4d-ff46bfc3ed84	Color: Rustic Orange, Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102536646.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102537142.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102537583.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102538470.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102538038.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102539332.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102539758.webp?v=2}	\N	\N	f71dfc3d-062b-4a48-8606-22ce34dabd4a	2026-04-29 06:33:18.055	2026-04-29 06:33:18.055
6b6aa834-0844-4ead-9bb6-9379a8c24c1c	Color: Dark Orange, Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102431705.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102429985.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102431294.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102430891.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102430434.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102428542.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102429279.webp?v=2}	\N	\N	439b5c59-cf77-4653-9e67-dc5876426ea2	2026-04-29 06:35:29.906	2026-04-29 06:35:29.906
22c1d19b-f1e9-45b3-98a2-c7937af72170	Color: Dark Orange, Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102431705.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102429985.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102431294.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102430891.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102430434.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102428542.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102429279.webp?v=2}	\N	\N	439b5c59-cf77-4653-9e67-dc5876426ea2	2026-04-29 06:35:29.906	2026-04-29 06:35:29.906
2b12425c-1de9-41fc-a257-23e580a02a6b	Color: Dark Orange, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102431705.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102429985.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102431294.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102430891.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102430434.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102428542.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102429279.webp?v=2}	\N	\N	439b5c59-cf77-4653-9e67-dc5876426ea2	2026-04-29 06:35:29.906	2026-04-29 06:35:29.906
fb792f1e-e2c5-4877-9ba7-4e672a9787ee	Color: Dark Orange, Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102431705.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102429985.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102431294.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102430891.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102430434.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102428542.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102429279.webp?v=2}	\N	\N	439b5c59-cf77-4653-9e67-dc5876426ea2	2026-04-29 06:35:29.906	2026-04-29 06:35:29.906
97a15289-f76b-4f8d-b7a6-19cd2f0b6611	Color: Red , Size: L	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141793.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103143732.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141272.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103144600.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103145052.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103145578.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103142300.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103142783.webp}	\N	\N	736fbb5e-87bd-4bf4-9209-ba5c6f700fca	2026-04-25 11:56:31.977	2026-04-25 11:56:31.977
799f7336-65dd-402d-b188-81615e5071f0	Color: Red , Size: 2XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141793.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103143732.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141272.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103144600.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103145052.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103145578.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103142300.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103142783.webp}	\N	\N	736fbb5e-87bd-4bf4-9209-ba5c6f700fca	2026-04-25 11:56:31.977	2026-04-25 11:56:31.977
13365f2f-dceb-41d4-a717-afca84117ad2	Color: Red , Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141793.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103143732.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141272.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103144600.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103145052.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103145578.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103142300.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103142783.webp}	\N	\N	736fbb5e-87bd-4bf4-9209-ba5c6f700fca	2026-04-25 11:56:31.977	2026-04-25 11:56:31.977
742ccde2-d208-4003-a58a-cfaf4e40d744	Color: Red , Size: M	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141793.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103143732.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103141272.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103144600.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103145052.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103145578.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103142300.webp,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777103142783.webp}	\N	\N	736fbb5e-87bd-4bf4-9209-ba5c6f700fca	2026-04-25 11:56:31.977	2026-04-25 11:56:31.977
71ee9af8-d29f-4f83-82bd-2547ad3bcfab	Color: Pink, Size: XL	\N	1	{https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102379720.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102378213.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102377544.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102378672.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102379174.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102380309.webp?v=2,https://urqngkygaqaoiwdbqjtj.supabase.co/storage/v1/object/public/uploads/product-1777102380759.webp?v=2}	\N	\N	fe54a318-76b9-4577-81d5-1d767029149d	2026-04-29 06:36:30.086	2026-04-29 06:36:30.086
\.


--
-- Data for Name: Profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Profile" (id, email, role, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: ReturnRequest; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ReturnRequest" (id, "orderId", reason, description, "returnDate", status, "adminResponse", "refundAmount", "returnShipmentId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Review" (id, rating, comment, "userName", "userEmail", "userPhone", images, "productId", "createdAt") FROM stdin;
aaa33092-b70f-4982-8482-7fea05a3d182	5	Was a little skeptical ordering from Ghar Of Ethnics at first, but sooo glad I did! 😍\n\nThe quality is absolutely top-notch ✨ packaging was beautiful, and the fit? Just perfect! 💯\n\nAnd the best part… a sweet note + cute earrings 🎁💕 such a thoughtful touch!\n\nThe product looks exactly like the pictures on the website (rare win 🙌)\n\nTotally worth it! Thank you Team Ghar Of Ethnics ❤️\n\n#HappyCustomer #EthnicWear #OnlineShoppingWin #WorthIt	Priti Singh 	nitesh9singh@gmail.com	\N	{}	6004ffab-7236-44df-a1f6-c1145c40367e	2026-04-29 12:07:23.572
\.


--
-- Data for Name: Sale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Sale" (id, "productId", quantity, price, source, "createdAt") FROM stdin;
8a0e7db9-d01b-4e58-b296-2490673a2757	fe54a318-76b9-4577-81d5-1d767029149d	1	2099	Website	2026-04-28 04:30:11.992
098b4394-b711-4f50-b9bd-e85159a74d8d	600a0a7f-ae4a-4414-8b06-7e55090b93aa	1	2399	Website	2026-04-28 16:57:43.241
96d1bfe6-79ce-40f9-9c03-82abea9b6309	d25bf760-b535-4755-91ec-aeca8b163832	1	1299	Website	2026-04-29 04:25:26.585
\.


--
-- Data for Name: Shipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Shipment" (id, "orderId", awb, "shipmentId", courier, status, "labelUrl", "createdAt", "updatedAt") FROM stdin;
3d10e608-f351-454b-b4eb-313373b71cd0	68f3668a-15f5-4fe2-8f9a-06bc95068dc0	SRSP3517066565	1303643116	Ekart Logistics Surface	CANCELLED	https://shiprocket-db-mum.s3.ap-south-1.amazonaws.com/pdfs/label_9793199_019dc45a-37f0-7304-bde1-5c85f06afb68.pdf	2026-04-25 11:15:26.234+00	2026-04-25 11:16:01.795+00
bbbba4d7-1b2f-4023-9a05-549584f5cde1	668f0e16-a959-4347-b413-029ad7c02104	368945883233	1308298093	Amazon Prepaid Surface 500g	AWB_ASSIGNED	https://kr-shipmultichannel-mum.s3.ap-south-1.amazonaws.com/9793199/labels/430a0e83f42c9676dbbbedbe3c8169c5final_labels_amazon.pdf	2026-04-28 04:37:20.987+00	2026-04-28 04:37:53.477+00
3a777ead-9a5d-448d-a96a-5d0d2a2122db	ebe14aec-920c-4048-965d-004bdd82fb66	14112362133812	1309681074	Xpressbees Surface	AWB_ASSIGNED	\N	2026-04-28 17:01:20.408+00	2026-04-28 17:01:20.408+00
0cef5f58-7b36-4f4e-b2bd-65906f271b87	7455f121-a59b-4c30-bbf0-17f83f78f67b	14112362134240	1310117762	Xpressbees Surface	AWB_ASSIGNED	\N	2026-04-29 04:30:33.505+00	2026-04-29 04:30:33.505+00
ae7e83d0-306b-49a5-99a9-5ffa51adfab7	70ab56d1-dbff-45fc-aab1-f3dedac97bbb	SF3158100416KR	1310414530	Shadowfax Surface	AWB_ASSIGNED	https://shiprocket-db-mum.s3.ap-south-1.amazonaws.com/pdfs/label_9793199_019dd80a-f866-7cfe-8bea-842c23aa5afc.pdf	2026-04-29 07:01:26.764+00	2026-04-29 07:01:31.057+00
\.


--
-- Data for Name: _CategoryToProduct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_CategoryToProduct" ("A", "B") FROM stdin;
d95bc219-c235-4e52-9593-d12b491f8abd	478cec6d-1759-4ed4-88c2-326313a8d245
ad97e691-78ce-4497-94bc-65025e7c4c23	478cec6d-1759-4ed4-88c2-326313a8d245
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	478cec6d-1759-4ed4-88c2-326313a8d245
d95bc219-c235-4e52-9593-d12b491f8abd	0968b431-10d8-4922-bc0e-0b152fe8f937
ad97e691-78ce-4497-94bc-65025e7c4c23	0968b431-10d8-4922-bc0e-0b152fe8f937
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	0968b431-10d8-4922-bc0e-0b152fe8f937
d95bc219-c235-4e52-9593-d12b491f8abd	736fbb5e-87bd-4bf4-9209-ba5c6f700fca
ad97e691-78ce-4497-94bc-65025e7c4c23	736fbb5e-87bd-4bf4-9209-ba5c6f700fca
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	736fbb5e-87bd-4bf4-9209-ba5c6f700fca
d95bc219-c235-4e52-9593-d12b491f8abd	5bc3412a-cf30-432d-9a87-0c4160de3bda
ad97e691-78ce-4497-94bc-65025e7c4c23	5bc3412a-cf30-432d-9a87-0c4160de3bda
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	5bc3412a-cf30-432d-9a87-0c4160de3bda
d95bc219-c235-4e52-9593-d12b491f8abd	600a0a7f-ae4a-4414-8b06-7e55090b93aa
ad97e691-78ce-4497-94bc-65025e7c4c23	600a0a7f-ae4a-4414-8b06-7e55090b93aa
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	600a0a7f-ae4a-4414-8b06-7e55090b93aa
d95bc219-c235-4e52-9593-d12b491f8abd	64932421-c97c-432a-9b89-f22c522763cc
ad97e691-78ce-4497-94bc-65025e7c4c23	64932421-c97c-432a-9b89-f22c522763cc
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	64932421-c97c-432a-9b89-f22c522763cc
d95bc219-c235-4e52-9593-d12b491f8abd	e80ea23f-a3e4-460f-a540-c2fc805d3dd8
ad97e691-78ce-4497-94bc-65025e7c4c23	e80ea23f-a3e4-460f-a540-c2fc805d3dd8
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	e80ea23f-a3e4-460f-a540-c2fc805d3dd8
d95bc219-c235-4e52-9593-d12b491f8abd	6004ffab-7236-44df-a1f6-c1145c40367e
ad97e691-78ce-4497-94bc-65025e7c4c23	6004ffab-7236-44df-a1f6-c1145c40367e
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	6004ffab-7236-44df-a1f6-c1145c40367e
d95bc219-c235-4e52-9593-d12b491f8abd	a59a0ce1-5f0a-4e94-b59e-76a403ca9ed0
ad97e691-78ce-4497-94bc-65025e7c4c23	a59a0ce1-5f0a-4e94-b59e-76a403ca9ed0
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	a59a0ce1-5f0a-4e94-b59e-76a403ca9ed0
d95bc219-c235-4e52-9593-d12b491f8abd	f71dfc3d-062b-4a48-8606-22ce34dabd4a
ad97e691-78ce-4497-94bc-65025e7c4c23	f71dfc3d-062b-4a48-8606-22ce34dabd4a
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	f71dfc3d-062b-4a48-8606-22ce34dabd4a
d95bc219-c235-4e52-9593-d12b491f8abd	439b5c59-cf77-4653-9e67-dc5876426ea2
ad97e691-78ce-4497-94bc-65025e7c4c23	439b5c59-cf77-4653-9e67-dc5876426ea2
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	439b5c59-cf77-4653-9e67-dc5876426ea2
d95bc219-c235-4e52-9593-d12b491f8abd	a9d1a05f-eb33-4ad3-bda2-fa611aaf5c7b
ad97e691-78ce-4497-94bc-65025e7c4c23	a9d1a05f-eb33-4ad3-bda2-fa611aaf5c7b
d95bc219-c235-4e52-9593-d12b491f8abd	a94742a6-d946-4d41-bed1-effeb7bd3fb4
ad97e691-78ce-4497-94bc-65025e7c4c23	a94742a6-d946-4d41-bed1-effeb7bd3fb4
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	a94742a6-d946-4d41-bed1-effeb7bd3fb4
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	a9d1a05f-eb33-4ad3-bda2-fa611aaf5c7b
d95bc219-c235-4e52-9593-d12b491f8abd	fe54a318-76b9-4577-81d5-1d767029149d
ad97e691-78ce-4497-94bc-65025e7c4c23	fe54a318-76b9-4577-81d5-1d767029149d
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	fe54a318-76b9-4577-81d5-1d767029149d
d95bc219-c235-4e52-9593-d12b491f8abd	d25bf760-b535-4755-91ec-aeca8b163832
ad97e691-78ce-4497-94bc-65025e7c4c23	d25bf760-b535-4755-91ec-aeca8b163832
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	d25bf760-b535-4755-91ec-aeca8b163832
d95bc219-c235-4e52-9593-d12b491f8abd	42967ced-2bb4-4a1f-b13c-4b143b150452
ad97e691-78ce-4497-94bc-65025e7c4c23	42967ced-2bb4-4a1f-b13c-4b143b150452
013fac9e-9fcd-4f20-a873-a2e9cc7190ba	42967ced-2bb4-4a1f-b13c-4b143b150452
\.


--
-- Data for Name: _CollectionToProduct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_CollectionToProduct" ("A", "B") FROM stdin;
bd4b5c35-f627-4ab8-a217-fa3c509e5db9	0968b431-10d8-4922-bc0e-0b152fe8f937
92ebe55e-a7f7-4dcf-8666-921c38f4614a	5bc3412a-cf30-432d-9a87-0c4160de3bda
92ebe55e-a7f7-4dcf-8666-921c38f4614a	600a0a7f-ae4a-4414-8b06-7e55090b93aa
a852100a-2a1e-416c-b5c8-206f44732279	600a0a7f-ae4a-4414-8b06-7e55090b93aa
92ebe55e-a7f7-4dcf-8666-921c38f4614a	64932421-c97c-432a-9b89-f22c522763cc
92ebe55e-a7f7-4dcf-8666-921c38f4614a	e80ea23f-a3e4-460f-a540-c2fc805d3dd8
92ebe55e-a7f7-4dcf-8666-921c38f4614a	a59a0ce1-5f0a-4e94-b59e-76a403ca9ed0
bd4b5c35-f627-4ab8-a217-fa3c509e5db9	d25bf760-b535-4755-91ec-aeca8b163832
a852100a-2a1e-416c-b5c8-206f44732279	42967ced-2bb4-4a1f-b13c-4b143b150452
bd4b5c35-f627-4ab8-a217-fa3c509e5db9	478cec6d-1759-4ed4-88c2-326313a8d245
bd4b5c35-f627-4ab8-a217-fa3c509e5db9	736fbb5e-87bd-4bf4-9209-ba5c6f700fca
bd4b5c35-f627-4ab8-a217-fa3c509e5db9	a94742a6-d946-4d41-bed1-effeb7bd3fb4
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, email, role) FROM stdin;
aaf564e2-7454-4035-8305-1704619072ef	admin@admin.com	admin
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-03-24 11:07:50
20211116045059	2026-03-24 11:07:51
20211116050929	2026-03-24 11:07:52
20211116051442	2026-03-24 11:11:09
20211116212300	2026-03-24 11:11:10
20211116213355	2026-03-24 11:11:11
20211116213934	2026-03-24 11:11:12
20211116214523	2026-03-24 11:11:13
20211122062447	2026-03-24 11:11:14
20211124070109	2026-03-24 11:11:14
20211202204204	2026-03-24 11:11:15
20211202204605	2026-03-24 11:11:16
20211210212804	2026-03-24 11:11:18
20211228014915	2026-03-24 11:11:19
20220107221237	2026-03-24 11:11:19
20220228202821	2026-03-24 11:11:20
20220312004840	2026-03-24 11:11:21
20220603231003	2026-03-24 11:11:22
20220603232444	2026-03-24 11:11:23
20220615214548	2026-03-24 11:11:23
20220712093339	2026-03-24 11:11:24
20220908172859	2026-03-24 11:11:25
20220916233421	2026-03-24 11:11:25
20230119133233	2026-03-24 11:11:26
20230128025114	2026-03-24 11:11:27
20230128025212	2026-03-24 11:11:28
20230227211149	2026-03-24 11:11:28
20230228184745	2026-03-24 11:11:29
20230308225145	2026-03-24 11:11:30
20230328144023	2026-03-24 11:11:31
20231018144023	2026-03-24 11:11:31
20231204144023	2026-03-24 11:11:32
20231204144024	2026-03-24 11:11:33
20231204144025	2026-03-24 11:11:34
20240108234812	2026-03-24 11:11:35
20240109165339	2026-03-24 11:11:35
20240227174441	2026-03-24 11:11:36
20240311171622	2026-03-24 11:11:37
20240321100241	2026-03-24 11:11:39
20240401105812	2026-03-24 11:11:41
20240418121054	2026-03-24 11:11:42
20240523004032	2026-03-24 11:11:44
20240618124746	2026-03-24 11:11:45
20240801235015	2026-03-24 11:11:46
20240805133720	2026-03-24 11:11:46
20240827160934	2026-03-24 11:11:47
20240919163303	2026-03-24 11:11:48
20240919163305	2026-03-24 11:11:49
20241019105805	2026-03-24 11:11:50
20241030150047	2026-03-24 11:11:52
20241108114728	2026-03-24 11:11:53
20241121104152	2026-03-24 11:11:54
20241130184212	2026-03-24 11:11:55
20241220035512	2026-03-24 11:11:55
20241220123912	2026-03-24 11:11:56
20241224161212	2026-03-24 11:11:57
20250107150512	2026-03-24 11:11:57
20250110162412	2026-03-24 11:11:58
20250123174212	2026-03-24 11:11:59
20250128220012	2026-03-24 11:11:59
20250506224012	2026-03-24 11:12:00
20250523164012	2026-03-24 11:12:01
20250714121412	2026-03-24 11:12:01
20250905041441	2026-03-24 11:12:02
20251103001201	2026-03-24 11:12:03
20251120212548	2026-03-24 11:12:04
20251120215549	2026-03-24 11:12:04
20260218120000	2026-03-24 11:12:05
20260326120000	2026-04-14 09:37:15
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
uploads	uploads	\N	2026-03-24 12:28:04.44858+00	2026-03-24 12:28:04.44858+00	t	f	\N	\N	\N	STANDARD
reviews	reviews	\N	2026-04-20 08:39:29.196437+00	2026-04-20 08:39:29.196437+00	t	f	1048576	{image/jpeg,image/png,image/webp}	\N	STANDARD
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-03-24 11:07:50.176781
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-03-24 11:07:50.248535
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-03-24 11:07:50.260699
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-03-24 11:07:50.39077
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-03-24 11:07:50.719225
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-03-24 11:07:50.724884
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-03-24 11:07:50.732167
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-03-24 11:07:50.739989
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-03-24 11:07:50.743584
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-03-24 11:07:50.746494
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-03-24 11:07:50.750663
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-03-24 11:07:50.753884
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-03-24 11:07:50.758288
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-03-24 11:07:50.761324
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-03-24 11:07:50.76437
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-03-24 11:07:50.831857
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-03-24 11:07:50.842067
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-03-24 11:07:50.84556
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-03-24 11:07:50.848171
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-03-24 11:07:50.855058
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-03-24 11:07:50.859589
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-03-24 11:07:50.864601
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-03-24 11:07:50.884076
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-03-24 11:07:50.901782
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-03-24 11:07:50.904893
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-03-24 11:07:50.909964
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-03-24 11:07:50.913086
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-03-24 11:07:50.916025
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-03-24 11:07:50.918723
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-03-24 11:07:50.921288
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-03-24 11:07:50.923778
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-03-24 11:07:50.926274
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-03-24 11:07:50.928856
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-03-24 11:07:50.931494
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-03-24 11:07:50.934066
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-03-24 11:07:50.936585
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-03-24 11:07:50.939378
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-03-24 11:07:50.941938
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-03-24 11:07:50.945371
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-03-24 11:07:50.952476
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-03-24 11:07:50.954692
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-03-24 11:07:50.957956
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-03-24 11:07:50.960442
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-03-24 11:07:50.962895
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-03-24 11:07:50.965359
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-03-24 11:07:50.968386
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-03-24 11:07:50.985767
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-03-24 11:07:50.988983
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-03-24 11:07:50.992041
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-03-24 11:07:51.050652
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-03-24 11:07:51.053885
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-03-24 11:08:48.067207
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-03-24 11:08:48.088697
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-03-24 11:08:48.145915
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-03-24 11:08:48.148907
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-03-24 11:08:48.150778
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-03-24 11:08:48.180208
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-04-08 10:50:33.350636
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-04-08 10:50:33.375549
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
94be2afe-db6c-4e4a-aa1f-32b3cbd89987	uploads	product-1774440567061.png	\N	2026-03-25 12:09:27.717646+00	2026-03-25 12:09:27.717646+00	2026-03-25 12:09:27.717646+00	{"eTag": "\\"3926d62a592649fbcddbd95049f000e9\\"", "size": 196994, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T12:09:28.000Z", "contentLength": 196994, "httpStatusCode": 200}	c2d44f87-e3ba-4b6e-9aed-ca23f5e672c3	\N	{}
a58d6147-7c28-403b-b46d-20ece69ebe2a	uploads	product-1776501130346.webp	\N	2026-04-18 08:32:11.000331+00	2026-04-18 08:32:11.000331+00	2026-04-18 08:32:11.000331+00	{"eTag": "\\"ed9d0e920b9c14a05d852660f8589449\\"", "size": 383640, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:32:11.000Z", "contentLength": 383640, "httpStatusCode": 200}	476ac122-e279-4cf3-b51e-b6573972b863	\N	{}
82c782c7-3f9f-4148-8388-7cf0f30cf34c	reviews	review-1776747558400-6.blob	\N	2026-04-21 04:59:19.220788+00	2026-04-21 04:59:19.220788+00	2026-04-21 04:59:19.220788+00	{"eTag": "\\"b3a1ed90d946cbbdba43755c57aaed74\\"", "size": 213130, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-21T04:59:20.000Z", "contentLength": 213130, "httpStatusCode": 200}	c01e6f8d-c5d4-44da-8fb3-035a4148b7f8	\N	{}
3953923a-940a-491f-8e54-23df808142d6	uploads	product-1776503077554.webp	\N	2026-04-18 09:04:38.115746+00	2026-04-18 09:04:38.115746+00	2026-04-18 09:04:38.115746+00	{"eTag": "\\"d584df4a869c343c4b6ce3b288544333\\"", "size": 339728, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:04:39.000Z", "contentLength": 339728, "httpStatusCode": 200}	b1bcba1d-16dd-4faa-a0b4-e21c5594ab4b	\N	{}
630ecc09-fca2-486b-8361-7aba96ddd52a	uploads	product-1777103097090.webp	\N	2026-04-25 07:44:57.366974+00	2026-04-25 07:44:57.366974+00	2026-04-25 07:44:57.366974+00	{"eTag": "\\"01e50d3def97036f8e875f596877cb53\\"", "size": 507402, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:44:58.000Z", "contentLength": 507402, "httpStatusCode": 200}	1e4e6f68-292a-42e4-a678-98368fa4d25b	\N	{}
0f2b7d17-0cce-4dbb-be2a-de3dcb2be182	uploads	product-1776501131228.webp	\N	2026-04-18 08:32:11.475371+00	2026-04-18 08:32:11.475371+00	2026-04-18 08:32:11.475371+00	{"eTag": "\\"37e17f85a685e36a311055a16b1cbc1d\\"", "size": 329118, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:32:12.000Z", "contentLength": 329118, "httpStatusCode": 200}	90b85445-09ba-4105-9a29-6e959c687b96	\N	{}
c2bd77ee-583e-4276-bc87-27bcd90570d7	uploads	product-1777102287945.webp	\N	2026-04-25 07:31:28.098274+00	2026-04-25 07:31:28.098274+00	2026-04-25 07:31:28.098274+00	{"eTag": "\\"1e33d47af70e8a704c5139f67d402fc8\\"", "size": 48674, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:31:29.000Z", "contentLength": 48674, "httpStatusCode": 200}	987ec0d3-9a12-41f5-bf96-f322b6c6cf21	\N	{}
28fe5894-37e4-4a9c-8b54-757cc25143aa	uploads	product-1777102288276.webp	\N	2026-04-25 07:31:28.558256+00	2026-04-25 07:31:28.558256+00	2026-04-25 07:31:28.558256+00	{"eTag": "\\"988a008f3e82c635c18e52ed359a294b\\"", "size": 336148, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:31:29.000Z", "contentLength": 336148, "httpStatusCode": 200}	fb5c74bc-ebe5-4aec-a41c-455d6b898042	\N	{}
2f02bd25-428e-46f3-b191-b6540805a7fb	uploads	product-1776501131723.webp	\N	2026-04-18 08:32:12.025756+00	2026-04-18 08:32:12.025756+00	2026-04-18 08:32:12.025756+00	{"eTag": "\\"7ca9225a355324aab9f4d27a48cae490\\"", "size": 516488, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:32:12.000Z", "contentLength": 516488, "httpStatusCode": 200}	7fbc0ad9-455b-4caf-8d71-2ba168159637	\N	{}
f02d8166-b3b5-42d4-8c56-bc7e7ba9fb05	uploads	product-1777102377544.webp	\N	2026-04-25 07:32:58.033101+00	2026-04-25 07:32:58.033101+00	2026-04-25 07:32:58.033101+00	{"eTag": "\\"25cd4f9eb34eb563bd5d1533a7222bd1\\"", "size": 356918, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:32:58.000Z", "contentLength": 356918, "httpStatusCode": 200}	d71c1bc4-69e4-4ba3-b7aa-686338495f2d	\N	{}
97bfbff7-73d8-47a7-ade2-2b5c5ac3a7cc	uploads	product-1776161947307.png	\N	2026-04-14 10:19:08.343909+00	2026-04-14 10:19:08.343909+00	2026-04-14 10:19:08.343909+00	{"eTag": "\\"b54a84af53f56382642a98ad61e8b151\\"", "size": 2090425, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-14T10:19:09.000Z", "contentLength": 2090425, "httpStatusCode": 200}	ca76a37f-f627-42ef-8bde-d6de72aae3b1	\N	{}
244db208-2c0e-40ae-b337-12ba71e6ada8	uploads	product-1776501132277.webp	\N	2026-04-18 08:32:12.519712+00	2026-04-18 08:32:12.519712+00	2026-04-18 08:32:12.519712+00	{"eTag": "\\"63190f3711e8349d315e2634fc92fe61\\"", "size": 332512, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:32:13.000Z", "contentLength": 332512, "httpStatusCode": 200}	00891e5b-e6c6-4fc7-a984-e0f8e4cfc383	\N	{}
2832e11e-a050-482b-881a-b783c0a0ae64	uploads	product-1776161950516.png	\N	2026-04-14 10:19:11.593329+00	2026-04-14 10:19:11.593329+00	2026-04-14 10:19:11.593329+00	{"eTag": "\\"42527c283b9bed92362a1a9e41f4efa9\\"", "size": 1587158, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-14T10:19:12.000Z", "contentLength": 1587158, "httpStatusCode": 200}	e6e2d639-f9d7-4198-9751-d5d4b71b000a	\N	{}
4b2bcb5b-17b7-4404-a0a0-8f7ef523b48d	uploads	product-1776161952828.png	\N	2026-04-14 10:19:13.928776+00	2026-04-14 10:19:13.928776+00	2026-04-14 10:19:13.928776+00	{"eTag": "\\"eeb8aa24ce467c58cbfbec528cfdfbd9\\"", "size": 1701511, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-14T10:19:14.000Z", "contentLength": 1701511, "httpStatusCode": 200}	62c7079a-a04a-43bf-80f1-89b34aabdb72	\N	{}
ecc79f46-98f4-4037-8ad0-23dad6945e9f	uploads	product-1776161954749.png	\N	2026-04-14 10:19:15.042234+00	2026-04-14 10:19:15.042234+00	2026-04-14 10:19:15.042234+00	{"eTag": "\\"962e7023ced37b26f3d0f554b1cadaa4\\"", "size": 935235, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-14T10:19:15.000Z", "contentLength": 935235, "httpStatusCode": 200}	6f401b39-b64a-4361-927f-e60cfb7b4e7c	\N	{}
a721a939-bf9e-4b56-b49e-98dd32550a87	uploads	product-1776161956100.png	\N	2026-04-14 10:19:16.722541+00	2026-04-14 10:19:16.722541+00	2026-04-14 10:19:16.722541+00	{"eTag": "\\"35de511a31b6af36787da3e4ab83fcbb\\"", "size": 1127116, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-14T10:19:17.000Z", "contentLength": 1127116, "httpStatusCode": 200}	ae3f1122-69a4-4218-91b1-b8f4980bfc63	\N	{}
650678a4-b9ee-4964-a61a-2ac8a9a38647	uploads	product-1776161958075.png	\N	2026-04-14 10:19:19.061852+00	2026-04-14 10:19:19.061852+00	2026-04-14 10:19:19.061852+00	{"eTag": "\\"093c05c79cfb8bec8861804899e69ea0\\"", "size": 903072, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-14T10:19:19.000Z", "contentLength": 903072, "httpStatusCode": 200}	9d177ce7-b80a-4282-b02e-f3417cf40c7f	\N	{}
c7af9e5a-dce0-4032-98b9-b709b52da66d	uploads	product-1776501132701.webp	\N	2026-04-18 08:32:12.979315+00	2026-04-18 08:32:12.979315+00	2026-04-18 08:32:12.979315+00	{"eTag": "\\"fa670423abb83f64b411a1037ce3d17f\\"", "size": 291064, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:32:13.000Z", "contentLength": 291064, "httpStatusCode": 200}	f2bf96ae-43b2-4231-b0ac-01edb98661e0	\N	{}
8c9d2d0d-aba4-4eed-a8ad-77e52d01ad0e	uploads	product-1776162586062.png	\N	2026-04-14 10:29:47.425153+00	2026-04-14 10:29:47.425153+00	2026-04-14 10:29:47.425153+00	{"eTag": "\\"8c7c7cf1e4727425ac341c488b156769\\"", "size": 2064577, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-14T10:29:48.000Z", "contentLength": 2064577, "httpStatusCode": 200}	030f8038-a9bc-446e-837d-0edbfabed95c	\N	{}
9ecf2b48-6423-4c56-82a5-89f9697a0f7c	uploads	product-1776503078364.webp	\N	2026-04-18 09:04:38.62626+00	2026-04-18 09:04:38.62626+00	2026-04-18 09:04:38.62626+00	{"eTag": "\\"ccc5f623c8b8df1fd849263e836993da\\"", "size": 315060, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:04:39.000Z", "contentLength": 315060, "httpStatusCode": 200}	a56959e2-0e43-4f6d-9c6b-6612bc6c3838	\N	{}
eee5cf45-88d7-4bb1-8039-106cffb4adbc	uploads	product-1776490586295.jpeg	\N	2026-04-18 05:36:27.26682+00	2026-04-18 05:36:27.26682+00	2026-04-18 05:36:27.26682+00	{"eTag": "\\"347d8eccce97e5d53bf56832441c6b01\\"", "size": 303050, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T05:36:28.000Z", "contentLength": 303050, "httpStatusCode": 200}	730e581d-df29-48d6-beb6-804cf0f358ff	\N	{}
17efd554-2921-442a-b2c1-dee385cbe9d2	uploads	product-1776501133173.webp	\N	2026-04-18 08:32:13.442024+00	2026-04-18 08:32:13.442024+00	2026-04-18 08:32:13.442024+00	{"eTag": "\\"44576229557c8ab87cd22f7163728523\\"", "size": 310794, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:32:14.000Z", "contentLength": 310794, "httpStatusCode": 200}	abb8e112-03a4-496b-86e4-12c7c776d913	\N	{}
d11d6fb7-c469-40f8-92b5-cad7e76bf6de	uploads	product-1776490587443.png	\N	2026-04-18 05:36:27.826978+00	2026-04-18 05:36:27.826978+00	2026-04-18 05:36:27.826978+00	{"eTag": "\\"8bac8f07fb038b0e4a7634689132bd7c\\"", "size": 465788, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T05:36:28.000Z", "contentLength": 465788, "httpStatusCode": 200}	cbe1ccb6-0b7b-4c1c-bb31-0e526da4bc61	\N	{}
640cd299-4df4-4a80-95df-6422f07fd14a	uploads	product-1776490587989.png	\N	2026-04-18 05:36:28.47699+00	2026-04-18 05:36:28.47699+00	2026-04-18 05:36:28.47699+00	{"eTag": "\\"962e7023ced37b26f3d0f554b1cadaa4\\"", "size": 935235, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T05:36:29.000Z", "contentLength": 935235, "httpStatusCode": 200}	b993e716-1f45-4f74-b538-91a91713b4ba	\N	{}
9502d220-406e-4dc3-8d4c-6d5b25040683	uploads	product-1776501133633.webp	\N	2026-04-18 08:32:13.874418+00	2026-04-18 08:32:13.874418+00	2026-04-18 08:32:13.874418+00	{"eTag": "\\"2eddefad1387ae38fab72a3ea309fdd7\\"", "size": 378290, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:32:14.000Z", "contentLength": 378290, "httpStatusCode": 200}	d278a86f-864b-48cc-a355-e87eedf62ad9	\N	{}
02027268-cf87-4956-bd31-0d3a3e14715a	uploads	product-1776490588658.png	\N	2026-04-18 05:36:29.070291+00	2026-04-18 05:36:29.070291+00	2026-04-18 05:36:29.070291+00	{"eTag": "\\"e3fc14e3712c4f28ff18a19d7082f895\\"", "size": 1133112, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T05:36:30.000Z", "contentLength": 1133112, "httpStatusCode": 200}	cf8f05e1-5f86-408a-9027-337463faa0b5	\N	{}
e9d760fa-3a03-4865-833d-7bab2dbc6c3e	uploads	product-1776501899183.webp	\N	2026-04-18 08:44:59.808652+00	2026-04-18 08:44:59.808652+00	2026-04-18 08:44:59.808652+00	{"eTag": "\\"54d6b77273eede6991382619f9a90f01\\"", "size": 382262, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:45:00.000Z", "contentLength": 382262, "httpStatusCode": 200}	479f15fd-2006-480a-8453-2551f7f42773	\N	{}
1162f7e9-61a3-4f61-9c92-7e0aa82dc3d2	uploads	testing-1776493956091.webp	\N	2026-04-18 06:32:37.195183+00	2026-04-18 06:32:37.195183+00	2026-04-18 06:32:37.195183+00	{"eTag": "\\"e90343ff41fa4816752a71818610c073\\"", "size": 304202, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T06:32:38.000Z", "contentLength": 304202, "httpStatusCode": 200}	d80f3eba-3a30-4548-a5fa-d9ab933f8d8d	\N	{}
b4028ba9-a431-4422-8d08-98bda3c84024	uploads	product-1776495946953.webp	\N	2026-04-18 07:05:47.973493+00	2026-04-18 07:05:47.973493+00	2026-04-18 07:05:47.973493+00	{"eTag": "\\"52ebfc4d73bba5c820afc38776d4112d\\"", "size": 402588, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:05:48.000Z", "contentLength": 402588, "httpStatusCode": 200}	3db1b53f-6d7a-4172-b6a6-bffc92609a44	\N	{}
c0eec19a-7cf4-48cd-bd49-ffc6b908b676	uploads	product-1776495948232.webp	\N	2026-04-18 07:05:48.482016+00	2026-04-18 07:05:48.482016+00	2026-04-18 07:05:48.482016+00	{"eTag": "\\"618b1eef6497e71f2f415bcd84a81d0d\\"", "size": 384208, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:05:49.000Z", "contentLength": 384208, "httpStatusCode": 200}	f52a9cc4-48c9-40bb-a45b-1b5ab894a8d1	\N	{}
972e6790-a3f8-4680-9b86-b82b965a8fdf	uploads	product-1776495948718.webp	\N	2026-04-18 07:05:48.981844+00	2026-04-18 07:05:48.981844+00	2026-04-18 07:05:48.981844+00	{"eTag": "\\"e54d83f845992b5a430c2e9b6421260d\\"", "size": 374124, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:05:49.000Z", "contentLength": 374124, "httpStatusCode": 200}	ad50c7eb-0c53-4173-bead-f3ef02580058	\N	{}
b7e4ec24-f845-4044-917f-ad9a552c3a6f	uploads	product-1776495949214.webp	\N	2026-04-18 07:05:49.486727+00	2026-04-18 07:05:49.486727+00	2026-04-18 07:05:49.486727+00	{"eTag": "\\"e9dc89cc0bb2ea0de366f695d806cb04\\"", "size": 396498, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:05:50.000Z", "contentLength": 396498, "httpStatusCode": 200}	8016677f-06e9-4ef0-a9b3-db5510131482	\N	{}
6f9ecb2c-4fd0-4eb9-b166-7dbcb5e6f836	uploads	product-1776495949745.webp	\N	2026-04-18 07:05:50.062384+00	2026-04-18 07:05:50.062384+00	2026-04-18 07:05:50.062384+00	{"eTag": "\\"edc2348349b8abbea3664d60982a2c52\\"", "size": 431928, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:05:50.000Z", "contentLength": 431928, "httpStatusCode": 200}	36767750-b45f-4c8a-9689-a2a9d1af0991	\N	{}
b57e3a5f-6501-42e1-9526-b7bb48792bf6	uploads	product-1776495950317.webp	\N	2026-04-18 07:05:50.587319+00	2026-04-18 07:05:50.587319+00	2026-04-18 07:05:50.587319+00	{"eTag": "\\"e90343ff41fa4816752a71818610c073\\"", "size": 304202, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:05:51.000Z", "contentLength": 304202, "httpStatusCode": 200}	ccd98c3a-f1b2-4627-86ce-527c7bf462c9	\N	{}
28cd7729-7fee-4378-beb9-99243e35f59b	uploads	product-1776503078811.webp	\N	2026-04-18 09:04:39.05899+00	2026-04-18 09:04:39.05899+00	2026-04-18 09:04:39.05899+00	{"eTag": "\\"4d1786f200c3c58e82d095dfb2562772\\"", "size": 234140, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:04:40.000Z", "contentLength": 234140, "httpStatusCode": 200}	feee9129-f84c-4be3-b4ef-0a35f0a1f3ff	\N	{}
52b53f21-8cce-473b-b13e-a750378fa339	uploads	product-1776496641002.webp	\N	2026-04-18 07:17:22.069816+00	2026-04-18 07:17:22.069816+00	2026-04-18 07:17:22.069816+00	{"eTag": "\\"b96133fd574568dd054133493188ce69\\"", "size": 379734, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:17:22.000Z", "contentLength": 379734, "httpStatusCode": 200}	f85d28dd-9416-48f5-8d84-22937d7282d7	\N	{}
1fccd274-abb5-401f-ae2d-be0da9321581	uploads	product-1776501367820.webp	\N	2026-04-18 08:36:08.55227+00	2026-04-18 08:36:08.55227+00	2026-04-18 08:36:08.55227+00	{"eTag": "\\"2b3cc01eff8667f30725dbc67ab50d76\\"", "size": 374644, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:36:09.000Z", "contentLength": 374644, "httpStatusCode": 200}	cb07fc32-cdfa-43a7-bfc9-7a3ba5a919e2	\N	{}
837492e2-c47c-4271-a1d7-c8e750581406	uploads	product-1776496642326.webp	\N	2026-04-18 07:17:24.182894+00	2026-04-18 07:17:24.182894+00	2026-04-18 07:17:24.182894+00	{"eTag": "\\"c35b99373790c0b60e4e7ab3e9e13c42\\"", "size": 439466, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:17:25.000Z", "contentLength": 439466, "httpStatusCode": 200}	722379dd-373f-4a34-8ec7-86a3ed7d6589	\N	{}
be2e07f7-e7b2-4026-ba34-9e433760c28f	uploads	product-1776496644420.webp	\N	2026-04-18 07:17:24.954804+00	2026-04-18 07:17:24.954804+00	2026-04-18 07:17:24.954804+00	{"eTag": "\\"3b5bd851a84a210b569e92dea05b1b25\\"", "size": 396760, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:17:25.000Z", "contentLength": 396760, "httpStatusCode": 200}	93491d19-797f-45b9-9d28-070c830417a3	\N	{}
be064410-446d-440b-aab1-f5c3b4158c1a	uploads	product-1776501368811.webp	\N	2026-04-18 08:36:09.288171+00	2026-04-18 08:36:09.288171+00	2026-04-18 08:36:09.288171+00	{"eTag": "\\"9faa520ae286e6218d5aaea5531b6dee\\"", "size": 386436, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:36:10.000Z", "contentLength": 386436, "httpStatusCode": 200}	dd21f875-a2e9-46d9-a17e-23a1927ca7ca	\N	{}
81ece6df-dcd9-4b50-914a-95d745484077	uploads	product-1776496645156.webp	\N	2026-04-18 07:17:25.659837+00	2026-04-18 07:17:25.659837+00	2026-04-18 07:17:25.659837+00	{"eTag": "\\"206ea8c49446ab0aeb8f660385c0d776\\"", "size": 288396, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:17:26.000Z", "contentLength": 288396, "httpStatusCode": 200}	3663a8c3-3b37-44e7-8af0-b8221a50e0b8	\N	{}
f11896d0-b237-43d1-9dc6-3fdab6983eef	uploads	product-1776503079269.webp	\N	2026-04-18 09:04:39.496993+00	2026-04-18 09:04:39.496993+00	2026-04-18 09:04:39.496993+00	{"eTag": "\\"13072af610e7f77fbe4b01c289e35b54\\"", "size": 332222, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:04:40.000Z", "contentLength": 332222, "httpStatusCode": 200}	b2dd7b92-9c92-48eb-bd4f-8f4ebe7750fd	\N	{}
dc14ba69-3d76-43ca-a370-fd076e295d1a	uploads	product-1776496645854.webp	\N	2026-04-18 07:17:26.75896+00	2026-04-18 07:17:26.75896+00	2026-04-18 07:17:26.75896+00	{"eTag": "\\"4e5df1c7d363373c56f913ac5b90c77c\\"", "size": 334066, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:17:27.000Z", "contentLength": 334066, "httpStatusCode": 200}	66a1f090-60fb-4693-8024-5ff3bf0f0cca	\N	{}
2afc8646-77d8-419c-a800-acad203ad565	uploads	product-1776501369481.webp	\N	2026-04-18 08:36:09.730524+00	2026-04-18 08:36:09.730524+00	2026-04-18 08:36:09.730524+00	{"eTag": "\\"2254eef52f53a95eb1757490b90aa032\\"", "size": 244022, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:36:10.000Z", "contentLength": 244022, "httpStatusCode": 200}	7c903d26-4341-4ad9-ba72-3ccfda733ddd	\N	{}
57304d57-70dd-40f0-9f0b-95142f3bd7f9	uploads	product-1776496647072.webp	\N	2026-04-18 07:17:27.799491+00	2026-04-18 07:17:27.799491+00	2026-04-18 07:17:27.799491+00	{"eTag": "\\"876d74879f2bbcd8362462bb98ad28e2\\"", "size": 429972, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:17:28.000Z", "contentLength": 429972, "httpStatusCode": 200}	8279b694-2eaf-4377-983e-7178701e3ebd	\N	{}
8ef6702c-3d8e-4326-80a3-f50195842b5c	uploads	product-1776496648033.webp	\N	2026-04-18 07:17:28.394278+00	2026-04-18 07:17:28.394278+00	2026-04-18 07:17:28.394278+00	{"eTag": "\\"63c16222d7ccc69c2c553721271a32e5\\"", "size": 543828, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:17:29.000Z", "contentLength": 543828, "httpStatusCode": 200}	aaf6a7c2-87d4-48b9-8e15-b2b342c31bf5	\N	{}
750f3657-19db-4444-8350-6107d7a217f7	uploads	product-1776496648596.webp	\N	2026-04-18 07:17:28.908707+00	2026-04-18 07:17:28.908707+00	2026-04-18 07:17:28.908707+00	{"eTag": "\\"3a6a11af7b0e53b43b61d94097d8b63b\\"", "size": 403158, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:17:29.000Z", "contentLength": 403158, "httpStatusCode": 200}	a1b8cced-89ef-4c29-bbea-87c74901eb56	\N	{}
0fbd11cb-7cf3-4913-a468-83bceae918c0	uploads	product-1776497025903.webp	\N	2026-04-18 07:23:46.422796+00	2026-04-18 07:23:46.422796+00	2026-04-18 07:23:46.422796+00	{"eTag": "\\"4810886dc3b79b8b905a252790e69740\\"", "size": 378248, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:23:47.000Z", "contentLength": 378248, "httpStatusCode": 200}	da546280-3661-4338-8902-a105c34457ad	\N	{}
6c71cc8c-30fa-4167-bb39-74e0ab8f5bdf	uploads	product-1776497026683.webp	\N	2026-04-18 07:23:46.971935+00	2026-04-18 07:23:46.971935+00	2026-04-18 07:23:46.971935+00	{"eTag": "\\"6e5fa5c7b3ab77ad15ac7f5525b79abd\\"", "size": 374418, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:23:47.000Z", "contentLength": 374418, "httpStatusCode": 200}	450d98ff-c074-48f3-8145-e2a209506024	\N	{}
b2ace0f5-f077-4817-a057-c170946a03a3	uploads	product-1776497027238.webp	\N	2026-04-18 07:23:47.517548+00	2026-04-18 07:23:47.517548+00	2026-04-18 07:23:47.517548+00	{"eTag": "\\"9c8b2c6e0edf5e002f184b34a6fd8c68\\"", "size": 355350, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:23:48.000Z", "contentLength": 355350, "httpStatusCode": 200}	eade0224-5bd6-42e0-a29e-476ef965bc44	\N	{}
ecfdbf12-3c81-4573-a847-dc8d260b1109	uploads	product-1776501369935.webp	\N	2026-04-18 08:36:10.242406+00	2026-04-18 08:36:10.242406+00	2026-04-18 08:36:10.242406+00	{"eTag": "\\"156519a620c22c059abe501beb7fb0d6\\"", "size": 328090, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:36:11.000Z", "contentLength": 328090, "httpStatusCode": 200}	20f3372e-f26d-48a8-8bc2-8c2fdce675e1	\N	{}
d5390581-52d8-489a-a846-70fc1a11ad62	uploads	product-1776497027768.webp	\N	2026-04-18 07:23:48.039427+00	2026-04-18 07:23:48.039427+00	2026-04-18 07:23:48.039427+00	{"eTag": "\\"ed1253b08ada2e6fa58dfe10147ea493\\"", "size": 336282, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:23:48.000Z", "contentLength": 336282, "httpStatusCode": 200}	a043c137-d5a6-4910-9672-009dd38e9c80	\N	{}
29b413a4-0fbe-4b62-8936-6af540e71949	uploads	product-1776842103558.webp	\N	2026-04-22 07:15:04.953728+00	2026-04-22 07:15:04.953728+00	2026-04-22 07:15:04.953728+00	{"eTag": "\\"799ab47725f28701e5a372cfddc69014\\"", "size": 1122930, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-22T07:15:05.000Z", "contentLength": 1122930, "httpStatusCode": 200}	46b902c7-6902-4f1f-ad0b-df5390ba80ca	\N	{}
f022a0f0-49f7-495e-a408-8b3c4a8b4cae	uploads	product-1776497028303.webp	\N	2026-04-18 07:23:48.619711+00	2026-04-18 07:23:48.619711+00	2026-04-18 07:23:48.619711+00	{"eTag": "\\"c0ccac3b3b2f17ada20967b611ae288d\\"", "size": 319554, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:23:49.000Z", "contentLength": 319554, "httpStatusCode": 200}	3542407a-d387-4e3a-af20-5ed4f9a56416	\N	{}
3ce774b9-6a7c-4a75-a556-e159803e2079	uploads	product-1776501370466.webp	\N	2026-04-18 08:36:10.944602+00	2026-04-18 08:36:10.944602+00	2026-04-18 08:36:10.944602+00	{"eTag": "\\"01e50d3def97036f8e875f596877cb53\\"", "size": 507402, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:36:11.000Z", "contentLength": 507402, "httpStatusCode": 200}	653e5c94-24ef-420c-a58f-b4df03488b56	\N	{}
2302616c-5f27-40c0-aa1c-8390787c73d3	uploads	product-1776497028870.webp	\N	2026-04-18 07:23:49.08986+00	2026-04-18 07:23:49.08986+00	2026-04-18 07:23:49.08986+00	{"eTag": "\\"9d14b88c540fde0b85acecc43674718e\\"", "size": 279892, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:23:50.000Z", "contentLength": 279892, "httpStatusCode": 200}	e2d91f63-0a83-45b6-a7bf-fecd48bc63e4	\N	{}
f09fb7f9-cb38-48c3-8827-393f6ab27d2f	uploads	product-1776503079664.webp	\N	2026-04-18 09:04:39.928261+00	2026-04-18 09:04:39.928261+00	2026-04-18 09:04:39.928261+00	{"eTag": "\\"d501abb505179a75851a84e1f06a538e\\"", "size": 222276, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:04:40.000Z", "contentLength": 222276, "httpStatusCode": 200}	8e6c9d0d-d30c-47b3-a3a1-d75d33543111	\N	{}
a362c760-46ec-4952-bc3b-b45334acb75f	uploads	product-1776497029492.webp	\N	2026-04-18 07:23:49.791746+00	2026-04-18 07:23:49.791746+00	2026-04-18 07:23:49.791746+00	{"eTag": "\\"6921f0e049062cf2d15c0e0104c4aadf\\"", "size": 400432, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T07:23:50.000Z", "contentLength": 400432, "httpStatusCode": 200}	1f60ddda-8120-4ae5-8578-8349dd3b2a95	\N	{}
774de3fb-d0c0-41a0-9d43-82fbdea35860	uploads	product-1776501371148.webp	\N	2026-04-18 08:36:11.427935+00	2026-04-18 08:36:11.427935+00	2026-04-18 08:36:11.427935+00	{"eTag": "\\"71db35031dd4a5e87adee765c1d26c63\\"", "size": 376594, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:36:12.000Z", "contentLength": 376594, "httpStatusCode": 200}	1245d371-aba7-4634-b62b-446105309e85	\N	{}
ffd79c87-a47c-49b6-b975-5387b3d8d1c5	uploads	product-1776500613730.webp	\N	2026-04-18 08:23:35.226125+00	2026-04-18 08:23:35.226125+00	2026-04-18 08:23:35.226125+00	{"eTag": "\\"6c19bfcb2ea5ffad741d792887f9ba86\\"", "size": 530268, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:23:36.000Z", "contentLength": 530268, "httpStatusCode": 200}	ebe4bfbb-eb71-4fc9-be41-60248e4df4da	\N	{}
98b85d1d-22de-4acf-afca-ac3e6279cd7d	uploads	product-1776500615472.webp	\N	2026-04-18 08:23:36.182136+00	2026-04-18 08:23:36.182136+00	2026-04-18 08:23:36.182136+00	{"eTag": "\\"849f0aaba3b0f7f8ad78febde6dc86a7\\"", "size": 432004, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:23:37.000Z", "contentLength": 432004, "httpStatusCode": 200}	3b963c7c-6744-4735-85d0-01589580b9f7	\N	{}
2ccae871-2685-4375-b808-a52355627a73	uploads	product-1776501371613.webp	\N	2026-04-18 08:36:12.12815+00	2026-04-18 08:36:12.12815+00	2026-04-18 08:36:12.12815+00	{"eTag": "\\"d00a1a0bc1425af6f86b937371d77f2a\\"", "size": 362992, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:36:13.000Z", "contentLength": 362992, "httpStatusCode": 200}	1868f578-0a97-4dbb-b2e7-ad1c902ff56a	\N	{}
4c991469-4c84-4ecd-9482-94f4fab60c87	uploads	product-1776500616413.webp	\N	2026-04-18 08:23:38.151689+00	2026-04-18 08:23:38.151689+00	2026-04-18 08:23:38.151689+00	{"eTag": "\\"23ab0b56d2d21f3aa72802e956c6e2db\\"", "size": 620278, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:23:39.000Z", "contentLength": 620278, "httpStatusCode": 200}	d9d5b643-1c4c-4d3e-b77d-c6487c89b844	\N	{}
c19f22eb-a620-4d76-ae9a-d420a9cda9ed	uploads	product-1776500618370.webp	\N	2026-04-18 08:23:38.686127+00	2026-04-18 08:23:38.686127+00	2026-04-18 08:23:38.686127+00	{"eTag": "\\"4f7fb863ca423a5ec173dedc6fcf6898\\"", "size": 559998, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:23:39.000Z", "contentLength": 559998, "httpStatusCode": 200}	5d84da6e-ca0a-452a-9f2f-ba38ecf0ac62	\N	{}
974e4695-b344-4c37-a55d-2a6e77bfa46d	uploads	product-1776500618983.webp	\N	2026-04-18 08:23:39.879844+00	2026-04-18 08:23:39.879844+00	2026-04-18 08:23:39.879844+00	{"eTag": "\\"4bb11e7be6718f3b09d3052841c5c1fe\\"", "size": 378982, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:23:40.000Z", "contentLength": 378982, "httpStatusCode": 200}	f8a50086-ee04-48ee-942c-baafb7e6919e	\N	{}
56a1271b-6afd-4aa9-9769-65012e9f835a	uploads	product-1776500620093.webp	\N	2026-04-18 08:23:41.670018+00	2026-04-18 08:23:41.670018+00	2026-04-18 08:23:41.670018+00	{"eTag": "\\"de08bca98741198f05249aa5428e0e16\\"", "size": 541738, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:23:42.000Z", "contentLength": 541738, "httpStatusCode": 200}	26499605-5f79-426e-b50a-4158242cbfd8	\N	{}
6b7c9600-7cbe-4752-9abd-80c1022df377	uploads	product-1776500621903.webp	\N	2026-04-18 08:23:42.652121+00	2026-04-18 08:23:42.652121+00	2026-04-18 08:23:42.652121+00	{"eTag": "\\"1cea25d35ff93369a00870b53e24843f\\"", "size": 752510, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:23:43.000Z", "contentLength": 752510, "httpStatusCode": 200}	b487a60c-7170-49a1-b13a-887d6ca77657	\N	{}
97834843-23d8-4676-b680-ac1a6d7e8451	uploads	product-1776500829335.webp	\N	2026-04-18 08:27:10.266334+00	2026-04-18 08:27:10.266334+00	2026-04-18 08:27:10.266334+00	{"eTag": "\\"5996ee00a6fdbc156fd915d119b6f590\\"", "size": 370070, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:27:11.000Z", "contentLength": 370070, "httpStatusCode": 200}	d3d2e705-3e55-44d7-b3cb-10c5dcf841c0	\N	{}
2ea6105b-adc8-4b68-91d5-4558e23b0713	uploads	product-1776501732252.webp	\N	2026-04-18 08:42:13.23121+00	2026-04-18 08:42:13.23121+00	2026-04-18 08:42:13.23121+00	{"eTag": "\\"adcc43e3a0fae8f30f7fbbd23a0b9408\\"", "size": 431730, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:42:14.000Z", "contentLength": 431730, "httpStatusCode": 200}	1466fc7b-1799-4489-9661-2cdc93728fd6	\N	{}
34e9e78f-7afc-4fbb-8a52-9a08a7fc19d6	uploads	product-1776500830522.webp	\N	2026-04-18 08:27:10.86937+00	2026-04-18 08:27:10.86937+00	2026-04-18 08:27:10.86937+00	{"eTag": "\\"02f5074dd504780446cd823dbc844a5f\\"", "size": 527978, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:27:11.000Z", "contentLength": 527978, "httpStatusCode": 200}	9e5aab80-efab-49db-94c5-8d2e3e08b77e	\N	{}
f7a24edd-c2e6-4d65-87c2-12f6f6266558	uploads	product-1776503080084.webp	\N	2026-04-18 09:04:40.249174+00	2026-04-18 09:04:40.249174+00	2026-04-18 09:04:40.249174+00	{"eTag": "\\"1e33d47af70e8a704c5139f67d402fc8\\"", "size": 48674, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:04:41.000Z", "contentLength": 48674, "httpStatusCode": 200}	e1acf8fa-d699-4119-9f3f-26af9cef3855	\N	{}
267479ac-4d6c-45f9-b6a3-fc8a4fb22683	uploads	product-1776500831055.webp	\N	2026-04-18 08:27:11.594358+00	2026-04-18 08:27:11.594358+00	2026-04-18 08:27:11.594358+00	{"eTag": "\\"3725ec5a7d57b870222361a38718d115\\"", "size": 230604, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:27:12.000Z", "contentLength": 230604, "httpStatusCode": 200}	13e39b5c-4156-4361-a73b-1500cb10aca3	\N	{}
c1f8842b-3efd-438c-a021-8404dcd35340	uploads	product-1776501733443.webp	\N	2026-04-18 08:42:13.929429+00	2026-04-18 08:42:13.929429+00	2026-04-18 08:42:13.929429+00	{"eTag": "\\"71e5d16c0f0a73e31ebf0c07dba6fd72\\"", "size": 232902, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:42:14.000Z", "contentLength": 232902, "httpStatusCode": 200}	4756f345-0ca4-4dda-b0b2-d67f7e54c3a8	\N	{}
58b66890-bfd2-4820-b90f-a4a50108aecc	uploads	product-1776500831806.webp	\N	2026-04-18 08:27:12.07611+00	2026-04-18 08:27:12.07611+00	2026-04-18 08:27:12.07611+00	{"eTag": "\\"74c48ff56e1d901224579c7da1be9165\\"", "size": 391184, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:27:13.000Z", "contentLength": 391184, "httpStatusCode": 200}	a28ea1d8-ee83-4890-8ede-9b3f6219b09f	\N	{}
b65573bd-74e9-4a6c-ab66-c90be2bf2c5b	uploads	product-1776500832290.webp	\N	2026-04-18 08:27:12.890344+00	2026-04-18 08:27:12.890344+00	2026-04-18 08:27:12.890344+00	{"eTag": "\\"94a53d157d89eb33135af9d48b3b4d1d\\"", "size": 388942, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:27:13.000Z", "contentLength": 388942, "httpStatusCode": 200}	42bdd74e-1886-4cf6-9223-8fd8e8410aa2	\N	{}
2a74928b-637e-4a18-ab35-5a4b30b6394c	uploads	product-1776501734156.webp	\N	2026-04-18 08:42:14.636567+00	2026-04-18 08:42:14.636567+00	2026-04-18 08:42:14.636567+00	{"eTag": "\\"879bee773984824a0068243f8a15af8f\\"", "size": 338780, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:42:15.000Z", "contentLength": 338780, "httpStatusCode": 200}	046e1ab1-2eaf-4992-94c8-a3bdfb245a06	\N	{}
b9d4dc03-92eb-4c4b-b0ab-13ca33e1b2e9	uploads	product-1776500833076.webp	\N	2026-04-18 08:27:13.353195+00	2026-04-18 08:27:13.353195+00	2026-04-18 08:27:13.353195+00	{"eTag": "\\"1fc64458157c930894bca83140cb4630\\"", "size": 328420, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:27:14.000Z", "contentLength": 328420, "httpStatusCode": 200}	5392ae10-646e-4a45-b75d-cc05db55fcbe	\N	{}
73791475-e4a1-4dc4-a2cd-3d6eab781135	uploads	product-1776503080446.webp	\N	2026-04-18 09:04:40.691721+00	2026-04-18 09:04:40.691721+00	2026-04-18 09:04:40.691721+00	{"eTag": "\\"988a008f3e82c635c18e52ed359a294b\\"", "size": 336148, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:04:41.000Z", "contentLength": 336148, "httpStatusCode": 200}	3cac0131-c900-418b-aa6f-46be9bd670a0	\N	{}
ee407385-cab1-47da-9ced-66fc60c17b5b	uploads	product-1776500833563.webp	\N	2026-04-18 08:27:13.928241+00	2026-04-18 08:27:13.928241+00	2026-04-18 08:27:13.928241+00	{"eTag": "\\"97260ebecac9ab3181d93439bd972a2e\\"", "size": 389508, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:27:14.000Z", "contentLength": 389508, "httpStatusCode": 200}	99f0d7f1-4c36-44da-be7b-cae2dd7d42b3	\N	{}
0f5a09c5-ecb3-42eb-a833-900e4b9bafc8	uploads	product-1776501734808.webp	\N	2026-04-18 08:42:15.071877+00	2026-04-18 08:42:15.071877+00	2026-04-18 08:42:15.071877+00	{"eTag": "\\"d501d05d1a1f5cd0426e91f8bce971f2\\"", "size": 152760, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:42:16.000Z", "contentLength": 152760, "httpStatusCode": 200}	4bb6c847-1710-40e4-8d81-8d82d6c18a71	\N	{}
6721ed12-a19b-4d5c-8e53-63977beb97ba	uploads	product-1776842118617.webp	\N	2026-04-22 07:15:18.908694+00	2026-04-22 07:15:18.908694+00	2026-04-22 07:15:18.908694+00	{"eTag": "\\"3ce124999cbecbe677e45f1b0392e8a2\\"", "size": 116740, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-22T07:15:19.000Z", "contentLength": 116740, "httpStatusCode": 200}	da568fa3-8d94-463d-827c-4c96da750764	\N	{}
b415c0b8-1928-4295-bf5e-b4c144c7f8ea	uploads	product-1776501735301.webp	\N	2026-04-18 08:42:15.58052+00	2026-04-18 08:42:15.58052+00	2026-04-18 08:42:15.58052+00	{"eTag": "\\"446e1a468b05bb5d72790f8e6520b6f2\\"", "size": 395054, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:42:16.000Z", "contentLength": 395054, "httpStatusCode": 200}	41f26666-80d7-4196-bf43-b125bcd72a35	\N	{}
f490467a-401c-433d-accd-35e896351c95	uploads	product-1776501735807.webp	\N	2026-04-18 08:42:16.378906+00	2026-04-18 08:42:16.378906+00	2026-04-18 08:42:16.378906+00	{"eTag": "\\"299e6c85183d122f0b0980d49e67bb0d\\"", "size": 335772, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:42:17.000Z", "contentLength": 335772, "httpStatusCode": 200}	06764558-f3e9-4d9f-915f-5be33db60d9d	\N	{}
1d40df6d-7b49-4c40-a2e1-92e37acdb9f9	uploads	product-1776501736574.webp	\N	2026-04-18 08:42:16.867607+00	2026-04-18 08:42:16.867607+00	2026-04-18 08:42:16.867607+00	{"eTag": "\\"b8306718980d919dfda54e4c74d04eaa\\"", "size": 321770, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:42:17.000Z", "contentLength": 321770, "httpStatusCode": 200}	5edf4fd2-c018-4d2f-b316-a84495e49728	\N	{}
6c18d1a0-7ec1-4ec0-90eb-104d076814ff	uploads	product-1776501900000.webp	\N	2026-04-18 08:45:00.700048+00	2026-04-18 08:45:00.700048+00	2026-04-18 08:45:00.700048+00	{"eTag": "\\"fbce109edd4efc3d8f8b50b8ef299e00\\"", "size": 285308, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:45:01.000Z", "contentLength": 285308, "httpStatusCode": 200}	4a817f9a-5221-45ff-bc6e-ac0e6cd107a0	\N	{}
a932cf9f-fa83-41a7-b6d7-7eb4a303d1de	uploads	product-1776503148566.webp	\N	2026-04-18 09:05:48.91672+00	2026-04-18 09:05:48.91672+00	2026-04-18 09:05:48.91672+00	{"eTag": "\\"4810886dc3b79b8b905a252790e69740\\"", "size": 378248, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:05:49.000Z", "contentLength": 378248, "httpStatusCode": 200}	d3fd2234-f02c-4d1d-9c21-cb957f00818e	\N	{}
ec81874d-b09a-4397-8dd1-3d4bc420710f	uploads	product-1776501900875.webp	\N	2026-04-18 08:45:01.525879+00	2026-04-18 08:45:01.525879+00	2026-04-18 08:45:01.525879+00	{"eTag": "\\"b9318a3b71949f5b411c009d0945ac02\\"", "size": 123722, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:45:02.000Z", "contentLength": 123722, "httpStatusCode": 200}	332993ac-5fd5-4cbb-8adf-f4db6df707b0	\N	{}
f0fc390c-229f-4c32-ac52-ea3efa4ee8f5	uploads	product-1777103097511.webp	\N	2026-04-25 07:44:58.105401+00	2026-04-25 07:44:58.105401+00	2026-04-25 07:44:58.105401+00	{"eTag": "\\"71db35031dd4a5e87adee765c1d26c63\\"", "size": 376594, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:44:59.000Z", "contentLength": 376594, "httpStatusCode": 200}	0df80069-4cb0-4042-9821-7c936f6b81bb	\N	{}
c5433074-e8c6-4797-a25a-c3ec8f36e0b4	uploads	product-1776501901702.webp	\N	2026-04-18 08:45:02.022163+00	2026-04-18 08:45:02.022163+00	2026-04-18 08:45:02.022163+00	{"eTag": "\\"65a79ee040d9fcc5ead8d263d5f5631f\\"", "size": 161170, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:45:02.000Z", "contentLength": 161170, "httpStatusCode": 200}	bbade9b8-e16d-4a8f-9bc7-c31d49e3e943	\N	{}
ce56e141-d376-4e1f-9565-2d27dfc7be57	uploads	product-1776503149126.webp	\N	2026-04-18 09:05:49.41578+00	2026-04-18 09:05:49.41578+00	2026-04-18 09:05:49.41578+00	{"eTag": "\\"6e5fa5c7b3ab77ad15ac7f5525b79abd\\"", "size": 374418, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:05:50.000Z", "contentLength": 374418, "httpStatusCode": 200}	e4cfc83e-eb07-4b42-b11d-f1bb8b78478c	\N	{}
37298aac-c113-4d68-b4fa-ec134ee8e81b	uploads	product-1776501902173.webp	\N	2026-04-18 08:45:02.414776+00	2026-04-18 08:45:02.414776+00	2026-04-18 08:45:02.414776+00	{"eTag": "\\"a74a21acd8d1ee7afc890ee56cf79374\\"", "size": 87022, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:45:03.000Z", "contentLength": 87022, "httpStatusCode": 200}	607d0d26-328e-452e-83af-3f71b7bf2e29	\N	{}
c33c0a60-7135-40a2-b349-70a882083ef1	uploads	product-1776842130582.webp	\N	2026-04-22 07:15:31.199526+00	2026-04-22 07:15:31.199526+00	2026-04-22 07:15:31.199526+00	{"eTag": "\\"865c7324013e1ad0fd94f9b60e679928\\"", "size": 477754, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-22T07:15:32.000Z", "contentLength": 477754, "httpStatusCode": 200}	64668c81-aee7-4d1a-aa02-bf72ed3700b8	\N	{}
f9b47add-379b-4aa6-aa9a-26d6cd5d4b65	uploads	product-1776501902599.webp	\N	2026-04-18 08:45:03.053726+00	2026-04-18 08:45:03.053726+00	2026-04-18 08:45:03.053726+00	{"eTag": "\\"35079a8b1c52151b7789e41766d0f309\\"", "size": 263216, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:45:04.000Z", "contentLength": 263216, "httpStatusCode": 200}	77c9b348-ede6-4341-aeaa-f0f0bab728d7	\N	{}
ab695d6f-af54-44c6-b713-779b2773fda3	uploads	product-1776503149617.webp	\N	2026-04-18 09:05:49.914781+00	2026-04-18 09:05:49.914781+00	2026-04-18 09:05:49.914781+00	{"eTag": "\\"9c8b2c6e0edf5e002f184b34a6fd8c68\\"", "size": 355350, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:05:50.000Z", "contentLength": 355350, "httpStatusCode": 200}	73aefd27-8da7-49cb-924b-ea759ec7f0da	\N	{}
5eb73a1f-fe3e-4fb7-8525-f54faadfad6a	uploads	product-1776501903256.webp	\N	2026-04-18 08:45:03.513772+00	2026-04-18 08:45:03.513772+00	2026-04-18 08:45:03.513772+00	{"eTag": "\\"18ecd5ca0d0e3ff7477a0880f03e6917\\"", "size": 395164, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:45:04.000Z", "contentLength": 395164, "httpStatusCode": 200}	440dd55d-5d04-4d05-b852-8c6b448e1c7c	\N	{}
5521a345-ab5d-43c9-9919-9486127394f3	uploads	product-1777102378213.webp	\N	2026-04-25 07:32:58.473805+00	2026-04-25 07:32:58.473805+00	2026-04-25 07:32:58.473805+00	{"eTag": "\\"a38e6fa5104e04925891164f6d57215a\\"", "size": 317804, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:32:59.000Z", "contentLength": 317804, "httpStatusCode": 200}	80954e3d-77bf-4c38-a451-9871dc1c3b7c	\N	{}
b75ebbda-7c9c-4915-8a79-ee4ddded8426	uploads	product-1776501903708.webp	\N	2026-04-18 08:45:03.991031+00	2026-04-18 08:45:03.991031+00	2026-04-18 08:45:03.991031+00	{"eTag": "\\"784efb5dd9323f3c829b1310bf325603\\"", "size": 363366, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:45:04.000Z", "contentLength": 363366, "httpStatusCode": 200}	3b2fb554-b9e8-4aea-977e-12d354a97bb3	\N	{}
c28d0ac0-2e6a-442e-98db-e5c17aec98da	uploads	product-1776503150142.webp	\N	2026-04-18 09:05:50.395071+00	2026-04-18 09:05:50.395071+00	2026-04-18 09:05:50.395071+00	{"eTag": "\\"ed1253b08ada2e6fa58dfe10147ea493\\"", "size": 336282, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:05:51.000Z", "contentLength": 336282, "httpStatusCode": 200}	9f3b1354-c271-427b-b579-3b95e1e4513b	\N	{}
23973c42-b0bd-43ea-b11c-7487d63c20c0	uploads	product-1776503150588.webp	\N	2026-04-18 09:05:51.109805+00	2026-04-18 09:05:51.109805+00	2026-04-18 09:05:51.109805+00	{"eTag": "\\"c0ccac3b3b2f17ada20967b611ae288d\\"", "size": 319554, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:05:52.000Z", "contentLength": 319554, "httpStatusCode": 200}	dd1af66b-707b-445f-95f3-7aba34757812	\N	{}
deacbab8-f3fd-4a3d-a60c-433e2aac7ace	uploads	product-1776503151297.webp	\N	2026-04-18 09:05:51.55345+00	2026-04-18 09:05:51.55345+00	2026-04-18 09:05:51.55345+00	{"eTag": "\\"9d14b88c540fde0b85acecc43674718e\\"", "size": 279892, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:05:52.000Z", "contentLength": 279892, "httpStatusCode": 200}	c2c340df-fda2-4bfa-addc-a7096a3b300f	\N	{}
bef80d73-0af8-4998-b4a2-a2d57baa364d	uploads	product-1776503151754.webp	\N	2026-04-18 09:05:52.039667+00	2026-04-18 09:05:52.039667+00	2026-04-18 09:05:52.039667+00	{"eTag": "\\"6921f0e049062cf2d15c0e0104c4aadf\\"", "size": 400432, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:05:52.000Z", "contentLength": 400432, "httpStatusCode": 200}	0c2f5918-b9ca-4774-8b3e-05fe29807829	\N	{}
84442e57-bfbc-4203-ae64-043d51989ed5	uploads	product-1776502084947.webp	\N	2026-04-18 08:48:05.852297+00	2026-04-18 08:48:05.852297+00	2026-04-18 08:48:05.852297+00	{"eTag": "\\"3f70938453e2d89a487b42024e52b387\\"", "size": 599590, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:48:06.000Z", "contentLength": 599590, "httpStatusCode": 200}	f4a6c603-5769-48dd-a334-78d598df92c7	\N	{}
703d3217-daf7-4800-89f0-7940b64ee887	uploads	product-1776503245805.webp	\N	2026-04-18 09:07:26.310027+00	2026-04-18 09:07:26.310027+00	2026-04-18 09:07:26.310027+00	{"eTag": "\\"4810886dc3b79b8b905a252790e69740\\"", "size": 378248, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:07:27.000Z", "contentLength": 378248, "httpStatusCode": 200}	de8edc1e-0803-4822-9d7f-1941b8d3c222	\N	{}
60f41db6-e388-40ff-b47d-eb0900adbf2b	uploads	product-1776502086066.webp	\N	2026-04-18 08:48:06.36805+00	2026-04-18 08:48:06.36805+00	2026-04-18 08:48:06.36805+00	{"eTag": "\\"78212fa392ce1f04e2adec2a49ff72cd\\"", "size": 385452, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:48:07.000Z", "contentLength": 385452, "httpStatusCode": 200}	e4502a04-91b6-42f2-8ce2-6fda387a94b7	\N	{}
144db8bd-2691-4dc9-8e2c-39c799f3a9ec	uploads	product-1776502086589.webp	\N	2026-04-18 08:48:06.898321+00	2026-04-18 08:48:06.898321+00	2026-04-18 08:48:06.898321+00	{"eTag": "\\"bb30dd474ed3697b159b91e78a913466\\"", "size": 444886, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:48:07.000Z", "contentLength": 444886, "httpStatusCode": 200}	cec5ed0e-fd57-4dfe-b7d6-359edd7b106e	\N	{}
6a4459d9-e12d-4fc6-8d93-f4e7ce5b2a2e	uploads	product-1776503246476.webp	\N	2026-04-18 09:07:26.739106+00	2026-04-18 09:07:26.739106+00	2026-04-18 09:07:26.739106+00	{"eTag": "\\"6e5fa5c7b3ab77ad15ac7f5525b79abd\\"", "size": 374418, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:07:27.000Z", "contentLength": 374418, "httpStatusCode": 200}	39134ea5-a95e-4771-b745-7c565d260692	\N	{}
e8e661e2-744d-4bf2-a501-ab27f0ed47c3	uploads	product-1776502087117.webp	\N	2026-04-18 08:48:07.647818+00	2026-04-18 08:48:07.647818+00	2026-04-18 08:48:07.647818+00	{"eTag": "\\"f490c35d994354b70f39adea43cbe061\\"", "size": 602152, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:48:08.000Z", "contentLength": 602152, "httpStatusCode": 200}	62d491eb-76e0-4776-8a65-c672f3fb42f5	\N	{}
b853c0ce-794f-4ddc-b31d-597a6a780466	uploads	product-1777101774664.webp	\N	2026-04-25 07:22:55.773103+00	2026-04-25 07:22:55.773103+00	2026-04-25 07:22:55.773103+00	{"eTag": "\\"c35b99373790c0b60e4e7ab3e9e13c42\\"", "size": 439466, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:22:56.000Z", "contentLength": 439466, "httpStatusCode": 200}	22e2400e-4f9b-4711-a75c-81945fe3395e	\N	{}
58130e26-e912-49d3-9782-736380ebf2f4	uploads	product-1776502087845.webp	\N	2026-04-18 08:48:08.778138+00	2026-04-18 08:48:08.778138+00	2026-04-18 08:48:08.778138+00	{"eTag": "\\"c456f49535fcca7f004f9004ef88995e\\"", "size": 468322, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:48:09.000Z", "contentLength": 468322, "httpStatusCode": 200}	cf155264-2fae-4152-8317-c2eb79e4572d	\N	{}
738cdd8e-ec87-410e-8445-4007ba961f2d	uploads	product-1776503246890.webp	\N	2026-04-18 09:07:27.161306+00	2026-04-18 09:07:27.161306+00	2026-04-18 09:07:27.161306+00	{"eTag": "\\"9c8b2c6e0edf5e002f184b34a6fd8c68\\"", "size": 355350, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:07:28.000Z", "contentLength": 355350, "httpStatusCode": 200}	1b060a87-46a4-406b-b2d5-8a59dd3f813a	\N	{}
c1f75603-5317-481f-bf27-a5bac5432d0f	uploads	product-1776502088986.webp	\N	2026-04-18 08:48:09.302125+00	2026-04-18 08:48:09.302125+00	2026-04-18 08:48:09.302125+00	{"eTag": "\\"5a12394972b4a0f8b374dc0423584743\\"", "size": 593830, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:48:10.000Z", "contentLength": 593830, "httpStatusCode": 200}	fdda84c6-6938-4ed3-86f2-8bf9ce85e7a3	\N	{}
20db5832-6414-4416-953e-f2e4db1e9bb4	uploads	product-1776502089501.webp	\N	2026-04-18 08:48:10.257399+00	2026-04-18 08:48:10.257399+00	2026-04-18 08:48:10.257399+00	{"eTag": "\\"1b748002afd934c715e52f4ef9fc72f1\\"", "size": 556212, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:48:11.000Z", "contentLength": 556212, "httpStatusCode": 200}	9cbc328d-239e-4867-a54d-172760e2b107	\N	{}
11a6ebf6-d2a8-4d2d-b886-24926ba8e8ad	uploads	product-1776503247321.webp	\N	2026-04-18 09:07:27.575292+00	2026-04-18 09:07:27.575292+00	2026-04-18 09:07:27.575292+00	{"eTag": "\\"ed1253b08ada2e6fa58dfe10147ea493\\"", "size": 336282, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:07:28.000Z", "contentLength": 336282, "httpStatusCode": 200}	54fc41bd-7b55-43ef-8116-981ffcd01152	\N	{}
44ddd353-14fe-467f-a66b-6e6bb964aa71	uploads	product-1776502090508.webp	\N	2026-04-18 08:48:11.24641+00	2026-04-18 08:48:11.24641+00	2026-04-18 08:48:11.24641+00	{"eTag": "\\"9293cdb666ed5f25dbe47034fa77ff5b\\"", "size": 730236, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:48:12.000Z", "contentLength": 730236, "httpStatusCode": 200}	0d191151-a041-4e0b-a712-ecd5375aabde	\N	{}
5bc87333-98c0-48c6-a4bb-0e3937cb00b5	uploads	product-1776502211035.webp	\N	2026-04-18 08:50:11.751626+00	2026-04-18 08:50:11.751626+00	2026-04-18 08:50:11.751626+00	{"eTag": "\\"c2a1a1a1013a5732c858637cf97464ee\\"", "size": 259940, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:50:12.000Z", "contentLength": 259940, "httpStatusCode": 200}	9c0f5aeb-f8e4-4df6-ac23-fa396a46c972	\N	{}
4dc05e40-de99-41bc-ab44-38165c6a25a5	uploads	product-1776502211958.webp	\N	2026-04-18 08:50:12.488595+00	2026-04-18 08:50:12.488595+00	2026-04-18 08:50:12.488595+00	{"eTag": "\\"404ddace9168857cf34e8cac147f05f8\\"", "size": 332638, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:50:13.000Z", "contentLength": 332638, "httpStatusCode": 200}	3c844179-885a-44a1-b648-c4e6e85fd37e	\N	{}
865afd5c-b4b3-4f72-9baa-88ca56e289f1	uploads	product-1776502212686.webp	\N	2026-04-18 08:50:12.994042+00	2026-04-18 08:50:12.994042+00	2026-04-18 08:50:12.994042+00	{"eTag": "\\"ac687d5c940e0c9f7538df4f32ab5203\\"", "size": 311080, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:50:13.000Z", "contentLength": 311080, "httpStatusCode": 200}	59a8e1d4-ec38-4b6a-a35b-a19856deb4bf	\N	{}
f0c8ed12-d278-4814-8f5b-9427daf2c51f	uploads	product-1776502213178.webp	\N	2026-04-18 08:50:13.658431+00	2026-04-18 08:50:13.658431+00	2026-04-18 08:50:13.658431+00	{"eTag": "\\"552c25e9bb6393b6068af02c1552b545\\"", "size": 208164, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:50:14.000Z", "contentLength": 208164, "httpStatusCode": 200}	9b2976fd-6e51-4104-bda8-f49464a81bf6	\N	{}
715e9414-4d5a-4d52-8ae1-7f8999c5a167	uploads	product-1776502213840.webp	\N	2026-04-18 08:50:14.359629+00	2026-04-18 08:50:14.359629+00	2026-04-18 08:50:14.359629+00	{"eTag": "\\"4d3b333a1cde23f3f9499b76fa3ec0ec\\"", "size": 308838, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:50:15.000Z", "contentLength": 308838, "httpStatusCode": 200}	c19317b1-fa79-4cb8-944b-05b25a6ab03a	\N	{}
7a65c37f-53aa-428e-8824-21dafc64c80d	uploads	product-1777103098234.webp	\N	2026-04-25 07:44:58.556181+00	2026-04-25 07:44:58.556181+00	2026-04-25 07:44:58.556181+00	{"eTag": "\\"d00a1a0bc1425af6f86b937371d77f2a\\"", "size": 362992, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:44:59.000Z", "contentLength": 362992, "httpStatusCode": 200}	dcd8c0dc-1a2c-4c40-8928-1084d53f9442	\N	{}
464fb039-a850-44d9-9a68-cb66f6aa018b	uploads	product-1776502214512.webp	\N	2026-04-18 08:50:14.790365+00	2026-04-18 08:50:14.790365+00	2026-04-18 08:50:14.790365+00	{"eTag": "\\"bad981d12b201b705747c4fdb39c56b7\\"", "size": 98098, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:50:15.000Z", "contentLength": 98098, "httpStatusCode": 200}	8a82b9bd-84a7-429d-b1c4-04fc62c477d4	\N	{}
97abd6b4-b707-4460-85af-ccd7f9fc8298	uploads	product-1776503247741.webp	\N	2026-04-18 09:07:28.000159+00	2026-04-18 09:07:28.000159+00	2026-04-18 09:07:28.000159+00	{"eTag": "\\"c0ccac3b3b2f17ada20967b611ae288d\\"", "size": 319554, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:07:28.000Z", "contentLength": 319554, "httpStatusCode": 200}	27b2d156-9d1c-4272-9410-0f159cc59227	\N	{}
759d9342-7c67-49b4-bdeb-c4b254ae2407	uploads	product-1776502214964.webp	\N	2026-04-18 08:50:15.245073+00	2026-04-18 08:50:15.245073+00	2026-04-18 08:50:15.245073+00	{"eTag": "\\"dd43b93e106333698f6b20dcd2c8fec7\\"", "size": 222434, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:50:16.000Z", "contentLength": 222434, "httpStatusCode": 200}	f86e55d8-ab48-4ba0-a601-e27403a33718	\N	{}
74d15b5f-225a-46ec-b43d-9f1c11d29e03	uploads	product-1777101776025.webp	\N	2026-04-25 07:22:56.286947+00	2026-04-25 07:22:56.286947+00	2026-04-25 07:22:56.286947+00	{"eTag": "\\"3b5bd851a84a210b569e92dea05b1b25\\"", "size": 396760, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:22:57.000Z", "contentLength": 396760, "httpStatusCode": 200}	9d8882ae-3a9b-41b7-9011-bf689753893e	\N	{}
042fa259-d9c7-4182-85c4-1c12a373b26a	uploads	product-1776502424193.webp	\N	2026-04-18 08:53:45.200712+00	2026-04-18 08:53:45.200712+00	2026-04-18 08:53:45.200712+00	{"eTag": "\\"452c91b4096186a76092b56870da8190\\"", "size": 327634, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:53:46.000Z", "contentLength": 327634, "httpStatusCode": 200}	7eb860ae-9a5f-4164-b598-2a21642e8d9c	\N	{}
616571a8-a1e8-4af9-9588-832cab97bc84	uploads	product-1776503248156.webp	\N	2026-04-18 09:07:28.40482+00	2026-04-18 09:07:28.40482+00	2026-04-18 09:07:28.40482+00	{"eTag": "\\"9d14b88c540fde0b85acecc43674718e\\"", "size": 279892, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:07:29.000Z", "contentLength": 279892, "httpStatusCode": 200}	0f01fcf6-53f3-4d66-8a42-d89c6d2fbcb1	\N	{}
7b6e154f-ce67-4519-a68b-539eccfc7146	uploads	product-1776502425405.webp	\N	2026-04-18 08:53:45.722089+00	2026-04-18 08:53:45.722089+00	2026-04-18 08:53:45.722089+00	{"eTag": "\\"346ed58c7f0834feaf1d447a548cea4c\\"", "size": 324284, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:53:46.000Z", "contentLength": 324284, "httpStatusCode": 200}	b385b25f-9a42-421e-8458-7acb23fa9fdc	\N	{}
952c17bf-ba1e-4a9b-acb8-69f754d06ce9	uploads	product-1776502425917.webp	\N	2026-04-18 08:53:46.221343+00	2026-04-18 08:53:46.221343+00	2026-04-18 08:53:46.221343+00	{"eTag": "\\"0a703b362f643c6678df51a1ee13b186\\"", "size": 319084, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:53:47.000Z", "contentLength": 319084, "httpStatusCode": 200}	6e25edfa-3638-4953-a87d-953d3629496f	\N	{}
95f455de-e539-4cfe-b577-6c33d70f6bf4	uploads	product-1776503248575.webp	\N	2026-04-18 09:07:28.832066+00	2026-04-18 09:07:28.832066+00	2026-04-18 09:07:28.832066+00	{"eTag": "\\"6921f0e049062cf2d15c0e0104c4aadf\\"", "size": 400432, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:07:29.000Z", "contentLength": 400432, "httpStatusCode": 200}	4a48999e-1a99-4cb6-ad4d-ad19f558f90c	\N	{}
b93470ca-8675-47aa-b7f6-92681894885b	uploads	product-1776502426441.webp	\N	2026-04-18 08:53:47.984978+00	2026-04-18 08:53:47.984978+00	2026-04-18 08:53:47.984978+00	{"eTag": "\\"cf3d5d086c6a5b0c123da3f411db1a65\\"", "size": 372066, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:53:48.000Z", "contentLength": 372066, "httpStatusCode": 200}	577722c4-5d86-43d7-83dd-49c1579106ea	\N	{}
5e1f99cf-2eae-414f-b177-eb92825339b9	uploads	product-1776502428183.webp	\N	2026-04-18 08:53:48.4774+00	2026-04-18 08:53:48.4774+00	2026-04-18 08:53:48.4774+00	{"eTag": "\\"a1ade605ad918fa5ce219dc54b78c9aa\\"", "size": 294946, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:53:49.000Z", "contentLength": 294946, "httpStatusCode": 200}	14964485-76d2-4afe-8c77-21b63b3262d5	\N	{}
2a3ed410-df36-48b1-8444-9dfd53fea4ee	uploads	product-1776502428652.webp	\N	2026-04-18 08:53:48.948549+00	2026-04-18 08:53:48.948549+00	2026-04-18 08:53:48.948549+00	{"eTag": "\\"be7056f41d18fcb380c3247556182879\\"", "size": 292026, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:53:49.000Z", "contentLength": 292026, "httpStatusCode": 200}	b3790f9b-de5b-4f46-826d-47475be66c24	\N	{}
9eb66122-c98a-452e-ba73-751a6ee10c4d	uploads	product-1776502429204.webp	\N	2026-04-18 08:53:49.528605+00	2026-04-18 08:53:49.528605+00	2026-04-18 08:53:49.528605+00	{"eTag": "\\"72a742bbb4ebc995a24dd1e822e0f0ad\\"", "size": 456924, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:53:50.000Z", "contentLength": 456924, "httpStatusCode": 200}	ec0d9721-4c00-4a42-ad28-3dd467fd41bc	\N	{}
41c8a9ac-9159-49d7-8ffc-bdafea223e8e	uploads	product-1776502429750.webp	\N	2026-04-18 08:53:50.030579+00	2026-04-18 08:53:50.030579+00	2026-04-18 08:53:50.030579+00	{"eTag": "\\"7a5f721b43d8962cddd1f1862c58cfdf\\"", "size": 249558, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:53:50.000Z", "contentLength": 249558, "httpStatusCode": 200}	c0e1304b-a68d-4323-953c-ea32c4571376	\N	{}
c0f5209b-2971-4e52-bbf3-34c119e36708	uploads	product-1776502533376.webp	\N	2026-04-18 08:55:34.02907+00	2026-04-18 08:55:34.02907+00	2026-04-18 08:55:34.02907+00	{"eTag": "\\"17c8fe711756133aca4ec19dfc343a1d\\"", "size": 447476, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:55:34.000Z", "contentLength": 447476, "httpStatusCode": 200}	9a12384c-0ef3-4056-8176-0bfb158d9285	\N	{}
e9508813-1295-47f6-a09e-bc54adee9c0f	uploads	product-1777101776484.webp	\N	2026-04-25 07:22:56.794786+00	2026-04-25 07:22:56.794786+00	2026-04-25 07:22:56.794786+00	{"eTag": "\\"206ea8c49446ab0aeb8f660385c0d776\\"", "size": 288396, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:22:57.000Z", "contentLength": 288396, "httpStatusCode": 200}	b0b1c422-6e79-45b8-8749-e48dcb119d4f	\N	{}
453225f1-3842-481a-90dd-4e6b78bdf456	uploads	product-1776502534265.webp	\N	2026-04-18 08:55:34.521561+00	2026-04-18 08:55:34.521561+00	2026-04-18 08:55:34.521561+00	{"eTag": "\\"a2483c5da14b83097f3d02de54dba848\\"", "size": 419146, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:55:35.000Z", "contentLength": 419146, "httpStatusCode": 200}	bd73c8c9-c2c1-41fe-b24c-cdb88882cb34	\N	{}
77b515e6-6354-4716-896b-3acbec05c0ef	uploads	product-1776502534777.webp	\N	2026-04-18 08:55:35.029981+00	2026-04-18 08:55:35.029981+00	2026-04-18 08:55:35.029981+00	{"eTag": "\\"6acd66d8ebb83f260ef55144536340a4\\"", "size": 500930, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:55:35.000Z", "contentLength": 500930, "httpStatusCode": 200}	b419fd43-c4b7-4352-b8b1-5d1048fbe490	\N	{}
f8361c30-8933-42c1-a774-d1c4f899faf0	uploads	product-1777101777007.webp	\N	2026-04-25 07:22:57.281121+00	2026-04-25 07:22:57.281121+00	2026-04-25 07:22:57.281121+00	{"eTag": "\\"4e5df1c7d363373c56f913ac5b90c77c\\"", "size": 334066, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:22:58.000Z", "contentLength": 334066, "httpStatusCode": 200}	9cd96718-b768-4a7e-91e1-d1794847c09d	\N	{}
047a66c4-402a-42cb-b564-f4a4abf89c4e	uploads	product-1776502535258.webp	\N	2026-04-18 08:55:35.522693+00	2026-04-18 08:55:35.522693+00	2026-04-18 08:55:35.522693+00	{"eTag": "\\"24c20346662bf481bba74f60b1f6c85c\\"", "size": 509216, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:55:36.000Z", "contentLength": 509216, "httpStatusCode": 200}	433f64c7-940f-427b-b5c0-370842b72b6a	\N	{}
6183e7df-063b-4883-90bf-52da62e0e396	uploads	product-1776502535720.webp	\N	2026-04-18 08:55:35.992937+00	2026-04-18 08:55:35.992937+00	2026-04-18 08:55:35.992937+00	{"eTag": "\\"eedf31f9c626173424aee0c8fd7f5ce0\\"", "size": 312288, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:55:36.000Z", "contentLength": 312288, "httpStatusCode": 200}	b82511a8-a100-45ac-af65-e3075fba661e	\N	{}
a2b31e38-13f8-4c5b-ac5f-1c0d194cc4d9	uploads	product-1776503498474.webp	\N	2026-04-18 09:11:38.73228+00	2026-04-18 09:11:38.73228+00	2026-04-18 09:11:38.73228+00	{"eTag": "\\"c6d811ec0ad8842ace1c4b3e0ac2f09a\\"", "size": 422870, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:11:39.000Z", "contentLength": 422870, "httpStatusCode": 200}	13bb4aa6-5b69-4da0-ae20-39f72ccd43c6	\N	{}
6ea74780-185c-411d-9899-57e9e5d55bd3	uploads	product-1776502536269.webp	\N	2026-04-18 08:55:36.563368+00	2026-04-18 08:55:36.563368+00	2026-04-18 08:55:36.563368+00	{"eTag": "\\"5db7af1dcc1e53bb41a52d140267d365\\"", "size": 518350, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:55:37.000Z", "contentLength": 518350, "httpStatusCode": 200}	a2a60e89-dcec-429a-a652-4a98332ed1df	\N	{}
d9966197-417c-40df-811f-da687fc059cd	uploads	product-1776502536777.webp	\N	2026-04-18 08:55:37.027411+00	2026-04-18 08:55:37.027411+00	2026-04-18 08:55:37.027411+00	{"eTag": "\\"904362810eafb62e5d33a1390f43a62d\\"", "size": 472230, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:55:37.000Z", "contentLength": 472230, "httpStatusCode": 200}	eac55333-7665-4ae5-98ce-08c5414557f1	\N	{}
1a7edae3-bd67-4c2b-ac46-386e9dac4150	uploads	product-1776503498951.webp	\N	2026-04-18 09:11:39.233953+00	2026-04-18 09:11:39.233953+00	2026-04-18 09:11:39.233953+00	{"eTag": "\\"e95593ff116381235896ce56ebffc863\\"", "size": 364782, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:11:40.000Z", "contentLength": 364782, "httpStatusCode": 200}	6b704ec0-b0c6-434d-9aef-a8c277571a59	\N	{}
9a1b19ec-faf4-40c5-a060-8d27e33df400	uploads	product-1776502674886.webp	\N	2026-04-18 08:57:55.473233+00	2026-04-18 08:57:55.473233+00	2026-04-18 08:57:55.473233+00	{"eTag": "\\"715102f73619ab4788ca813c53f450c1\\"", "size": 352084, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:57:56.000Z", "contentLength": 352084, "httpStatusCode": 200}	ad07ad71-0f9a-434a-8b54-49996a2d1b0e	\N	{}
f218795e-8177-4a82-bdd4-c99122422cdf	uploads	product-1776502675671.webp	\N	2026-04-18 08:57:55.92166+00	2026-04-18 08:57:55.92166+00	2026-04-18 08:57:55.92166+00	{"eTag": "\\"ccec93675da0fd1f0a16efa6abe24662\\"", "size": 282484, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:57:56.000Z", "contentLength": 282484, "httpStatusCode": 200}	490dedc6-3593-450b-97be-fc56a53ff5ed	\N	{}
62e98c39-4053-47ab-a20e-46333b90541c	uploads	product-1776502676156.webp	\N	2026-04-18 08:57:56.408228+00	2026-04-18 08:57:56.408228+00	2026-04-18 08:57:56.408228+00	{"eTag": "\\"66377751b530a49225916c6fbbc28d68\\"", "size": 337150, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:57:57.000Z", "contentLength": 337150, "httpStatusCode": 200}	7c530272-19d4-4475-b18b-4e8dd0d3fa4a	\N	{}
f0be4e9a-af58-4e70-8114-aa07dc3c98a7	uploads	product-1776502676624.webp	\N	2026-04-18 08:57:56.883902+00	2026-04-18 08:57:56.883902+00	2026-04-18 08:57:56.883902+00	{"eTag": "\\"4bf7d66659f5bb7c7456bc2baf9af8ed\\"", "size": 343062, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:57:57.000Z", "contentLength": 343062, "httpStatusCode": 200}	78f86043-7808-4abc-9f87-d2d01bb1bda5	\N	{}
19b72972-aa07-4577-9d19-9d1825e24622	uploads	product-1776502677075.webp	\N	2026-04-18 08:57:57.350383+00	2026-04-18 08:57:57.350383+00	2026-04-18 08:57:57.350383+00	{"eTag": "\\"6918c7a3903090153de33ae5bbd7edf4\\"", "size": 343958, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:57:58.000Z", "contentLength": 343958, "httpStatusCode": 200}	545df8f5-d9ed-4622-9caa-74e3001a6f40	\N	{}
a31ddb50-4d41-40e8-a43a-95a226e248c5	uploads	the-indigo-batik-story--1776666815691.webp	\N	2026-04-20 06:33:36.51004+00	2026-04-20 06:33:36.51004+00	2026-04-20 06:33:36.51004+00	{"eTag": "\\"981af1711fc250b1114dd7bf3b3fb342\\"", "size": 190824, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T06:33:37.000Z", "contentLength": 190824, "httpStatusCode": 200}	29ad4c0e-fe31-4e42-aaa5-7570fd5f1492	\N	{}
fdca24a5-1a4c-4f8f-8445-a7aa0bffe68d	uploads	the-indigo-batik-story--1776666826058.webp	\N	2026-04-20 06:33:46.846298+00	2026-04-20 06:33:46.846298+00	2026-04-20 06:33:46.846298+00	{"eTag": "\\"2e74e0a9ab9e6f425fddc71c6ee399b6\\"", "size": 290146, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T06:33:47.000Z", "contentLength": 290146, "httpStatusCode": 200}	6dc2bdb1-b5f5-4f2e-9d60-eaadc8227273	\N	{}
34cf3ccf-431e-4c90-afab-20e6b5c92d36	uploads	product-1776502677549.webp	\N	2026-04-18 08:57:57.842985+00	2026-04-18 08:57:57.842985+00	2026-04-18 08:57:57.842985+00	{"eTag": "\\"eaf14ceac1e0a5d7cff1c8862c50c643\\"", "size": 314682, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:57:58.000Z", "contentLength": 314682, "httpStatusCode": 200}	4ff08797-e000-4e0c-be0b-307975cc9e99	\N	{}
0d72dfe2-6349-4486-aa81-679d183de9ca	uploads	product-1776503499470.webp	\N	2026-04-18 09:11:39.782642+00	2026-04-18 09:11:39.782642+00	2026-04-18 09:11:39.782642+00	{"eTag": "\\"a61f277c311f6400a99aa757b875cec3\\"", "size": 434028, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:11:40.000Z", "contentLength": 434028, "httpStatusCode": 200}	872ba4d9-7adc-4f59-a0bb-5d568a01d528	\N	{}
b1baee50-36ff-4fe4-9211-06ce18bcebe3	uploads	product-1776502678007.webp	\N	2026-04-18 08:57:58.258685+00	2026-04-18 08:57:58.258685+00	2026-04-18 08:57:58.258685+00	{"eTag": "\\"9ebecd6b62579e40780bbccd5abb8b57\\"", "size": 127944, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T08:57:59.000Z", "contentLength": 127944, "httpStatusCode": 200}	a8fc3b9e-a6e4-43fd-9f92-6ac4f1dbb1bf	\N	{}
6c698215-3319-4de7-97e1-c18312f923cb	uploads	product-1777103098877.webp	\N	2026-04-25 07:44:59.415403+00	2026-04-25 07:44:59.415403+00	2026-04-25 07:44:59.415403+00	{"eTag": "\\"2b3cc01eff8667f30725dbc67ab50d76\\"", "size": 374644, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:00.000Z", "contentLength": 374644, "httpStatusCode": 200}	feee5744-dd02-403a-92cf-2edc8d8968e3	\N	{}
1a75aa61-409c-4fa7-8657-ad86c72df6f5	uploads	product-1776502951977.webp	\N	2026-04-18 09:02:32.943178+00	2026-04-18 09:02:32.943178+00	2026-04-18 09:02:32.943178+00	{"eTag": "\\"25cd4f9eb34eb563bd5d1533a7222bd1\\"", "size": 356918, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:02:33.000Z", "contentLength": 356918, "httpStatusCode": 200}	3c7b3a79-7dd3-407b-a8b8-140093fed237	\N	{}
bbd949bf-77df-4feb-bcf7-887936303fbb	uploads	product-1776503500002.webp	\N	2026-04-18 09:11:40.260903+00	2026-04-18 09:11:40.260903+00	2026-04-18 09:11:40.260903+00	{"eTag": "\\"1323639b53a3d777623dbacbae376059\\"", "size": 379462, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:11:41.000Z", "contentLength": 379462, "httpStatusCode": 200}	9c516be8-a750-4880-b68c-42acaae2ebde	\N	{}
39cbf609-54b7-44c8-bb96-b93ce2187eb3	uploads	product-1776502953150.webp	\N	2026-04-18 09:02:33.485898+00	2026-04-18 09:02:33.485898+00	2026-04-18 09:02:33.485898+00	{"eTag": "\\"a38e6fa5104e04925891164f6d57215a\\"", "size": 317804, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:02:34.000Z", "contentLength": 317804, "httpStatusCode": 200}	8b047bd8-ea46-42c0-a6b8-1ea21a996672	\N	{}
556cc589-e679-453d-8caf-854dd988bf99	uploads	product-1777101777607.webp	\N	2026-04-25 07:22:57.936024+00	2026-04-25 07:22:57.936024+00	2026-04-25 07:22:57.936024+00	{"eTag": "\\"876d74879f2bbcd8362462bb98ad28e2\\"", "size": 429972, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:22:58.000Z", "contentLength": 429972, "httpStatusCode": 200}	f18c288d-098e-41aa-b943-26314d2c980a	\N	{}
d4b1ee67-6252-44bd-a09d-fd5e0339d766	uploads	product-1776502953717.webp	\N	2026-04-18 09:02:34.052345+00	2026-04-18 09:02:34.052345+00	2026-04-18 09:02:34.052345+00	{"eTag": "\\"a5d028bfb3947b6d89d0749ac78ca09f\\"", "size": 373366, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:02:34.000Z", "contentLength": 373366, "httpStatusCode": 200}	39b73570-9230-4f2d-b909-1cf8b09c7271	\N	{}
7766fb15-55c6-4eb9-9c00-2c1804e2da61	uploads	product-1776503500469.webp	\N	2026-04-18 09:11:40.714046+00	2026-04-18 09:11:40.714046+00	2026-04-18 09:11:40.714046+00	{"eTag": "\\"ec3f1ecf58941b5788e194fb510e7449\\"", "size": 351402, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:11:41.000Z", "contentLength": 351402, "httpStatusCode": 200}	fe11387a-8ce6-4044-b344-9bb7e271e0d2	\N	{}
f6018fd8-bc6e-4654-9467-174ae9be3795	uploads	product-1776502954268.webp	\N	2026-04-18 09:02:34.584501+00	2026-04-18 09:02:34.584501+00	2026-04-18 09:02:34.584501+00	{"eTag": "\\"d4695efe7b5b366cb0e7caa7dcf9ecd9\\"", "size": 390158, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:02:35.000Z", "contentLength": 390158, "httpStatusCode": 200}	6f30a6aa-f90e-4753-a778-6dfd9823c753	\N	{}
b1600a30-b322-4429-a0a9-9827c6cbcf6a	uploads	product-1776502954789.webp	\N	2026-04-18 09:02:35.085616+00	2026-04-18 09:02:35.085616+00	2026-04-18 09:02:35.085616+00	{"eTag": "\\"23b9c0837d0c9d3b9b0b2eef9c7cf484\\"", "size": 335026, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:02:36.000Z", "contentLength": 335026, "httpStatusCode": 200}	8f89bac8-4291-4f5c-9706-b857aac1ea93	\N	{}
94823b18-be18-4aed-8887-ddce2c075dec	uploads	product-1776502955290.webp	\N	2026-04-18 09:02:35.577006+00	2026-04-18 09:02:35.577006+00	2026-04-18 09:02:35.577006+00	{"eTag": "\\"48401b4c0e24495892ece0fc09199f00\\"", "size": 272738, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:02:36.000Z", "contentLength": 272738, "httpStatusCode": 200}	bfcddb80-cd6f-4b71-bccb-dbdc9d353e10	\N	{}
da98b166-146e-46e9-b278-2a5985250662	uploads	product-1776516392054.png	\N	2026-04-18 12:46:32.892942+00	2026-04-18 12:46:32.892942+00	2026-04-18 12:46:32.892942+00	{"eTag": "\\"b5e3f60f22af3b84341754dfe1f43b1a\\"", "size": 1608624, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T12:46:33.000Z", "contentLength": 1608624, "httpStatusCode": 200}	f581d74f-66a2-4d67-986e-5ec1034a18f1	\N	{}
1e84e4cc-ab8e-450d-8661-a48f4732dbce	uploads	product-1776502955766.webp	\N	2026-04-18 09:02:36.052842+00	2026-04-18 09:02:36.052842+00	2026-04-18 09:02:36.052842+00	{"eTag": "\\"15394111bc1d77f241e3669ffb7cda6b\\"", "size": 259788, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T09:02:36.000Z", "contentLength": 259788, "httpStatusCode": 200}	770a262e-ce7b-48b5-96bf-844d7fb47c36	\N	{}
dce00389-736f-4049-9a9c-4ef455d67b40	uploads	product-1776539017705.jpg	\N	2026-04-18 19:03:38.629173+00	2026-04-18 19:03:38.629173+00	2026-04-18 19:03:38.629173+00	{"eTag": "\\"9c1a7c244325c8fbaca9b7aecac6e3ec\\"", "size": 565093, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T19:03:39.000Z", "contentLength": 565093, "httpStatusCode": 200}	3cf3559d-b399-4304-a6fe-ef85e2e110a9	\N	{}
429b54c6-cbbd-4c3b-afeb-02744ec9bebc	uploads	product-1776539456332.jpg	\N	2026-04-18 19:10:57.254355+00	2026-04-18 19:10:57.254355+00	2026-04-18 19:10:57.254355+00	{"eTag": "\\"7cc323a0e17f931094bbd41debc1c6da\\"", "size": 864364, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T19:10:58.000Z", "contentLength": 864364, "httpStatusCode": 200}	2a071144-4ce0-4fa5-abc7-38d9f5aa1049	\N	{}
8b5790a7-e5bf-4671-913f-ec009eefe639	uploads	product-1776539708312.jpg	\N	2026-04-18 19:15:08.933726+00	2026-04-18 19:15:08.933726+00	2026-04-18 19:15:08.933726+00	{"eTag": "\\"c9f416748d326536db6da41445923dda\\"", "size": 138816, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T19:15:09.000Z", "contentLength": 138816, "httpStatusCode": 200}	a150ca21-eb9c-4b0e-a033-e0465dea82d2	\N	{}
b8a303dd-c6c5-45a3-a7c9-401a79d4c6bc	uploads	product-1777101778183.webp	\N	2026-04-25 07:22:58.729365+00	2026-04-25 07:22:58.729365+00	2026-04-25 07:22:58.729365+00	{"eTag": "\\"63c16222d7ccc69c2c553721271a32e5\\"", "size": 543828, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:22:59.000Z", "contentLength": 543828, "httpStatusCode": 200}	2980d15e-c138-417d-bb48-79be21a52daf	\N	{}
fe459198-7168-48cd-bddf-157961a9b32b	uploads	product-1776539984077.jpg	\N	2026-04-18 19:19:45.258963+00	2026-04-18 19:19:45.258963+00	2026-04-18 19:19:45.258963+00	{"eTag": "\\"ddc47c87ad2c5dbaec3757f03fde2596\\"", "size": 1809443, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T19:19:46.000Z", "contentLength": 1809443, "httpStatusCode": 200}	33bb53fa-fe70-42c3-99be-d32f3f9842ca	\N	{}
9f92908c-6326-44a7-a54b-cb97550ae637	uploads	product-1777103099577.webp	\N	2026-04-25 07:44:59.856405+00	2026-04-25 07:44:59.856405+00	2026-04-25 07:44:59.856405+00	{"eTag": "\\"9faa520ae286e6218d5aaea5531b6dee\\"", "size": 386436, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:00.000Z", "contentLength": 386436, "httpStatusCode": 200}	b8c42a6d-df9e-4acc-b405-0628245dfc37	\N	{}
a3444f4c-c621-4929-bc2b-4684a0c51064	uploads	product-1776540538073.jpg	\N	2026-04-18 19:28:58.98023+00	2026-04-18 19:28:58.98023+00	2026-04-18 19:28:58.98023+00	{"eTag": "\\"7cc323a0e17f931094bbd41debc1c6da\\"", "size": 864364, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T19:28:59.000Z", "contentLength": 864364, "httpStatusCode": 200}	458de74f-654a-4402-9fa9-114f115b429f	\N	{}
a1c3c926-e495-476f-aaa0-c14ee5908b91	uploads	product-1777101778927.webp	\N	2026-04-25 07:22:59.224008+00	2026-04-25 07:22:59.224008+00	2026-04-25 07:22:59.224008+00	{"eTag": "\\"b96133fd574568dd054133493188ce69\\"", "size": 379734, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:23:00.000Z", "contentLength": 379734, "httpStatusCode": 200}	97ec8fef-30a8-4940-8357-167e14c8ff07	\N	{}
a632d454-c7fe-46b1-bc65-339654cf47ed	uploads	product-1777101779430.webp	\N	2026-04-25 07:22:59.913576+00	2026-04-25 07:22:59.913576+00	2026-04-25 07:22:59.913576+00	{"eTag": "\\"3a6a11af7b0e53b43b61d94097d8b63b\\"", "size": 403158, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:23:00.000Z", "contentLength": 403158, "httpStatusCode": 200}	a1ff4054-4624-4c59-b90b-0924e400af70	\N	{}
cdff4e06-6d26-48cd-9986-49e226cdbd92	uploads	product-1777103099992.webp	\N	2026-04-25 07:45:00.244936+00	2026-04-25 07:45:00.244936+00	2026-04-25 07:45:00.244936+00	{"eTag": "\\"2254eef52f53a95eb1757490b90aa032\\"", "size": 244022, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:01.000Z", "contentLength": 244022, "httpStatusCode": 200}	6880b098-f513-48be-a5bc-f5499577dc99	\N	{}
c3c74ca7-2abb-4135-b90e-0929d52ae589	uploads	product-1777101972579.webp	\N	2026-04-25 07:26:13.274628+00	2026-04-25 07:26:13.274628+00	2026-04-25 07:26:13.274628+00	{"eTag": "\\"c6d811ec0ad8842ace1c4b3e0ac2f09a\\"", "size": 422870, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:26:14.000Z", "contentLength": 422870, "httpStatusCode": 200}	2dba0665-f14f-4bcc-b08f-c3fe6a06deae	\N	{}
6f2eb8b5-ab7d-4b8a-bcc6-ee8c66f95d47	uploads	product-1777101973492.webp	\N	2026-04-25 07:26:13.775845+00	2026-04-25 07:26:13.775845+00	2026-04-25 07:26:13.775845+00	{"eTag": "\\"e95593ff116381235896ce56ebffc863\\"", "size": 364782, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:26:14.000Z", "contentLength": 364782, "httpStatusCode": 200}	38fdeaad-b28a-4c4d-8a8a-867a205c1eb1	\N	{}
9c541e0e-18d9-40fa-b6ea-2cc5fb8d4ce3	uploads	product-1777103100487.webp	\N	2026-04-25 07:45:00.807312+00	2026-04-25 07:45:00.807312+00	2026-04-25 07:45:00.807312+00	{"eTag": "\\"156519a620c22c059abe501beb7fb0d6\\"", "size": 328090, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:01.000Z", "contentLength": 328090, "httpStatusCode": 200}	9560a8d0-5e9f-42b0-9bb4-db8965515c45	\N	{}
4169b454-2062-479a-bd66-ea1e67475b38	uploads	product-1777101974004.webp	\N	2026-04-25 07:26:14.831001+00	2026-04-25 07:26:14.831001+00	2026-04-25 07:26:14.831001+00	{"eTag": "\\"a61f277c311f6400a99aa757b875cec3\\"", "size": 434028, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:26:15.000Z", "contentLength": 434028, "httpStatusCode": 200}	b6c57728-cf22-48bd-a93a-aaaf45dba453	\N	{}
3f31df7a-b186-4125-bbbd-4505b6992f23	uploads	product-1777101975038.webp	\N	2026-04-25 07:26:15.38885+00	2026-04-25 07:26:15.38885+00	2026-04-25 07:26:15.38885+00	{"eTag": "\\"1323639b53a3d777623dbacbae376059\\"", "size": 379462, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:26:16.000Z", "contentLength": 379462, "httpStatusCode": 200}	3cf70944-adca-4273-a81a-80772471270d	\N	{}
390870e1-3bfc-4b42-b5fa-93eecf660f61	uploads	product-1777101975558.webp	\N	2026-04-25 07:26:16.163986+00	2026-04-25 07:26:16.163986+00	2026-04-25 07:26:16.163986+00	{"eTag": "\\"ec3f1ecf58941b5788e194fb510e7449\\"", "size": 351402, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:26:17.000Z", "contentLength": 351402, "httpStatusCode": 200}	c18b3881-c312-46b8-a8da-f5d6d4359ec0	\N	{}
1569eea5-d3ef-4113-8d48-983450d1671c	uploads	product-1777101976357.webp	\N	2026-04-25 07:26:16.679709+00	2026-04-25 07:26:16.679709+00	2026-04-25 07:26:16.679709+00	{"eTag": "\\"05d2e0f7c26827fee18d86318bb8c905\\"", "size": 473706, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:26:17.000Z", "contentLength": 473706, "httpStatusCode": 200}	188a0f8d-a563-4ef4-8b41-dcc66357e2d2	\N	{}
b9a64a8d-a8e4-49a8-99ea-48b88e38b135	uploads	product-1777101976851.webp	\N	2026-04-25 07:26:17.134777+00	2026-04-25 07:26:17.134777+00	2026-04-25 07:26:17.134777+00	{"eTag": "\\"2e74e0a9ab9e6f425fddc71c6ee399b6\\"", "size": 290146, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:26:18.000Z", "contentLength": 290146, "httpStatusCode": 200}	96914753-6842-4cf4-80c2-b97c428e8283	\N	{}
bb7426c9-11ae-4345-816f-838725185fb7	uploads	product-1777103141272.webp	\N	2026-04-25 07:45:41.610994+00	2026-04-25 07:45:41.610994+00	2026-04-25 07:45:41.610994+00	{"eTag": "\\"3f70938453e2d89a487b42024e52b387\\"", "size": 599590, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:42.000Z", "contentLength": 599590, "httpStatusCode": 200}	231ea69e-5541-4e20-b087-ba99e14d9fe1	\N	{}
135e0ce9-bc00-456e-8970-8517617d2e1a	uploads	product-1777101977271.webp	\N	2026-04-25 07:26:17.567759+00	2026-04-25 07:26:17.567759+00	2026-04-25 07:26:17.567759+00	{"eTag": "\\"981af1711fc250b1114dd7bf3b3fb342\\"", "size": 190824, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:26:18.000Z", "contentLength": 190824, "httpStatusCode": 200}	18607591-5753-4f3d-8719-58d6656b74c4	\N	{}
67064323-ba27-4cf7-a891-8d180c13f860	uploads	product-1777102117164.webp	\N	2026-04-25 07:28:38.21231+00	2026-04-25 07:28:38.21231+00	2026-04-25 07:28:38.21231+00	{"eTag": "\\"4810886dc3b79b8b905a252790e69740\\"", "size": 378248, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:39.000Z", "contentLength": 378248, "httpStatusCode": 200}	a962e264-ea7f-44d2-864a-16bf3e4c851b	\N	{}
e5c772a9-0066-4ede-b138-1f03fc69e1eb	uploads	product-1777103141793.webp	\N	2026-04-25 07:45:42.066637+00	2026-04-25 07:45:42.066637+00	2026-04-25 07:45:42.066637+00	{"eTag": "\\"78212fa392ce1f04e2adec2a49ff72cd\\"", "size": 385452, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:43.000Z", "contentLength": 385452, "httpStatusCode": 200}	435866c0-48ed-4612-a95a-b404c9ba2d20	\N	{}
58fbacc8-e884-4c0f-b647-3b401ee0ef5f	uploads	product-1777102118391.webp	\N	2026-04-25 07:28:39.112025+00	2026-04-25 07:28:39.112025+00	2026-04-25 07:28:39.112025+00	{"eTag": "\\"6e5fa5c7b3ab77ad15ac7f5525b79abd\\"", "size": 374418, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:40.000Z", "contentLength": 374418, "httpStatusCode": 200}	b22492f3-18ce-4168-b96b-4b3d8fa2a446	\N	{}
19c8df1a-a88f-4438-9744-959b67a3e471	uploads	product-1777103142300.webp	\N	2026-04-25 07:45:42.577671+00	2026-04-25 07:45:42.577671+00	2026-04-25 07:45:42.577671+00	{"eTag": "\\"bb30dd474ed3697b159b91e78a913466\\"", "size": 444886, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:43.000Z", "contentLength": 444886, "httpStatusCode": 200}	4c4e432b-5549-40f4-946f-ade332ad3209	\N	{}
e33eca84-746f-49f1-9ee7-d518a8f08241	uploads	product-1777102119264.webp	\N	2026-04-25 07:28:39.626427+00	2026-04-25 07:28:39.626427+00	2026-04-25 07:28:39.626427+00	{"eTag": "\\"9c8b2c6e0edf5e002f184b34a6fd8c68\\"", "size": 355350, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:40.000Z", "contentLength": 355350, "httpStatusCode": 200}	4e1e035f-a401-49d1-a8c2-6efd1ebd63fe	\N	{}
ecc6a9e2-76ea-411d-8122-0ea0ddf95db5	uploads	product-1777102121602.webp	\N	2026-04-25 07:28:41.864864+00	2026-04-25 07:28:41.864864+00	2026-04-25 07:28:41.864864+00	{"eTag": "\\"e90343ff41fa4816752a71818610c073\\"", "size": 304202, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:42.000Z", "contentLength": 304202, "httpStatusCode": 200}	5ad2fe80-f08d-4a17-b10b-259bf05207f2	\N	{}
42f54d00-6a06-4cc6-9002-c214a00e79b4	uploads	product-1777102122161.webp	\N	2026-04-25 07:28:42.484935+00	2026-04-25 07:28:42.484935+00	2026-04-25 07:28:42.484935+00	{"eTag": "\\"edc2348349b8abbea3664d60982a2c52\\"", "size": 431928, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:43.000Z", "contentLength": 431928, "httpStatusCode": 200}	b402f902-9d72-4fa9-b6cb-bfa486e21176	\N	{}
a34af70f-8866-4a28-99de-cbe3e6d72bf6	uploads	product-1777102378672.webp	\N	2026-04-25 07:32:59.000694+00	2026-04-25 07:32:59.000694+00	2026-04-25 07:32:59.000694+00	{"eTag": "\\"a5d028bfb3947b6d89d0749ac78ca09f\\"", "size": 373366, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:32:59.000Z", "contentLength": 373366, "httpStatusCode": 200}	a31be69d-94fc-42ed-9652-629b50db112f	\N	{}
716534b5-c4c5-4f9b-8d8d-0111db136d42	uploads	product-1777103142783.webp	\N	2026-04-25 07:45:43.499681+00	2026-04-25 07:45:43.499681+00	2026-04-25 07:45:43.499681+00	{"eTag": "\\"f490c35d994354b70f39adea43cbe061\\"", "size": 602152, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:44.000Z", "contentLength": 602152, "httpStatusCode": 200}	a3d80e61-30bf-4e30-9da5-8bf1bef0d62a	\N	{}
e3e7f81b-172d-409e-8e51-2b3daba81cc1	uploads	product-1777102379174.webp	\N	2026-04-25 07:32:59.521266+00	2026-04-25 07:32:59.521266+00	2026-04-25 07:32:59.521266+00	{"eTag": "\\"d4695efe7b5b366cb0e7caa7dcf9ecd9\\"", "size": 390158, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:33:00.000Z", "contentLength": 390158, "httpStatusCode": 200}	84657067-259d-401b-a2f9-4258755183e1	\N	{}
b8f61494-317b-43e9-9768-3b282215beda	uploads	product-1777102379720.webp	\N	2026-04-25 07:33:00.015185+00	2026-04-25 07:33:00.015185+00	2026-04-25 07:33:00.015185+00	{"eTag": "\\"23b9c0837d0c9d3b9b0b2eef9c7cf484\\"", "size": 335026, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:33:00.000Z", "contentLength": 335026, "httpStatusCode": 200}	0daed0aa-4385-48ef-b32a-5d8f44e9ade2	\N	{}
470d3928-732b-4e07-ab23-06a55e20a0b7	uploads	product-1777102380309.webp	\N	2026-04-25 07:33:00.601629+00	2026-04-25 07:33:00.601629+00	2026-04-25 07:33:00.601629+00	{"eTag": "\\"48401b4c0e24495892ece0fc09199f00\\"", "size": 272738, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:33:01.000Z", "contentLength": 272738, "httpStatusCode": 200}	77226d38-74f0-45b7-9229-e38cf5933063	\N	{}
2ad1d8f2-d18f-4e55-b20e-3e275e88a039	uploads	product-1777102380759.webp	\N	2026-04-25 07:33:01.008133+00	2026-04-25 07:33:01.008133+00	2026-04-25 07:33:01.008133+00	{"eTag": "\\"15394111bc1d77f241e3669ffb7cda6b\\"", "size": 259788, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:33:01.000Z", "contentLength": 259788, "httpStatusCode": 200}	9d1923d4-674f-461f-bc2a-978bea8bf36f	\N	{}
47929a78-3212-4f82-a840-57a4cdbe0e85	uploads	product-1777102428542.webp	\N	2026-04-25 07:33:49.142081+00	2026-04-25 07:33:49.142081+00	2026-04-25 07:33:49.142081+00	{"eTag": "\\"02f5074dd504780446cd823dbc844a5f\\"", "size": 527978, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:33:50.000Z", "contentLength": 527978, "httpStatusCode": 200}	52bef080-875c-473d-9f71-941d1a34473f	\N	{}
c047f1c8-695c-41e0-88d4-24a2c692ddfc	uploads	product-1777102119275.webp	\N	2026-04-25 07:28:39.627705+00	2026-04-25 07:28:39.627705+00	2026-04-25 07:28:39.627705+00	{"eTag": "\\"52ebfc4d73bba5c820afc38776d4112d\\"", "size": 402588, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:40.000Z", "contentLength": 402588, "httpStatusCode": 200}	5b4586f5-fabe-40bd-a1a4-10553c073052	\N	{}
8dfb8264-8bc0-4a52-8f64-8b6a69d0fa83	uploads	product-1777103143732.webp	\N	2026-04-25 07:45:44.388874+00	2026-04-25 07:45:44.388874+00	2026-04-25 07:45:44.388874+00	{"eTag": "\\"c456f49535fcca7f004f9004ef88995e\\"", "size": 468322, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:45.000Z", "contentLength": 468322, "httpStatusCode": 200}	f934999c-7f67-4755-a8e0-aae3ae26056d	\N	{}
aa878ee8-040b-437d-86f8-5195aaa3e198	uploads	product-1777102119785.webp	\N	2026-04-25 07:28:40.081195+00	2026-04-25 07:28:40.081195+00	2026-04-25 07:28:40.081195+00	{"eTag": "\\"ed1253b08ada2e6fa58dfe10147ea493\\"", "size": 336282, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:41.000Z", "contentLength": 336282, "httpStatusCode": 200}	48ae122e-0c49-49d8-a8d4-f991db8c2995	\N	{}
a74448ab-221b-49b7-8dab-57339e554e28	uploads	the-indigo-batik-story--1776668313641.webp	\N	2026-04-20 06:58:34.693524+00	2026-04-20 06:58:34.693524+00	2026-04-20 06:58:34.693524+00	{"eTag": "\\"b96133fd574568dd054133493188ce69\\"", "size": 379734, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T06:58:35.000Z", "contentLength": 379734, "httpStatusCode": 200}	f9886db1-211f-4776-8460-2a0022e53d9a	\N	{}
325d63f2-fd60-4b1a-8f2f-3cb86bfe5332	uploads	the-indigo-batik-story--1776668323762.webp	\N	2026-04-20 06:58:44.882895+00	2026-04-20 06:58:44.882895+00	2026-04-20 06:58:44.882895+00	{"eTag": "\\"3a6a11af7b0e53b43b61d94097d8b63b\\"", "size": 403158, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T06:58:45.000Z", "contentLength": 403158, "httpStatusCode": 200}	864d6159-f1ed-4e09-b698-4e4e2a47f7c5	\N	{}
1ded9dc3-4cf2-4aa5-9815-3629232aa98b	uploads	the-indigo-batik-story--1776668332197.webp	\N	2026-04-20 06:58:53.376523+00	2026-04-20 06:58:53.376523+00	2026-04-20 06:58:53.376523+00	{"eTag": "\\"c35b99373790c0b60e4e7ab3e9e13c42\\"", "size": 439466, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T06:58:54.000Z", "contentLength": 439466, "httpStatusCode": 200}	5833a977-e8a6-4bf4-82dd-391e870e8aab	\N	{}
fd2902f1-f1ed-47b4-9092-08986df6eae2	uploads	the-indigo-batik-story--1776668340513.webp	\N	2026-04-20 06:59:01.111952+00	2026-04-20 06:59:01.111952+00	2026-04-20 06:59:01.111952+00	{"eTag": "\\"3b5bd851a84a210b569e92dea05b1b25\\"", "size": 396760, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T06:59:02.000Z", "contentLength": 396760, "httpStatusCode": 200}	429d517a-0fd4-4244-a676-e776217fd90b	\N	{}
a2df7e68-277a-47ee-b231-b0079d4cb101	uploads	the-indigo-batik-story--1776668348287.webp	\N	2026-04-20 06:59:09.293083+00	2026-04-20 06:59:09.293083+00	2026-04-20 06:59:09.293083+00	{"eTag": "\\"206ea8c49446ab0aeb8f660385c0d776\\"", "size": 288396, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T06:59:10.000Z", "contentLength": 288396, "httpStatusCode": 200}	e217d164-0b5a-4897-9011-c9366af8b496	\N	{}
e754779c-3faf-430f-ab7d-f7184bdabd26	uploads	the-indigo-batik-story--1776668358226.webp	\N	2026-04-20 06:59:18.599796+00	2026-04-20 06:59:18.599796+00	2026-04-20 06:59:18.599796+00	{"eTag": "\\"4e5df1c7d363373c56f913ac5b90c77c\\"", "size": 334066, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T06:59:19.000Z", "contentLength": 334066, "httpStatusCode": 200}	d2b826a8-ef5e-4f97-8de1-8307060cae8b	\N	{}
90e15781-7039-40bf-917c-1f1b65ed8bd2	uploads	the-indigo-batik-story--1776668365362.webp	\N	2026-04-20 06:59:25.726518+00	2026-04-20 06:59:25.726518+00	2026-04-20 06:59:25.726518+00	{"eTag": "\\"876d74879f2bbcd8362462bb98ad28e2\\"", "size": 429972, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T06:59:26.000Z", "contentLength": 429972, "httpStatusCode": 200}	156c1399-f1ac-4c30-ac4b-f44ffb089cd4	\N	{}
1dbc8fed-03f3-4b8c-8089-ba7f09a725e1	uploads	the-indigo-batik-story--1776668374914.webp	\N	2026-04-20 06:59:36.189665+00	2026-04-20 06:59:36.189665+00	2026-04-20 06:59:36.189665+00	{"eTag": "\\"63c16222d7ccc69c2c553721271a32e5\\"", "size": 543828, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T06:59:37.000Z", "contentLength": 543828, "httpStatusCode": 200}	1aed6794-f923-4840-b7fa-4c1c4d5e3c80	\N	{}
9a0a1f57-5171-47d0-84bc-572db9373d36	uploads	the-indigo-edit--1776668831668.webp	\N	2026-04-20 07:07:12.807267+00	2026-04-20 07:07:12.807267+00	2026-04-20 07:07:12.807267+00	{"eTag": "\\"5a12394972b4a0f8b374dc0423584743\\"", "size": 593830, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T07:07:13.000Z", "contentLength": 593830, "httpStatusCode": 200}	7fce1d35-a96c-4df3-90ab-58f3aa36da44	\N	{}
a0eb874e-21f2-406f-9285-fa08f0da93d4	uploads	the-indigo-edit--1776668841675.webp	\N	2026-04-20 07:07:22.1166+00	2026-04-20 07:07:22.1166+00	2026-04-20 07:07:22.1166+00	{"eTag": "\\"1b748002afd934c715e52f4ef9fc72f1\\"", "size": 556212, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T07:07:23.000Z", "contentLength": 556212, "httpStatusCode": 200}	ddcbe542-03ee-4a85-a7a2-2d790bf1de8b	\N	{}
dfe2494e-0de9-4672-9bc5-5d5a43e4417d	uploads	the-indigo-edit--1776668851561.webp	\N	2026-04-20 07:07:32.249926+00	2026-04-20 07:07:32.249926+00	2026-04-20 07:07:32.249926+00	{"eTag": "\\"3f70938453e2d89a487b42024e52b387\\"", "size": 599590, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T07:07:33.000Z", "contentLength": 599590, "httpStatusCode": 200}	799d0ec5-00f1-4737-8655-247a22ab00a9	\N	{}
a76c592c-1146-4f65-96f5-bcbf48cbeaf3	uploads	the-indigo-edit--1776668859876.webp	\N	2026-04-20 07:07:41.006102+00	2026-04-20 07:07:41.006102+00	2026-04-20 07:07:41.006102+00	{"eTag": "\\"78212fa392ce1f04e2adec2a49ff72cd\\"", "size": 385452, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T07:07:41.000Z", "contentLength": 385452, "httpStatusCode": 200}	f6584a3d-d647-4ef8-aa02-c1bb61f562c2	\N	{}
87e66da7-8791-4cd2-b7ce-379d6185ce65	uploads	the-indigo-edit--1776668868296.webp	\N	2026-04-20 07:07:49.38442+00	2026-04-20 07:07:49.38442+00	2026-04-20 07:07:49.38442+00	{"eTag": "\\"bb30dd474ed3697b159b91e78a913466\\"", "size": 444886, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T07:07:50.000Z", "contentLength": 444886, "httpStatusCode": 200}	8ec3146a-2971-406c-a617-24200152fad0	\N	{}
fca65abb-105d-4618-9a27-ab3cac208c18	uploads	the-indigo-edit--1776668877631.webp	\N	2026-04-20 07:07:58.883525+00	2026-04-20 07:07:58.883525+00	2026-04-20 07:07:58.883525+00	{"eTag": "\\"f490c35d994354b70f39adea43cbe061\\"", "size": 602152, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T07:07:59.000Z", "contentLength": 602152, "httpStatusCode": 200}	52c0157c-9bec-48d7-a5ef-93c29c597611	\N	{}
249c18a5-776e-46ef-abc0-4cf31abb2000	uploads	product-1777102119926.webp	\N	2026-04-25 07:28:40.409417+00	2026-04-25 07:28:40.409417+00	2026-04-25 07:28:40.409417+00	{"eTag": "\\"618b1eef6497e71f2f415bcd84a81d0d\\"", "size": 384208, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:41.000Z", "contentLength": 384208, "httpStatusCode": 200}	986c3ada-0487-451c-b75a-c94c070ef61a	\N	{}
348b802a-60bc-49a9-9598-f79a4996c2bf	uploads	the-indigo-edit--1776668905562.webp	\N	2026-04-20 07:08:26.34453+00	2026-04-20 07:08:26.34453+00	2026-04-20 07:08:26.34453+00	{"eTag": "\\"9293cdb666ed5f25dbe47034fa77ff5b\\"", "size": 730236, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T07:08:27.000Z", "contentLength": 730236, "httpStatusCode": 200}	2ad5ab38-22b1-4bb9-af6a-2eb8e5494233	\N	{}
f2f5d00e-7e4e-44cb-93cc-52160748ae76	uploads	product-1777103144600.webp	\N	2026-04-25 07:45:44.865742+00	2026-04-25 07:45:44.865742+00	2026-04-25 07:45:44.865742+00	{"eTag": "\\"5a12394972b4a0f8b374dc0423584743\\"", "size": 593830, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:45.000Z", "contentLength": 593830, "httpStatusCode": 200}	6486b6c4-8d61-4d3a-a54c-d1e9be0bbd00	\N	{}
dbb0291d-3526-4783-8843-54e0299f5307	uploads	product-1777102120648.webp	\N	2026-04-25 07:28:40.910526+00	2026-04-25 07:28:40.910526+00	2026-04-25 07:28:40.910526+00	{"eTag": "\\"e54d83f845992b5a430c2e9b6421260d\\"", "size": 374124, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:41.000Z", "contentLength": 374124, "httpStatusCode": 200}	d7438711-07b5-476f-9415-266555104e20	\N	{}
c126bdde-a5c0-4d62-a9d4-35b4b1bdc7e1	uploads	product-1777102120234.webp	\N	2026-04-25 07:28:40.928849+00	2026-04-25 07:28:40.928849+00	2026-04-25 07:28:40.928849+00	{"eTag": "\\"c0ccac3b3b2f17ada20967b611ae288d\\"", "size": 319554, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:41.000Z", "contentLength": 319554, "httpStatusCode": 200}	f83ecebf-1d02-4a78-9095-51b3123ad722	\N	{}
8be5e262-363f-4c62-8fbe-b72ff71b168e	uploads	product-1777103145052.webp	\N	2026-04-25 07:45:45.377431+00	2026-04-25 07:45:45.377431+00	2026-04-25 07:45:45.377431+00	{"eTag": "\\"1b748002afd934c715e52f4ef9fc72f1\\"", "size": 556212, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:46.000Z", "contentLength": 556212, "httpStatusCode": 200}	6566fe16-ee8b-4520-b02a-ddc13a1a4c8e	\N	{}
7a7f8984-719c-40d1-8b77-f270048efe24	uploads	product-1777102121069.webp	\N	2026-04-25 07:28:41.35988+00	2026-04-25 07:28:41.35988+00	2026-04-25 07:28:41.35988+00	{"eTag": "\\"9d14b88c540fde0b85acecc43674718e\\"", "size": 279892, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:42.000Z", "contentLength": 279892, "httpStatusCode": 200}	99cc1a70-5228-4ec8-9cc9-b7e5c2a0513d	\N	{}
e82ad1b0-00f3-41e2-a335-e0739d6f33cf	uploads	product-1777102121115.webp	\N	2026-04-25 07:28:41.432651+00	2026-04-25 07:28:41.432651+00	2026-04-25 07:28:41.432651+00	{"eTag": "\\"e9dc89cc0bb2ea0de366f695d806cb04\\"", "size": 396498, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:42.000Z", "contentLength": 396498, "httpStatusCode": 200}	dc7357bf-cd30-45ac-9c51-79bb496b62a5	\N	{}
9810c169-a1d8-4b3c-8172-0e94797ef858	uploads	product-1777103145578.webp	\N	2026-04-25 07:45:45.965196+00	2026-04-25 07:45:45.965196+00	2026-04-25 07:45:45.965196+00	{"eTag": "\\"9293cdb666ed5f25dbe47034fa77ff5b\\"", "size": 730236, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:45:46.000Z", "contentLength": 730236, "httpStatusCode": 200}	4dde2a1a-31f6-41f6-83dc-1253627e595e	\N	{}
59f6ff0d-5883-488d-9c1b-067fea180515	uploads	product-1777102121513.webp	\N	2026-04-25 07:28:41.84837+00	2026-04-25 07:28:41.84837+00	2026-04-25 07:28:41.84837+00	{"eTag": "\\"6921f0e049062cf2d15c0e0104c4aadf\\"", "size": 400432, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:28:42.000Z", "contentLength": 400432, "httpStatusCode": 200}	769a4040-0b58-48fc-bb30-634d76b4efca	\N	{}
8fe64050-08fd-43d8-85c3-93ca8d165328	uploads	product-1777102429279.webp	\N	2026-04-25 07:33:49.530235+00	2026-04-25 07:33:49.530235+00	2026-04-25 07:33:49.530235+00	{"eTag": "\\"3725ec5a7d57b870222361a38718d115\\"", "size": 230604, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:33:50.000Z", "contentLength": 230604, "httpStatusCode": 200}	6726e45a-fc88-43f6-9d58-7a43d19de20b	\N	{}
951faa83-ccbb-4384-90c5-e01980ea5f7c	uploads	product-1777105901383.webp	\N	2026-04-25 08:31:42.601355+00	2026-04-25 08:31:42.601355+00	2026-04-25 08:31:42.601355+00	{"eTag": "\\"799ab47725f28701e5a372cfddc69014\\"", "size": 1122930, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T08:31:43.000Z", "contentLength": 1122930, "httpStatusCode": 200}	37f15ddd-d5e6-4e14-b6a2-66c0b3622dd0	\N	{}
11e91448-5ce5-4ac3-81fb-8932338b454d	uploads	the-indigo-batik-story--1777109401221.webp	\N	2026-04-25 09:30:01.691179+00	2026-04-25 09:30:01.691179+00	2026-04-25 09:30:01.691179+00	{"eTag": "\\"4e5df1c7d363373c56f913ac5b90c77c\\"", "size": 334066, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T09:30:02.000Z", "contentLength": 334066, "httpStatusCode": 200}	459e975c-448c-44ad-a524-68fbfc40aa98	\N	{}
e3fa9f3b-3797-4319-ac97-f6a43572c281	uploads	product-1777102429985.webp	\N	2026-04-25 07:33:50.277828+00	2026-04-25 07:33:50.277828+00	2026-04-25 07:33:50.277828+00	{"eTag": "\\"74c48ff56e1d901224579c7da1be9165\\"", "size": 391184, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:33:51.000Z", "contentLength": 391184, "httpStatusCode": 200}	cd85e171-8680-4aef-b136-efa80d9cb35d	\N	{}
60950181-5c5c-42a2-becc-729cd4b04e1f	uploads	product-1777102430434.webp	\N	2026-04-25 07:33:50.747188+00	2026-04-25 07:33:50.747188+00	2026-04-25 07:33:50.747188+00	{"eTag": "\\"94a53d157d89eb33135af9d48b3b4d1d\\"", "size": 388942, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:33:51.000Z", "contentLength": 388942, "httpStatusCode": 200}	31e6e01c-f108-417f-b480-3bb12576655d	\N	{}
a5ebd00a-e3ee-4521-b252-63227887bd47	uploads	the-indigo-edit--1776668890890.webp	\N	2026-04-20 07:08:11.359275+00	2026-04-20 07:08:11.359275+00	2026-04-20 07:08:11.359275+00	{"eTag": "\\"c456f49535fcca7f004f9004ef88995e\\"", "size": 468322, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T07:08:12.000Z", "contentLength": 468322, "httpStatusCode": 200}	ce56566d-490a-4873-b943-62135db71093	\N	{}
3aa56b13-1b8f-4382-8c48-5ee62c59f201	uploads	product-1777102285160.webp	\N	2026-04-25 07:31:25.812007+00	2026-04-25 07:31:25.812007+00	2026-04-25 07:31:25.812007+00	{"eTag": "\\"d584df4a869c343c4b6ce3b288544333\\"", "size": 339728, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:31:26.000Z", "contentLength": 339728, "httpStatusCode": 200}	f6aa1ff9-92dc-4b48-8aa9-afe52fca6a17	\N	{}
70af4e7a-b39d-4f02-aed5-ef1821d4fe67	uploads	product-1777103227874.webp	\N	2026-04-25 07:47:08.9625+00	2026-04-25 07:47:08.9625+00	2026-04-25 07:47:08.9625+00	{"eTag": "\\"adcc43e3a0fae8f30f7fbbd23a0b9408\\"", "size": 431730, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:47:09.000Z", "contentLength": 431730, "httpStatusCode": 200}	9e05aec4-d93b-4e19-b4b5-c31624258f8e	\N	{}
f4937647-8767-4fbf-8924-2d655277b092	uploads	product-1777102286006.webp	\N	2026-04-25 07:31:26.436137+00	2026-04-25 07:31:26.436137+00	2026-04-25 07:31:26.436137+00	{"eTag": "\\"ccc5f623c8b8df1fd849263e836993da\\"", "size": 315060, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:31:27.000Z", "contentLength": 315060, "httpStatusCode": 200}	c0dfabe1-2c04-48bf-8fd6-c234774c6300	\N	{}
37242de6-55d4-4905-8249-a97755a6ac58	reviews	review-1776676069895-378.blob	\N	2026-04-20 09:07:50.540389+00	2026-04-20 09:07:50.540389+00	2026-04-20 09:07:50.540389+00	{"eTag": "\\"fc01b30f83d16fdf0db7b9f77dd64d90\\"", "size": 232298, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T09:07:51.000Z", "contentLength": 232298, "httpStatusCode": 200}	90b3ddfc-0a77-49ac-9e4a-33439b1488f8	\N	{}
a416a358-487e-4886-97cb-b1e1ccf4fbcf	reviews	review-1776676069895-480.blob	\N	2026-04-20 09:07:50.840465+00	2026-04-20 09:07:50.840465+00	2026-04-20 09:07:50.840465+00	{"eTag": "\\"b57d5accf2053ceb525797fbadbb63c9\\"", "size": 223486, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T09:07:51.000Z", "contentLength": 223486, "httpStatusCode": 200}	fa5c6770-265b-412f-a674-b5e5a17e4d69	\N	{}
98825186-b5e7-4722-b5a3-a1510f7f375b	reviews	review-1776676069894-579.blob	\N	2026-04-20 09:07:50.796999+00	2026-04-20 09:07:50.796999+00	2026-04-20 09:07:50.796999+00	{"eTag": "\\"049d0b4780e0dfee2222a0e910dc1add\\"", "size": 208726, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T09:07:51.000Z", "contentLength": 208726, "httpStatusCode": 200}	00f78295-0b4e-4936-85fa-195ba8061e99	\N	{}
6397b564-e742-4cbf-9b37-e6f01f53f9b3	reviews	review-1776676069895-513.blob	\N	2026-04-20 09:07:51.157666+00	2026-04-20 09:07:51.157666+00	2026-04-20 09:07:51.157666+00	{"eTag": "\\"4a354e6353a5adf75628728bd6fab9f3\\"", "size": 933472, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T09:07:52.000Z", "contentLength": 933472, "httpStatusCode": 200}	929df48c-ac22-4101-8acc-8802189ae021	\N	{}
68efcd7f-8f4d-4bac-bd22-285fd201bd6e	uploads	product-1777102286602.webp	\N	2026-04-25 07:31:26.889962+00	2026-04-25 07:31:26.889962+00	2026-04-25 07:31:26.889962+00	{"eTag": "\\"4d1786f200c3c58e82d095dfb2562772\\"", "size": 234140, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:31:27.000Z", "contentLength": 234140, "httpStatusCode": 200}	3913d464-3763-4f0b-bdbe-15fc59866d0a	\N	{}
94e56a68-fb7a-486a-b1ab-93db12b03302	reviews	review-1776686792019-347.blob	\N	2026-04-20 12:06:32.299841+00	2026-04-20 12:06:32.299841+00	2026-04-20 12:06:32.299841+00	{"eTag": "\\"4e13fd2a39b82a96ce162b59264f9740\\"", "size": 292960, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T12:06:33.000Z", "contentLength": 292960, "httpStatusCode": 200}	9632a8af-12c8-487f-b93d-b7007df8f813	\N	{}
9db599f4-a64d-4f5b-b85e-f7b959812367	reviews	review-1776686792020-577.blob	\N	2026-04-20 12:06:32.717199+00	2026-04-20 12:06:32.717199+00	2026-04-20 12:06:32.717199+00	{"eTag": "\\"094714700c8c0f4e6867e95f7e856d6e\\"", "size": 207578, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T12:06:33.000Z", "contentLength": 207578, "httpStatusCode": 200}	32c1ff41-2d91-45bb-82c2-4676cfdb469a	\N	{}
b34dc724-a7fc-4ec9-affc-db1a37c4d7f5	uploads	product-1777102287070.webp	\N	2026-04-25 07:31:27.3529+00	2026-04-25 07:31:27.3529+00	2026-04-25 07:31:27.3529+00	{"eTag": "\\"13072af610e7f77fbe4b01c289e35b54\\"", "size": 332222, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:31:28.000Z", "contentLength": 332222, "httpStatusCode": 200}	2278d270-b73a-4dce-bba2-c70b3adead17	\N	{}
c5536dc8-fe55-4c5f-901b-a4923c4d5c35	reviews	review-1776689698494-630.blob	\N	2026-04-20 12:54:59.14851+00	2026-04-20 12:54:59.14851+00	2026-04-20 12:54:59.14851+00	{"eTag": "\\"10a05cd98abf217750fe24dcabadd604\\"", "size": 212938, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T12:55:00.000Z", "contentLength": 212938, "httpStatusCode": 200}	1646dfbe-bf6d-4f43-a1dc-5764387e7b66	\N	{}
e6a9ca09-43af-446c-a5a8-7ce2a2340053	reviews	review-1776689698494-631.blob	\N	2026-04-20 12:54:59.153676+00	2026-04-20 12:54:59.153676+00	2026-04-20 12:54:59.153676+00	{"eTag": "\\"ec27cb7aeec73bf13278e6955a5e3622\\"", "size": 205892, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T12:55:00.000Z", "contentLength": 205892, "httpStatusCode": 200}	9dd372f4-9ce4-4b72-b252-2d4989001030	\N	{}
1cbbf36a-c255-4f02-9211-591d4840f3be	reviews	review-1776689698492-285.blob	\N	2026-04-20 12:54:59.163138+00	2026-04-20 12:54:59.163138+00	2026-04-20 12:54:59.163138+00	{"eTag": "\\"ec27cb7aeec73bf13278e6955a5e3622\\"", "size": 205892, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-20T12:55:00.000Z", "contentLength": 205892, "httpStatusCode": 200}	8aad7c9d-8975-4cbf-9386-2fce8460b5b0	\N	{}
990f427d-a8b3-4ed6-a6ac-e0c6d4dedc6c	uploads	product-1777102287516.webp	\N	2026-04-25 07:31:27.806383+00	2026-04-25 07:31:27.806383+00	2026-04-25 07:31:27.806383+00	{"eTag": "\\"d501abb505179a75851a84e1f06a538e\\"", "size": 222276, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:31:28.000Z", "contentLength": 222276, "httpStatusCode": 200}	9eae7715-62ab-41f8-b2e3-0b55585a79aa	\N	{}
aee2233a-6e92-41ba-a8d0-262fd94a762d	uploads	product-1777102430891.webp	\N	2026-04-25 07:33:51.140029+00	2026-04-25 07:33:51.140029+00	2026-04-25 07:33:51.140029+00	{"eTag": "\\"1fc64458157c930894bca83140cb4630\\"", "size": 328420, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:33:52.000Z", "contentLength": 328420, "httpStatusCode": 200}	48a7c42c-5732-4fc7-b9bd-781f2b420ecc	\N	{}
955ab81e-a6ce-4a3e-a3d6-68194c221192	uploads	product-1777103229171.webp	\N	2026-04-25 07:47:09.446121+00	2026-04-25 07:47:09.446121+00	2026-04-25 07:47:09.446121+00	{"eTag": "\\"71e5d16c0f0a73e31ebf0c07dba6fd72\\"", "size": 232902, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:47:10.000Z", "contentLength": 232902, "httpStatusCode": 200}	c151db12-e656-41d0-ae4e-fecbf4859d27	\N	{}
096d1243-0a3f-4d98-9053-ed806be81e1b	uploads	product-1777102431294.webp	\N	2026-04-25 07:33:51.550924+00	2026-04-25 07:33:51.550924+00	2026-04-25 07:33:51.550924+00	{"eTag": "\\"97260ebecac9ab3181d93439bd972a2e\\"", "size": 389508, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:33:52.000Z", "contentLength": 389508, "httpStatusCode": 200}	9ee3a899-8dcd-409b-afef-db743771f090	\N	{}
917e43a1-23e6-4bcf-809a-f8a17a773b2b	uploads	product-1777102431705.webp	\N	2026-04-25 07:33:51.974138+00	2026-04-25 07:33:51.974138+00	2026-04-25 07:33:51.974138+00	{"eTag": "\\"5996ee00a6fdbc156fd915d119b6f590\\"", "size": 370070, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:33:52.000Z", "contentLength": 370070, "httpStatusCode": 200}	502536ee-8cc6-439f-9edf-eef7d30e5f1f	\N	{}
b1fced2c-0d6c-4f67-988a-66a35dc2fd69	uploads	product-1777103229643.webp	\N	2026-04-25 07:47:09.97678+00	2026-04-25 07:47:09.97678+00	2026-04-25 07:47:09.97678+00	{"eTag": "\\"879bee773984824a0068243f8a15af8f\\"", "size": 338780, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:47:10.000Z", "contentLength": 338780, "httpStatusCode": 200}	e7ff0c62-2ce8-42d6-8089-f52c205a7d8d	\N	{}
8693be63-1e1f-42d5-9d3d-3c668f3e3a8d	uploads	product-1777103230145.webp	\N	2026-04-25 07:47:10.41295+00	2026-04-25 07:47:10.41295+00	2026-04-25 07:47:10.41295+00	{"eTag": "\\"d501d05d1a1f5cd0426e91f8bce971f2\\"", "size": 152760, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:47:11.000Z", "contentLength": 152760, "httpStatusCode": 200}	a100dff7-a6bc-47ed-8081-4ad99ebb77c6	\N	{}
247a0e00-e2b4-4089-8813-9e8d193ecfe8	uploads	product-1777103230598.webp	\N	2026-04-25 07:47:10.867929+00	2026-04-25 07:47:10.867929+00	2026-04-25 07:47:10.867929+00	{"eTag": "\\"446e1a468b05bb5d72790f8e6520b6f2\\"", "size": 395054, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:47:11.000Z", "contentLength": 395054, "httpStatusCode": 200}	032220d5-1a84-4982-a970-9b4cbbfef9ab	\N	{}
0f983ce8-9168-4050-a3ff-d575d61f1e3a	uploads	product-1777103231046.webp	\N	2026-04-25 07:47:11.351085+00	2026-04-25 07:47:11.351085+00	2026-04-25 07:47:11.351085+00	{"eTag": "\\"299e6c85183d122f0b0980d49e67bb0d\\"", "size": 335772, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:47:12.000Z", "contentLength": 335772, "httpStatusCode": 200}	45736074-c10e-4b05-836f-8144b37a5583	\N	{}
1fd8d5aa-44f1-4d72-899e-e6f97cf44a04	uploads	product-1777103231510.webp	\N	2026-04-25 07:47:11.791088+00	2026-04-25 07:47:11.791088+00	2026-04-25 07:47:11.791088+00	{"eTag": "\\"b8306718980d919dfda54e4c74d04eaa\\"", "size": 321770, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:47:12.000Z", "contentLength": 321770, "httpStatusCode": 200}	2f750a9f-d2bd-4c26-b55e-30fd0321600d	\N	{}
4d939d8e-0fc0-49b4-81d6-d37cf471c821	uploads	product-1777103316246.webp	\N	2026-04-25 07:48:36.9876+00	2026-04-25 07:48:36.9876+00	2026-04-25 07:48:36.9876+00	{"eTag": "\\"18ecd5ca0d0e3ff7477a0880f03e6917\\"", "size": 395164, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:48:37.000Z", "contentLength": 395164, "httpStatusCode": 200}	f4738ef3-11f0-47a0-9ded-0ac09874b2ea	\N	{}
a42a2f33-0a26-4570-a4f6-18e539052b82	uploads	product-1777103317210.webp	\N	2026-04-25 07:48:37.487757+00	2026-04-25 07:48:37.487757+00	2026-04-25 07:48:37.487757+00	{"eTag": "\\"784efb5dd9323f3c829b1310bf325603\\"", "size": 363366, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:48:38.000Z", "contentLength": 363366, "httpStatusCode": 200}	3b4a8477-fc63-4bcb-b952-8ac4fedfcde4	\N	{}
bb157844-bad3-4b11-9ff9-2f7927f8fe3b	uploads	product-1777103317697.webp	\N	2026-04-25 07:48:37.955212+00	2026-04-25 07:48:37.955212+00	2026-04-25 07:48:37.955212+00	{"eTag": "\\"54d6b77273eede6991382619f9a90f01\\"", "size": 382262, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:48:38.000Z", "contentLength": 382262, "httpStatusCode": 200}	91326420-3b67-4d9e-8c8f-dd6056af877a	\N	{}
8347d4e4-6927-4b03-a5fb-a6ce1e153133	uploads	product-1777103318116.webp	\N	2026-04-25 07:48:38.382338+00	2026-04-25 07:48:38.382338+00	2026-04-25 07:48:38.382338+00	{"eTag": "\\"fbce109edd4efc3d8f8b50b8ef299e00\\"", "size": 285308, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:48:39.000Z", "contentLength": 285308, "httpStatusCode": 200}	3eebe29c-b558-4a57-ae09-5257dce4ff12	\N	{}
7bf484b7-93cb-4f9a-aaf2-c429df6ef714	uploads	product-1777102536646.webp	\N	2026-04-25 07:35:36.958021+00	2026-04-25 07:35:36.958021+00	2026-04-25 07:35:36.958021+00	{"eTag": "\\"715102f73619ab4788ca813c53f450c1\\"", "size": 352084, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:35:37.000Z", "contentLength": 352084, "httpStatusCode": 200}	935ae11c-6b12-4ab9-92c2-87a64b37b557	\N	{}
043fae6c-d668-426c-b59d-85efdbbbd8b4	uploads	product-1777102537142.webp	\N	2026-04-25 07:35:37.412203+00	2026-04-25 07:35:37.412203+00	2026-04-25 07:35:37.412203+00	{"eTag": "\\"ccec93675da0fd1f0a16efa6abe24662\\"", "size": 282484, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:35:38.000Z", "contentLength": 282484, "httpStatusCode": 200}	11be9baf-63dd-4fd2-a313-82dee66eaf0b	\N	{}
876556ca-3f29-4e92-ac84-27b5e740d02e	uploads	product-1777103318519.webp	\N	2026-04-25 07:48:38.795526+00	2026-04-25 07:48:38.795526+00	2026-04-25 07:48:38.795526+00	{"eTag": "\\"b9318a3b71949f5b411c009d0945ac02\\"", "size": 123722, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:48:39.000Z", "contentLength": 123722, "httpStatusCode": 200}	d4be88e9-37ed-4090-aeb0-721b4d670987	\N	{}
f7308c02-b75e-4896-a536-6929ce3630e2	uploads	product-1777102537583.webp	\N	2026-04-25 07:35:37.86543+00	2026-04-25 07:35:37.86543+00	2026-04-25 07:35:37.86543+00	{"eTag": "\\"66377751b530a49225916c6fbbc28d68\\"", "size": 337150, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:35:38.000Z", "contentLength": 337150, "httpStatusCode": 200}	9ff36e87-5db4-4bd6-849d-90c9b544e355	\N	{}
55bea290-cb81-4eb6-b5e3-29ea7457b6e1	uploads	product-1777102538038.webp	\N	2026-04-25 07:35:38.297045+00	2026-04-25 07:35:38.297045+00	2026-04-25 07:35:38.297045+00	{"eTag": "\\"4bf7d66659f5bb7c7456bc2baf9af8ed\\"", "size": 343062, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:35:39.000Z", "contentLength": 343062, "httpStatusCode": 200}	168eec51-e91c-48f8-9d75-0abbbd6e7e36	\N	{}
5b537fb4-15d4-46c2-b87c-0ab620d11604	uploads	product-1777103318933.webp	\N	2026-04-25 07:48:39.197718+00	2026-04-25 07:48:39.197718+00	2026-04-25 07:48:39.197718+00	{"eTag": "\\"65a79ee040d9fcc5ead8d263d5f5631f\\"", "size": 161170, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:48:40.000Z", "contentLength": 161170, "httpStatusCode": 200}	24a930a2-c3d8-41ad-93db-3d9f88e0d9fd	\N	{}
2b7c1747-1032-492a-b79e-80ba617705a0	uploads	product-1777102538470.webp	\N	2026-04-25 07:35:39.16539+00	2026-04-25 07:35:39.16539+00	2026-04-25 07:35:39.16539+00	{"eTag": "\\"6918c7a3903090153de33ae5bbd7edf4\\"", "size": 343958, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:35:40.000Z", "contentLength": 343958, "httpStatusCode": 200}	20b721d0-229f-4406-840a-f10a3718224b	\N	{}
fbd7eb8f-14d2-4d28-9273-62514409eb51	uploads	product-1777102539332.webp	\N	2026-04-25 07:35:39.597049+00	2026-04-25 07:35:39.597049+00	2026-04-25 07:35:39.597049+00	{"eTag": "\\"eaf14ceac1e0a5d7cff1c8862c50c643\\"", "size": 314682, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:35:40.000Z", "contentLength": 314682, "httpStatusCode": 200}	cbdcd8e0-26a0-4a1e-932e-dc468b54bc18	\N	{}
2bf273db-2703-44f8-8d96-6abec78029c5	uploads	product-1777103319321.webp	\N	2026-04-25 07:48:39.607594+00	2026-04-25 07:48:39.607594+00	2026-04-25 07:48:39.607594+00	{"eTag": "\\"a74a21acd8d1ee7afc890ee56cf79374\\"", "size": 87022, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:48:40.000Z", "contentLength": 87022, "httpStatusCode": 200}	dae654fc-05c3-4720-a744-3ed8f59c07e8	\N	{}
fba0bd83-9714-46df-a912-0430f9e3693f	uploads	product-1777102539758.webp	\N	2026-04-25 07:35:40.268731+00	2026-04-25 07:35:40.268731+00	2026-04-25 07:35:40.268731+00	{"eTag": "\\"9ebecd6b62579e40780bbccd5abb8b57\\"", "size": 127944, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:35:41.000Z", "contentLength": 127944, "httpStatusCode": 200}	973cfb9c-7364-4190-ab1f-57a7ef6a1f39	\N	{}
4f4e6666-55df-4851-b8fb-08ce9077cd27	uploads	product-1777102808527.webp	\N	2026-04-25 07:40:09.027785+00	2026-04-25 07:40:09.027785+00	2026-04-25 07:40:09.027785+00	{"eTag": "\\"6c19bfcb2ea5ffad741d792887f9ba86\\"", "size": 530268, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:40:09.000Z", "contentLength": 530268, "httpStatusCode": 200}	9b833a56-df23-48cd-9bc1-8e45511e3102	\N	{}
b1dde5c4-393f-4d71-a89a-5382b53ff59e	uploads	product-1777102809268.webp	\N	2026-04-25 07:40:09.5459+00	2026-04-25 07:40:09.5459+00	2026-04-25 07:40:09.5459+00	{"eTag": "\\"849f0aaba3b0f7f8ad78febde6dc86a7\\"", "size": 432004, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:40:10.000Z", "contentLength": 432004, "httpStatusCode": 200}	b151258d-0837-42cd-81e6-7793ec1a8dc1	\N	{}
17808be2-fbd8-4cb5-a292-2472093d96e0	uploads	product-1777102809785.webp	\N	2026-04-25 07:40:10.3394+00	2026-04-25 07:40:10.3394+00	2026-04-25 07:40:10.3394+00	{"eTag": "\\"23ab0b56d2d21f3aa72802e956c6e2db\\"", "size": 620278, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:40:11.000Z", "contentLength": 620278, "httpStatusCode": 200}	f81700e1-33b3-475b-a0ee-bbe981cfd047	\N	{}
d15333dd-47e9-4cfb-b371-e439bb037f43	uploads	product-1777102810564.webp	\N	2026-04-25 07:40:10.850333+00	2026-04-25 07:40:10.850333+00	2026-04-25 07:40:10.850333+00	{"eTag": "\\"4f7fb863ca423a5ec173dedc6fcf6898\\"", "size": 559998, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:40:11.000Z", "contentLength": 559998, "httpStatusCode": 200}	d34ae1f5-51b5-4a95-ba0e-5f27247679ac	\N	{}
43010a81-2eeb-4a7d-bc3c-ab8926d253c9	uploads	product-1777102811024.webp	\N	2026-04-25 07:40:11.290207+00	2026-04-25 07:40:11.290207+00	2026-04-25 07:40:11.290207+00	{"eTag": "\\"4bb11e7be6718f3b09d3052841c5c1fe\\"", "size": 378982, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:40:12.000Z", "contentLength": 378982, "httpStatusCode": 200}	277898ae-b1f1-45f6-b38b-1a8e71c06f89	\N	{}
b18d5af9-deff-4d05-8a5f-5dce92ea2ac7	uploads	product-1777102773105.webp	\N	2026-04-25 07:39:33.641428+00	2026-04-25 07:39:33.641428+00	2026-04-25 07:39:33.641428+00	{"eTag": "\\"17c8fe711756133aca4ec19dfc343a1d\\"", "size": 447476, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:39:34.000Z", "contentLength": 447476, "httpStatusCode": 200}	c1619d5b-df24-409a-b78b-861ea37ee2cb	\N	{}
edd8ca73-6835-4173-9ed3-5f22ac0d1b51	uploads	product-1777103319766.webp	\N	2026-04-25 07:48:40.022154+00	2026-04-25 07:48:40.022154+00	2026-04-25 07:48:40.022154+00	{"eTag": "\\"35079a8b1c52151b7789e41766d0f309\\"", "size": 263216, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:48:40.000Z", "contentLength": 263216, "httpStatusCode": 200}	222e54c6-f89a-44c0-b69f-e759dd8cf40b	\N	{}
a13f4bba-19e0-4a8c-b857-a1d4aabd3377	uploads	product-1777102773802.webp	\N	2026-04-25 07:39:34.108711+00	2026-04-25 07:39:34.108711+00	2026-04-25 07:39:34.108711+00	{"eTag": "\\"a2483c5da14b83097f3d02de54dba848\\"", "size": 419146, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:39:35.000Z", "contentLength": 419146, "httpStatusCode": 200}	e5592ac1-eca1-4561-a55e-68ab46e262d0	\N	{}
5ce5fe2d-9546-45fd-9ae2-d5ba1450cae5	uploads	product-1777105928323.webp	\N	2026-04-25 08:32:08.752152+00	2026-04-25 08:32:08.752152+00	2026-04-25 08:32:08.752152+00	{"eTag": "\\"865c7324013e1ad0fd94f9b60e679928\\"", "size": 477754, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T08:32:09.000Z", "contentLength": 477754, "httpStatusCode": 200}	3ea5e183-3e78-4ecb-a141-b55d868b6e8b	\N	{}
1a8d3d2e-48b6-4fa4-b7cd-89297d173d23	uploads	product-1777102774266.webp	\N	2026-04-25 07:39:34.528439+00	2026-04-25 07:39:34.528439+00	2026-04-25 07:39:34.528439+00	{"eTag": "\\"6acd66d8ebb83f260ef55144536340a4\\"", "size": 500930, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:39:35.000Z", "contentLength": 500930, "httpStatusCode": 200}	9e805680-49d6-4ac4-ae12-bdb2cb699448	\N	{}
15d5782d-c64c-408e-a0b4-22595085f3ee	uploads	the-indigo-batik-story--1777109407747.webp	\N	2026-04-25 09:30:08.084418+00	2026-04-25 09:30:08.084418+00	2026-04-25 09:30:08.084418+00	{"eTag": "\\"206ea8c49446ab0aeb8f660385c0d776\\"", "size": 288396, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T09:30:09.000Z", "contentLength": 288396, "httpStatusCode": 200}	4cc24926-7c14-4dbf-811c-f65df6187317	\N	{}
216e7d89-7901-4e3f-a97a-d96ebabcecf9	uploads	product-1777102774687.webp	\N	2026-04-25 07:39:34.974373+00	2026-04-25 07:39:34.974373+00	2026-04-25 07:39:34.974373+00	{"eTag": "\\"24c20346662bf481bba74f60b1f6c85c\\"", "size": 509216, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:39:35.000Z", "contentLength": 509216, "httpStatusCode": 200}	a3be92d4-8713-483a-89e9-4a497ca0385c	\N	{}
27fce74d-744c-47ce-857d-97f348aee12c	uploads	the-indigo-batik-story--1777109416293.webp	\N	2026-04-25 09:30:16.841189+00	2026-04-25 09:30:16.841189+00	2026-04-25 09:30:16.841189+00	{"eTag": "\\"876d74879f2bbcd8362462bb98ad28e2\\"", "size": 429972, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T09:30:17.000Z", "contentLength": 429972, "httpStatusCode": 200}	276f6e20-b525-436d-8b2e-583cb9a961cc	\N	{}
0e05f10e-e78f-462d-a88e-e4aa65f8c4e2	uploads	product-1777102775128.webp	\N	2026-04-25 07:39:35.392042+00	2026-04-25 07:39:35.392042+00	2026-04-25 07:39:35.392042+00	{"eTag": "\\"eedf31f9c626173424aee0c8fd7f5ce0\\"", "size": 312288, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:39:36.000Z", "contentLength": 312288, "httpStatusCode": 200}	18a9e272-0285-466d-bad4-a2e9c563752b	\N	{}
6f2bdeb3-d2c9-4ecf-8c3e-b4ed0b059d0a	uploads	product-1777102775564.webp	\N	2026-04-25 07:39:35.84866+00	2026-04-25 07:39:35.84866+00	2026-04-25 07:39:35.84866+00	{"eTag": "\\"5db7af1dcc1e53bb41a52d140267d365\\"", "size": 518350, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:39:36.000Z", "contentLength": 518350, "httpStatusCode": 200}	e34a85b5-33df-4a36-9f06-d3d98ad798b7	\N	{}
b28f285b-90cc-4dcc-9707-bde315c5bf94	uploads	the-indigo-batik-story--1777109423073.webp	\N	2026-04-25 09:30:23.96265+00	2026-04-25 09:30:23.96265+00	2026-04-25 09:30:23.96265+00	{"eTag": "\\"63c16222d7ccc69c2c553721271a32e5\\"", "size": 543828, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T09:30:24.000Z", "contentLength": 543828, "httpStatusCode": 200}	cb58f0ce-08f9-4e46-8baa-91c3c4dd2ca4	\N	{}
d27b5047-3e5c-48fa-8bc8-6dd832565a97	uploads	product-1777102776016.webp	\N	2026-04-25 07:39:36.312084+00	2026-04-25 07:39:36.312084+00	2026-04-25 07:39:36.312084+00	{"eTag": "\\"904362810eafb62e5d33a1390f43a62d\\"", "size": 472230, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:39:37.000Z", "contentLength": 472230, "httpStatusCode": 200}	34b4e421-9edc-4704-9c6d-20d1e7eeb362	\N	{}
6f5ef4ee-1b4c-4efe-8c1e-1750bd913e2c	uploads	product-1777102811535.webp	\N	2026-04-25 07:40:11.808393+00	2026-04-25 07:40:11.808393+00	2026-04-25 07:40:11.808393+00	{"eTag": "\\"de08bca98741198f05249aa5428e0e16\\"", "size": 541738, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:40:12.000Z", "contentLength": 541738, "httpStatusCode": 200}	03b0ea04-8946-4869-ab4f-66ed8a271116	\N	{}
fc1a7277-3c4e-4905-8739-fd67c0f72319	uploads	product-1777102812041.webp	\N	2026-04-25 07:40:12.338132+00	2026-04-25 07:40:12.338132+00	2026-04-25 07:40:12.338132+00	{"eTag": "\\"1cea25d35ff93369a00870b53e24843f\\"", "size": 752510, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:40:13.000Z", "contentLength": 752510, "httpStatusCode": 200}	9f441163-22c6-40a2-95c9-dc8c9039a196	\N	{}
527aa430-7b35-4f93-9db6-4502fa273526	uploads	product-1777103351273.webp	\N	2026-04-25 07:49:11.875167+00	2026-04-25 07:49:11.875167+00	2026-04-25 07:49:11.875167+00	{"eTag": "\\"3ce124999cbecbe677e45f1b0392e8a2\\"", "size": 116740, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:49:12.000Z", "contentLength": 116740, "httpStatusCode": 200}	82bf1418-1ef6-4a0e-8fe8-b84df351cdd4	\N	{}
6ced7388-7811-4106-a335-0b5f7f0b7da5	uploads	product-1777102887511.webp	\N	2026-04-25 07:41:28.013399+00	2026-04-25 07:41:28.013399+00	2026-04-25 07:41:28.013399+00	{"eTag": "\\"346ed58c7f0834feaf1d447a548cea4c\\"", "size": 324284, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:41:28.000Z", "contentLength": 324284, "httpStatusCode": 200}	b9b025d6-a962-432b-aeff-6a15c1361169	\N	{}
16145a70-3303-46d2-9c00-e58f11bbc7f7	uploads	product-1777102888159.webp	\N	2026-04-25 07:41:28.41851+00	2026-04-25 07:41:28.41851+00	2026-04-25 07:41:28.41851+00	{"eTag": "\\"0a703b362f643c6678df51a1ee13b186\\"", "size": 319084, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:41:29.000Z", "contentLength": 319084, "httpStatusCode": 200}	fef33711-e1fd-464c-b6f2-563ed2decac3	\N	{}
af1a2446-bfb2-4ee9-8286-32df79d04311	uploads	the-indigo-batik-story--1777109340050.webp	\N	2026-04-25 09:29:01.641844+00	2026-04-25 09:29:01.641844+00	2026-04-25 09:29:01.641844+00	{"eTag": "\\"b96133fd574568dd054133493188ce69\\"", "size": 379734, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T09:29:02.000Z", "contentLength": 379734, "httpStatusCode": 200}	cc44fd51-ee56-474a-a684-659f76ce5703	\N	{}
6829bcce-80bc-4d3a-9c56-5f365b506a6e	uploads	product-1777102888563.webp	\N	2026-04-25 07:41:28.825176+00	2026-04-25 07:41:28.825176+00	2026-04-25 07:41:28.825176+00	{"eTag": "\\"cf3d5d086c6a5b0c123da3f411db1a65\\"", "size": 372066, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:41:29.000Z", "contentLength": 372066, "httpStatusCode": 200}	afac83e0-d144-4a6e-b0ed-4c71fe7aa6a8	\N	{}
5a243c41-fa7a-462f-a968-5e826d8f6249	uploads	product-1777102888962.webp	\N	2026-04-25 07:41:29.230036+00	2026-04-25 07:41:29.230036+00	2026-04-25 07:41:29.230036+00	{"eTag": "\\"a1ade605ad918fa5ce219dc54b78c9aa\\"", "size": 294946, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:41:30.000Z", "contentLength": 294946, "httpStatusCode": 200}	8c74cfcc-fa61-4446-beee-21f84c46b4b8	\N	{}
ee95530d-58b7-444a-840d-f805441acb76	uploads	the-indigo-batik-story--1777109369371.webp	\N	2026-04-25 09:29:30.190204+00	2026-04-25 09:29:30.190204+00	2026-04-25 09:29:30.190204+00	{"eTag": "\\"c35b99373790c0b60e4e7ab3e9e13c42\\"", "size": 439466, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T09:29:31.000Z", "contentLength": 439466, "httpStatusCode": 200}	14763401-8bb9-499b-807c-789e04776a2d	\N	{}
0c4851c0-f5d5-4520-82ee-d236e836fdd1	uploads	product-1777102889364.webp	\N	2026-04-25 07:41:29.616507+00	2026-04-25 07:41:29.616507+00	2026-04-25 07:41:29.616507+00	{"eTag": "\\"be7056f41d18fcb380c3247556182879\\"", "size": 292026, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:41:30.000Z", "contentLength": 292026, "httpStatusCode": 200}	aa2b68f0-4d98-4519-9c42-b384cd5c5e1a	\N	{}
2b305121-7b13-464f-945b-f66006bf22c5	uploads	product-1777102889811.webp	\N	2026-04-25 07:41:30.552944+00	2026-04-25 07:41:30.552944+00	2026-04-25 07:41:30.552944+00	{"eTag": "\\"72a742bbb4ebc995a24dd1e822e0f0ad\\"", "size": 456924, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:41:31.000Z", "contentLength": 456924, "httpStatusCode": 200}	b3661a7d-8490-4209-b861-fd8b29ac5268	\N	{}
4269cf20-1c26-454c-8d06-9279592a0ba1	uploads	product-1777102890689.webp	\N	2026-04-25 07:41:30.956288+00	2026-04-25 07:41:30.956288+00	2026-04-25 07:41:30.956288+00	{"eTag": "\\"7a5f721b43d8962cddd1f1862c58cfdf\\"", "size": 249558, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:41:31.000Z", "contentLength": 249558, "httpStatusCode": 200}	e4864c0f-d939-4899-ab37-3fd71e1b87d4	\N	{}
d7d1122d-b8f8-452d-9e60-131f08566414	uploads	product-1777102891106.webp	\N	2026-04-25 07:41:31.581113+00	2026-04-25 07:41:31.581113+00	2026-04-25 07:41:31.581113+00	{"eTag": "\\"452c91b4096186a76092b56870da8190\\"", "size": 327634, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:41:32.000Z", "contentLength": 327634, "httpStatusCode": 200}	f55a3875-e86b-436e-80ee-23cf89e0aed9	\N	{}
89592a3b-2d76-42a5-adeb-6bc0c7155062	uploads	product-1777102947150.webp	\N	2026-04-25 07:42:27.700984+00	2026-04-25 07:42:27.700984+00	2026-04-25 07:42:27.700984+00	{"eTag": "\\"44576229557c8ab87cd22f7163728523\\"", "size": 310794, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:42:28.000Z", "contentLength": 310794, "httpStatusCode": 200}	fe0b6ab7-355c-4ea2-853c-7876e6fc00a2	\N	{}
97d9b09b-e686-44eb-be76-7247b03b9fc7	uploads	product-1777102947903.webp	\N	2026-04-25 07:42:28.157678+00	2026-04-25 07:42:28.157678+00	2026-04-25 07:42:28.157678+00	{"eTag": "\\"2eddefad1387ae38fab72a3ea309fdd7\\"", "size": 378290, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:42:29.000Z", "contentLength": 378290, "httpStatusCode": 200}	0106a0ca-1345-4fe5-a019-41c5bd438b2b	\N	{}
337ddb0c-4c80-4f79-8a87-7ef1e0f96a51	uploads	product-1777102948346.webp	\N	2026-04-25 07:42:28.864347+00	2026-04-25 07:42:28.864347+00	2026-04-25 07:42:28.864347+00	{"eTag": "\\"ed9d0e920b9c14a05d852660f8589449\\"", "size": 383640, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:42:29.000Z", "contentLength": 383640, "httpStatusCode": 200}	24813e7a-90ca-42c4-aaab-bf7ceae8d4a4	\N	{}
e487243f-a367-4fa0-9d8f-eab635509a9d	uploads	product-1777102949078.webp	\N	2026-04-25 07:42:29.34342+00	2026-04-25 07:42:29.34342+00	2026-04-25 07:42:29.34342+00	{"eTag": "\\"37e17f85a685e36a311055a16b1cbc1d\\"", "size": 329118, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:42:30.000Z", "contentLength": 329118, "httpStatusCode": 200}	f7562d0c-ccbb-46cc-8c1a-b0fa6b9e7269	\N	{}
02314aca-4865-4357-a39b-1ae1303e0ee0	uploads	product-1777105288941.webp	\N	2026-04-25 08:21:29.818351+00	2026-04-25 08:21:29.818351+00	2026-04-25 08:21:29.818351+00	{"eTag": "\\"799ab47725f28701e5a372cfddc69014\\"", "size": 1122930, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T08:21:30.000Z", "contentLength": 1122930, "httpStatusCode": 200}	22e04e41-9fd5-4122-b717-bdac2222626b	\N	{}
33e6199d-fc5b-488b-b83f-102ce9c7d7e4	uploads	product-1777102949563.webp	\N	2026-04-25 07:42:29.862848+00	2026-04-25 07:42:29.862848+00	2026-04-25 07:42:29.862848+00	{"eTag": "\\"7ca9225a355324aab9f4d27a48cae490\\"", "size": 516488, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:42:30.000Z", "contentLength": 516488, "httpStatusCode": 200}	b9d1d558-32d0-4333-b5a6-fd58ca193334	\N	{}
b8d3401e-033c-42bc-b92b-2b3ef056373d	uploads	product-1777102950044.webp	\N	2026-04-25 07:42:30.357379+00	2026-04-25 07:42:30.357379+00	2026-04-25 07:42:30.357379+00	{"eTag": "\\"63190f3711e8349d315e2634fc92fe61\\"", "size": 332512, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:42:31.000Z", "contentLength": 332512, "httpStatusCode": 200}	68f1245a-bfde-47e7-b6ab-f68c493f74c8	\N	{}
08b398eb-c6aa-4d08-805c-8d81786f6411	uploads	the-indigo-batik-story--1777109353778.webp	\N	2026-04-25 09:29:14.998269+00	2026-04-25 09:29:14.998269+00	2026-04-25 09:29:14.998269+00	{"eTag": "\\"3a6a11af7b0e53b43b61d94097d8b63b\\"", "size": 403158, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T09:29:15.000Z", "contentLength": 403158, "httpStatusCode": 200}	c39adbfb-057e-42a3-9431-0b12bfa7a2ca	\N	{}
59744c66-8db9-44a9-b58f-6c742799e229	uploads	product-1777102950520.webp	\N	2026-04-25 07:42:30.80959+00	2026-04-25 07:42:30.80959+00	2026-04-25 07:42:30.80959+00	{"eTag": "\\"fa670423abb83f64b411a1037ce3d17f\\"", "size": 291064, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:42:31.000Z", "contentLength": 291064, "httpStatusCode": 200}	401f0f48-8831-4445-ae8a-3169ee7d0861	\N	{}
70231396-2a73-420a-9926-266379d9e047	uploads	product-1777103050509.webp	\N	2026-04-25 07:44:11.216365+00	2026-04-25 07:44:11.216365+00	2026-04-25 07:44:11.216365+00	{"eTag": "\\"c2a1a1a1013a5732c858637cf97464ee\\"", "size": 259940, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:44:12.000Z", "contentLength": 259940, "httpStatusCode": 200}	6e54d5e2-6043-45ea-ae60-c805055a0bd0	\N	{}
84f39ff3-3e3f-4707-9b69-49d00a154343	uploads	the-indigo-batik-story--1777109386093.webp	\N	2026-04-25 09:29:46.590922+00	2026-04-25 09:29:46.590922+00	2026-04-25 09:29:46.590922+00	{"eTag": "\\"3b5bd851a84a210b569e92dea05b1b25\\"", "size": 396760, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T09:29:47.000Z", "contentLength": 396760, "httpStatusCode": 200}	53b4c04a-8dce-4d4e-b572-5daaf0339cb6	\N	{}
04b8dd54-6738-48db-907b-48434410b682	uploads	product-1777103051366.webp	\N	2026-04-25 07:44:12.051556+00	2026-04-25 07:44:12.051556+00	2026-04-25 07:44:12.051556+00	{"eTag": "\\"404ddace9168857cf34e8cac147f05f8\\"", "size": 332638, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:44:13.000Z", "contentLength": 332638, "httpStatusCode": 200}	addf8870-bea5-4234-bbff-002634ae65b5	\N	{}
d30fa2c3-c948-4fcc-8fff-9b9ee8bdcc82	uploads	product-1777103052193.webp	\N	2026-04-25 07:44:12.521002+00	2026-04-25 07:44:12.521002+00	2026-04-25 07:44:12.521002+00	{"eTag": "\\"ac687d5c940e0c9f7538df4f32ab5203\\"", "size": 311080, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:44:13.000Z", "contentLength": 311080, "httpStatusCode": 200}	f0dc90ba-61f9-4f9e-99fe-e09d5f111168	\N	{}
47c3b984-4070-41f8-af40-e40768b134c6	uploads	product-1777103052658.webp	\N	2026-04-25 07:44:12.908088+00	2026-04-25 07:44:12.908088+00	2026-04-25 07:44:12.908088+00	{"eTag": "\\"552c25e9bb6393b6068af02c1552b545\\"", "size": 208164, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:44:13.000Z", "contentLength": 208164, "httpStatusCode": 200}	4bd22e94-af3e-4064-abaa-4b0809698abb	\N	{}
8e129970-bf7c-4d4c-91d0-b3fade8505a0	uploads	product-1777103053044.webp	\N	2026-04-25 07:44:13.379973+00	2026-04-25 07:44:13.379973+00	2026-04-25 07:44:13.379973+00	{"eTag": "\\"4d3b333a1cde23f3f9499b76fa3ec0ec\\"", "size": 308838, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:44:14.000Z", "contentLength": 308838, "httpStatusCode": 200}	9d8da712-272b-42b9-ad6d-0cf28e7fafe6	\N	{}
5539c066-b8f7-4d4b-8395-c78530ce26a7	uploads	product-1777103053511.webp	\N	2026-04-25 07:44:13.761308+00	2026-04-25 07:44:13.761308+00	2026-04-25 07:44:13.761308+00	{"eTag": "\\"bad981d12b201b705747c4fdb39c56b7\\"", "size": 98098, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:44:14.000Z", "contentLength": 98098, "httpStatusCode": 200}	1196464b-47f4-44c7-b74d-6d2d5047e60c	\N	{}
19a50288-669c-45dd-af57-be7d6c86cd5f	uploads	product-1777103053891.webp	\N	2026-04-25 07:44:14.144887+00	2026-04-25 07:44:14.144887+00	2026-04-25 07:44:14.144887+00	{"eTag": "\\"dd43b93e106333698f6b20dcd2c8fec7\\"", "size": 222434, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T07:44:15.000Z", "contentLength": 222434, "httpStatusCode": 200}	b307017c-26c4-4662-8796-36c2af09c8f5	\N	{}
85dc03d8-f4a0-46ba-81b8-a1df2b5e21c8	uploads	product-1777118605629.webp	\N	2026-04-25 12:03:26.512747+00	2026-04-25 12:03:26.512747+00	2026-04-25 12:03:26.512747+00	{"eTag": "\\"6c19bfcb2ea5ffad741d792887f9ba86\\"", "size": 530268, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T12:03:27.000Z", "contentLength": 530268, "httpStatusCode": 200}	9c1b3f9d-08cd-4e1b-9a70-b7d973e2ad37	\N	{}
fdfdfce3-2bee-41ff-a1af-09e3c074d313	uploads	product-1777118606695.webp	\N	2026-04-25 12:03:27.626915+00	2026-04-25 12:03:27.626915+00	2026-04-25 12:03:27.626915+00	{"eTag": "\\"849f0aaba3b0f7f8ad78febde6dc86a7\\"", "size": 432004, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T12:03:28.000Z", "contentLength": 432004, "httpStatusCode": 200}	05b81377-75f1-4047-8a2b-5f6dc06fa99c	\N	{}
823f11b2-06f9-44f8-aafa-fd6584d5eb76	uploads	product-1777118607828.webp	\N	2026-04-25 12:03:28.229644+00	2026-04-25 12:03:28.229644+00	2026-04-25 12:03:28.229644+00	{"eTag": "\\"23ab0b56d2d21f3aa72802e956c6e2db\\"", "size": 620278, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T12:03:29.000Z", "contentLength": 620278, "httpStatusCode": 200}	6f11f490-db27-4fbb-8cbe-cee2a80b6f81	\N	{}
bc312809-3433-4060-9d04-ab6f34744b9e	uploads	product-1777118608426.webp	\N	2026-04-25 12:03:29.298302+00	2026-04-25 12:03:29.298302+00	2026-04-25 12:03:29.298302+00	{"eTag": "\\"4f7fb863ca423a5ec173dedc6fcf6898\\"", "size": 559998, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T12:03:30.000Z", "contentLength": 559998, "httpStatusCode": 200}	7eab4eb4-c6fc-4862-a6bc-7af6db56a50a	\N	{}
c6c19b33-40e9-49a4-b434-76a12d4d9d4e	uploads	product-1777118609493.webp	\N	2026-04-25 12:03:29.844502+00	2026-04-25 12:03:29.844502+00	2026-04-25 12:03:29.844502+00	{"eTag": "\\"4bb11e7be6718f3b09d3052841c5c1fe\\"", "size": 378982, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T12:03:30.000Z", "contentLength": 378982, "httpStatusCode": 200}	503875ed-fabd-4349-ae1d-a389203165c8	\N	{}
056e3754-c637-4822-9762-c2e38e837d30	uploads	product-1777118610046.webp	\N	2026-04-25 12:03:30.569201+00	2026-04-25 12:03:30.569201+00	2026-04-25 12:03:30.569201+00	{"eTag": "\\"de08bca98741198f05249aa5428e0e16\\"", "size": 541738, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T12:03:31.000Z", "contentLength": 541738, "httpStatusCode": 200}	ef4fd60c-204d-4d0b-bb9d-cc41fb5371ab	\N	{}
513af02b-4262-4c57-ac3b-13d99f0d527c	uploads	product-1777118610773.webp	\N	2026-04-25 12:03:31.155598+00	2026-04-25 12:03:31.155598+00	2026-04-25 12:03:31.155598+00	{"eTag": "\\"1cea25d35ff93369a00870b53e24843f\\"", "size": 752510, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-25T12:03:32.000Z", "contentLength": 752510, "httpStatusCode": 200}	e701d7b2-64b5-43a6-88ed-99195af575c7	\N	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 151, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: Address Address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Address"
    ADD CONSTRAINT "Address_pkey" PRIMARY KEY (id);


--
-- Name: Admin Admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Admin"
    ADD CONSTRAINT "Admin_pkey" PRIMARY KEY (id);


--
-- Name: Banner Banner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Banner"
    ADD CONSTRAINT "Banner_pkey" PRIMARY KEY (id);


--
-- Name: Category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);


--
-- Name: Collection Collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Collection"
    ADD CONSTRAINT "Collection_pkey" PRIMARY KEY (id);


--
-- Name: ContactMessage ContactMessage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ContactMessage"
    ADD CONSTRAINT "ContactMessage_pkey" PRIMARY KEY (id);


--
-- Name: Coupon Coupon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Coupon"
    ADD CONSTRAINT "Coupon_pkey" PRIMARY KEY (id);


--
-- Name: Customer Customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Customer"
    ADD CONSTRAINT "Customer_pkey" PRIMARY KEY (id);


--
-- Name: GlobalSetting GlobalSetting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."GlobalSetting"
    ADD CONSTRAINT "GlobalSetting_pkey" PRIMARY KEY (id);


--
-- Name: MobileOtp MobileOtp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MobileOtp"
    ADD CONSTRAINT "MobileOtp_pkey" PRIMARY KEY (id);


--
-- Name: OrderActivity OrderActivity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderActivity"
    ADD CONSTRAINT "OrderActivity_pkey" PRIMARY KEY (id);


--
-- Name: OrderItem OrderItem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_pkey" PRIMARY KEY (id);


--
-- Name: Order Order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_pkey" PRIMARY KEY (id);


--
-- Name: ProductVariant ProductVariant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ProductVariant"
    ADD CONSTRAINT "ProductVariant_pkey" PRIMARY KEY (id);


--
-- Name: Product Product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_pkey" PRIMARY KEY (id);


--
-- Name: Profile Profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profile"
    ADD CONSTRAINT "Profile_pkey" PRIMARY KEY (id);


--
-- Name: ReturnRequest ReturnRequest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ReturnRequest"
    ADD CONSTRAINT "ReturnRequest_pkey" PRIMARY KEY (id);


--
-- Name: Review Review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Review"
    ADD CONSTRAINT "Review_pkey" PRIMARY KEY (id);


--
-- Name: Sale Sale_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sale"
    ADD CONSTRAINT "Sale_pkey" PRIMARY KEY (id);


--
-- Name: Shipment Shipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Shipment"
    ADD CONSTRAINT "Shipment_pkey" PRIMARY KEY (id);


--
-- Name: _CategoryToProduct _CategoryToProduct_AB_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CategoryToProduct"
    ADD CONSTRAINT "_CategoryToProduct_AB_pkey" PRIMARY KEY ("A", "B");


--
-- Name: _CollectionToProduct _CollectionToProduct_AB_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CollectionToProduct"
    ADD CONSTRAINT "_CollectionToProduct_AB_pkey" PRIMARY KEY ("A", "B");


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: Address_pincode_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Address_pincode_idx" ON public."Address" USING btree (pincode);


--
-- Name: Admin_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Admin_email_key" ON public."Admin" USING btree (email);


--
-- Name: Banner_createdAt_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Banner_createdAt_idx" ON public."Banner" USING btree ("createdAt");


--
-- Name: Banner_isActive_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Banner_isActive_idx" ON public."Banner" USING btree ("isActive");


--
-- Name: Category_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Category_name_key" ON public."Category" USING btree (name);


--
-- Name: Collection_createdAt_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Collection_createdAt_idx" ON public."Collection" USING btree ("createdAt");


--
-- Name: Collection_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Collection_name_idx" ON public."Collection" USING btree (name);


--
-- Name: Collection_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Collection_name_key" ON public."Collection" USING btree (name);


--
-- Name: Collection_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Collection_order_idx" ON public."Collection" USING btree ("order");


--
-- Name: Coupon_code_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Coupon_code_idx" ON public."Coupon" USING btree (code);


--
-- Name: Coupon_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Coupon_code_key" ON public."Coupon" USING btree (code);


--
-- Name: Coupon_isActive_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Coupon_isActive_idx" ON public."Coupon" USING btree ("isActive");


--
-- Name: Customer_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Customer_email_key" ON public."Customer" USING btree (email);


--
-- Name: Customer_mobile_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Customer_mobile_key" ON public."Customer" USING btree (mobile);


--
-- Name: MobileOtp_expiresAt_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "MobileOtp_expiresAt_idx" ON public."MobileOtp" USING btree ("expiresAt");


--
-- Name: MobileOtp_mobile_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "MobileOtp_mobile_key" ON public."MobileOtp" USING btree (mobile);


--
-- Name: OrderActivity_orderId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "OrderActivity_orderId_idx" ON public."OrderActivity" USING btree ("orderId");


--
-- Name: Order_invoiceNumber_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Order_invoiceNumber_key" ON public."Order" USING btree ("invoiceNumber");


--
-- Name: Order_razorpayOrderId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Order_razorpayOrderId_key" ON public."Order" USING btree ("razorpayOrderId");


--
-- Name: Order_razorpayPaymentId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Order_razorpayPaymentId_key" ON public."Order" USING btree ("razorpayPaymentId");


--
-- Name: Product_createdAt_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Product_createdAt_idx" ON public."Product" USING btree ("createdAt");


--
-- Name: Product_handle_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Product_handle_key" ON public."Product" USING btree (handle);


--
-- Name: Product_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Product_name_key" ON public."Product" USING btree (name);


--
-- Name: Product_price_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Product_price_idx" ON public."Product" USING btree (price);


--
-- Name: Profile_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Profile_email_key" ON public."Profile" USING btree (email);


--
-- Name: ReturnRequest_orderId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ReturnRequest_orderId_idx" ON public."ReturnRequest" USING btree ("orderId");


--
-- Name: ReturnRequest_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ReturnRequest_status_idx" ON public."ReturnRequest" USING btree (status);


--
-- Name: Shipment_awb_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Shipment_awb_idx" ON public."Shipment" USING btree (awb);


--
-- Name: Shipment_awb_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Shipment_awb_key" ON public."Shipment" USING btree (awb);


--
-- Name: Shipment_orderId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Shipment_orderId_idx" ON public."Shipment" USING btree ("orderId");


--
-- Name: Shipment_orderId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Shipment_orderId_key" ON public."Shipment" USING btree ("orderId");


--
-- Name: Shipment_shipmentId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Shipment_shipmentId_key" ON public."Shipment" USING btree ("shipmentId");


--
-- Name: Shipment_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Shipment_status_idx" ON public."Shipment" USING btree (status);


--
-- Name: _CategoryToProduct_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_CategoryToProduct_B_index" ON public."_CategoryToProduct" USING btree ("B");


--
-- Name: _CollectionToProduct_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_CollectionToProduct_B_index" ON public."_CollectionToProduct" USING btree ("B");


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: Address Address_customerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Address"
    ADD CONSTRAINT "Address_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES public."Customer"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OrderActivity OrderActivity_orderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderActivity"
    ADD CONSTRAINT "OrderActivity_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OrderItem OrderItem_orderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: OrderItem OrderItem_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Order Order_customerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES public."Customer"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ProductVariant ProductVariant_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ProductVariant"
    ADD CONSTRAINT "ProductVariant_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ReturnRequest ReturnRequest_orderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ReturnRequest"
    ADD CONSTRAINT "ReturnRequest_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Review Review_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Review"
    ADD CONSTRAINT "Review_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Sale Sale_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sale"
    ADD CONSTRAINT "Sale_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CategoryToProduct _CategoryToProduct_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CategoryToProduct"
    ADD CONSTRAINT "_CategoryToProduct_A_fkey" FOREIGN KEY ("A") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CategoryToProduct _CategoryToProduct_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CategoryToProduct"
    ADD CONSTRAINT "_CategoryToProduct_B_fkey" FOREIGN KEY ("B") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CollectionToProduct _CollectionToProduct_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CollectionToProduct"
    ADD CONSTRAINT "_CollectionToProduct_A_fkey" FOREIGN KEY ("A") REFERENCES public."Collection"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CollectionToProduct _CollectionToProduct_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CollectionToProduct"
    ADD CONSTRAINT "_CollectionToProduct_B_fkey" FOREIGN KEY ("B") REFERENCES public."Product"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles Users can read own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can read own profile" ON public.profiles FOR SELECT USING ((auth.uid() = id));


--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict KvXnwJZ5caEqHs8j1AkEq0L4rcc9EKYdrH9cH5iOyhdb660Kjy8OCv20c5BYHcT

