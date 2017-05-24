# ESC GPIO Scripts

Scripts to emit events on Raspberry PI GPIO changes and also act on commands.

Just copy the files at you configured dir or clone the repo:

    $ git clone https://github.com/projesc/gpio files/scripts/gpio

## Events

Event name is the change, the payload is the GPIO number.

```json
{"name":"gpio_is_in","payload":"2"}
{"name":"gpio_is_out","payload":"20"}
{"name":"gpio_is_high","payload":"8"}
{"name":"gpio_is_low","payload":"4"}
{"name":"gpio_2_direction_is","payload":"in"}
{"name":"gpio_2_value_is","payload":"high"}
```

## Commands

Will act on the commands to change direction or value of GPIO, where the command name is the change and the payload is the gpio number.

```json
{"name":"set_gpio_in","payload":"2"}
{"name":"set_gpio_out","payload":"20"}
{"name":"set_gpio_high","payload":"8"}
{"name":"set_gpio_low","payload":"4"}
```

## License

MIT

