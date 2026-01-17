---
layout: lecture
title: "Packaging and Shipping Code"
date: 2026-01-20
ready: true
---

<span class="construction">
This page is under construction for the IAP 2026 offering of Missing Semester.
</span>

Writing code to work as intended is difficult, yet getting that same code to run in a machine different from your own is often harder.

Shipping code means taking the code you wrote and converting it into a usable thing that someone else can run without your computer's exact setup.
Shipping code takes many forms and depends on the choices of programming language, system libraries, or operating system, among other factors.
It also depends on what you are building; a software library, a command line tool, and a web service all have different requirements and deployment steps.
Regardless, there is a common pattern between all these scenarios: we need to define what the deliverable is -- a.k.a the _artifact_ -- and what assumptions it makes about the environment around it.

## Dependencies & Environments

No man is an island and no program ships alone.
In modern software development layers of abstraction are ubiquitous.
Programs naturally offload logic to other libraries or services. 
However, this introduces a _dependency_ relationship between your program and the libraries it requires to function.

For instance, in Python to fetch the content of a website we often do

```python
import requests

response = requests.get("https://missing.csail.mit.edu")
```

Yet the `requests` library does not come bundled with the Python runtime, so if we try to run this code without having `requests` installed, Python will raise an error:

```console
❯ python fetch.py
Traceback (most recent call last):
  File "fetch.py", line 1, in <module>
    import requests
ModuleNotFoundError: No module named 'requests'
```

To make this library available we need to first run `pip install requests` to install it.
`pip` is the command line tool that the Python programming language provides for installing packages.
Executing `pip install requests` produces the following sequence of actions:

1. Search for requests in the Python Package Index (PyPI)
1. Search for the appropriate artifact for the platform we are running under
1. Resolve dependencies -- the `requests` library itself depends on other packages, so the installer must find compatible versions of all transitive dependencies, more on that later
1. Download the artifacts, then unpack and copy the files into the right places in our filesystem

```console
❯ pip install requests
Collecting requests
  Downloading requests-2.32.3-py3-none-any.whl (64 kB)
Collecting charset-normalizer<4,>=2
  Downloading charset_normalizer-3.4.0-cp311-cp311-manylinux_x86_64.whl (142 kB)
Collecting idna<4,>=2.5
  Downloading idna-3.10-py3-none-any.whl (70 kB)
Collecting urllib3<3,>=1.21.1
  Downloading urllib3-2.2.3-py3-none-any.whl (126 kB)
Collecting certifi>=2017.4.17
  Downloading certifi-2024.8.30-py3-none-any.whl (167 kB)
Installing collected packages: urllib3, idna, charset-normalizer, certifi, requests
Successfully installed certifi-2024.8.30 charset-normalizer-3.4.0 idna-3.10 requests-2.32.3 urllib3-2.2.3
```

Here we can see that `requests` has its own dependencies such as `certifi` or `charset-normalizer` and that they have to be installed before `requests` can be installed.
Once installed, the Python runtime can find this library when importing it.

```console
❯ python -c 'import requests; print(requests.__path__)'
['/home/josejavier/.venv/lib/python3.11/site-packages/requests']

❯ pip list | grep requests
requests        2.32.3
```

Programming languages have different tools, conventions and practices for installing and publishing libraries.
In some languages like Rust, the toolchain is unified -- `cargo` handles building, testing, dependency management, and publishing. 
In others like Python, the unification happens at a specification level -- rather than a single tool, there are standardized specifications (PEPs) that define how packaging works, allowing multiple competing tools for each task (`pip` vs `uv`, `setuptools` vs `hatch` vs `poetry`).
And in some ecosystems like LaTeX, distributions like TeX Live or MacTeX come bundled with thousands of packages pre-installed.

Introducing dependencies, also introduces dependency conflicts.
Conflicts happen when programs require incompatible versions of the same dependency.
For example, if `tensorflow==2.3.0` requires `numpy>=1.16.0,<1.19.0` and `pandas==1.2.0`  requires `numpy>=1.16.5`, then any version satifying `numpy>=1.16.0,<1.19.0` will be valid.
But if another package in your project requires `numpy>=1.19`, you have a conflict with no valid version that satisfies all constraints.
This situation -- where multiple packages require mutually incompatible versions of shared dependencies -- is commonly referred to as _dependency hell_.

> While many modern operating systems ship with installations of programming language runtimes like Python, it is unwise to modify these installations since the OS might rely on them for its own functionality. 

One way to deal with conflicts is to isolate the dependencies of each program into their own _environment_.
In Python we create a virtual environment by running 

```console
❯ which python
/usr/bin/python
❯ python -m venv venv
❯ source venv/bin/activate # this effectively modifies the $PATH in this session
❯ which python
/home/josejavier/venv/bin/python
❯ which pip
/home/josejavier/venv/bin/pip
❯ python -c 'import requests; print(requests.__path__)'
['/home/josejavier/venv/lib/python3.11/site-packages/requests']
```

You can think of an environment as an entire standalone version of the language runtime with its own set of installed packages.
This virtual environment or venv isolates the installed dependencies from the global Python installation. 
It is a good practice to have a virtual environment for each project, containing the dependencies it requires.


In some languages, the installation protocol is not defined by a tool but as a specification.
In Python [PEP 517](https://peps.python.org/pep-0517/) defines the build system interface and [PEP 621](https://peps.python.org/pep-0621/) specifies how project metadata is stored in `pyproject.toml`.
This has enabled developers to improve upon `pip` and produce more optimized tools like `uv`.

Using `uv` instead of `pip` follows the same interface but is significantly faster:

```console
❯ uv pip install requests
Resolved 5 packages in 12ms
Prepared 5 packages in 0.45ms
Installed 5 packages in 8ms
 + certifi==2024.8.30
 + charset-normalizer==3.4.0
 + idna==3.10
 + requests==2.32.3
 + urllib3==2.2.3
```

We strongly recommend using `uv pip` instead of `pip` whenever possible as it dramatically reduces the installation time. The speed difference becomes dramatic for larger dependency trees:
> To install `uv` it suffices to do `pip install uv`

```console
❯ time pip install numpy pandas scikit-learn  # fresh venv
...
real    0m45.320s

❯ time uv pip install numpy pandas scikit-learn  # fresh venv
...
real    0m2.156s
```

Beyond the dependencies, environments also allow you to have different versions of your programming language runtime.

```console
❯ uv venv --python 3.12 venv312
Using CPython 3.12.7
Creating virtual environment at: venv312

❯ source venv312/bin/activate && python --version
Python 3.12.7

❯ uv venv --python 3.11 venv311
Using CPython 3.11.10
Creating virtual environment at: venv311

❯ source venv311/bin/activate && python --version
Python 3.11.10
```

This helps when you need to test your code across multiple Python versions or when a project requires a specific version.


## Artifacts & Packaging

In software development we differentiate between source code and artifacts. Developers write and read source code, while artifacts are the packaged, distributable outputs produced from that source code -- ready to be installed or deployed.
An artifact can be as simple as a file of code that we run, and as complex as an entire Virtual Machine that contains all the necessary bits and bobs of an application.
<!-- Packaging code provides us portability, we can now run the same code somewhere else. -->


Consider this example where we have a Python file `mylib.py` in our current directory:

```console
❯ cat mylib.py
def greet(name):
    return f"Hello, {name}!"

❯ python -c "from mylib import greet; print(greet('World'))"
Hello, World!

❯ cd /tmp
❯ python -c "from mylib import greet; print(greet('World'))"
ModuleNotFoundError: No module named 'mylib'
```

The import fails once we move to a different directory because Python only searches for modules in specific locations (the current directory, installed packages, and paths in `PYTHONPATH`). Packaging solves this by installing the code into a known location.

In Python, packaging a library involves producing an artifact that package installers like `pip` or `uv` can use to install the relevant files.
Python artifacts are called _wheels_ and contain all the necessary information to install a package: the code files, metadata about the package (name, version, dependencies), and instructions for where to place files in the environment. 
Building an artifact requires that we write a project file (also often known as manifest) detailing the specifics of the project, the required dependencies, the version of the package, and other details. In Python, we use `pyproject.toml` for this purpose. 

> `pyproject.toml` is the modern and recommended way. While earlier packaging methods like `requirements.txt` or `setup.py` are still supported, you should prefer `pyproject.toml` whenever possible.

Here's a minimal `pyproject.toml` for a library that also provides a command-line tool:

```toml
[project]
name = "greeting"
version = "0.1.0"
description = "A simple greeting library"
dependencies = ["click>=8.0"]

[project.scripts]
greet = "greeting:main"

[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"
```

> Some dependencies are declared as optional and won't be installed by default.
E.g. if they are required for testing: contributors will need them but end users won't.

And the corresponding `greeting.py`:

```python
import click

def hello(name):
    return f"Hello, {name}!"

@click.command()
@click.argument("name")
def main(name):
    click.echo(hello(name))
```

With this file, we can now build the wheel:

```console
❯ uv build
Building source distribution...
Building wheel from source distribution...
Successfully built dist/greeting-0.1.0.tar.gz
Successfully built dist/greeting-0.1.0-py3-none-any.whl

❯ ls dist/
greeting-0.1.0-py3-none-any.whl
greeting-0.1.0.tar.gz
```

The `.whl` file is the wheel (a zip archive with a specific structure), and the `.tar.gz` is a source distribution for systems that need to build from source.

Now if we were to give this wheel to someone else, they could install it by running:

```console
uv pip install ./greeting-0.1.0-py3-none-any.whl
```

This would install the library we built earlier into their environment.

There are limitations to this approach. In particular if our library depends on platform-specific libraries, e.g. CUDA for GPU acceleration, then our artifact only works on systems with those specific libraries installed, and we may need to build separate wheels for different platforms (Linux, macOS, Windows) and architectures (x86, ARM).


When installing software, there's an important distinction between installing from source and installing a prebuilt binary. Installing from source means downloading the original code and compiling it on your machine -- this requires having a compiler and build tools installed, and can take significant time for large projects. Installing a prebuilt binary means downloading an artifact that was already compiled by someone else -- faster and simpler, but the binary must match your platform and architecture.

For example, [ripgrep's releases page](https://github.com/BurntSushi/ripgrep/releases) shows prebuilt binaries for Linux (x86_64, ARM), macOS (Intel, Apple Silicon), and Windows -- users download the appropriate archive for their system rather than compiling from source.


## Releases & Versioning

Code is built in a continuous process but is released on a discrete basis. 
In software development there is a clear distinction between **dev**evelopment and **prod**uction environments.
Code needs to be proven to work in a dev environment before getting _shipped_ to prod.
The release process involves many steps, including testing, dependency management, versioning, configuration, deployment and publishing.


Software libraries are not static and evolve over time getting fixes and new features.
We track this evolution by discrete version identifiers, that correspond to the state of the library at a certain point in time.

Changes in the behavior of a library can range from patches that fix noncritical functionality, new features that extend its functionality, to changes breaking backwards compatibility.
Changelogs document what changes a version introduces -- these are documents that software developers use to communicate the changes associated with a new release.

However, keeping track of the ongoing changes in each and every dependency is impractical, even more so when we consider the transitive dependencies -- i.e. the dependencies of our dependencies.

> You can visualize the entire dependency tree of your project with `uv tree`, which shows all packages and their transitive dependencies in a tree format.

To simplify this problem there are conventions on how to version software, and one of the most prevalent is [Semantic Versioning](https://semver.org/) or SemVer.
Under Semantic Versioning a version has an identifier of the form MAJOR.MINOR.PATCH where each one of the values takes an integer value. The short version is that upgrading:

- PATCH (e.g., 1.2.3 → 1.2.4) should only contain bug fixes and be fully backwards compatible
- MINOR (e.g., 1.2.3 → 1.3.0) adds new functionality in a backwards-compatible way
- MAJOR (e.g., 1.2.3 → 2.0.0) indicates breaking changes that may require code modifications

However, it is important to note that semantic versioning is not infallible and sometimes maintainers inadvertently introduce breaking changes in minor or patch releases. 

> This is a simplification and we encourage reading the full SemVer specification to understand for instance why going from 0.1.3 to 0.2.0 might cause breaking changes or what 1.0.0-rc.1 means.

Python packaging supports semantic versioning natively so when we specify the versions of our dependencies we can use various specifiers:

```toml
[project]
dependencies = [
    "requests==2.32.3",      # Exact version - only this specific version
    "click>=8.0",            # Minimum version - 8.0 or newer
    "numpy>=1.24,<2.0",      # Range - at least 1.24 but less than 2.0
    "pandas~=2.1.0",         # Compatible release - >=2.1.0 and <2.2.0
]
``` 

> Note that the Python programming language itself uses semantic versioning for its releases.

Not all software uses semantic versioning. An alternative is Calendar Versioning (CalVer), where versions are based on release dates rather than semantic meaning. For example, Ubuntu uses versions like `24.04` (April 2024) and `24.10` (October 2024). CalVer makes it easy to see how old a release is, though it doesn't communicate anything about compatibility. 


## Reproducibility

In modern software development the code you write sits atop a significant number of layers of abstraction.
This includes things like your programming language runtime, third party libraries, the operating system, or even the hardware itself.
Any difference across any of these layers might change the behavior of your code or even prevent it from working as intended.
Furthermore, even differences in the underlying hardware impact your ability to ship software.

Pinning a library refers to specifying an exact version rather than a range, e.g. `requests==2.32.3` instead of `requests>=2.0`.

Part of the job of a package manager is to consider all the constraints provided by the dependices -- and transitive dependencies -- and then produce a valid list of versions that will satisfy all the constraints.
The specific list of versions can be then saved to a file for reproducibility purposes, this files are referred to as lock files.

```console
❯ uv lock
Resolved 12 packages in 45ms

❯ cat uv.lock | head -20
version = 1
requires-python = ">=3.11"

[[package]]
name = "certifi"
version = "2024.8.30"
source = { registry = "https://pypi.org/simple" }
sdist = { url = "https://files.pythonhosted.org/...", hash = "sha256:..." }
wheels = [
    { url = "https://files.pythonhosted.org/...", hash = "sha256:..." },
]
...
```

One critical distinction when dealing with dependency versioning and reproducibility is the difference between libraries and applications/services.
A library is intended to be imported and used by other code which might have its own dependencies, so specifying overly strict version constraints can cause conflicts with the user's other dependencies.
In contrast, applications or services are final consumers of the software and typically expose their functionality through a user interface or an API, not through a programming interface that other code imports.
For libraries, it is good practice to specify version ranges to maximize compatibility with the wider package ecosystem. For applications, pinning exact versions ensures reproducibility -- everyone running the application uses the exact same dependencies.


For projects requiring maximum reproducibility, tools like [Nix](https://nixos.org/) and [Bazel](https://bazel.build/) provide _hermetic_ builds -- where every input including compilers, system libraries, and even the build environment itself is pinned and content-addressed. This guarantees bit-for-bit identical outputs regardless of when or where the build runs, at the cost of additional complexity.


A neverending tension in software development is that new software versions introduce breakage either intentionally or unintentionally, while old fixed software versions become compromised with security vulnerabilities over time.
We can address this by using continuous integration pipelines (we'll see more in the [Code Quality and CI](/2026/code-quality/) lecture) that test our application against new software versions and having automation in place for detecting when new versions of our dependencies are released, such as [Dependabot](https://github.com/dependabot).

Even with CI testing in place, issues still occur when upgrading software versions, often because of the inevitable mismatch between dev and prod environments.
In those circumstances the best course of action is to have a _rollback_ plan, where the version upgrade is reverted and a known good version is redeployed instead.

<!-- 
One key challenge with versioning and reproducibility is that applications with strict versioning can run into conflicts for common dependencies, preventing you from installing them simultaneously in the same machine.
This problem is often referred to as _dependency hell_ and is mitigated by expanding the shipped artifact from a library to include all dependencies bundled together, which is exactly what VMs & and containers do. 
 -->

## VMs & Containers

As you start relying on more complex dependencies, it is likely that the dependencies of your code will span beyond the boundaries of what the package manager can handle.
One common reason is having to interface with specific system libraries or hardware drivers.
For example, in scientific computing and AI, programs often need specialized libraries and drivers to utilize GPU hardware.
While some packages like PyTorch now bundle CUDA libraries directly via pip, many system-level dependencies (GPU drivers, specific compiler versions, shared libraries like OpenSSL) still require system-wide installation.

Traditionally this wider dependency problem was solved with Virtual Machines (VMs).
VMs abstract the entire computer and provide a completely isolated environment with its own dedicated operating system.
A more modern approach is containers, which package an application along with its dependencies, libraries, and filesystem, but share the host's operating system kernel rather than virtualizing an entire computer.
Containers are lighter weight than VMs because they share the kernel, making them faster to start and more efficient to run.

A Dockerfile allows us to specify exactly what dependencies, system libraries, and configurations each container requires.

In practice your program might depend on the entire filesystem.
To overcome this, we ship the entire filesystem of the application as the artifcat of choice by using containers.

```dockerfile
FROM python:3.12
RUN apt-get update && apt-get install -y gcc libpq-dev
RUN pip install numpy pandas
COPY . /app
WORKDIR /app
RUN pip install .
```

In the previous example we start from a given image using `FROM` which provides us a starting filesystem. Then each `RUN` or `COPY` operation produces a new layer, a filesystem snapshot that Docker can cache for faster rebuilds.

An important distinction: a Docker **image** is the packaged artifact (like a template), while a **container** is a running instance of that image. You can run multiple containers from the same image. Images are built in layers, where each instruction in a Dockerfile creates a new layer. Docker caches these layers, so if you change a line in your Dockerfile, only that layer and subsequent layers need to be rebuilt -- this is why the order of instructions matters for build performance.



The previous Dockerfile has several issues: it uses the full Python image instead of a slim variant, runs separate `RUN` commands creating unnecessary layers, and doesn't clean up package manager caches. Common pitfalls like these lead to bloated images. Other frequent mistakes include running containers as root (a security risk) and accidentally embedding secrets in layers.

Here's an improved version:

```dockerfile
FROM python:3.12-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libpq-dev && \
    rm -rf /var/lib/apt/lists/*
COPY pyproject.toml uv.lock ./
RUN uv pip install --system -r uv.lock
COPY . /app
```

Key improvements: using a slim base image, combining commands to reduce layers, cleaning up package manager caches, and copying requirements first to leverage Docker's layer caching.

As we saw earlier, it's not the same installing a package from source or from a prebuilt binary.
We find a similar pattern with Dockerfile packaging, with the _builder_ pattern:

```dockerfile
# Stage 1: Build
FROM python:3.12 AS builder
WORKDIR /app
RUN pip install build
COPY pyproject.toml .
COPY src/ src/
RUN python -m build --wheel

# Stage 2: Runtime (much smaller)
FROM python:3.12-slim
COPY --from=builder /app/dist/*.whl /tmp/
RUN pip install /tmp/*.whl && rm /tmp/*.whl
CMD ["myapp"]
```

The builder pattern uses multiple stages: the first stage has all the build tools needed to compile/package the code, while the final stage only contains what's needed to run the application. This dramatically reduces image size since compilers, headers, and build artifacts don't end up in the final image.




Docker has some important limitations to be aware of. First, container images are often platform-specific -- an image built for `linux/amd64` won't run natively on `linux/arm64` (Apple Silicon Macs) without emulation, which is slow. Second, Docker containers require a Linux kernel, so on macOS and Windows, Docker actually runs a lightweight Linux VM under the hood, adding overhead. Third, Docker's isolation is weaker than VMs -- containers share the host kernel, which is a security concern in multi-tenant environments.


## Configuration

Software is inherently configurable. In the [command line environment](/2026/command-line-environment/) lecture we saw programs receiving options via flags, environment variables or even configuration files aka dotfiles.
This holds true even for more complex applications, and there are established patterns for managing configuration at scale.

Software configuration should not be embedded in the code but be provided at runtime.
You encounter different patterns, with a couple of common ones being environment variables and config files. 

Here's an example of configuring an application via environment variables:

```python
import os

DATABASE_URL = os.environ.get("DATABASE_URL", "sqlite:///local.db")
DEBUG = os.environ.get("DEBUG", "false").lower() == "true"
API_KEY = os.environ["API_KEY"]  # Required - will raise if not set
```

Or via a configuration file (`config.yaml`):

```yaml
database:
  url: "postgresql://localhost/myapp"
  pool_size: 5
server:
  host: "0.0.0.0"
  port: 8080
  debug: false
```

This principle of separating configuration from code is part of the [12-factor app](https://12factor.net/) methodology -- a set of best practices for building modern, deployable applications. The key idea is that the same codebase should be deployable to different environments (development, staging, production) with only configuration changes, never code changes.

Among the many configuration options there is often sensitive data such as API keys and other types of secrets.
Given their nature secrets need to be handled with care to avoid exposing them accidentally.
Some best practices for handling secrets include: never committing them to version control (use `.gitignore` for `.env` files), using environment variables rather than hardcoding values, rotating secrets periodically, and using dedicated secrets management tools for production deployments.
As with the build process, automation is your friend in this regard, with tools like [Trufflehog](https://github.com/trufflesecurity/trufflehog) detecting frequent secret patterns and preventing you from publishing them accidentally.


## Deployment & Orchestration

Docker Compose is a tool for defining and running multi-container applications. Rather than managing containers individually, you declare all services in a single YAML file and orchestrate them together.

As an example, if we determine our application might benefit from using a cache, instead of rolling our own we can leverage existing battle tested solutions like [Redis](https://redis.io/) or [Memcached](https://memcached.org/).
We could embed redis in our application dependencies by building it as part of the container, but that means harmonizing all the dependencies between redis and our application which could be challenging or even unfeasible.
Instead what we can do is deploy each application separately in its own container.
This is commonly referred to as a microservice architecture where each component runs as an independent service that communicates over the network, typically via HTTP APIs. 

Now our full application encompasses more than one container and we can use orchestration solutions like docker compose:

```yaml
# docker-compose.yml
services:
  web:
    build: .
    ports:
      - "8080:8080"
    environment:
      - REDIS_URL=redis://cache:6379
    depends_on:
      - cache

  cache:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  redis_data:
```

With `docker compose up`, both services start together, and the web application can connect to Redis using the hostname `cache` (Docker's internal DNS resolves service names automatically). 

Docker compose lets us declare how we want to deploy one or more services, and handles the orchestration of starting them together, setting up networking between them, and managing shared volumes for data persistence.

As deployment requirements grow more complex -- needing scalability across multiple machines, fault tolerance when services crash, and high availability guarantees -- docker compose reaches its limits. For these scenarios, organizations turn to container orchestration platforms like Kubernetes (k8s), which can manage thousands of containers across clusters of machines. However, Kubernetes has a steep learning curve and significant operational overhead, so it's often overkill for smaller projects. 


## Deployment & Services

For deployments on a single machine, systemd can manage your application as a service -- starting it on boot, restarting it if it crashes, and handling logs.

Modern services communicate over HTTP APIs, a standardized protocol for request-response interactions. For example, whenever a program interacts with an LLM provider like OpenAI or Anthropic, what we are doing is sending an HTTP request to their servers and receiving a response:

```console
❯ curl https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "content-type: application/json" \
    -H "anthropic-version: 2023-06-01" \
    -d '{"model": "claude-sonnet-4-20250514", "max_tokens": 256,
         "messages": [{"role": "user", "content": "Explain containers vs VMs in one sentence."}]}'
```

The libraries you use (like `anthropic` or `openai` in Python) are wrappers around these HTTP calls, handling authentication, serialization, and error handling for you.

## Publishing


Once you have shown your code to work, you might be interested in distributing it for others to download and install.
Distribution takes many forms and is intrinsically tied to the programming language and environments that you operate with.

The most simple form of distribution is uploading artifacts for people to download and install locally.
This is still common and you can find it in places like [Ubuntu's package archive](http://archive.ubuntu.com/ubuntu/pool/main/), which is essentially an HTTP directory listing of `.deb` files.

These days, GitHub has become the de facto platform for publishing source code and artifacts.
While the source code is often publicly available, GitHub Releases allow maintainers to attach prebuilt binaries and other artifacts to tagged versions.


Package managers sometimes support installing directly from GitHub, either from source or from a pre-built wheel:

```console
# Install from source (will clone and build)
❯ pip install git+https://github.com/psf/requests.git

# Install from a specific tag/branch
❯ pip install git+https://github.com/psf/requests.git@v2.32.3

# Install a wheel directly from a GitHub release
❯ pip install https://github.com/user/repo/releases/download/v1.0/package-1.0-py3-none-any.whl
```

In fact, some languages like Go use a decentralized distribution model -- rather than a central package repository, Go modules are distributed directly from their source code repositories. 
Module paths like `github.com/gorilla/mux` indicate where the code lives, and `go get` fetches directly from there.
While Go does run a module proxy service for caching and availability, there's no equivalent to PyPI where you upload your package.

However, most package managers like `pip`, `cargo` or `brew` index pre-built packages for ease of distribution and  installation. Running

```console
❯ uv pip install requests --verbose --no-cache 2>&1 | grep -F '.whl'
DEBUG Selecting: requests==2.32.5 [compatible] (requests-2.32.5-py3-none-any.whl)
DEBUG No cache entry for: https://files.pythonhosted.org/packages/1e/db/4254e3eabe8020b458f1a747140d32277ec7a271daf1d235b70dc0b4e6e3/requests-2.32.5-py3-none-any.whl.metadata
DEBUG No cache entry for: https://files.pythonhosted.org/packages/1e/db/4254e3eabe8020b458f1a747140d32277ec7a271daf1d235b70dc0b4e6e3/requests-2.32.5-py3-none-any.whl
```

shows where we are fetching the `requests` wheel from. Notice the `py3-none-any` in the filename -- this means the wheel works with any Python 3 version, on any OS, on any architecture. For packages with compiled code, the wheel is platform-specific:

```console
❯ uv pip install numpy --verbose --no-cache 2>&1 | grep -F '.whl'
DEBUG Selecting: numpy==2.2.1 [compatible] (numpy-2.2.1-cp312-cp312-macosx_14_0_arm64.whl)
```

Here `cp312-cp312-macosx_14_0_arm64` indicates this wheel is specifically for CPython 3.12 on macOS 14+ for ARM64 (Apple Silicon). If you're on a different platform, `pip` will download a different wheel or build from source.

Conversely, for people to be able to find a package we've created, we need to publish it to one of these registries.
In Python, the main registry is the [Python Package Index (PyPI)](https://pypi.org).
Like with installing, there are multiple ways of publishing packages. The `uv publish` command provides a modern interface for uploading packages to PyPI:

```console
❯ uv publish --publish-url https://test.pypi.org/legacy/
Publishing greeting-0.1.0.tar.gz
Publishing greeting-0.1.0-py3-none-any.whl
```

Here we are using [TestPyPI](https://test.pypi.org) -- a separate package registry intended for testing your publishing workflow without polluting the real PyPI. Once uploaded, you can install from TestPyPI:

```console
❯ uv pip install --index-url https://test.pypi.org/simple/ greeting
```

A key consideration when publishing software is trust. How do users verify that the package they download actually comes from you and hasn't been tampered with? Package registries use checksums to verify integrity, and some ecosystems support package signing with tools like [Sigstore](https://www.sigstore.dev/) to provide cryptographic proof of authorship.

Different languages have their own package registries: [crates.io](https://crates.io) for Rust, [npm](https://www.npmjs.com) for JavaScript, [RubyGems](https://rubygems.org) for Ruby, and [Docker Hub](https://hub.docker.com) for container images.

For private or internal packages, organizations often deploy their own package repositories (such as a private PyPI server or a private Docker registry) or use managed solutions from cloud providers like AWS CodeArtifact or GitHub Packages.

Deploying a web service to the internet involves additional infrastructure: domain name registration, DNS configuration to point your domain to your server, and often a reverse proxy like nginx to handle HTTPS and route traffic. For simpler use cases like documentation or static sites, [GitHub Pages](https://pages.github.com/) provides free hosting directly from a repository. 

## Documentation

So far we have emphasized the deliverable _artifact_ as the main output of packaging and shipping code.
In addition to the artifact, we need to document for users the code's functionality, installation instructions, and usage examples.

Tools like [Sphinx](https://www.sphinx-doc.org/) (Python) and [MkDocs](https://www.mkdocs.org/) can automatically generate browsable documentation from docstrings and markdown files, often hosted on services like [Read the Docs](https://readthedocs.org/).
For HTTP-based APIs, the [OpenAPI specification](https://www.openapis.org/) (formerly Swagger) provides a standard format for describing API endpoints, which tools can use to generate interactive documentation and client libraries automatically.

## AI for packaging and shipping code

AI tools like Claude and ChatGPT can assist with generating Dockerfiles, GitHub Actions workflows, and CI/CD pipelines. They can be useful for producing initial scaffolding or troubleshooting configuration issues.

However, AI-generated infrastructure code comes with important caveats: models may hallucinate plausible-looking but incorrect configurations, suggested defaults may not match your specific requirements, and the generated code should always be reviewed and tested before deploying to production.


## Exercises

1. Save your environment with `printenv` to a file, create a venv, activate it, `printenv` to another file and `diff before.txt after.txt`. What changed in the environment? Why does the shell prefer the venv? Run `which deactivate` and reason about what the deactivate bash function is doing.
1. Create a Python package with a `pyproject.toml` and install it in a virtual environment.
1. Install Docker and use it to build the Missing Semester class website locally using docker compose.
1. Write a Dockerfile for a simple Python application.
1. Write a `docker-compose.yml` that runs your application alongside a Redis cache.
1. Publish a Python package to TestPyPI (don't publish to the real PyPI unless it's worth sharing!). Then build a Docker image with said package and push it to `ghcr.io`.
1. Make a website using [GitHub Pages](https://docs.github.com/en/pages/quickstart). Extra credit: configure it with a custom domain.