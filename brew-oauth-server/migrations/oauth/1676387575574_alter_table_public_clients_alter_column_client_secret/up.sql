alter table "public"."clients" alter column "client_secret" set default random_string(48,'-_');
