> :warning: The Cartesi team keeps working internally on the next version of this repository, following its regular development roadmap. Whenever there's a new version ready or important fix, these are published to the public source tree as new releases.

# Cartesi Machine Playground

The Cartesi Machine Playground is the repository that provides the Dockefile to build the `cartesi/playground` image. This image is base on Ubuntu 20.04 and comes with a pre-built emulator and Lua interpreter accessible within the command-line, as well as a pre-built ROM image, RAM image, and root file-system. It also comes with the cross-compiler for the RISC-V architecture on which the Cartesi Machine is based. For more information, please refer to the [documentation](https://cartesi.io/en/docs/machine/host/overview/).

## Getting Started

### Requirements

- Docker >= 18.x
- GNU Make >= 3.81

### Build

```bash
$ make build
```

If you want to build using only the docker command, you can do the following:

```bash
$ docker build -t cartesi/playground .
```

To remove the generated images from your system, please refer to the Docker documentation.

#### Makefile targets

The following options are available as `make` targets:

- **build**: builds the docker playground image
- **run**: runs the generated image with current user UID and GID
- **push**: pushes the image to the registry repository

#### Makefile container options

You can pass the following variables to the make target if you wish to use different docker image tags.

- TAG: playground image tag
- TOOLCHAIN\_TAG: toolchain image tag

```
$ make build TAG=mytag
```

It's also useful if you want to use pre-built images:

```
$ make run TAG=latest
```

## Usage

If you want to play around on the environment you can also do:

```
$ make run
```

## Contributing

Thank you for your interest in Cartesi! Head over to our [Contributing Guidelines](CONTRIBUTING.md) for instructions on how to sign our Contributors Agreement and get started with
Cartesi!

Please note we have a [Code of Conduct](CODE_OF_CONDUCT.md), please follow it in all your interactions with the project.

## Authors

* *Diego Nehab*
* *Victor Fusco*

## License

The playground repository and all contributions are licensed under
[APACHE 2.0](https://www.apache.org/licenses/LICENSE-2.0). Please review our [LICENSE](LICENSE) file.

