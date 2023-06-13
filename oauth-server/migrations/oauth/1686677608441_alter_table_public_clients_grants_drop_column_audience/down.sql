alter table "public"."clients_grants" alter column "audience" drop not null;
alter table "public"."clients_grants" add column "audience" text;
