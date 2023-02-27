alter table "public"."refresh_tokens"
  add constraint "refresh_tokens_client_id_fkey"
  foreign key ("client_id")
  references "public"."clients"
  ("id") on update cascade on delete cascade;
