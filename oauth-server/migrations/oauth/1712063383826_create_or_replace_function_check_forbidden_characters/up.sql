CREATE OR REPLACE FUNCTION check_forbidden_characters(input_string TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (input_string ~* '[|&;$%@''"<>()+\\,]')
           OR (input_string ~* E'[\\n\\r]+');
END;
$$ LANGUAGE plpgsql;
