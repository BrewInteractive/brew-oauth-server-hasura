alter table "public"."clients_scopes" add constraint "clients_scopes_client_id_scope_key" unique ("client_id", "scope");
