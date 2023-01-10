CREATE SEQUENCE IF NOT EXISTS "public"."user_id_sequence";

CREATE OR REPLACE FUNCTION "public"."user_id_generator"(OUT result bigint) AS $$
DECLARE
	our_epoch bigint := 857736000000; -- change as needed
	seq_id bigint;
	now_millis bigint;
	-- the id of this DB shard, must be set for each
	-- schema shard you have - you could pass this as a parameter too
	shard_id int := 1;
BEGIN
	SELECT nextval('public.user_id_sequence') % 1024 INTO seq_id;

	SELECT FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) INTO now_millis;
	result := (now_millis - our_epoch) << 23;
	result := result | (shard_id << 10);
	result := result | (seq_id);
END;
$$ LANGUAGE PLPGSQL;
