alter table "public"."clients_users" alter column "user_id" drop not null;
alter table "public"."clients_users" add column "user_id" int8;
