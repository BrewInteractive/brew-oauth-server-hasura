alter table "public"."clients_users_scopes" add constraint "clients_users_scopes_client_user_id_scope_key" unique ("client_user_id", "scope");
