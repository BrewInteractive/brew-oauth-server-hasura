CREATE EXTENSION IF NOT EXISTS pgcrypto;
alter table "public"."web_origins" add column "id" uuid
 not null default gen_random_uuid();
