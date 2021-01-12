# Badsec

## Installation

First, clone the repository and `cd` into it. Then, run `bundle install` to install dependencies.

    $ git clone https://github.com/beechnut/badsec.git
    $ cd badsec
    $ bundle install

## Usage

To get a list of IDs, run the `get` command. This will request an auth token from the server, then return a JSON-formatted list of IDs.

    $ bundle exec bin/cli get

Results are always JSON-formatted, meaning you can pipe them to `jq` or do other useful things. For example, to get the first 3 IDs, you can run:

    $ bundle exec bin/cli get | jq '.[0:3]'

If you have an auth token already, you can provide it as a second argument. This will skip the request to the server's `/auth` endpoint.

    $ bundle exec bin/cli get AUTH_TOKEN_HERE | jq '.[0:3]'

## Roadmap

Future work includes:

- Adding a HOST option to the CLI, to allow easy switching between staging / production API endpoints.
- Incremental waiting upon each URL retry, so as not to overload the server upon failure.
- Removing exceptions as a control flow mechanism.
- Local storage of authorization token, to reduce load on server.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/beechnut/badsec. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Badsec project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/badsec_client/blob/master/CODE_OF_CONDUCT.md).
