# Homebrew Tap for zcompact

This is the Homebrew tap for [zcompact](https://github.com/zackmarks/zcompact), a JSON compaction tool with queryable ID index.

## Installation

```bash
brew tap zackmarks/zcompact
brew install zcompact
```

Or install directly:

```bash
brew install zackmarks/zcompact/zcompact
```

## Usage

```bash
# Create archive from gzip NDJSON
zcompact create data.jcpk input.json.gz --id-field "id"

# Query by ID
zcompact get data.jcpk "user-123"

# See all commands
zcompact --help
```

## Documentation

See the [main repository](https://github.com/zackmarks/zcompact) for full documentation.
