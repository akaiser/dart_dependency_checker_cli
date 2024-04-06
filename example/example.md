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
