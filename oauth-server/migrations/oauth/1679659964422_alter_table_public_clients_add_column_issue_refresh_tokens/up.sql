alter table "public"."clients" add column "issue_refresh_tokens" boolean
 not null default 'false';
