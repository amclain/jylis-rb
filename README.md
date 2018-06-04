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
