alter table "public"."authorization_codes"
  add constraint "authorization_codes_client_id_fkey"
  foreign key (client_id)
  references "public"."clients"
  (id) on update restrict on delete restrict;
alter table "public"."authorization_codes" alter column "client_id" drop not null;
alter table "public"."authorization_codes" add column "client_id" uuid;
