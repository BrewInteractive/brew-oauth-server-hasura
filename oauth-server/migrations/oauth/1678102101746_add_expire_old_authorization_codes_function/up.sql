CREATE OR REPLACE FUNCTION public.expire_old_authorization_codes()  
	RETURNS trigger   
	LANGUAGE plpgsql 
	AS 
$$
BEGIN
	UPDATE public.authorization_codes   
	SET used_at = NOW()    
	WHERE user_id = NEW.user_id AND used_at IS null;
	RETURN NEW;
END;
$$;
