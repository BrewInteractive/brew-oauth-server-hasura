alter table "public"."hooks"
  add constraint "hooks_hook_type_fkey"
  foreign key ("hook_type")
  references "public"."hook_types"
  ("hook_type") on update restrict on delete restrict;
