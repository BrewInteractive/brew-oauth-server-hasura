alter table "public"."refresh_tokens" alter column "user_id" drop not null;
alter table "public"."refresh_tokens" add column "user_id" int8;
