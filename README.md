<div align='center'>

# CommanderConda

Custom Conda distribution in support of TAU Commander

</div>

[![.github/workflows/BuildCommanderConda.yml][GHA badge]][workflow]
[![GitHub release (latest SemVer)][Release badge]][latest]
[![License Badge][license badge]][license]

## About

This repository defines a custom [Anaconda] Python distribution that is used by [TAU Commander].
[TAU Commander] will automatically pick and use the correct custom [Anaconda] distribution;
this project and repository is not intended to be of interest or of use to [TAU Commander] users.
The packages included in the distribution are defined in the [construct.yaml] file.
These packages must be kept in sync with [TAU Commander] development.
[GitHub Actions] is used to automate the creation and release of this custom [Anaconda] distribution using [Constructor].
The mechanisms for generating Python2 and Python3 packages using Jinja2 templating and distributions for multiple achitectures
is based on the approach used by the [miniforge project][miniforge].

## [TAU Commander] Developers

To create a new release please follow these steps:

1. Make the appropriate changes to [construct.yaml] to include new/different packages on a new branch.
2. Open a [pull request] against master.
3. Ensure tests & build passes, push any needed fixes to the working branch.
4. Merge the [pull request] into master.
5. Create a new tag and ensure that it is an annotated tag by passing `-a` to `git tag` (or, better yet, GPG sign the tag with `-s` which implies `-a`).
6. After CI/CD finishes running check that the [workflow] created [a new release][latest] using the tag message as the body of the release text.

## Target Platforms and Status

| Arch-OS \ Python Version | 2.7 | 3.7 |
| --------------------: | :--: | :--: |
| x86_64 Linux | Supported, implemented, deprecated | Supported |
| x86_64 macOS | Supported, implemented, deprecated | Supported |
| x86_64 Windows | Unsupported, deprecated | Unsupported |
| aarch64 Linux | Unsupported | Supported |
| ppc64le Linux | Unsupported | Supported |

## Acknowledgements

Special thanks to the [conda-forge/miniforge][miniforge],
from which some code and scripts have been borrowed and adapted,
and to the [conda-forge project] in general.
[miniforge] is licensed under the same [BSD-3-clause license] as [this project][license]
and [their LICENSE] is distributed along with the source code of this project.

[GHA badge]: https://github.com/ParaToolsInc/CommanderConda/workflows/Build%20Commander%20Conda/badge.svg?branch=master&event=push
[Release badge]: https://img.shields.io/github/v/release/ParaToolsInc/CommanderConda?sort=semver
[workflow]: https://github.com/ParaToolsInc/CommanderConda/actions?query=workflow%3A%22Build+Commander+Conda%22
[latest]: https://github.com/ParaToolsInc/CommanderConda/releases/latest
[license badge]: https://img.shields.io/github/license/ParaToolsInc/CommanderConda
[license]: https://github.com/ParaToolsInc/CommanderConda/blob/master/LICENSE
[TAU Commander]: https://github.com/ParaToolsInc/taucmdr
[construct.yaml]: https://github.com/ParaToolsInc/CommanderConda/blob/master/CommanderConda/construct.yaml
[GitHub Actions]: https://help.github.com/en/actions
[Constructor]: https://github.com/conda/constructor
[miniforge]: https://github.com/conda-forge/miniforge
[pull request]: https://github.com/ParaToolsInc/CommanderConda/pulls
[Anaconda]: https://docs.conda.io/projects/conda/en/latest/
[conda-forge project]: https://conda-forge.org
[BSD-3-clause license]: https://opensource.org/licenses/BSD-3-Clause
[their LICENSE]: https://github.com/ParaToolsInc/CommanderConda/blob/master/miniforge-LICENSE
