# dart_dependency_checker_cli

A command-line wrapper using utilities from [dart_dependency_checker](https://pub.dev/packages/dart_dependency_checker)
for checking dependencies within Dart/Flutter packages.

## Usage

Install:

```bash
dart pub global activate dart_dependency_checker_cli
```

Run:

```
# Dependencies used command
ddc deps-used -p /some/package
## with alias
ddc du -p /some/package

# Dependencies unused command
ddc deps-unused -p /some/package --dev-ignores lints,build_runner
## with aliases
ddc dun -p /some/package --di lints,build_runner

# Transitive use command
ddc transitive-use -p /some/package --main-ignores async,meta
## with aliases
ddc tu -p /some/package --mi async,meta

# Dependencies add command
ddc deps-add -p /some/package --main equatable:2.0.7,meta:^1.3.0 --dev some_path_source:path=../some_path_dependency
## with aliases
ddc da -p /some/package --m equatable:2.0.7,meta:^1.3.0 --d some_path_source:path=../some_path_dependency

# Dependencies sort command
ddc deps-sort -p /some/package
## with aliases
ddc ds -p /some/package
```

Or even:

```
# With instant fix
ddc deps-unused --fix

# Json as output
ddc deps-unused --json

# In a wild mono repo environment
melos exec -c1 -- ddc deps-unused

# Run everywhere
for d in */ ; do (cd $d && ddc deps-unused); done;
```

## License

See the [LICENSE](LICENSE) file.

## Version history

See the [CHANGELOG.md](CHANGELOG.md) file.
