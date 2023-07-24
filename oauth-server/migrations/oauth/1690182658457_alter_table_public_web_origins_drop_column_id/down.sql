comment on column "public"."web_origins"."id" is E'Client web origins for applying CORS policy.';
alter table "public"."web_origins" alter column "id" set default nextval('web_origins_id_seq'::regclass);
alter table "public"."web_origins" alter column "id" drop not null;
alter table "public"."web_origins" add column "id" int8;
