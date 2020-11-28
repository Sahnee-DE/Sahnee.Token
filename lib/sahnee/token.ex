defmodule Sahnee.Token do
  @moduledoc """
  This module is used for token generation.
  """

  @typedoc """
  All valid hash algorithms for generating tokens. Keep in mind that some of them are more secure than others.
  """
  @type hash_alg :: :md4 | :md5 | :sha | :sha224 | :sha256 | :sha384 | :sha3_224 | :sha3_256 | :sha3_384 | :sha3_512 | :sha512

  @doc """
  Generates a cryptograpically secure token based on the given values.

  ## Parameters

    - opts: The data structure must have the keys `:hash`, `:bytes` & `:secret`. See the documentation of `make_token/3` for details
      on each of those values.

  ## Example

      iex> Sahnee.Token.make_token(hash: :md5, bytes: 128, secret: "sahnee.de")
      "BA3323E0808375D5635A7044EFD7D689"


  """
  @spec make_token(
    opts :: %{hash: hash_alg, bytes: non_neg_integer, secret: String.t} |
    [hash: hash_alg, bytes: non_neg_integer, secret: String.t]
  ) :: String.t
  def make_token(opts) when is_list(opts), do: make_token(opts[:hash], opts[:bytes], opts[:secret])
  def make_token(opts) when is_map(opts), do: make_token(opts.hash, opts.bytes, opts.secret)

  @doc """
  Generates a cryptograpically secure token based on the given values.

  ## Parameters

    - hash: The hash algorithm to use. Either refer to the `t:hash_alg/0` type or OpenSSL for documentation on all
      allowed types.
    - bytes: The length in bytes used for the token. This does not correspond with the output length. These are just the amount
      of strong random bytes that are hashed.
    - secret: The secret/salt to use for the hash.

  ## Example

      iex> Sahnee.Token.make_token(:md5, 128, "sahnee.de")
      "BA3323E0808375D5635A7044EFD7D689"
  """
  @spec make_token(hash :: hash_alg, bytes :: non_neg_integer, secret :: String.t) :: String.t
  def make_token(hash, bytes, secret) do
    token = :crypto.strong_rand_bytes(bytes)
    token = :crypto.mac(:hmac, hash, secret, token)
    Base.encode16(token)
  end
end
