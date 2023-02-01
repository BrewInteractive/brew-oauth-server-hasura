alter table "public"."refresh_tokens" alter column "client_id" drop not null;
alter table "public"."refresh_tokens" add column "client_id" uuid;
