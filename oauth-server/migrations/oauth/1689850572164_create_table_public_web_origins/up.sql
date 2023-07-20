CREATE TABLE "public"."web_origins" ("id" bigserial NOT NULL, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "client_id" uuid NOT NULL, "web_origin" text NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("client_id") REFERENCES "public"."clients"("id") ON UPDATE cascade ON DELETE cascade, UNIQUE ("client_id", "web_origin"));COMMENT ON TABLE "public"."web_origins" IS E'Client web origins for applying CORS policy.';
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
CREATE TRIGGER "set_public_web_origins_updated_at"
BEFORE UPDATE ON "public"."web_origins"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_web_origins_updated_at" ON "public"."web_origins"
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
