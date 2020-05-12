This directory is for utility, and template files.

- [condarc.yml] holds a default `condarc` configuration that differs from the default only by showing channel urls.
- [environment.yml] contains the conda packages needed to build and deploy the custom Commander Conda distribution.
  - These *may NOT* be installed into the custom distribution; [construct.yaml] dictates what is included in the generated distribution.

[condarc.yml]: ./condarc.yml
[environment.yml]: ./environment.yml
[construct.yaml]: ../CommanderConda/construct.yaml
