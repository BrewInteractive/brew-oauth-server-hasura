alter table "public"."grants"
  add constraint "grants_response_type_fkey"
  foreign key ("response_type")
  references "public"."response_types"
  ("response_type") on update restrict on delete restrict;
