# paul-e-allen/docker-terraform-tools

Derived from https://github.com/paul-e-allen/docker-build-publish-example.

## Image

```
ghcr.io/paul-e-allen/docker-terraform-tools:latest
```

## Change Log

### v1.0.0
- Initial release

##  Trigger a New Release and Image Build

Trigger a new release, build, and push by creating and pushing a new tag with format:
```
v<MAJOR_VERSION>.<MINOR_VERSION>.<PATCH_NUMBER>
```
For example, `v1.0.0`. 

You can use the following `git` commands to create a push a tag:

```
git tag -a v1.0.0 -m v1.0.0
git push origin v1.0.0
