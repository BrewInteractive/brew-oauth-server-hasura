SET check_function_bodies = false;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE FUNCTION public.user_id_generator(OUT result bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
	our_epoch bigint := 857736000000; -- change as needed
	seq_id bigint;
	now_millis bigint;
	-- the id of this DB shard, must be set for each
	-- schema shard you have - you could pass this as a parameter too
	shard_id int := 1;
BEGIN
	SELECT nextval('public.user_id_sequence') % 1024 INTO seq_id;
	SELECT FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) INTO now_millis;
	result := (now_millis - our_epoch) << 23;
	result := result | (shard_id << 10);
	result := result | (seq_id);
END;
$$;
CREATE TABLE public.clients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    token_expires_in_minutes integer NOT NULL,
    refresh_token_expires_in_days integer NOT NULL
);
CREATE TABLE public.clients_grants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id uuid NOT NULL,
    grant_id integer NOT NULL,
    audience text
);
CREATE TABLE public.clients_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id uuid NOT NULL,
    user_id bigint NOT NULL
);
CREATE TABLE public.grant_types (
    grant_type text NOT NULL
);
CREATE TABLE public.grants (
    id integer NOT NULL,
    name text NOT NULL,
    response_type text,
    grant_type text
);
CREATE SEQUENCE public.grants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.grants_id_seq OWNED BY public.grants.id;
CREATE TABLE public.redirect_uris (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id uuid NOT NULL,
    redirect_uri text NOT NULL
);
CREATE TABLE public.refresh_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    token text NOT NULL,
    revoked_at timestamp with time zone NOT NULL,
    replaced_by_token_id uuid NOT NULL,
    user_id bigint NOT NULL,
    client_id uuid NOT NULL,
    CONSTRAINT expires_at_check CHECK ((expires_at > created_at))
);
CREATE TABLE public.response_types (
    response_type text NOT NULL
);
CREATE SEQUENCE public.user_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE ONLY public.grants ALTER COLUMN id SET DEFAULT nextval('public.grants_id_seq'::regclass);
ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_client_id_key UNIQUE (client_id);
ALTER TABLE ONLY public.clients_grants
    ADD CONSTRAINT clients_grants_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.clients_users
    ADD CONSTRAINT clients_users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.grant_types
    ADD CONSTRAINT grant_types_pkey PRIMARY KEY (grant_type);
ALTER TABLE ONLY public.grants
    ADD CONSTRAINT grants_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT redirect_uris_client_id_redirect_uri_key UNIQUE (client_id, redirect_uri);
ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT redirect_uris_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_key UNIQUE (token);
ALTER TABLE ONLY public.response_types
    ADD CONSTRAINT response_types_pkey PRIMARY KEY (response_type);
CREATE TRIGGER set_public_clients_grants_updated_at BEFORE UPDATE ON public.clients_grants FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_clients_grants_updated_at ON public.clients_grants IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_clients_updated_at BEFORE UPDATE ON public.clients FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_clients_updated_at ON public.clients IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_clients_users_updated_at BEFORE UPDATE ON public.clients_users FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_clients_users_updated_at ON public.clients_users IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_redirect_uris_updated_at BEFORE UPDATE ON public.redirect_uris FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_redirect_uris_updated_at ON public.redirect_uris IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_refresh_tokens_updated_at BEFORE UPDATE ON public.refresh_tokens FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_refresh_tokens_updated_at ON public.refresh_tokens IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.clients_grants
    ADD CONSTRAINT clients_grants_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.clients_grants
    ADD CONSTRAINT clients_grants_grant_id_fkey FOREIGN KEY (grant_id) REFERENCES public.grants(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.clients_users
    ADD CONSTRAINT clients_users_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.grants
    ADD CONSTRAINT grants_response_type_fkey FOREIGN KEY (response_type) REFERENCES public.response_types(response_type) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT redirect_uris_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_replaced_token_id_fkey FOREIGN KEY (replaced_by_token_id) REFERENCES public.refresh_tokens(id) ON UPDATE SET NULL ON DELETE SET NULL;
