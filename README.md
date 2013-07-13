# PSD EngineData

Adobe thought it would be cool to create their own markup language for text data embedded within a Photoshop document. I've taken the liberty of calling it EngineData since that is the name used in the descriptor embedded within PSD files. This is a general purpose parser for that data.

## Installation

Add this line to your application's Gemfile:

    gem 'psd-enginedata'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install psd-enginedata

## Usage

``` ruby
# From File
parser = PSD::EngineData.load('path/to/file')

# From string
parser = PSD::EngineData.new(text)

# Parse it
parser.parse!

# Use it
puts parser.result.Editor.Text
```

## File Spec

The EngineData format uses certain characters to denote various data types. All newlines are denoted with a UNIX newline (\n) and it is not indentation-aware (although it seems to be stored with pretty indentation in the PSD file).

```
<<
  /EngineDict
  <<
    /Editor
    <<
      /Text (˛ˇMake a change and save.)
    >>
  >>
  /Font
  <<
    /Name (˛ˇHelveticaNeue-Light)
    /FillColor
    <<
      /Type 1
      /Values [ 1.0 0.0 0.0 0.0 ]
    >>
    /StyleSheetSet [
    <<
      /Name (˛ˇNormal RGB)
    >>
    ]
  >>
>>
```

There are 6 data types available to use:

* Dictionary/Hash
* Array (single or multi-line)
* Float
* Integer
* String
* Boolean

Altogether we have a non-turing complete markup language with some interesting quirks that was written in 1998 with the release of Photoshop 5.0 since it included the ability to edit text areas after they were created (before that, they were rasterized immediately).

### Property Names

Property names are started with a `/` followed by an alphanumeric word. The property value either comes after a space or a new line.

### Dictionaries/Hashes

Dictionaries are denoted by a property name (unless at the root), followed by a new line and the `<<` instruction. The end of a dictionary is denoted by the `>>` instruction.

A dictionary can contain any type of data including more dictionaries for nesting purposes. All values within a dictionary must have a property followed by a value of some kind.

### Arrays

Arrays come in two flavors: single-line or multi-line. Both are denoted by square brackets `[ ]`.

Single-line arrays can only hold number values (doubles or integers). While it wouldn't be out of the question for it to hold string or boolean values, this does not seem to appear in any tested Photoshop documents so we're going to assume it's not a part of the specification. Values in single-line arrays are **space delimited**. There seems to be a space between the opening and closing square brackets and the data, but we assume it's optional.

Multi-line arrays can contain any type of data. Values in multi-line arrays are newline-denoted. The opening bracket for multi-line arrays must occur on the same line as the property to which it belongs.

### Floats/Integers

Basically, numbers can be expressed with or without a decimal point. Floats are of the form `1.76`, but the non-fractional digits to the left of the decimal point are optional. Integers are just numbers with no commas or decimal points.

### Strings

Strings are delimited by parentheses with a cedilla-breve (thanks @robgrant for the terminology) at the start of the string. Since operations are UNIX newline (\n) delimited within the document, new lines in strings are denoted by carriage returns (\r).

### Booleans

Booleans are simply denoted by `true` or `false`. Pretty simple.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
