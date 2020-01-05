defmodule Wttj.Repo.Migrations.AddPostgresListen do
  use Ecto.Migration

  def up do
    execute """
      CREATE TRIGGER notify_persons_changes_trg
      AFTER INSERT OR UPDATE OR DELETE
      ON persons
      FOR EACH ROW
      EXECUTE PROCEDURE notify_persons_changes();
    """
  end

  def down do
    execute """
      DROP TRIGGER notify_persons_changes_trg ON persons;
    """
  end
end
