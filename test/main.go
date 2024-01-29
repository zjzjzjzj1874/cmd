package main

import (
	"fmt"
	"github.com/zjzjzjzj1874/cmd/version"
	"os"

	"github.com/sirupsen/logrus"
	"github.com/urfave/cli"
)

var (
	Logger *logrus.Logger
	App    *cli.App
)

func main() {
	App = newApp()

	registerCommands(App)
	registerFlags(App)
	err := App.Run(os.Args)
	if err != nil {
		Logger.Fatal(err)
	}
}

func newApp() *cli.App {
	app := cli.NewApp()
	app.Name = "zj-cli"
	app.Usage = "个人常用工具命令行"
	app.Version = version.Version
	return app
}

// 注册 命令
func registerCommands(app *cli.App) {
	app.EnableBashCompletion = true
	app.Commands = []cli.Command{
		{
			Name:  "hello",
			Usage: "测试",
			Action: func(*cli.Context) error {
				fmt.Println("world!")
				return nil
			},
		},
	}
}

// 注册 Flags
func registerFlags(app *cli.App) {
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:   "key, k",
			Usage:  "账户 API `access_key`",
			EnvVar: "ACCESS_KEY",
		},
		cli.StringFlag{
			Name:   "secret, s",
			Usage:  "账户 API `access_key_secret`",
			EnvVar: "ACCESS_KEY_SECRET",
		},
	}
}
