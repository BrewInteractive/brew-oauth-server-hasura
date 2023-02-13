create trigger set_client_secret_trigger before
insert
    on
    public.clients for each row execute function set_client_secret();
