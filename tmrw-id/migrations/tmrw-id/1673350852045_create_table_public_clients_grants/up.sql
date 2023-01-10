CREATE TABLE "public"."clients_grants" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "client_id" uuid NOT NULL, "grant_id" integer NOT NULL, "audience" text, PRIMARY KEY ("id") , FOREIGN KEY ("client_id") REFERENCES "public"."clients"("id") ON UPDATE cascade ON DELETE cascade, FOREIGN KEY ("grant_id") REFERENCES "public"."grants"("id") ON UPDATE restrict ON DELETE restrict);
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
CREATE TRIGGER "set_public_clients_grants_updated_at"
BEFORE UPDATE ON "public"."clients_grants"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_clients_grants_updated_at" ON "public"."clients_grants" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE EXTENSION IF NOT EXISTS pgcrypto;
