## Usage

Install:

```bash
dart pub global activate dart_dependency_checker_cli
```

Run:

```bash
ddc deps-unused -p /some/package --dev-ignores lints,build_runner
# with aliases
ddc du -p /some/package --di lints,build_runner

ddc transitive-use -p /some/package --main-ignores async,meta
# with aliases
ddc tu -p /some/package --mi async,meta
```
