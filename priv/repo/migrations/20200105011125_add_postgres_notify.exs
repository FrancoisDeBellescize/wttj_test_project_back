defmodule Wttj.Repo.Migrations.AddPostgresNotify do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION notify_persons_changes()
      RETURNS trigger AS $$
      DECLARE
        current_row RECORD;
      BEGIN
        IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
          current_row := NEW;
        ELSE
          current_row := OLD;
        END IF;
        PERFORM pg_notify(
          'persons_changes',
          json_build_object(
            'table', TG_TABLE_NAME,
            'type', TG_OP,
            'id', current_row.id,
            'data', row_to_json(current_row)
          )::text
        );
        RETURN current_row;
      END;
      $$ LANGUAGE plpgsql;
    """
  end

  def down do
    execute """
      DROP FUNCTION notify_persons_changes;
    """
  end
end
