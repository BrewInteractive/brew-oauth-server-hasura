CREATE TABLE "public"."redirect_uris" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "client_id" uuid NOT NULL, "redirect_uri" text NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("client_id") REFERENCES "public"."clients"("id") ON UPDATE cascade ON DELETE cascade, UNIQUE ("client_id", "redirect_uri"));
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
CREATE TRIGGER "set_public_redirect_uris_updated_at"
BEFORE UPDATE ON "public"."redirect_uris"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_redirect_uris_updated_at" ON "public"."redirect_uris" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE EXTENSION IF NOT EXISTS pgcrypto;
