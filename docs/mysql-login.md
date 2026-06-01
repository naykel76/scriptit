# MySQL Login

Use `dblogin` to SSH into the Forge server and open an interactive MySQL session
or run a single SQL command without leaving your terminal.

## Prerequisites

Ensure `DBASE_USER` and `DBASE_PWD` are set in your `.env` file:

```bash +code
DBASE_USER=forge
DBASE_PWD=your_database_password
```

## Usage

-------------------------------------------------------------------------------

**Step 1 — Run the script**

```bash +code
dblogin
```

-------------------------------------------------------------------------------

**Step 2 — Select a database**

```bash +code
Select database:
  1) fol_dbase
  2) fol_dev_dbase
  3) dev_dbase
  4) Other (enter manually)
Choice [1]:
```

Press `Enter` to use the default, or type a number. Choose **Other** to type a
database name manually.

-------------------------------------------------------------------------------

**Step 3 — Choose a mode**

```bash +code
Mode:
  1) Interactive session (default)
  2) Run a single SQL command
Choice [1]:
```

- **Interactive session** — opens a live `mysql>` prompt on the server. Type
  SQL freely and exit with `quit` or `Ctrl+D`.
- **Single SQL command** — prompts for one query, runs it, prints the result,
  and exits.

## Example SQL Commands

List all tables:

```bash +code
SHOW TABLES;
```

Inspect a table's structure:

```bash +code
DESCRIBE users;
```

Query with a filter:

```bash +code
SELECT id, email, created_at FROM users WHERE id = 1;
```

Count rows:

```bash +code
SELECT COUNT(*) FROM courses;
```
