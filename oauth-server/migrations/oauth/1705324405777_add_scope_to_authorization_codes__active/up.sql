CREATE
OR REPLACE VIEW "public"."authorization_codes__active" AS
SELECT
  authorization_codes.id,
  authorization_codes.client_user_id,
  authorization_codes.redirect_uri,
  authorization_codes.code,
  authorization_codes.expires_at,
  authorization_codes.used_at,
  authorization_codes.created_at,
  authorization_codes.updated_at,
  authorization_codes.scope
FROM
  authorization_codes
WHERE
  (
    (authorization_codes.used_at IS NULL)
    AND (authorization_codes.expires_at > now())
  );
