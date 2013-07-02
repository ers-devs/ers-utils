Getting started
===============

To get the XO development setup utility, use the following from the terminal:

    wget https://raw.github.com/ers-devs/ers-utils/master/xo_setup/xo_setup.sh
    chmod a+x ./xo_setup.sh

Then just run `./xo_setup.sh` for further instructions.

You only need to do this once - the script has a command for automatically
getting updated versions of itself from upstream.

About site-packages
===================

The `site-packages.tar` archive contains all Python libraries that, for one
reason or another, cannot be installed normally using `pip` or `yum`. As such,
we keep a snapshot of these and just copy them to the `site-packages` folder
directly.

An explanation should be included for each package herein:

- `avahi` and `avahi_discover`: Not found on PyPi. Not available via `yum` for
  the Fedora distribution used by the XO.
- `http_parser`: Can be installed using `pip` but calls `gcc` during install.
  This package is required by `couchdbkit`.