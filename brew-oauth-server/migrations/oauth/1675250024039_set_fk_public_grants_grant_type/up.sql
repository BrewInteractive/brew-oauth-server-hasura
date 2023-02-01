alter table "public"."grants"
  add constraint "grants_grant_type_fkey"
  foreign key ("grant_type")
  references "public"."grant_types"
  ("grant_type") on update restrict on delete restrict;
