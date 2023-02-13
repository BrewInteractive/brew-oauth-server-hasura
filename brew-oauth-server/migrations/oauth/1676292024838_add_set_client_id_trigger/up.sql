create trigger set_client_id_trigger before
insert
    on
    public.clients for each row execute function set_client_id();
