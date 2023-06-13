alter table "public"."authorization_codes"
  add constraint "authorization_codes_client_user_id_fkey"
  foreign key ("client_user_id")
  references "public"."clients_users"
  ("id") on update restrict on delete restrict;
