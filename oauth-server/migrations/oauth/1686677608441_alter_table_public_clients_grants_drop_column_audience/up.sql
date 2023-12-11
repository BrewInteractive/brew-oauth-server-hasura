alter table "public"."clients_grants" drop column "audience" cascade;
INSERT INTO "public"."grants"("name", "response_type", "grant_type") VALUES (E'Authorization Code', E'code', E'authorization_code');
INSERT INTO "public"."grants"("name", "response_type", "grant_type") VALUES (E'Refresh Token', E'code', E'refresh_token');

