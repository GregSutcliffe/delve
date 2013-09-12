# Delve

**Delve** is a Ruby-on-Rails webapp that aims to help you manage you documents.
No more delving into boxes full of paper! Delve is strongly inspired/influenced
by [OpenDIAS](http://opendias.essentialcollections.co.uk).

Delve is under initial development, and can't do very much yet, but you can view the
TODO section for some of the things we have planned.

# TODO

## Needs tests

* models for Page and Scanner
* find and scan from local scanner
* display stored images

## Short term goals

* Make it look better
* Add settings system
  * Global
    1. Scans location
    2. Default Scanner
  * Per-Scanner
    1. Scan Resolution
    2. Greyscale vs colour
* Quick Acquire via default scanner

## Longer term

* Import from image
* import from pdf
* Rotate images
* OCR images

* Model for Document
  * Associate Pages into Documents
* Re-perform OCR on an image
* Search forms
* Tags
* Image hashing with PHash

## Nice-to-have

* Export image+text as hidden-text embedded PDF

# Copyright

Copyright (c) 2012-2013 Greg Sutcliffe

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.