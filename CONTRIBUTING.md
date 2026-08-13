# Contributing to Scurator

Thank you for your interest in contributing to **Scurator** (High-Performance, GPU-Accelerated Somatic Driver Mutation Profiling Framework). 

Scurator is developed in accordance with European Open Science Cloud (EOSC) FAIR principles (Findable, Accessible, Interoperable, Reusable), Google Open Source Software (OSS) engineering practice standards, and the European Union Public Licence v1.2 (EUPL-1.2).

Whether you are fixing a bug, proposing a new driver gene filtering algorithm, optimizing GPU acceleration kernels, or improving technical documentation, your contributions are essential to advancing open cancer genomics.

---

## Table of Contents

1. [Code of Conduct and Open Science Standards](#code-of-conduct-and-open-science-standards)
2. [Developer Certificate of Origin (DCO)](#developer-certificate-of-origin-dco)
3. [Environment Setup and Installation](#environment-setup-and-installation)
4. [Branching Strategy and Git Workflow](#branching-strategy-and-git-workflow)
5. [Commit Message Guidelines](#commit-message-guidelines)
6. [Coding Standards and Code Quality](#coding-standards-and-code-quality)
7. [Testing and Quality Assurance](#testing-and-quality-assurance)
8. [GPU Acceleration Guidelines](#gpu-acceleration-guidelines)
9. [Documentation Standards](#documentation-standards)
10. [Submitting a Pull Request (PR)](#submitting-a-pull-request-pr)
11. [Issue Reporting Guidelines](#issue-reporting-guidelines)
12. [Licensing Declaration](#licensing-declaration)

---

## Code of Conduct and Open Science Standards

By participating in the Scurator project, you agree to abide by our Code of Conduct (`CODE_OF_CONDUCT.md`). We are committed to fostering an inclusive, professional, and respectful scientific community.

All contributions must respect data privacy guidelines:
* Do not commit Protected Health Information (PHI) or identifiable clinical patient records.
* Use public datasets (e.g., TCGA, ClinVar, COSMIC) or synthetic test fixtures provided in `data/test_fixtures/`.
* Ensure code and workflow modules remain reproducible across Linux and container environments.

---

## Developer Certificate of Origin (DCO)

All contributions to Scurator must be accompanied by a Developer Certificate of Origin (DCO) sign-off. By signing off your commit, you certify that you have the right to submit the work under the European Union Public Licence v1.2 (EUPL-1.2).

To sign off your commit, add the `-s` or `--signoff` flag to your git commit command:

```bash
git commit -s -m "feat(filter): implement missense impact scoring threshold logic"
```

---

## Environment Setup and Installation

### Prerequisites

* Operating System: Linux (Ubuntu 22.04 LTS or higher recommended) or macOS
* Package Manager: Conda or Mamba (Mamba recommended for fast dependency resolution)
* Python Version: Python 3.10
* Optional Hardware: NVIDIA GPU with CUDA 11.8+ drivers for GPU acceleration

### Step 1: Fork and Clone the Repository

Fork `https://github.com/nexagen-bioinfo/Cancer-Driver-Mutation-Profiling.git` to your personal GitHub account, then clone it locally:

```bash
git clone https://github.com/YOUR_USERNAME/Cancer-Driver-Mutation-Profiling.git
cd Cancer-Driver-Mutation-Profiling
```

### Step 2: Create the Conda Development Environment

Create and activate the environment using `environment.yml`:

```bash
mamba env create -f environment.yml
conda activate scurator
```

### Step 3: Install Scurator in Development Mode

Install the package in editable mode along with all development and testing dependencies:

```bash
pip install -e ".[all]"
```

### Step 4: Install Git Pre-Commit Hooks

Activate automated quality checks that run prior to every commit:

```bash
pre-commit install
```

To verify your environment setup by running pre-commit across all files:

```bash
pre-commit run --all-files
```

---

## Branching Strategy and Git Workflow

Scurator follows a modified Git Flow strategy. All development occurs on topic branches created off the `develop` branch.

### Branch Naming Conventions

* `feature/`: New bioinformatics algorithms, pipeline modules, or CLI commands.  
  Example: `feature/alpha-missense-annotation`
* `bugfix/`: Fixes for identified computational bugs or logic errors.  
  Example: `bugfix/vcf-header-parsing-error`
* `perf/`: Performance optimizations or GPU memory acceleration improvements.  
  Example: `perf/rapids-cudf-vectorization`
* `docs/`: Technical documentation, API references, or methodology updates.  
  Example: `docs/add-benchmarking-results`
* `refactor/`: Code restructuring without changing external functionality.  
  Example: `refactor/data-loader-abstraction`

---

## Commit Message Guidelines

Scurator enforces Conventional Commits standards. Structure your commit messages as follows:

```text
<type>(<scope>): <short descriptive summary in present tense>

[optional body providing scientific or algorithmic reasoning]

[optional footer referencing issue numbers]
```

### Permitted Commit Types

* `feat`: A new feature or biological module.
* `fix`: A bug fix or error correction.
* `docs`: Documentation changes only.
* `style`: Changes that do not affect code logic (formatting, missing semi-colons).
* `refactor`: Code change that neither fixes a bug nor adds a feature.
* `perf`: Performance optimization (CPU or GPU speedup).
* `test`: Adding missing unit tests or correcting existing tests.
* `build`: Changes affecting build system, packaging, or dependencies (`pyproject.toml`, `Dockerfile`).
* `ci`: Changes to CI/CD workflows (`.github/workflows/`).

### Example Commit Messages

```text
feat(pipeline): add ClinVar pathogenicity score mapping logic

Integrates NCBI ClinVar VCF parser to assign pathogenicity classifications
(Pathogenic, Likely Pathogenic, Benign) to somatic missense variants.

Closes #42
```

---

## Coding Standards and Code Quality

Scurator follows Google Open Source Software (OSS) Python Style Guidelines. Static analysis tools run automatically via GitHub Actions CI and pre-commit hooks.

### Formatting and Linting Commands

Before submitting code, ensure compliance by running:

1. Code Formatting (`black`):
   ```bash
   black src tests
   ```
2. Import Sorting (`isort`):
   ```bash
   isort src tests
   ```
3. Fast Linter Analysis (`ruff`):
   ```bash
   ruff check src tests --fix
   ```
4. Static Type Checking (`mypy`):
   ```bash
   mypy src/scurator
   ```

### Docstring Requirements

All public functions, classes, and methods must include Google-style docstrings with explicit type definitions:

```python
def filter_somatic_variants(
    vcf_path: str,
    min_read_depth: int = 10,
    impact_types: list[str] | None = None,
) -> pandas.DataFrame:
    """Filter somatic variants from a VCF file based on coverage and impact.

    Args:
        vcf_path: Absolute or relative file path to input VCF.
        min_read_depth: Minimum sequencing read coverage depth (DP).
        impact_types: List of functional variant impact types to retain.

    Returns:
        DataFrame containing filtered somatic driver mutation candidates.

    Raises:
        FileNotFoundError: If input vcf_path does not exist.
        ValueError: If VCF header lacks required DP formatting fields.
    """
```

---

## Testing and Quality Assurance

Quality assurance is mandatory for all code contributions. We maintain a strict test coverage threshold (>85%) enforced by Pytest.

### Running Test Suite Locally

Execute the full test suite with coverage reporting:

```bash
pytest --cov=scurator --cov-report=term-missing tests/
```

### Test Organization Principles

* Place unit tests inside `tests/` matching module structure (e.g., `tests/test_filter.py` tests `src/scurator/pipeline/filter.py`).
* Use synthetic VCF fixtures located in `data/test_fixtures/` rather than large real-world VCF files.
* Ensure tests run deterministically without internet dependency. Mock external HTTP API calls in `src/scurator/data/fetcher.py`.

---

## GPU Acceleration Guidelines

When writing modules in `src/scurator/utils/gpu_accelerator.py` or modifying pipeline components:

1. Always implement a CPU fallback mechanism. GPU hardware (NVIDIA RAPIDS cuDF) may not be available in all execution contexts.
2. Use safe import guards:
   ```python
   try:
       import cudf
       HAS_GPU = True
   except ImportError:
       import pandas as cudf
       HAS_GPU = False
   ```
3. Vectorize operations using native DataFrame methods rather than applying custom Python loops across rows.

---

## Documentation Standards

Documentation is treated with the same priority as code:

* User documentation resides in `docs/`.
* Scientific methodology details must be documented in `docs/METHODOLOGY.md`.
* Ensure new CLI commands or subcommands are reflected in `docs/API_REFERENCE.md`.

---

## Submitting a Pull Request (PR)

Follow these steps when your feature or bug fix is ready:

1. Rebase your topic branch on the latest `develop` branch:
   ```bash
   git fetch origin
   git rebase origin/develop
   ```
2. Ensure all pre-commit hooks, Pytest unit tests, and mypy type checks pass locally.
3. Open a Pull Request targeting the `develop` branch on GitHub.
4. Fill out the Pull Request template completely, describing:
   * Biological and technical motivation.
   * Summary of changes introduced.
   * Testing evidence and benchmarking output.
5. Link relevant GitHub Issues (e.g., `Closes #12`).
6. Respond promptly to code review comments from maintainers.

---

## Issue Reporting Guidelines

Before opening an issue, search existing open and closed issues on GitHub to avoid duplicates.

* **Bug Reports:** Use `.github/ISSUE_TEMPLATE/bug_report.md`. Provide complete error tracebacks, environment information, and minimal reproducible VCF snippets.
* **Feature Requests:** Use `.github/ISSUE_TEMPLATE/feature_request.md`. Fill out all open-ended questions and structured checkboxes detailing biological utility and technical impact.

---

## Licensing Declaration

Scurator is open-source software licensed under the **European Union Public Licence v1.2 (EUPL-1.2)**. 

By contributing to Scurator, you agree that your contributions will be licensed under the EUPL v1.2 terms. You retain copyright ownership of your individual contributions while granting the project rights to distribute under EUPL v1.2.
