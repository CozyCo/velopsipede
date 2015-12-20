Picycle
=======

Picycle runs on a Raspberry Pi and powers the rider's deploy experience.


### Development

#### Dependencies
- A ruby environment with `bundler`
- `dialog` unix tool. `brew install dialog` in OSX, should be installed on most unixen.

#### Usage
```
bundle install --without piface
bundle exec bin/picycle
```

### Production

- Runs on a Raspberry Pi with the Piface I/O board.
- Green LED on relay output 0
- Yellow LED on relay output 1
- Momentary magnetic proximity switch on input 0
- [Enable SPI Pins](http://www.piface.org.uk/guides/Install_PiFace_Software/Enabling_SPI/)

