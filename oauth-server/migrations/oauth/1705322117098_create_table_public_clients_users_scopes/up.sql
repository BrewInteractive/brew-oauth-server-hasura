CREATE TABLE "public"."clients_users_scopes" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "client_user_id" uuid NOT NULL, "scope" text NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("client_user_id") REFERENCES "public"."clients_users"("id") ON UPDATE cascade ON DELETE cascade, FOREIGN KEY ("scope") REFERENCES "public"."scopes"("scope") ON UPDATE cascade ON DELETE cascade);
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
CREATE TRIGGER "set_public_clients_users_scopes_updated_at"
BEFORE UPDATE ON "public"."clients_users_scopes"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_clients_users_scopes_updated_at" ON "public"."clients_users_scopes"
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE EXTENSION IF NOT EXISTS pgcrypto;
