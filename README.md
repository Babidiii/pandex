# Pandex

Pandex is a template for pandoc reports without installing anything on your machine except docker or podman. 
The project is based on [pandoc image](https://hub.docker.com/r/pandoc/latex)

## Dependancies

You will need either 
- **docker**
- **podman** and **buildah**

The output result will be a container defined as the following schema.

```sh
podman run --rm -ti --volume "`pwd`:/data" --entrypoint "/data/latex_compile.sh" "templex"

               pandex container
              ┌─────────────────────┐
              │      - Pandoc       │
              │      - entr      ┌──────────┐
              │      - ...       │ENTRYPOINT│─┐
              │                  └──────────┘ │
              │  ┌───────────────┐  │         │
              │  │ VOLUME (/data)│  │         │
              │  └───────┬───────┘  │         │
              └──────────┼──────────┘         │
                         │                    │
             ┌───────────┴────────────┐       │
             │  ./                    │       │
             │  ├── build/            │       │
             │  ├── images/           │       │
             │  ├── resources/        │       │
             │  ├── src/              │       │
             │  ├── Dockerfile        │       │
             │  ├── build.sh*         │       │
             │  ├── pandex_compile.sh*◄───────┘
             │  ├── LICENSE           │
             │  └── README.md         │
             └────────────────────────┘
```

- resources directory contain all file used by pandoc in order to customize the pdf generated (latex header, pygments...)

## Installation & usage

Run the `build.sh` script which will use either `podman` or `docker`.  
If the image doesn't exist yet it will build it before running it within a container.

```sh
./build.sh
```

The pandoc compilation chain is made in order to provide autoreload thanks to `entr` command.
If you want to customize your compilation you can change the `pandex_compilation.sh` script

If you need a package that is not installed you will have to add it within the Dockerfile and rebuild your image.

```yml
RUN tlmgr install packages ... yourpackage
# then rebuild the image
```
