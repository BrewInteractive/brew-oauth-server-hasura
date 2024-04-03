ALTER TABLE clients
ADD CONSTRAINT no_forbidden_characters
CHECK (check_forbidden_characters(name) IS FALSE);
