CREATE OR REPLACE FUNCTION public.set_client_secret()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  random_string text;
BEGIN
  random_string = random_string(48,'-_');
  NEW.client_secret := random_string;
  RETURN NEW;
END;
$function$
;
