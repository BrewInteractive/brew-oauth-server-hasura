CREATE
OR REPLACE VIEW "public"."refresh_tokens__active" AS
SELECT
  refresh_tokens.id,
  refresh_tokens.created_at,
  refresh_tokens.updated_at,
  refresh_tokens.token,
  refresh_tokens.client_user_id,
  refresh_tokens.expires_at,
  refresh_tokens.scope
FROM
  refresh_tokens
WHERE
  (
    (refresh_tokens.revoked_at IS NOT NULL)
    OR (refresh_tokens.replaced_by_token_id IS NOT NULL)
    OR (refresh_tokens.expires_at <= now())
  );
