CREATE TABLE "public"."clients" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "client_id" text NOT NULL, "client_secret" text NOT NULL, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "audience" text NOT NULL, "token_expires_in_minutes" integer NOT NULL, "refresh_token_expires_in_days" integer NOT NULL, PRIMARY KEY ("id") , UNIQUE ("client_id"));
CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_clients_updated_at"
BEFORE UPDATE ON "public"."clients"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_clients_updated_at" ON "public"."clients" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE EXTENSION IF NOT EXISTS pgcrypto;
