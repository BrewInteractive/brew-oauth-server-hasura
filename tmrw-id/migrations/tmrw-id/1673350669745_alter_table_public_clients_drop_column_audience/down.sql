alter table "public"."clients" alter column "audience" drop not null;
alter table "public"."clients" add column "audience" text;
