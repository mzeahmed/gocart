package main

import (
	"log/slog"
	"os"
)

func main() {
	cfg := Config{
		addr: ":8080",
		db: DbConfig{
			dsn: "postgres://user:password@localhost:5432/dbname?sslmode=disable",
		},
	}

	app := Application{
		Config: cfg,
	}
	handler := app.Mount()

	// logger
	logger := slog.New(slog.NewTextHandler(os.Stdout, nil))

	slog.SetDefault(logger)

	if err := app.Run(handler); err != nil {
		slog.Error("failed to run server", "error", err)
		os.Exit(1)
	}
}
