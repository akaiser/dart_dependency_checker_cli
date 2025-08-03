### Installation

```bash
dart pub global activate dart_dependency_checker_cli
```

### Command `deps-used`

Lists dependencies that are actively used in the project's codebase.

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

Lists dependencies that are declared in the `pubspec.yaml` file but are not utilized in the project's codebase. Supports
an instant fix during run.

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

Lists dependencies that are used directly in the project without being explicitly declared in the `pubspec.yaml` file.

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

### Command `deps-update`

Updates provided but only existing main and dev dependencies in a `pubspec.yaml` file. Supports updating both main and
dev dependencies, including those from path or git sources.

#### Arguments:

```
-p, --path=<path>    Path to valid pubspec.yaml.
    --main           Comma separated list of main dependencies.
    --dev            Comma separated list of dev dependencies.
    --[no-]json      Output in json format.
```

#### Example:

```bash
ddc deps-update --main equatable:2.0.7,meta:^1.3.0 --dev some_path_source:path=../some_path_dependency
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
