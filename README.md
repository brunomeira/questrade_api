[![Gem Version](https://badge.fury.io/rb/questrade_api.svg)](https://badge.fury.io/rb/questrade_api)
[![Build Status](https://travis-ci.org/brunomeira/questrade_api.svg?branch=master)](https://travis-ci.org/brunomeira/questrade_api) 
[![Code Climate](https://codeclimate.com/github/brunomeira/questrade_api/badges/gpa.svg)](https://codeclimate.com/github/brunomeira/questrade_api)

# The Questrade Ruby Api Gem

A Ruby interface to use the [Questrade API](http://www.questrade.com/api).

## Quick Start

- Create a Questrade Demo Account on: <http://www.questrade.com/api/free-practice-account>
- Add the following line to your Gemfile

```
gem 'questrade_api'
```
- Run Bundle to install gem

```
$ bundle
```
- Follow the tutorial on <http://www.questrade.com/api/documentation/getting-started> to generate a refresh token

### Authorization

- After getting the refresh token from Questrade, you are now ready to ask for an access token. In order to fetch an access token, copy the snippet of code below and replace the example token with your refresh token.

```ruby
# By default this API calls the practice(demo) endpoint.
client = QuestradeApi::Client.new(refresh_token: 'XXXX')

# If you want to call the live platform you need to pass :live as a parameter. Ex:
client = QuestradeApi::Client.new(refresh_token: 'XXXX', :live)

# Both calls automatically ask for a new access token


# In case you already have an access token and a api_server, you can instead use:
client = QuestradeApi::Client.new(access_token: 'XXXX', api_server: 'XXXX', :live)

# To ask for a new access token(Questrade invalidates tokens every 30 mins), simply call:
client.refresh_token # Make sure client has a valid refresh_token
```

### Some examples:

- After fetching a valid access token, you are now ready to use the API. Below you can find a few examples of the calls you can make with the gem.

```ruby
# Get Questrade's current server time
client.time

# list of all accounts
client.accounts

# List of all balances of an specific account
client.balances('account_id')

# List of positions of an specific account
client.positions('account_id')

# Activities of an specific period of time for an specific account
client.activities('account_id', startTime: DateTime.yesterday.to_s, endTime: DateTime.now.to_s)

# Symbol by ID
client.symbol('id')

# Symbols by name
client.symbols(names: ['AAPL'])

# Search symbols by prefix
client.search_symbols(prefix: 'BMO')

# List of quotes
client.quotes(['123', '456'])

# Quote details
client.quote('123')

# Historical Market in candlestick format
client.candles('123', startTime: DateTime.yesterday.to_s, endTime: DateTime.now.to_s)

# In case you already have a valid access token and its respective URL, you can use the QuestradeApi::REST objects. Example:
# authorization can be any object that responds to url and access_token
authorization = QuestradeApi::Authorization.new(access_token: 'access_token', api_server: 'url')
accounts = QuestradeApi::REST::Account.fetch(accounts)
```
For more advanced options, check out our [documentation](http://www.rubydoc.info/gems/questrade_api/1.0.0).

## Current Status

This Project is under development and some endpoints are still not accessible through the gem.
Check the tables below for more details.

### Account Calls

| Endpoint                 | Development   | Documentation |
| ---                      | ---           | ---           |
| /time                    |DONE           | DONE          |
| /accounts                |DONE           | DONE          |
| /accounts/:id/positions  |DONE           | DONE          |
| /accounts/:id/balances   |DONE           | DONE          |
| /accounts/:id/executions |DONE           | DONE          |
| /accounts/:id/orders     |DONE           | DONE          |
| /accounts/:id/activities |DONE           | DONE          |

### Market Calls

| Endpoint                   | Development   | Documentation |
| ---                        | ---           | ---           |
| /symbols/                  | DONE          |               |
| /symbols/:id               |               |               |
| /symbols/search            | DONE          |               |
| /symbols/:id/options       | DONE          |               |
| /markets                   | DONE          |               |
| /markets/quotes/           | DONE          |               |
| /markets/quotes/:id        | DONE          |               |
| /markets/quotes/options    |               |               |
| /markets/quotes/strategies |               |               |
| /markets/candles/:id       | DONE          |               |

### Order Calls

| Endpoint                          | Development   | Documentation |
| ---                               | ---           | ---           |
| POST accounts/:id/orders          |      |      |
| POST accounts/:id/orders/impact   |      |      |
| DELETE accounts/:id/orders        |      |      |
| POST accounts/:id/orders/brackets |      |      |
| POST accounts/:id/orders/strategy |      |      |

## Contributing

Contributions are more than welcome.
The only thing we ask is that before you send a Pull Request, please check if you completed the steps below:

1. Write and/or update affected tests
3. Write and/or update documentation
4. Run RuboCop and update code, if needed
5. Run test suite
6. Test if the changes are working properly and didn't break any affected area

## Note

This is an open-source project, licensed under the MIT License(see [LICENSE]), and was developed as a labour of love.
We are not responsible for any damages, capital losses, or any claim caused by the use of this gem.

USE IT AT YOUR OWN RISK.

[LICENSE]: https://github.com/brunomeira/questrade_api/blob/master/LICENSE
