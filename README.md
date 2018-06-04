# jylis-rb

[![Gem Version](https://badge.fury.io/rb/jylis-rb.svg)](https://badge.fury.io/rb/jylis-rb)
[![Coverage Status](https://coveralls.io/repos/github/amclain/jylis-rb/badge.svg?branch=master)](https://coveralls.io/github/amclain/jylis-rb?branch=master)
[![API Documentation](http://img.shields.io/badge/docs-api-blue.svg)](http://www.rubydoc.info/gems/jylis-rb)
[![MIT License](https://img.shields.io/badge/license-MIT-yellowgreen.svg)](https://github.com/amclain/jylis-rb/blob/master/license.txt)

An idiomatic library for connecting a Ruby project to a
[Jylis](https://github.com/jemc/jylis) database.

> Jylis is a distributed in-memory database for Conflict-free Replicated Data
> Types (CRDTs), built for speed, scalability, availability, and ease of use.

## Installation

Install this library from the Ruby package manager with the following command:

```text
$ gem install jylis-rb
```

Add the following `require` to your project:

```ruby
require 'jylis-rb'
```

The library is now ready for use.

### Installing From Source

If you choose not to use a version of the gem provided by the package manager,
you may alternatively install this library from the source code. This section
can be skipped if you have already installed the gem from the package manager.

Ensure `bundler` and `rake` are installed:

```text
$ gem install bundler
$ gem install rake
```

Clone the repository and navigate inside the project directory:

```text
$ git clone git@github.com:amclain/jylis-rb.git
$ cd jylis-rb
```

Install the dependencies:

```text
$ bundle install
```

Ensure the tests pass:

```text
$ rake
```

Install the gem from the working source code:

```text
$ rake install
```

## Database Connection

The connection URI must be specified in the format: `schema://host:port`, where
the schema is `jylis`. The `host` can be a host name, IP address, or domain name
of the database host to connect to. The `port` is optional and defaults to
`6379` unless otherwise specified.

```ruby
Jylis.connect("jylis://host:port")
```

## Queries

This library aims to be idiomatic with both Ruby and Jylis. Therefore, the
syntax of the queries closely match the [Jylis documentation](https://jemc.github.io/jylis/docs/types/)
and ideally it should feel so natural to you, a Ruby programmer, that you don't
need to read the documentation for this library (although this library is
thoroughly documented in the case that you do).

For example, take the case of a Jylis query to set a value for a
[`UJSON`](https://jemc.github.io/jylis/docs/types/ujson/#set-key-key-ujson) key:

```text
UJSON SET fruit apple properties '{"color": "red", "ripe": true}'
```

Using this library, the query looks like this:

```ruby
Jylis.ujson.set "fruit", "apple", "properties", {color: "red", ripe: true}
```

The format for a query is:

```text
Jylis.<data_type>.<function> key(s), [value], [timestamp]
```

However, be sure to consult the [API documentation](http://www.rubydoc.info/gems/jylis-rb)
or the [Jylis documentation](https://jemc.github.io/jylis/docs/types/) for the
exact format of your particular query.

### TREG

Timestamped Register <sup>[[link](https://jemc.github.io/jylis/docs/types/treg/)]</sup>

```ruby
Jylis.treg.set "lamp_brightness", 80, 1528082143

result = Jylis.treg.get "lamp_brightness"
# => #<Jylis::DataType::TREG::Result:0x00005598dd3941c8 @timestamp=1528082143, @value="80">

result.value
# => "80"
result.timestamp
# => 1528082143
```

### Raw Query

If this library doesn't contain a method for the query you would like to
perform, you can construct the query yourself by calling `Jylis.query`.
However, be aware that this method is non-idiomatic and may require you to
do your own pre/post processing on the data.

```ruby
Jylis.query "TLOG", "INS", "temperature", 72.6, 5
# => "OK"

Jylis.query "TLOG", "GET", "temperature"
# => [["72.6", 5]]
```
