# QuestradeApi

A Ruby interface to use the [Questrade API](http://www.questrade.com/api).

## Quick Start

1. Create a Questrade Demo Account on: <http://www.questrade.com/api/free-practice-account>

2. Add the following line to your Gemfile

```
gem 'questrade_api'

```

3. Run Bundle to install gem

```
$ bundle

```

4. Follow the tutorial on <http://www.questrade.com/api/documentation/getting-started> to generate a refresh token

5. Copy the snippet of code below to your application, and replace the 'XXXX' token with the token generated on step 4.

```ruby
# By default this API calls the practice(demo) endpoint.
# Check our documentation to learn how to call the live endpoint.
client = QuestradeApi::Client.new(refresh_token: 'XXXX')

```

6. That's all you need to access the API. A few examples of what you can do with it:

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

# In case you already have a valid access token and its respective URL, you can use the QuestradeApi::REST objects. Example:
# authorization can be any object that responds to url and access_token
authorization = QuestradeApi::Authorization.new(access_token: 'access_token', api_server: 'url')
accounts = QuestradeApi::REST::Account.all(accounts)

```

For more advanced options, check out our [documentation](http://www.google.com).

## Current Status

This Project is under development and some endpoints are still not accessible through the gem.
Check the tables below for more details.

<dl>
  <dt>LEGEND</dt>

  <dd>:green_heart: = Available</dd>
  <dd>:heart: = Not Available</dd>
</dl>

### Account Calls

| Endpoint                 | Development   | Documentation |
| ---                      | ---           | ---           |
| /time                    | :green_heart: | :green_heart: |
| /accounts                | :green_heart: | :green_heart: |
| /accounts/:id/positions  | :green_heart: | :heart:       |
| /accounts/:id/balances   | :green_heart: | :heart:       |
| /accounts/:id/executions | :green_heart: | :heart:       |
| /accounts/:id/orders     | :green_heart: | :heart:       |
| /accounts/:id/activities | :green_heart: | :heart:       |

### Market Calls

| Endpoint                   | Development   | Documentation |
| ---                        | ---           | ---           |
| /symbols/:id               | :heart:       | :heart:       |
| /symbols/:search           | :heart:       | :heart:       |
| /symbols/:id/options       | :heart:       | :heart:       |
| /markets                   | :green_heart: | :heart:       |
| /markets/quotes/:id        | :heart:       | :heart:       |
| /markets/quotes/options    | :heart:       | :heart:       |
| /markets/quotes/strategies | :heart:       | :heart:       |
| /markets/candles/:id       | :heart:       | :heart:       |

### Order Calls

| Endpoint                          | Development   | Documentation |
| ---                               | ---           | ---           |
| POST accounts/:id/orders          | :heart:       | :heart:       |
| POST accounts/:id/orders/impact   | :heart:       | :heart:       |
| DELETE accounts/:id/orders        | :heart:       | :heart:       |
| POST accounts/:id/orders/brackets | :heart:       | :heart:       |
| POST accounts/:id/orders/strategy | :heart:       | :heart:       |

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

[LICENSE]: LICENSE
