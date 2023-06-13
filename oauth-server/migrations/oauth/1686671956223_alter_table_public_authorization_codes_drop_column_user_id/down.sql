alter table "public"."authorization_codes" alter column "user_id" drop not null;
alter table "public"."authorization_codes" add column "user_id" int8;
