# Homebrew: Webhippie

[![Build Status](https://github.com/webhippie/homebrew-webhippie/actions/workflows/general.yml/badge.svg)](https://github.com/webhippie/homebrew-webhippie/actions/workflows/general.yml) [![Codacy Badge](https://app.codacy.com/project/badge/Grade/9f7da33f3e764e6f96d7fa23771d03a1)](https://app.codacy.com/gh/webhippie/homebrew-webhippie/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

Homebrew repository to install tools maintained by us.

## Prepare

```console
brew tap webhippie/webhippie
```

## Install

### [boilr](https://github.com/tmrts/boilr)

```console
brew install boilr
boilr -h
```

### [cursecli](https://github.com/webhippie/cursecli)

```console
brew install cursecli
cursecli -h
```

### [errors](https://github.com/webhippie/errors)

```console
brew install errors
errors -h
```

### [mcrcon](https://github.com/Tiiffi/mcrcon)

```console
brew install mcrcon
mcrcon -h
```

### [medialize](https://github.com/webhippie/medialize)

```console
brew install medialize
medialize -h
```

### [mygithub](https://github.com/webhippie/mygithub)

```console
brew install mygithub
mygithub -h
```

### [prom-to-apt-dater](https://github.com/webhippie/prom-to-apt-dater)

```console
brew install prom-to-apt-dater
prom-to-apt-dater -h
```

### [redirects](https://github.com/webhippie/redirects)

```console
brew install redirects
redirects -h
```

### [templater](https://github.com/webhippie/templater)

```console
brew install templater
templater -h
```

### [terrastate](https://github.com/webhippie/terrastate)

```console
brew install terrastate
terrastate -h
```

## Security

If you find a security issue please contact
[thomas@webhippie.de](mailto:thomas@webhippie.de) first.

## Development

We use [mise][mise] to manage all required tools and their versions. Install it
by following the [official installation instructions][mise-install], then run
the following commands inside the repository to activate mise and install all
tools defined in `mise.toml`:

```console
mise trust
mise install
```

After that you should be able to use the regular commands for the development of
Ruby files or Brews in general:

```console
bundle install
bundle exec rake rubocop
bundle exec rake spec
```

## Contributing

Generally we are following [conventional commits][commits] when we apply
changes. That way we are able to generate proper changelogs for every release.
Please use always pull requests to integrate new functionalities or to fix
issues.

For the release process we are following [semantic versioning][semver] which
clearly indicates if a new version just resolves bugs, includes new features or
even includes breaking changes.

After installing the tools via `mise install` as described above set up the
pre-commit hooks so they run automatically on every commit:

```console
pre-commit install --hook-type pre-commit --hook-type commit-msg
```

> `pre-commit` is managed by mise and will be available after `mise install`.

If you have changed something on the source you should simply commit following
the mentioned conventions:

```console
git checkout -b feat/new-feature
git add --all
git commit -m 'feat: added awesome new feature'
git push --set-upstream origin feat/new-feature
```

After pushing your changes into the Git repository you should create a pull
request on GitHub. If the pull request have been merged and everything built
fine it will also create automatically a new release at least once a week.

## Authors

-   [Thomas Boerger](https://github.com/tboerger)

## License

Apache-2.0

## Copyright

```console
Copyright (c) 2018 Thomas Boerger <thomas@webhippie.de>
```

[mise]: https://mise.jdx.dev/
[mise-install]: https://mise.jdx.dev/getting-started.html
[commits]: https://www.conventionalcommits.org/en/v1.0.0/
[semver]: https://semver.org/
