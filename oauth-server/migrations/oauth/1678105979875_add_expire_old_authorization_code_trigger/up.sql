CREATE TRIGGER expire_old_authorization_code_trigger 
	BEFORE INSERT ON public.authorization_codes 
	FOR EACH ROW 
	EXECUTE PROCEDURE public.expire_old_authorization_codes();
