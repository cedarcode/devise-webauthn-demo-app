# Devise WebAuthn Demo App

A Rails application demonstrating how to use `devise-webauthn` gem to integrate WebAuthn passwordless authentication and 2FA into a Devise-based authentication system.

## Want to try it?

### Run it locally

#### Prerequisites

- Ruby 3.4.7

#### Setup

```bash
$ git clone https://github.com/cedarcode/devise-webauthn-demo-app
$ cd devise-webauthn-demo-app/
$ bundle install
$ bundle exec rails db:setup
```

#### Running

```bash
$ bundle exec rails s
```

Now you can visit http://localhost:3000 to play with the demo site.

### Usage

1. Sign up at `/users/sign_up`
2. Register a passkey or security key from the dashboard
3. Try passwordless login or 2FA on your next sign-in
