CREATE OR REPLACE FUNCTION public.expire_old_authorization_codes()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    new_user_id int8;
BEGIN
	SELECT user_id INTO new_user_id
    FROM public.clients_users 
    WHERE id = NEW.client_user_id;
   
   UPDATE public.authorization_codes ac
	SET used_at = NOW()
	FROM public.clients_users cu
	WHERE ac.client_user_id = cu.id
	    AND cu.user_id = user_id
	    AND ac.used_at IS NULL;
   
    RETURN NEW;
END;
$function$
;
