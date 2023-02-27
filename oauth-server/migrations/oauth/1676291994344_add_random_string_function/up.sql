CREATE OR REPLACE FUNCTION public.random_string(length integer, additionalchars text DEFAULT ''::text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
  declare chars text = additionalChars || 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  _result text := '';
  i integer;
begin
  FOR i IN 1..length LOOP
    _result := _result || substring(chars from (floor(random() * char_length(chars)) + 1)::integer for 1);
  END LOOP;
  RETURN _result;
END;
$function$
;
