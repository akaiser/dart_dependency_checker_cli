# dart_dependency_checker_cli

A command-line wrapper using utilities from [dart_dependency_checker](https://pub.dev/packages/dart_dependency_checker) for checking dependencies within Dart/Flutter packages.

## Usage

Install:

```bash
dart pub global activate dart_dependency_checker_cli
```

Run:

```bash
ddc deps-unused -p /some/package --dev-ignores lints,build_runner
ddc transitive-use -p /some/package --main-ignores async,meta
```

Or even:

```
# With instant fix
ddc deps-unused -p /some/package --fix

# Json as output
ddc deps-unused -p /some/package --json

# In a wild mono repo environment
melos exec -c1 -- ddc deps-unused

# Run everywhere
for d in */ ; do (cd $d && ddc deps-unused); done;
```

## Future roadmap

- Command `dep-origin`: Utilize `dart pub deps -s compact --no-dev` to extract the origin of a direct/transitive dependency.

## License

See the [LICENSE](LICENSE) file.

## Version history

See the [CHANGELOG.md](CHANGELOG.md) file.
