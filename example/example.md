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
```
