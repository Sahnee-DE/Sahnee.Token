# Sahnee.Token

An Elixir helper module for generating cryptographically secure tokens.

## Installation

```elixir
def deps do
  [
    {:sahnee_token, git: "ssh://git@appsrv01.sahnee.internal:7999/lib/ex-sahnee.token.git", tag: "master"}
  ]
end
```

## Usage

Either allows to be called using list syntax, map synax or normal arguments:

```elixir
Sahnee.Token.make_token(hash: :md5, bytes: 128, secret: "sahnee.de")
Sahnee.Token.make_token(%{hash: :md5, bytes: 128, secret: "sahnee.de"})
Sahnee.Token.make_token(:md5, 128, "sahnee.de"})
# "BA3323E0808375D5635A7044EFD7D689"
```

The first two forms of the syntax are especially easy for allowing the secrets to be configured.


```elixir
Sahnee.Token.make_token(Application.get_env(:my_app, :example_token))
```

Supported hash algorithms depend on the installation of OpenSSL. Most common ones are:

```elixir
:md4 | :md5 | :sha | :sha224 | :sha256 | :sha384 | :sha3_224 | :sha3_256 | :sha3_384 | :sha3_512 | :sha512
```

Consider all algorithms besides the ones listed here (under `hmac_hash_algorithm`, exluding the one of `compatibility_only_hash`) unsafe and not suitable for production: https://erlang.org/doc/man/crypto.html#type-hmac_hash_algorithm