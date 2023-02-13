CREATE OR REPLACE FUNCTION public.set_client_id()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  random_string text;
BEGIN
  random_string = random_string(32);
  NEW.client_id := random_string;
  RETURN NEW;
END;
$function$
;
