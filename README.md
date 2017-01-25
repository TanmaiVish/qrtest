# Tests to benchmark processing speed and accuracy of various C QR scanning
# libraries

## Usage - speed test

 - (optional) build with `make all`
 - run tests with `make run`
 - results are stored in `./out`

## Usage - accuracy tests

 - (optional) `make all`
 - `make accuracy-report.md`

## Dependencies

 - libzbar-dev
 - imagemagick
 - qrencode
 - lua (version?)

## QR libs currently tested

 - quirc [https://github.com/dlbeer/quirc](https://github.com/dlbeer/quirc)
 - Zbar [http://zbar.sourceforge.net/](http://zbar.sourceforge.net/)
