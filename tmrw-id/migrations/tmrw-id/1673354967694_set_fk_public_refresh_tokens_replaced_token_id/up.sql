alter table "public"."refresh_tokens"
  add constraint "refresh_tokens_replaced_token_id_fkey"
  foreign key ("replaced_token_id")
  references "public"."refresh_tokens"
  ("id") on update set null on delete set null;
