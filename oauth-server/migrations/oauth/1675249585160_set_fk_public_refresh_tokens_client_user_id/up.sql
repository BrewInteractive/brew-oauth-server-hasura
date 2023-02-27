alter table "public"."refresh_tokens"
  add constraint "refresh_tokens_client_user_id_fkey"
  foreign key ("client_user_id")
  references "public"."clients_users"
  ("id") on update cascade on delete cascade;
