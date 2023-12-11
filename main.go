package main

import (
   "github.com/astaxie/beego"
)

// HelloController handles requests for the "/hello" endpoint.
type HelloController struct {
   beego.Controller
}

// Get handles GET requests for the "/hello" endpoint.
func (c *HelloController) Get() {
   c.Ctx.WriteString("Hello, World!")
}

func main() {
   // Load the configuration from app.conf
   beego.LoadAppConfig("ini", "conf/app.conf")

   // Create an instance of the HelloController.
   helloController := &HelloController{}

   // Register the "/hello" endpoint with the HelloController.
   beego.Router("/hello", helloController)

   // Read the HTTP port from the configuration.
   httpPort, _ := beego.AppConfig.Int("httpport")

   // Set the HTTP server port.
   beego.BConfig.Listen.HTTPPort = httpPort

   // Start the Beego web server.
   beego.Run()
}
