# dart_dependency_checker_cli

A command-line wrapper using utilities from [dart_dependency_checker](https://pub.dev/packages/dart_dependency_checker)
for checking dependencies within Dart/Flutter packages.

## Available commands

| Command          | Alias | Description                                                                                                                                               |
|------------------|-------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `deps-used`      | `du`  | Lists all dependencies that are actively used in the project's codebase.                                                                                  |
| `deps-unused`    | `dun` | Lists dependencies that are declared in the `pubspec.yaml` file but are not utilized in the project's codebase.                                           |
| `transitive-use` | `tu`  | Finds instances where transitive dependencies are used directly in the project without being explicitly declared in `pubspec.yaml`.                       |
| `deps-add`       | `da`  | Blindly adds specified dependencies to the `pubspec.yaml` file. Supports adding both main and dev dependencies, including those from path or git sources. |
| `deps-sort`      | `ds`  | Sorts the dependencies listed in the `pubspec.yaml` file, organizing them in a standardized order for better readability and maintenance.                 |

## Usage

### Installation

```bash
dart pub global activate dart_dependency_checker_cli
```

### Command `deps-used`

Lists all dependencies that are actively used in the project's codebase.

#### Arguments:

```
-p, --path=<path>     Path to valid pubspec.yaml.
    --main-ignores    Comma separated list of main dependencies to be ignored.
    --dev-ignores     Comma separated list of dev dependencies to be ignored.
    --[no-]json       Output in json format.
```

#### Example:

```bash
ddc deps-used --main-ignores http,path_provider --json
```

### Command `deps-unused`

Lists dependencies that are declared in the `pubspec.yaml` file but are not utilized in the project's codebase.

#### Arguments:

```
-p, --path=<path>     Path to valid pubspec.yaml.
    --main-ignores    Comma separated list of main dependencies to be ignored.
    --dev-ignores     Comma separated list of dev dependencies to be ignored.
    --[no-]fix        Instant cleanup after checker run.
    --[no-]json       Output in json format.
```

#### Example:

```bash
ddc deps-unused --dev-ignores lints,build_runner --fix
```

### Command `transitive-use`

Finds instances where transitive dependencies are used directly in the project without being explicitly declared in
`pubspec.yaml`.

#### Arguments:

```
-p, --path=<path>     Path to valid pubspec.yaml.
    --main-ignores    Comma separated list of main dependencies to be ignored.
    --dev-ignores     Comma separated list of dev dependencies to be ignored.
    --[no-]json       Output in json format.
```

#### Example:

```bash
ddc transitive-use --main-ignores async,meta
```

### Command `deps-add`

Blindly adds specified dependencies to the `pubspec.yaml` file. Supports adding both main and dev dependencies,
including those from path or git sources.

#### Arguments:

```
-p, --path=<path>    Path to valid pubspec.yaml.
    --main           Comma separated list of main dependencies.
    --dev            Comma separated list of dev dependencies.
    --[no-]json      Output in json format.
```

#### Example:

```bash
ddc deps-add --main equatable:2.0.7,meta:^1.3.0 --dev some_path_source:path=../some_path_dependency
```

### Command `deps-sort`

Sorts the dependencies listed in the `pubspec.yaml` file, organizing them in a standardized order for better readability
and maintenance.

#### Arguments:

```
-p, --path=<path>    Path to valid pubspec.yaml.
    --[no-]json      Output in json format.
```

#### Example:

```bash
ddc deps-sort
```

## License

See the [LICENSE](LICENSE) file.

## Version history

See the [CHANGELOG.md](CHANGELOG.md) file.
