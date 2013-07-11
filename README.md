# PSD EngineData

Adobe thought it would be cool to create their own markup language for text data embedded within a Photoshop document. This is a general purpose parser for that data.

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

The EngineData format uses certain characters to denote various data types. All newlines are denoted with a UNIX newline (\n) and it is not indentation-aware. New lines within String values are denoted with carriage returns.

```
<<
  /EngineDict
  <<
    /Editor
    <<
      /Text (˛ˇMake a change and save.)
    >>
  >>
>>
```

There are 5 data types available to use:

* Hash
* Array
* Number (with or without decimal values)
* String
* Boolean

<table>
  <thead>
    <th>Code</th>
    <th>Meaning</th>
  </thead>
  <tr>
    <td>&lt;&lt;</td>
    <td>Hash start</td>
  </tr>
  <tr>
    <td>&gt;&gt;</td>
    <td>Hash end</td>
  </tr>
  <tr>
    <td>/Name</td>
    <td>Property name</td>
  </tr>
  <tr>
    <td>[ 0.0 1.0 ]</td>
    <td>Array (space delimited)</td>
  </tr>
  <tr>
    <td>(˛ˇText)</td>
    <td>String</td>
  </tr>
</table>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
