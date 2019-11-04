package main

import (
	"fmt"
	"github.com/labstack/echo/v4"
	"net/http"
)

func main() {

	fmt.Println("|  _  _  _| _  _ . _ ")
	fmt.Println("|_(_)(_|(_|(/_| .|(_) v1.0")

	// Echo instance
	e := echo.New()
	e.HideBanner = true

	// Routes
	e.GET("/loaderio*", hLoaderio)
	e.GET("/", hIndex)
	e.Static("/static", "static")
	// Start server
	e.Logger.Fatal(e.Start(":80"))
}

// Loaderio Handler
func hLoaderio(c echo.Context) error {
	message := c.Param("*")
	if message[len(message)-1:] == "/" {
		message = message[0 : len(message)-1]
	}
	return c.String(http.StatusOK, "loaderio"+message)
}

// Index Handler
func hIndex(c echo.Context) error {
	return c.String(http.StatusOK, "loader.io test.")
}
