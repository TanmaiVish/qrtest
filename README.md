# Tests to benchmark processing speed of processing, and accuracy of various C
# QR scanning libraries

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

## Example

    --------------
    quirc: number of QR codes: 1
    Data: cheeseface
    [ 00 ] 0 s 191171 us
    --------------
    zbar: decoded QR-Code symbol "cheeseface"
    [ 01 ] 1 s 281484 us
    --------------
    quirc: number of QR codes: 1
    Data: cheeseface
    [ 00 ] 0 s 191326 us
    --------------
    zbar: decoded QR-Code symbol "cheeseface"
    [ 01 ] 1 s 281767 us
    --------------
    quirc: number of QR codes: 1
    Data: cheeseface
    [ 00 ] 0 s 191099 us
    --------------
    zbar: decoded QR-Code symbol "cheeseface"
    [ 01 ] 1 s 283005 us
    ================
    averages:
    00	0.502441s	speedup: 2.23617
    01	1.12354s	speedup: 1
