## Core

[![Build Status](https://travis-ci.org/Factlink/feedforward.svg?branch=master)](https://travis-ci.org/Factlink/feedforward) [![Dependency Status](https://gemnasium.com/Factlink/feedforward.svg)](https://gemnasium.com/Factlink/feedforward) [![Code Climate](https://codeclimate.com/github/Factlink/feedforward.png)](https://codeclimate.com/github/Factlink/feedforward) [![Code Climate](https://codeclimate.com/github/Factlink/feedforward/coverage.png)](https://codeclimate.com/github/Factlink/feedforward)

## Installation

For setting up the basic dependencies on your system, see:

https://github.com/Factlink/feedforward/wiki/Setting-up-a-developer-environment

Checkout this repo.

To install system level prerequisites, run `bin/bootstrap-mac` or `bin/bootstrap-linux` (or read those files to verify you've got everything)

Then you're basically set!

You can start feedforward by running

```
./start-all.sh
```

If you want more fine-grained control, the local db+bundler dependencies can be installed with `bin/bootstrap`, and the db without anything else can be started with `./start-db.sh` and the web-servers without the db or bootstrapping with `./start-web.sh`.

`./start-all.sh` avoids overheard by not running various bootstrap steps unnecessarily - to do so it compares sha1 hashes of the last executed code version with the current situation.  If every things go haywire, just delete `*.sha-cache` and everything will be re-bootstrapped.


Now open your browser and surf to http://localhost:3000

## Running the tests

`bundle exec rspec spec/unit spec; bundle exec rspec spec/acceptance spec/screenshots`

## Licensing

Copyright (c) 2011-2014 Kennisland and individual contributors. Dual Licensed under the EUPL V.1.1 and MIT, see [LICENSE.txt](LICENSE.txt) for the full license.
