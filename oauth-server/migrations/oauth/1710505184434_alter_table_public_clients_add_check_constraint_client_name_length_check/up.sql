alter table "public"."clients" add constraint "client_name_length_check" check (length(name) <= 140);
